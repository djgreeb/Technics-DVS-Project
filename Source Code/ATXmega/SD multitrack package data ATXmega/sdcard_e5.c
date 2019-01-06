#if __CODEVISIONAVR__ < 3090
#error This example requires CodeVisionAVR V3.09 or later
#endif

#include <io.h>
#include <ff.h>
#include <delay.h>
#include <math.h>
//#include <stdio.h>

#define SET_B(x) |= (1<<x)  //установить бит X в "1"
#define CLR_B(x) &=~(1<<x)  //установить бит X в "0"
#define INV_B(x) ^=(1<<x)   //инвертировать бит X

FRESULT res;
FATFS fat;
FIL file;
FILINFO finfo;

/* file path */
char path[]="0:/DVS/1/Track_01.wav";

unsigned int nbytes;
unsigned char buffer_1[1536];
unsigned char FROM_SD[4];
unsigned char FROM_FPGA[4];
unsigned char SEND[6];               //буффер для отправки на STM
unsigned char WFM[64];               //буффер для отправки WaveForm на STM
unsigned int remain;
unsigned int b;
bit play = 0;                         //разрешение на воспроизведение play=1 - воспроизведение                 
unsigned long flength;
bit stt = 0;                          //переменная для защелкивания принятой команды по переключению трека/папки
bit nxt = 1;                          //бит определения направления переключения треков или папок
bit fldr = 0;                         //бит определения типа переключения (папка/трек)
unsigned char FPGA_TRACK_TIME = 0;    //длительность трека для отправки в FPGA
unsigned int allsec = 0;               //для вычисления позиции времени на экране
unsigned char analyzing=0;
unsigned char cnt_uart=0;              //Для счетчика работы UART


// System clocks initialization
void system_clocks_init(void)
{
unsigned char n,s;

// Optimize for speed
#pragma optsize-
// Save interrupts enabled/disabled state
s=SREG;
// Disable interrupts
#asm("cli")

// External 16000,000 kHz oscillator initialization
// Crystal oscillator increased drive current: On
// External Clock Source - Startup Time: 0.4-16 MHz Quartz Crystal - 16k CLK
OSC.XOSCCTRL=OSC_FRQRANGE_12TO16_gc | OSC_XOSCPWR_bm | OSC_XOSCSEL_XTAL_16KCLK_gc;
// Enable the external oscillator/clock source
OSC.CTRL|=OSC_XOSCEN_bm;

// Wait for the external oscillator to stabilize
while ((OSC.STATUS & OSC_XOSCRDY_bm)==0);

// PLL initialization
// PLL clock source: External Osc. or Clock
// PLL multiplication factor: 2
// PLL output/2: Off
// PLL frequency: 32,000000 MHz
// Set the PLL clock source and multiplication factor
n=(OSC.PLLCTRL & (~(OSC_PLLSRC_gm | OSC_PLLDIV_bm | OSC_PLLFAC_gm))) |
	OSC_PLLSRC_XOSC_gc | (0<<OSC_PLLDIV_bp) | 2;
CCP=CCP_IOREG_gc;
OSC.PLLCTRL=n;
// Enable the PLL
OSC.CTRL|=OSC_PLLEN_bm;

// System Clock prescaler A division factor: 1
// System Clock prescalers B & C division factors: B:1, C:1
// ClkPer4: 32000,000 kHz
// ClkPer2: 32000,000 kHz
// ClkPer:  32000,000 kHz
// ClkCPU:  32000,000 kHz
n=(CLK.PSCTRL & (~(CLK_PSADIV_gm | CLK_PSBCDIV1_bm | CLK_PSBCDIV0_bm))) |
	CLK_PSADIV_1_gc | CLK_PSBCDIV_1_1_gc;
CCP=CCP_IOREG_gc;
CLK.PSCTRL=n;

// Wait for the PLL to stabilize
while ((OSC.STATUS & OSC_PLLRDY_bm)==0);

// Select the system clock source: Phase Locked Loop
n=(CLK.CTRL & (~CLK_SCLKSEL_gm)) | CLK_SCLKSEL_PLL_gc;
CCP=CCP_IOREG_gc;
CLK.CTRL=n;

// Disable the unused oscillators: 2 MHz, 32 MHz, internal 32 kHz
OSC.CTRL&= ~(OSC_RC2MEN_bm | OSC_RC32MEN_bm | OSC_RC32KEN_bm);

// ClkPer output disabled
PORTCFG.CLKEVOUT&= ~(PORTCFG_CLKOUTSEL_gm | PORTCFG_CLKOUT_gm);
// Restore interrupts enabled/disabled state
SREG=s;
// Restore optimization for size if needed
#pragma optsize_default
}

// RTC initialization
void rtcxm_init(void)
{
unsigned char s;

// RTC clock source: 32.768 kHz from internal RC Oscillator
// Select the clock source and enable the RTC clock
CLK.RTCCTRL=(CLK.RTCCTRL & (~CLK_RTCSRC_gm)) | CLK_RTCSRC_RCOSC32_gc | CLK_RTCEN_bm;
// Make sure that the RTC is stopped before initializing it
RTC.CTRL=(RTC.CTRL & (~RTC_PRESCALER_gm)) | RTC_PRESCALER_OFF_gc;
// Optimize for speed
#pragma optsize-
// Save interrupts enabled/disabled state
s=SREG;
// Disable interrupts
#asm("cli")
while (RTC.STATUS & RTC_SYNCBUSY_bm);
RTC.PER=0x0148;
RTC.CNT=0x0000;
RTC.COMP=0x0000;
SREG=s;
#pragma optsize_default
RTC.CTRL=(RTC.CTRL & (~RTC_PRESCALER_gm)) | RTC_PRESCALER_DIV1_gc;
RTC.INTCTRL=(RTC.INTCTRL & (~(RTC_OVFINTLVL_gm | RTC_COMPINTLVL_gm))) |
    RTC_OVFINTLVL_LO_gc | RTC_COMPINTLVL_OFF_gc;
}

// RTC overflow interrupt service routine every 10ms
interrupt [RTC_OVF_vect] void rtcxm_overflow_isr(void)
{
disk_timerproc(); // SD card access low level timing function
}

// Ports initialization
void ports_init(void)
{
// PORTB initialization
// OUT register
PORTB.OUT=0x00;
// Pin0: Output
// Pin1: Output
// Pin2: Input
// Pin3: Input
PORTB.DIR=0x03;
// Pin0 Output/Pull configuration: Totempole/No
// Pin0 Input/Sense configuration: Sense both edges
// Pin0 Inverted: Off
// Pin0 Slew Rate Limitation: Off
PORTB.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin1 Output/Pull configuration: Totempole/No
// Pin1 Input/Sense configuration: Sense both edges
// Pin1 Inverted: Off
// Pin1 Slew Rate Limitation: Off
PORTB.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin2 Output/Pull configuration: Totempole/Pull-up (on input)
// Pin2 Input/Sense configuration: Sense both edges
// Pin2 Inverted: Off
// Pin2 Slew Rate Limitation: Off
PORTB.PIN2CTRL=PORT_OPC_PULLUP_gc | PORT_ISC_BOTHEDGES_gc;
// Pin3 Output/Pull configuration: Totempole/No
// Pin3 Input/Sense configuration: Sense rising edge
// Pin3 Inverted: Off
// Pin3 Slew Rate Limitation: Off
PORTB.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_RISING_gc;
// Interrupt 0 level: High
// Interrupt 1 level: Disabled
PORTB.INTCTRL=(PORTB.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
    PORT_INT1LVL_OFF_gc | PORT_INT0LVL_HI_gc;
// Pin0 Pin Change interrupt 0: Off
// Pin1 Pin Change interrupt 0: Off
// Pin2 Pin Change interrupt 0: Off
// Pin3 Pin Change interrupt 0: On
//PORTB.INT0MASK=0x08;    
PORTB.INT0MASK=0x00;
PORTB.INT1MASK=0x00;


// PORTC initialization
// OUT register
PORTC.OUT=0x00;
// Pin0: Input
// Pin1: Input
// Pin2: Input
// Pin3: Input
// Pin4: Input
// Pin5: Input
// Pin6: Input
// Pin7: Input
PORTC.DIR=0x00;
// Pin0 Output/Pull configuration: Totempole/Pull-down (on input)
// Pin0 Input/Sense configuration: Sense both edges
// Pin0 Inverted: Off
// Pin0 Slew Rate Limitation: Off
PORTC.PIN0CTRL=PORT_OPC_PULLDOWN_gc | PORT_ISC_BOTHEDGES_gc;
// Pin1 Output/Pull configuration: Totempole/Pull-down (on input)
// Pin1 Input/Sense configuration: Sense both edges
// Pin1 Inverted: Off
// Pin1 Slew Rate Limitation: Off
PORTC.PIN1CTRL=PORT_OPC_PULLDOWN_gc | PORT_ISC_BOTHEDGES_gc;
// Pin2 Output/Pull configuration: Totempole/Pull-down (on input)
// Pin2 Input/Sense configuration: Sense both edges
// Pin2 Inverted: Off
// Pin2 Slew Rate Limitation: Off
PORTC.PIN2CTRL=PORT_OPC_PULLDOWN_gc | PORT_ISC_BOTHEDGES_gc;
// Pin3 Output/Pull configuration: Totempole/Pull-down (on input)
// Pin3 Input/Sense configuration: Sense both edges
// Pin3 Inverted: Off
// Pin3 Slew Rate Limitation: Off
PORTC.PIN3CTRL=PORT_OPC_PULLDOWN_gc | PORT_ISC_BOTHEDGES_gc;
// Pin4 Output/Pull configuration: Totempole/No
// Pin4 Input/Sense configuration: Sense both edges
// Pin4 Inverted: Off
// Pin4 Slew Rate Limitation: Off
PORTC.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin5 Output/Pull configuration: Totempole/No
// Pin5 Input/Sense configuration: Sense both edges
// Pin5 Inverted: Off
// Pin5 Slew Rate Limitation: Off
PORTC.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin6 Output/Pull configuration: Totempole/No
// Pin6 Input/Sense configuration: Sense both edges
// Pin6 Inverted: Off
// Pin6 Slew Rate Limitation: Off
PORTC.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin7 Output/Pull configuration: Totempole/No
// Pin7 Input/Sense configuration: Sense both edges
// Pin7 Inverted: Off
// Pin7 Slew Rate Limitation: Off
PORTC.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// PORTC Peripheral Output Remapping
// OC0A Output: Pin 0
// OC0B Output: Pin 1
// OC0C Output: Pin 2
// OC0D Output: Pin 3
// USART0 XCK: Pin 1
// USART0 RXD: Pin 2
// USART0 TXD: Pin 3
// SPI MOSI: Pin 5
// SPI SCK: Pin 7
PORTC.REMAP=(0<<PORT_SPI_bp) | (0<<PORT_USART0_bp) | (0<<PORT_TC0D_bp) | (0<<PORT_TC0C_bp) | (0<<PORT_TC0B_bp) | (0<<PORT_TC0A_bp);
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTC.INTCTRL=(PORTC.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Pin0 Pin Change interrupt 0: Off
// Pin1 Pin Change interrupt 0: Off
// Pin2 Pin Change interrupt 0: Off
// Pin3 Pin Change interrupt 0: Off
// Pin4 Pin Change interrupt 0: Off
// Pin5 Pin Change interrupt 0: Off
// Pin6 Pin Change interrupt 0: Off
// Pin7 Pin Change interrupt 0: Off
PORTC.INT0MASK=0x00;
// Pin0 Pin Change interrupt 1: Off
// Pin1 Pin Change interrupt 1: Off
// Pin2 Pin Change interrupt 1: Off
// Pin3 Pin Change interrupt 1: Off
// Pin4 Pin Change interrupt 1: Off
// Pin5 Pin Change interrupt 1: Off
// Pin6 Pin Change interrupt 1: Off
// Pin7 Pin Change interrupt 1: Off
PORTC.INT1MASK=0x00;



// PORTD initialization
// OUT register
PORTD.OUT=0x00;
//PORTD.DIR=0b11111111;     //порт-передатчик
PORTD.DIR=0b00000000;     //порт-приемник
PORTD.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
PORTD.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
PORTD.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
PORTD.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
PORTD.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
PORTD.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
PORTD.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
PORTD.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
PORTD.INTCTRL=(PORTD.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
PORTD.INT0MASK=0x00;
PORTD.INT1MASK=0x00;


// PORTE initialization
// OUT register
PORTE.OUT=0x08;
// Pin0: Input
// Pin1: Input
// Pin2: Input
// Pin3: Output
PORTE.DIR=0x08;
// Pin0 Output/Pull configuration: Totempole/No
// Pin0 Input/Sense configuration: Sense both edges
// Pin0 Inverted: Off
// Pin0 Slew Rate Limitation: Off
PORTE.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin1 Output/Pull configuration: Totempole/No
// Pin1 Input/Sense configuration: Sense both edges
// Pin1 Inverted: Off
// Pin1 Slew Rate Limitation: Off
PORTE.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin2 Output/Pull configuration: Totempole/No
// Pin2 Input/Sense configuration: Sense both edges
// Pin2 Inverted: Off
// Pin2 Slew Rate Limitation: Off
PORTE.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin3 Output/Pull configuration: Totempole/No
// Pin3 Input/Sense configuration: Sense both edges
// Pin3 Inverted: Off
// Pin3 Slew Rate Limitation: Off
PORTE.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTE.INTCTRL=(PORTE.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Pin0 Pin Change interrupt 0: Off
// Pin1 Pin Change interrupt 0: Off
// Pin2 Pin Change interrupt 0: Off
// Pin3 Pin Change interrupt 0: Off
PORTE.INT0MASK=0x00;
// Pin0 Pin Change interrupt 1: Off
// Pin1 Pin Change interrupt 1: Off
// Pin2 Pin Change interrupt 1: Off
// Pin3 Pin Change interrupt 1: Off
PORTE.INT1MASK=0x00;
}


// USARTE0 initialization
void usarte0_init(void)
{
// Note: The correct PORTE direction for the RxD, TxD and XCK signals
// is configured in the ports_init function.

// Transmitter is enabled
// Set TxD=1
PORTE.OUTSET=0x08;

// Communication mode: Asynchronous USART
// Data bits: 8
// Stop bits: 1
// Parity: Disabled
USARTE0.CTRLC=USART_CMODE_ASYNCHRONOUS_gc | USART_PMODE_DISABLED_gc | USART_CHSIZE_8BIT_gc;

// Receive complete interrupt: Disabled
// Transmit complete interrupt: Disabled
// Data register empty interrupt: Disabled
USARTE0.CTRLA=(USARTE0.CTRLA & (~(USART_RXCINTLVL_gm | USART_TXCINTLVL_gm | USART_DREINTLVL_gm))) |
	USART_RXCINTLVL_OFF_gc | USART_TXCINTLVL_OFF_gc | USART_DREINTLVL_OFF_gc;

// Required Baud rate: 57600
// Real Baud Rate: 57605,8 (x1 Mode), Error: 0,0 %
USARTE0.BAUDCTRLA=0x2E;
USARTE0.BAUDCTRLB=((0x09 << USART_BSCALE_gp) & USART_BSCALE_gm) | 0x08;

// Receiver: Off
// Transmitter: On
// Double transmission speed mode: Off
// Multi-processor communication mode: Off
USARTE0.CTRLB=(USARTE0.CTRLB & (~(USART_RXEN_bm | USART_TXEN_bm | USART_CLK2X_bm | USART_MPCM_bm | USART_TXB8_bm))) |
	USART_TXEN_bm;
}

// Write a character to the USARTE0 Transmitter
#pragma used+
void putchar_usarte0(char c)
{
while ((USARTE0.STATUS & USART_DREIF_bm) == 0);
USARTE0.DATA=c;
}
#pragma used-


// PORTB interrupt 0 service routine
interrupt [PORTB_INT0_vect] void portb_int0_isr(void)
{
PORTD.OUT = buffer_1[b];
if (b<1535)
    {
    b++;
    }
else
    {
    PORTB.OUT CLR_B(0);   //PORTB.0 = 0;   (AVR_READY)
    b=0;
    }
}



void main(void)
{
unsigned char n;

/* Interrupt system initialization
   Optimize for speed */
#pragma optsize-
/* Low level interrupt: On
   Round-robin scheduling for low level interrupt: Off
   Medium level interrupt: Off
   High level interrupt: Off
   The interrupt vectors will be placed at the start of the Application FLASH section */
n=(PMIC.CTRL & (~(PMIC_RREN_bm | PMIC_IVSEL_bm | PMIC_HILVLEN_bm | PMIC_MEDLVLEN_bm | PMIC_LOLVLEN_bm))) |
	PMIC_LOLVLEN_bm | PMIC_HILVLEN_bm;
CCP=CCP_IOREG_gc;
PMIC.CTRL=n;
/* Set the default priority for round-robin scheduling */
PMIC.INTPRI=0x00;
/* Restore optimization for size if needed */
#pragma optsize_default


system_clocks_init();
rtcxm_init();
ports_init();
PORTD.DIR=0xFF;    //порт-передатчик
PORTB.OUT CLR_B(0);      //AVR_READY=0;
PORTB.OUT CLR_B(1);      //RESET ПЛИС  PORTB.1 = 0
b = 0;
usarte0_init();


/* globally enable interrupts */
#asm("sei")

//search = 0;                            //search это значение b (байта, дискреты)   на поиск фрейма уходит около 330мс
//if ((res=f_lseek(&file, search))==FR_OK)    /////////так производится перемещение по файлу

if ((res=f_mount(0,&fat))==FR_OK)       //////////монтируем подключенный диск mount logical drive 0:
    {
    }

delay_ms(2000);                                 //задержка при включении, ждем загрузки ПЛИС и STM

while(1)
{
if ((res=f_open(&file,path,FA_READ))==FR_OK)                /////////////////открываем файл по одресу path для чтения
    {
    SEND[0]=path[7]-48;                               /////номер папки пишем в массив
    SEND[1]=(10*(path[15]-48))+path[16]-48;           //Отправляем номер трека
    if ((res=f_lseek(&file, 55))==FR_OK)               //переход к началу точек в файле
        {
        if ((res=f_read(&file,FROM_SD,sizeof(FROM_SD),&nbytes))==FR_OK)              ////Вычитываем горячие точки из файла 
            {
            if ((res=f_stat(path,&finfo))==FR_OK)
                {   
                if ((res=f_read(&file,&analyzing,sizeof(1),&nbytes))==FR_OK)              ////Вычитываем флаг анализированного трека
                    {   
                    if ((res=f_read(&file,WFM,sizeof(WFM),&nbytes))==FR_OK)              ////Вычитываем Waveform из трека
                        {
                        flength=finfo.fsize;                     ////вычисление длины файла в байтах
                        flength=flength-124;                     //отнимаем от файла размер заголовка
                        remain=flength/1536;                     //определение колечества посылок по 1536 байт
                        if(flength>33554431)                                //////////////////////////////////////////////////////////////
                            {                                               //
                            FPGA_TRACK_TIME = 255;                          //
                            SEND[2]=(256*FROM_SD[0]+FROM_SD[1])/512;        //
                            SEND[3]=(256*FROM_SD[2]+FROM_SD[3])/512;        //
                            flength=381;                                    //
                            }                                               //    Вычисление временной переменной для отправки в FPGA
                        else                                                //
                            {                                               //
                            FPGA_TRACK_TIME = flength/131587;               //                           и STM
                            allsec=flength/65536;                           //
                            SEND[2]=(256*FROM_SD[0]+FROM_SD[1])/allsec;     //
                            SEND[3]=(256*FROM_SD[2]+FROM_SD[3])/allsec;     //
                            flength=flength/88200;                          //
                            }                                               ////////////////////////////////////////////////////////////////
                        SEND[4]=flength/256;
                        SEND[5]=flength%256;    
                        if(!(analyzing==170))           /////если трек оказался не проанализирован, то место в буффере, отведенное для WaveForm заполняем нулями
                            {
                            cnt_uart=0;
                            while(cnt_uart<64)
                                {
                                WFM[cnt_uart]=0;
                                cnt_uart++;
                                }
                            }        
                        cnt_uart=0;
                        while(cnt_uart<70)
                            {
                            if(cnt_uart<64)
                                {
                                putchar_usarte0(WFM[cnt_uart]);
                                }
                            else
                                {
                                putchar_usarte0(SEND[cnt_uart-64]);    
                                }       
                            cnt_uart++;
                            }
                               
                        PORTD.OUT=FROM_SD[0];
                        delay_us(1);
                        PORTB.OUT SET_B(0);      //AVR_READY=1;
                        delay_us(1);  
                        PORTB.OUT CLR_B(0);      //AVR_READY=0;
                        PORTD.OUT=FROM_SD[1];
                        delay_us(1); 
                        PORTB.OUT SET_B(0);      //AVR_READY=1;
                        delay_us(1); 
                        PORTB.OUT CLR_B(0);      //AVR_READY=0;
                        PORTD.OUT=FROM_SD[2];
                        delay_us(1); 
                        PORTB.OUT SET_B(0);      //AVR_READY=1;
                        delay_us(1);   
                        PORTB.OUT CLR_B(0);      //AVR_READY=0;
                        PORTD.OUT=FROM_SD[3];
                        delay_us(1); 
                        PORTB.OUT SET_B(0);      //AVR_READY=1;
                        delay_us(1);   
                        PORTB.OUT CLR_B(0);      //AVR_READY=0;
                        PORTD.OUT=FPGA_TRACK_TIME;               /////// отправка временной переменной для FPGA
                        delay_us(1);  
                        PORTB.OUT SET_B(0);      //AVR_READY=1;
                        delay_us(1);
                        PORTB.OUT CLR_B(0);      //AVR_READY=0;  
                        delay_us(1);
                        play = 1;
                        PORTB.OUT SET_B(1);                   //PORTB.1 = 1  снимаем RESET CPLD
                        PORTB.INT0MASK=0x08;                  //включения прерывания
                        } 
                    }
                }                
            }   
        }
    }
else
    {
    PORTB.OUT CLR_B(1);                                   //PORTB.1 = 0
    }
        
while(play)
    {
    if(!(PORTB.OUT&1<<0))
        {
        if ((res=f_read(&file,buffer_1,sizeof(buffer_1),&nbytes))==FR_OK)              ////зачитываем данные и пишем в buffer размером sizeof(buffer)-1,&nbytes
            {
            PORTB.OUT SET_B(0);        //PORTB.0 = 1    (AVR_READY)
            if(remain==0)
                {
                PORTB.INT0MASK=0x00;    //отключаем прерывание
                if ((res=f_close(&file))==FR_OK)     ///////////////////закрываем файл
                    {}
                }
            else
                {
                remain--;
                }
            }
        }
    
    if((PORTC.IN&1<<1 || PORTC.IN&1<<2) & stt==0)             //нажали клавишу NEXT or FF     PINC.1 или PINC.2
        {
        PORTB.OUT CLR_B(0);      //AVR_READY=0;
        if(PORTC.IN&1<<1)
            {
            nxt=1;              //переключаем следующий трек или папку            
            }
        else
            {
            nxt=0;             //переключаем следующий трек или папку
            }
        fldr=PORTC.IN&1<<3;
        play = 0;
        stt = 1;
        PORTB.INT0MASK=0x00;     //отключаем прерывание
        if ((res=f_close(&file))==FR_OK)     ///////////////////закрываем файл 
        b = 0; 
        PORTB.OUT CLR_B(1);      //RESET ПЛИС  //PORTB.1 = 0 
        ////delay_ms(10);           /// задержка нажатия клавиши. для цифрового кода не нужна
        }

    if((!(PORTC.IN&1<<1)) & (!(PORTC.IN&1<<2)))                           //отпустили клавишу NEXT or FF
        {
        stt = 0;
        }
    }
          
       
if(fldr==1)                          /////////////////////////////////////////////////////////////переключение треков и папок /////////////////////////////////////////
    {
    fldr=0;
    path[15]=48;                    //выставляем Track_01
    path[16]=49;                    //
    if(nxt)
        {
        if(path[7]==54)
            {
            path[7]=49;
            }
        else
            {
            path[7]++;
            }
        }
    else
        {
        nxt=1;
        if(path[7]==49)
            {
            path[7]=54;
            }
        else
            {
            path[7]--;
            }
        }    
    }
else
    {
    if(nxt)
        {                      
        if(path[16]==57)
            {
            path[16]=48;
            if(path[15]==57)
                {
                path[15]=48;
                path[16]=49;
                }
            else
                {
                path[15]++;
                }
            }
        else
            {
            path[16]++;
            }
        }    
    else
        {
        if(path[16]==48)
            {
            path[16]=57;
            if(path[15]==48)
                {
                path[15]=57;
                path[16]=57;
                }
            else
                {
                path[15]--;
                }
            }
        else
            {
            path[16]--;
            }
        }
    }                  
}
}


