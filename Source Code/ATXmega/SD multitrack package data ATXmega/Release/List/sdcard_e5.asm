
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATxmega32A4U
;Program type           : Application
;Clock frequency        : 32,000000 MHz
;Memory model           : Small
;Optimize for           : Speed
;(s)printf features     : long, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATxmega32A4U
	#pragma AVRPART MEMORY PROG_FLASH 36864
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x2000

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU CCP=0x34
	.EQU RAMPD=0x38
	.EQU RAMPX=0x39
	.EQU RAMPY=0x3A
	.EQU RAMPZ=0x3B
	.EQU EIND=0x3C
	.EQU WDT_CTRL=0x80
	.EQU PMIC_CTRL=0xA2
	.EQU NVM_ADDR0=0X01C0
	.EQU NVM_ADDR1=NVM_ADDR0+1
	.EQU NVM_ADDR2=NVM_ADDR1+1
	.EQU NVM_DATA0=NVM_ADDR0+4
	.EQU NVM_CMD=NVM_ADDR0+0xA
	.EQU NVM_CTRLA=NVM_ADDR0+0xB
	.EQU NVM_CTRLB=NVM_ADDR0+0xC
	.EQU NVM_STATUS=NVM_ADDR0+0xF
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIO0=0x00
	.EQU GPIO1=0x01
	.EQU GPIO2=0x02
	.EQU GPIO3=0x03
	.EQU GPIO4=0x04
	.EQU GPIO5=0x05
	.EQU GPIO6=0x06
	.EQU GPIO7=0x07
	.EQU GPIO8=0x08
	.EQU GPIO9=0x09
	.EQU GPIO10=0x0A
	.EQU GPIO11=0x0B
	.EQU GPIO12=0x0C
	.EQU GPIO13=0x0D
	.EQU GPIO14=0x0E
	.EQU GPIO15=0x0F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x2000
	.EQU __SRAM_END=0x2FFF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _res=R3
	.DEF _nbytes=R4
	.DEF _nbytes_msb=R5
	.DEF _remain=R6
	.DEF _remain_msb=R7
	.DEF _b=R8
	.DEF _b_msb=R9
	.DEF _FPGA_TRACK_TIME=R2
	.DEF _allsec=R10
	.DEF _allsec_msb=R11
	.DEF _analyzing=R13
	.DEF _cnt_uart=R12

;GPIO0-GPIO15 INITIALIZATION VALUES
	.EQU __GPIO0_INIT=0x04
	.EQU __GPIO1_INIT=0x00
	.EQU __GPIO2_INIT=0x00
	.EQU __GPIO3_INIT=0x00
	.EQU __GPIO4_INIT=0x00
	.EQU __GPIO5_INIT=0x00
	.EQU __GPIO6_INIT=0x00
	.EQU __GPIO7_INIT=0x00
	.EQU __GPIO8_INIT=0x00
	.EQU __GPIO9_INIT=0x00
	.EQU __GPIO10_INIT=0x00
	.EQU __GPIO11_INIT=0x00
	.EQU __GPIO12_INIT=0x00
	.EQU __GPIO13_INIT=0x00
	.EQU __GPIO14_INIT=0x00
	.EQU __GPIO15_INIT=0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION VALUES
	.EQU __R2_INIT=0x00
	.EQU __R3_INIT=0x00
	.EQU __R4_INIT=0x00
	.EQU __R5_INIT=0x00
	.EQU __R6_INIT=0x00
	.EQU __R7_INIT=0x00
	.EQU __R8_INIT=0x00
	.EQU __R9_INIT=0x00
	.EQU __R10_INIT=0x00
	.EQU __R11_INIT=0x00
	.EQU __R12_INIT=0x00
	.EQU __R13_INIT=0x00
	.EQU __R14_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _rtcxm_overflow_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _portb_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_k1:
	.DB  0x20,0x22,0x2A,0x2B,0x2C,0x5B,0x3D,0x5D
	.DB  0x7C,0x7F,0x0
_vst_G101:
	.DB  0x0,0x4,0x0,0x2,0x0,0x1,0x80,0x0
	.DB  0x40,0x0,0x20,0x0,0x10,0x0,0x8,0x0
	.DB  0x4,0x0,0x2,0x0,0x0,0x0
_cst_G101:
	.DB  0x0,0x80,0x0,0x40,0x0,0x20,0x0,0x10
	.DB  0x0,0x8,0x0,0x40,0x0,0x20,0x0,0x10
	.DB  0x0,0x8,0x0,0x4,0x0,0x2

_0x3:
	.DB  0x30,0x3A,0x2F,0x44,0x56,0x53,0x2F,0x31
	.DB  0x2F,0x54,0x72,0x61,0x63,0x6B,0x5F,0x30
	.DB  0x31,0x2E,0x77,0x61,0x76
_0x2000003:
	.DB  0x1
_0x2020000:
	.DB  0xEB,0xFE,0x90,0x4D,0x53,0x44,0x4F,0x53
	.DB  0x35,0x2E,0x30,0x0,0x4E,0x4F,0x20,0x4E
	.DB  0x41,0x4D,0x45,0x20,0x20,0x20,0x20,0x46
	.DB  0x41,0x54,0x33,0x32,0x20,0x20,0x20,0x0
	.DB  0x4E,0x4F,0x20,0x4E,0x41,0x4D,0x45,0x20
	.DB  0x20,0x20,0x20,0x46,0x41,0x54,0x20,0x20
	.DB  0x20,0x20,0x20,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x15
	.DW  _path
	.DW  _0x3*2

	.DW  0x01
	.DW  _status_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30

;MEMORY MAPPED EEPROM ACCESS IS USED
	LDS  R31,NVM_CTRLB
	ORI  R31,0x08
	STS  NVM_CTRLB,R31

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,0xD8
	OUT  CCP,R31
	STS  PMIC_CTRL,R30

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIO0-GPIO15 INITIALIZATION
	LDI  R30,__GPIO0_INIT
	OUT  GPIO0,R30
	LDI  R30,__GPIO1_INIT
	OUT  GPIO1,R30
	;__GPIO2_INIT = __GPIO1_INIT
	OUT  GPIO2,R30
	;__GPIO3_INIT = __GPIO1_INIT
	OUT  GPIO3,R30
	;__GPIO4_INIT = __GPIO1_INIT
	OUT  GPIO4,R30
	;__GPIO5_INIT = __GPIO1_INIT
	OUT  GPIO5,R30
	;__GPIO6_INIT = __GPIO1_INIT
	OUT  GPIO6,R30
	;__GPIO7_INIT = __GPIO1_INIT
	OUT  GPIO7,R30
	;__GPIO8_INIT = __GPIO1_INIT
	OUT  GPIO8,R30
	;__GPIO9_INIT = __GPIO1_INIT
	OUT  GPIO9,R30
	;__GPIO10_INIT = __GPIO1_INIT
	OUT  GPIO10,R30
	;__GPIO11_INIT = __GPIO1_INIT
	OUT  GPIO11,R30
	;__GPIO12_INIT = __GPIO1_INIT
	OUT  GPIO12,R30
	;__GPIO13_INIT = __GPIO1_INIT
	OUT  GPIO13,R30
	;__GPIO14_INIT = __GPIO1_INIT
	OUT  GPIO14,R30
	;__GPIO15_INIT = __GPIO1_INIT
	OUT  GPIO15,R30

;GLOBAL REGISTER VARIABLES INITIALIZATION
	;__R2_INIT = __GPIO1_INIT
	MOV  R2,R30
	;__R3_INIT = __GPIO1_INIT
	MOV  R3,R30
	;__R4_INIT = __GPIO1_INIT
	MOV  R4,R30
	;__R5_INIT = __GPIO1_INIT
	MOV  R5,R30
	;__R6_INIT = __GPIO1_INIT
	MOV  R6,R30
	;__R7_INIT = __GPIO1_INIT
	MOV  R7,R30
	;__R8_INIT = __GPIO1_INIT
	MOV  R8,R30
	;__R9_INIT = __GPIO1_INIT
	MOV  R9,R30
	;__R10_INIT = __GPIO1_INIT
	MOV  R10,R30
	;__R11_INIT = __GPIO1_INIT
	MOV  R11,R30
	;__R12_INIT = __GPIO1_INIT
	MOV  R12,R30
	;__R13_INIT = __GPIO1_INIT
	MOV  R13,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x2400

	.CSEG
;#if __CODEVISIONAVR__ < 3090
;#error This example requires CodeVisionAVR V3.09 or later
;#endif
;
;#include <io.h>
;#include <ff.h>
;#include <delay.h>
;#include <math.h>
;//#include <stdio.h>
;
;#define SET_B(x) |= (1<<x)  //установить бит X в "1"
;#define CLR_B(x) &=~(1<<x)  //установить бит X в "0"
;#define INV_B(x) ^=(1<<x)   //инвертировать бит X
;
;FRESULT res;
;FATFS fat;
;FIL file;
;FILINFO finfo;
;
;/* file path */
;char path[]="0:/DVS/1/Track_01.wav";

	.DSEG
;
;unsigned int nbytes;
;unsigned char buffer_1[1536];
;unsigned char FROM_SD[4];
;unsigned char FROM_FPGA[4];
;unsigned char SEND[6];               //буффер для отправки на STM
;unsigned char WFM[64];               //буффер для отправки WaveForm на STM
;unsigned int remain;
;unsigned int b;
;bit play = 0;                         //разрешение на воспроизведение play=1 - воспроизведение
;unsigned long flength;
;bit stt = 0;                          //переменная для защелкивания принятой команды по переключению трека/папки
;bit nxt = 1;                          //бит определения направления переключения треков или папок
;bit fldr = 0;                         //бит определения типа переключения (папка/трек)
;unsigned char FPGA_TRACK_TIME = 0;    //длительность трека для отправки в FPGA
;unsigned int allsec = 0;               //для вычисления позиции времени на экране
;unsigned char analyzing=0;
;unsigned char cnt_uart=0;              //Для счетчика работы UART
;
;
;// System clocks initialization
;void system_clocks_init(void)
; 0000 002C {

	.CSEG
_system_clocks_init:
; .FSTART _system_clocks_init
; 0000 002D unsigned char n,s;
; 0000 002E 
; 0000 002F // Optimize for speed
; 0000 0030 #pragma optsize-
; 0000 0031 // Save interrupts enabled/disabled state
; 0000 0032 s=SREG;
	ST   -Y,R17
	ST   -Y,R16
;	n -> R17
;	s -> R16
	IN   R16,63
; 0000 0033 // Disable interrupts
; 0000 0034 #asm("cli")
	cli
; 0000 0035 
; 0000 0036 // External 16000,000 kHz oscillator initialization
; 0000 0037 // Crystal oscillator increased drive current: On
; 0000 0038 // External Clock Source - Startup Time: 0.4-16 MHz Quartz Crystal - 16k CLK
; 0000 0039 OSC.XOSCCTRL=OSC_FRQRANGE_12TO16_gc | OSC_XOSCPWR_bm | OSC_XOSCSEL_XTAL_16KCLK_gc;
	LDI  R30,LOW(219)
	STS  82,R30
; 0000 003A // Enable the external oscillator/clock source
; 0000 003B OSC.CTRL|=OSC_XOSCEN_bm;
	LDS  R30,80
	ORI  R30,8
	STS  80,R30
; 0000 003C 
; 0000 003D // Wait for the external oscillator to stabilize
; 0000 003E while ((OSC.STATUS & OSC_XOSCRDY_bm)==0);
_0x4:
	LDS  R30,81
	ANDI R30,LOW(0x8)
	BREQ _0x4
; 0000 003F 
; 0000 0040 // PLL initialization
; 0000 0041 // PLL clock source: External Osc. or Clock
; 0000 0042 // PLL multiplication factor: 2
; 0000 0043 // PLL output/2: Off
; 0000 0044 // PLL frequency: 32,000000 MHz
; 0000 0045 // Set the PLL clock source and multiplication factor
; 0000 0046 n=(OSC.PLLCTRL & (~(OSC_PLLSRC_gm | OSC_PLLDIV_bm | OSC_PLLFAC_gm))) |
; 0000 0047 	OSC_PLLSRC_XOSC_gc | (0<<OSC_PLLDIV_bp) | 2;
	LDS  R30,85
	ANDI R30,LOW(0x0)
	ORI  R30,LOW(0xC0)
	ORI  R30,2
	MOV  R17,R30
; 0000 0048 CCP=CCP_IOREG_gc;
	LDI  R30,LOW(216)
	OUT  0x34,R30
; 0000 0049 OSC.PLLCTRL=n;
	STS  85,R17
; 0000 004A // Enable the PLL
; 0000 004B OSC.CTRL|=OSC_PLLEN_bm;
	LDS  R30,80
	ORI  R30,0x10
	STS  80,R30
; 0000 004C 
; 0000 004D // System Clock prescaler A division factor: 1
; 0000 004E // System Clock prescalers B & C division factors: B:1, C:1
; 0000 004F // ClkPer4: 32000,000 kHz
; 0000 0050 // ClkPer2: 32000,000 kHz
; 0000 0051 // ClkPer:  32000,000 kHz
; 0000 0052 // ClkCPU:  32000,000 kHz
; 0000 0053 n=(CLK.PSCTRL & (~(CLK_PSADIV_gm | CLK_PSBCDIV1_bm | CLK_PSBCDIV0_bm))) |
; 0000 0054 	CLK_PSADIV_1_gc | CLK_PSBCDIV_1_1_gc;
	LDS  R30,65
	ANDI R30,LOW(0x80)
	MOV  R17,R30
; 0000 0055 CCP=CCP_IOREG_gc;
	LDI  R30,LOW(216)
	OUT  0x34,R30
; 0000 0056 CLK.PSCTRL=n;
	STS  65,R17
; 0000 0057 
; 0000 0058 // Wait for the PLL to stabilize
; 0000 0059 while ((OSC.STATUS & OSC_PLLRDY_bm)==0);
_0x7:
	LDS  R30,81
	ANDI R30,LOW(0x10)
	BREQ _0x7
; 0000 005A 
; 0000 005B // Select the system clock source: Phase Locked Loop
; 0000 005C n=(CLK.CTRL & (~CLK_SCLKSEL_gm)) | CLK_SCLKSEL_PLL_gc;
	LDS  R30,64
	ANDI R30,LOW(0xF8)
	ORI  R30,4
	MOV  R17,R30
; 0000 005D CCP=CCP_IOREG_gc;
	LDI  R30,LOW(216)
	OUT  0x34,R30
; 0000 005E CLK.CTRL=n;
	STS  64,R17
; 0000 005F 
; 0000 0060 // Disable the unused oscillators: 2 MHz, 32 MHz, internal 32 kHz
; 0000 0061 OSC.CTRL&= ~(OSC_RC2MEN_bm | OSC_RC32MEN_bm | OSC_RC32KEN_bm);
	LDS  R30,80
	ANDI R30,LOW(0xF8)
	STS  80,R30
; 0000 0062 
; 0000 0063 // ClkPer output disabled
; 0000 0064 PORTCFG.CLKEVOUT&= ~(PORTCFG_CLKOUTSEL_gm | PORTCFG_CLKOUT_gm);
	LDS  R30,180
	ANDI R30,LOW(0xF0)
	STS  180,R30
; 0000 0065 // Restore interrupts enabled/disabled state
; 0000 0066 SREG=s;
	OUT  0x3F,R16
; 0000 0067 // Restore optimization for size if needed
; 0000 0068 #pragma optsize_default
; 0000 0069 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;// RTC initialization
;void rtcxm_init(void)
; 0000 006D {
_rtcxm_init:
; .FSTART _rtcxm_init
; 0000 006E unsigned char s;
; 0000 006F 
; 0000 0070 // RTC clock source: 32.768 kHz from internal RC Oscillator
; 0000 0071 // Select the clock source and enable the RTC clock
; 0000 0072 CLK.RTCCTRL=(CLK.RTCCTRL & (~CLK_RTCSRC_gm)) | CLK_RTCSRC_RCOSC32_gc | CLK_RTCEN_bm;
	ST   -Y,R17
;	s -> R17
	LDS  R30,67
	ANDI R30,LOW(0xF1)
	ORI  R30,LOW(0xD)
	STS  67,R30
; 0000 0073 // Make sure that the RTC is stopped before initializing it
; 0000 0074 RTC.CTRL=(RTC.CTRL & (~RTC_PRESCALER_gm)) | RTC_PRESCALER_OFF_gc;
	LDS  R30,1024
	ANDI R30,LOW(0xF8)
	STS  1024,R30
; 0000 0075 // Optimize for speed
; 0000 0076 #pragma optsize-
; 0000 0077 // Save interrupts enabled/disabled state
; 0000 0078 s=SREG;
	IN   R17,63
; 0000 0079 // Disable interrupts
; 0000 007A #asm("cli")
	cli
; 0000 007B while (RTC.STATUS & RTC_SYNCBUSY_bm);
_0xA:
	LDS  R30,1025
	ANDI R30,LOW(0x1)
	BRNE _0xA
; 0000 007C RTC.PER=0x0148;
	LDI  R30,LOW(328)
	LDI  R31,HIGH(328)
	STS  1034,R30
	STS  1034+1,R31
; 0000 007D RTC.CNT=0x0000;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  1032,R30
	STS  1032+1,R31
; 0000 007E RTC.COMP=0x0000;
	STS  1036,R30
	STS  1036+1,R31
; 0000 007F SREG=s;
	OUT  0x3F,R17
; 0000 0080 #pragma optsize_default
; 0000 0081 RTC.CTRL=(RTC.CTRL & (~RTC_PRESCALER_gm)) | RTC_PRESCALER_DIV1_gc;
	LDS  R30,1024
	ANDI R30,LOW(0xF8)
	ORI  R30,1
	STS  1024,R30
; 0000 0082 RTC.INTCTRL=(RTC.INTCTRL & (~(RTC_OVFINTLVL_gm | RTC_COMPINTLVL_gm))) |
; 0000 0083     RTC_OVFINTLVL_LO_gc | RTC_COMPINTLVL_OFF_gc;
	LDS  R30,1026
	ANDI R30,LOW(0xF0)
	ORI  R30,1
	STS  1026,R30
; 0000 0084 }
	LD   R17,Y+
	RET
; .FEND
;
;// RTC overflow interrupt service routine every 10ms
;interrupt [RTC_OVF_vect] void rtcxm_overflow_isr(void)
; 0000 0088 {
_rtcxm_overflow_isr:
; .FSTART _rtcxm_overflow_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0089 disk_timerproc(); // SD card access low level timing function
	CALL _disk_timerproc
; 0000 008A }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Ports initialization
;void ports_init(void)
; 0000 008E {
_ports_init:
; .FSTART _ports_init
; 0000 008F // PORTB initialization
; 0000 0090 // OUT register
; 0000 0091 PORTB.OUT=0x00;
	LDI  R30,LOW(0)
	STS  1572,R30
; 0000 0092 // Pin0: Output
; 0000 0093 // Pin1: Output
; 0000 0094 // Pin2: Input
; 0000 0095 // Pin3: Input
; 0000 0096 PORTB.DIR=0x03;
	LDI  R30,LOW(3)
	STS  1568,R30
; 0000 0097 // Pin0 Output/Pull configuration: Totempole/No
; 0000 0098 // Pin0 Input/Sense configuration: Sense both edges
; 0000 0099 // Pin0 Inverted: Off
; 0000 009A // Pin0 Slew Rate Limitation: Off
; 0000 009B PORTB.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	LDI  R30,LOW(0)
	STS  1584,R30
; 0000 009C // Pin1 Output/Pull configuration: Totempole/No
; 0000 009D // Pin1 Input/Sense configuration: Sense both edges
; 0000 009E // Pin1 Inverted: Off
; 0000 009F // Pin1 Slew Rate Limitation: Off
; 0000 00A0 PORTB.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1585,R30
; 0000 00A1 // Pin2 Output/Pull configuration: Totempole/Pull-up (on input)
; 0000 00A2 // Pin2 Input/Sense configuration: Sense both edges
; 0000 00A3 // Pin2 Inverted: Off
; 0000 00A4 // Pin2 Slew Rate Limitation: Off
; 0000 00A5 PORTB.PIN2CTRL=PORT_OPC_PULLUP_gc | PORT_ISC_BOTHEDGES_gc;
	LDI  R30,LOW(24)
	STS  1586,R30
; 0000 00A6 // Pin3 Output/Pull configuration: Totempole/No
; 0000 00A7 // Pin3 Input/Sense configuration: Sense rising edge
; 0000 00A8 // Pin3 Inverted: Off
; 0000 00A9 // Pin3 Slew Rate Limitation: Off
; 0000 00AA PORTB.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_RISING_gc;
	LDI  R30,LOW(1)
	STS  1587,R30
; 0000 00AB // Interrupt 0 level: High
; 0000 00AC // Interrupt 1 level: Disabled
; 0000 00AD PORTB.INTCTRL=(PORTB.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 00AE     PORT_INT1LVL_OFF_gc | PORT_INT0LVL_HI_gc;
	LDS  R30,1577
	ANDI R30,LOW(0xF0)
	ORI  R30,LOW(0x3)
	STS  1577,R30
; 0000 00AF // Pin0 Pin Change interrupt 0: Off
; 0000 00B0 // Pin1 Pin Change interrupt 0: Off
; 0000 00B1 // Pin2 Pin Change interrupt 0: Off
; 0000 00B2 // Pin3 Pin Change interrupt 0: On
; 0000 00B3 //PORTB.INT0MASK=0x08;
; 0000 00B4 PORTB.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1578,R30
; 0000 00B5 PORTB.INT1MASK=0x00;
	STS  1579,R30
; 0000 00B6 
; 0000 00B7 
; 0000 00B8 // PORTC initialization
; 0000 00B9 // OUT register
; 0000 00BA PORTC.OUT=0x00;
	STS  1604,R30
; 0000 00BB // Pin0: Input
; 0000 00BC // Pin1: Input
; 0000 00BD // Pin2: Input
; 0000 00BE // Pin3: Input
; 0000 00BF // Pin4: Input
; 0000 00C0 // Pin5: Input
; 0000 00C1 // Pin6: Input
; 0000 00C2 // Pin7: Input
; 0000 00C3 PORTC.DIR=0x00;
	STS  1600,R30
; 0000 00C4 // Pin0 Output/Pull configuration: Totempole/Pull-down (on input)
; 0000 00C5 // Pin0 Input/Sense configuration: Sense both edges
; 0000 00C6 // Pin0 Inverted: Off
; 0000 00C7 // Pin0 Slew Rate Limitation: Off
; 0000 00C8 PORTC.PIN0CTRL=PORT_OPC_PULLDOWN_gc | PORT_ISC_BOTHEDGES_gc;
	LDI  R30,LOW(16)
	STS  1616,R30
; 0000 00C9 // Pin1 Output/Pull configuration: Totempole/Pull-down (on input)
; 0000 00CA // Pin1 Input/Sense configuration: Sense both edges
; 0000 00CB // Pin1 Inverted: Off
; 0000 00CC // Pin1 Slew Rate Limitation: Off
; 0000 00CD PORTC.PIN1CTRL=PORT_OPC_PULLDOWN_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1617,R30
; 0000 00CE // Pin2 Output/Pull configuration: Totempole/Pull-down (on input)
; 0000 00CF // Pin2 Input/Sense configuration: Sense both edges
; 0000 00D0 // Pin2 Inverted: Off
; 0000 00D1 // Pin2 Slew Rate Limitation: Off
; 0000 00D2 PORTC.PIN2CTRL=PORT_OPC_PULLDOWN_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1618,R30
; 0000 00D3 // Pin3 Output/Pull configuration: Totempole/Pull-down (on input)
; 0000 00D4 // Pin3 Input/Sense configuration: Sense both edges
; 0000 00D5 // Pin3 Inverted: Off
; 0000 00D6 // Pin3 Slew Rate Limitation: Off
; 0000 00D7 PORTC.PIN3CTRL=PORT_OPC_PULLDOWN_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1619,R30
; 0000 00D8 // Pin4 Output/Pull configuration: Totempole/No
; 0000 00D9 // Pin4 Input/Sense configuration: Sense both edges
; 0000 00DA // Pin4 Inverted: Off
; 0000 00DB // Pin4 Slew Rate Limitation: Off
; 0000 00DC PORTC.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	LDI  R30,LOW(0)
	STS  1620,R30
; 0000 00DD // Pin5 Output/Pull configuration: Totempole/No
; 0000 00DE // Pin5 Input/Sense configuration: Sense both edges
; 0000 00DF // Pin5 Inverted: Off
; 0000 00E0 // Pin5 Slew Rate Limitation: Off
; 0000 00E1 PORTC.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1621,R30
; 0000 00E2 // Pin6 Output/Pull configuration: Totempole/No
; 0000 00E3 // Pin6 Input/Sense configuration: Sense both edges
; 0000 00E4 // Pin6 Inverted: Off
; 0000 00E5 // Pin6 Slew Rate Limitation: Off
; 0000 00E6 PORTC.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1622,R30
; 0000 00E7 // Pin7 Output/Pull configuration: Totempole/No
; 0000 00E8 // Pin7 Input/Sense configuration: Sense both edges
; 0000 00E9 // Pin7 Inverted: Off
; 0000 00EA // Pin7 Slew Rate Limitation: Off
; 0000 00EB PORTC.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1623,R30
; 0000 00EC // PORTC Peripheral Output Remapping
; 0000 00ED // OC0A Output: Pin 0
; 0000 00EE // OC0B Output: Pin 1
; 0000 00EF // OC0C Output: Pin 2
; 0000 00F0 // OC0D Output: Pin 3
; 0000 00F1 // USART0 XCK: Pin 1
; 0000 00F2 // USART0 RXD: Pin 2
; 0000 00F3 // USART0 TXD: Pin 3
; 0000 00F4 // SPI MOSI: Pin 5
; 0000 00F5 // SPI SCK: Pin 7
; 0000 00F6 PORTC.REMAP=(0<<PORT_SPI_bp) | (0<<PORT_USART0_bp) | (0<<PORT_TC0D_bp) | (0<<PORT_TC0C_bp) | (0<<PORT_TC0B_bp) | (0<<POR ...
	STS  1614,R30
; 0000 00F7 // Interrupt 0 level: Disabled
; 0000 00F8 // Interrupt 1 level: Disabled
; 0000 00F9 PORTC.INTCTRL=(PORTC.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 00FA 	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,1609
	ANDI R30,LOW(0xF0)
	STS  1609,R30
; 0000 00FB // Pin0 Pin Change interrupt 0: Off
; 0000 00FC // Pin1 Pin Change interrupt 0: Off
; 0000 00FD // Pin2 Pin Change interrupt 0: Off
; 0000 00FE // Pin3 Pin Change interrupt 0: Off
; 0000 00FF // Pin4 Pin Change interrupt 0: Off
; 0000 0100 // Pin5 Pin Change interrupt 0: Off
; 0000 0101 // Pin6 Pin Change interrupt 0: Off
; 0000 0102 // Pin7 Pin Change interrupt 0: Off
; 0000 0103 PORTC.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1610,R30
; 0000 0104 // Pin0 Pin Change interrupt 1: Off
; 0000 0105 // Pin1 Pin Change interrupt 1: Off
; 0000 0106 // Pin2 Pin Change interrupt 1: Off
; 0000 0107 // Pin3 Pin Change interrupt 1: Off
; 0000 0108 // Pin4 Pin Change interrupt 1: Off
; 0000 0109 // Pin5 Pin Change interrupt 1: Off
; 0000 010A // Pin6 Pin Change interrupt 1: Off
; 0000 010B // Pin7 Pin Change interrupt 1: Off
; 0000 010C PORTC.INT1MASK=0x00;
	STS  1611,R30
; 0000 010D 
; 0000 010E 
; 0000 010F 
; 0000 0110 // PORTD initialization
; 0000 0111 // OUT register
; 0000 0112 PORTD.OUT=0x00;
	STS  1636,R30
; 0000 0113 //PORTD.DIR=0b11111111;     //порт-передатчик
; 0000 0114 PORTD.DIR=0b00000000;     //порт-приемник
	STS  1632,R30
; 0000 0115 PORTD.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1648,R30
; 0000 0116 PORTD.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1649,R30
; 0000 0117 PORTD.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1650,R30
; 0000 0118 PORTD.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1651,R30
; 0000 0119 PORTD.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1652,R30
; 0000 011A PORTD.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1653,R30
; 0000 011B PORTD.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1654,R30
; 0000 011C PORTD.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1655,R30
; 0000 011D PORTD.INTCTRL=(PORTD.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 011E 	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,1641
	ANDI R30,LOW(0xF0)
	STS  1641,R30
; 0000 011F PORTD.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1642,R30
; 0000 0120 PORTD.INT1MASK=0x00;
	STS  1643,R30
; 0000 0121 
; 0000 0122 
; 0000 0123 // PORTE initialization
; 0000 0124 // OUT register
; 0000 0125 PORTE.OUT=0x08;
	LDI  R30,LOW(8)
	STS  1668,R30
; 0000 0126 // Pin0: Input
; 0000 0127 // Pin1: Input
; 0000 0128 // Pin2: Input
; 0000 0129 // Pin3: Output
; 0000 012A PORTE.DIR=0x08;
	STS  1664,R30
; 0000 012B // Pin0 Output/Pull configuration: Totempole/No
; 0000 012C // Pin0 Input/Sense configuration: Sense both edges
; 0000 012D // Pin0 Inverted: Off
; 0000 012E // Pin0 Slew Rate Limitation: Off
; 0000 012F PORTE.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	LDI  R30,LOW(0)
	STS  1680,R30
; 0000 0130 // Pin1 Output/Pull configuration: Totempole/No
; 0000 0131 // Pin1 Input/Sense configuration: Sense both edges
; 0000 0132 // Pin1 Inverted: Off
; 0000 0133 // Pin1 Slew Rate Limitation: Off
; 0000 0134 PORTE.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1681,R30
; 0000 0135 // Pin2 Output/Pull configuration: Totempole/No
; 0000 0136 // Pin2 Input/Sense configuration: Sense both edges
; 0000 0137 // Pin2 Inverted: Off
; 0000 0138 // Pin2 Slew Rate Limitation: Off
; 0000 0139 PORTE.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1682,R30
; 0000 013A // Pin3 Output/Pull configuration: Totempole/No
; 0000 013B // Pin3 Input/Sense configuration: Sense both edges
; 0000 013C // Pin3 Inverted: Off
; 0000 013D // Pin3 Slew Rate Limitation: Off
; 0000 013E PORTE.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1683,R30
; 0000 013F // Interrupt 0 level: Disabled
; 0000 0140 // Interrupt 1 level: Disabled
; 0000 0141 PORTE.INTCTRL=(PORTE.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 0142 	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,1673
	ANDI R30,LOW(0xF0)
	STS  1673,R30
; 0000 0143 // Pin0 Pin Change interrupt 0: Off
; 0000 0144 // Pin1 Pin Change interrupt 0: Off
; 0000 0145 // Pin2 Pin Change interrupt 0: Off
; 0000 0146 // Pin3 Pin Change interrupt 0: Off
; 0000 0147 PORTE.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1674,R30
; 0000 0148 // Pin0 Pin Change interrupt 1: Off
; 0000 0149 // Pin1 Pin Change interrupt 1: Off
; 0000 014A // Pin2 Pin Change interrupt 1: Off
; 0000 014B // Pin3 Pin Change interrupt 1: Off
; 0000 014C PORTE.INT1MASK=0x00;
	STS  1675,R30
; 0000 014D }
	RET
; .FEND
;
;
;// USARTE0 initialization
;void usarte0_init(void)
; 0000 0152 {
_usarte0_init:
; .FSTART _usarte0_init
; 0000 0153 // Note: The correct PORTE direction for the RxD, TxD and XCK signals
; 0000 0154 // is configured in the ports_init function.
; 0000 0155 
; 0000 0156 // Transmitter is enabled
; 0000 0157 // Set TxD=1
; 0000 0158 PORTE.OUTSET=0x08;
	LDI  R30,LOW(8)
	STS  1669,R30
; 0000 0159 
; 0000 015A // Communication mode: Asynchronous USART
; 0000 015B // Data bits: 8
; 0000 015C // Stop bits: 1
; 0000 015D // Parity: Disabled
; 0000 015E USARTE0.CTRLC=USART_CMODE_ASYNCHRONOUS_gc | USART_PMODE_DISABLED_gc | USART_CHSIZE_8BIT_gc;
	LDI  R30,LOW(3)
	STS  2725,R30
; 0000 015F 
; 0000 0160 // Receive complete interrupt: Disabled
; 0000 0161 // Transmit complete interrupt: Disabled
; 0000 0162 // Data register empty interrupt: Disabled
; 0000 0163 USARTE0.CTRLA=(USARTE0.CTRLA & (~(USART_RXCINTLVL_gm | USART_TXCINTLVL_gm | USART_DREINTLVL_gm))) |
; 0000 0164 	USART_RXCINTLVL_OFF_gc | USART_TXCINTLVL_OFF_gc | USART_DREINTLVL_OFF_gc;
	LDS  R30,2723
	ANDI R30,LOW(0xC0)
	STS  2723,R30
; 0000 0165 
; 0000 0166 // Required Baud rate: 57600
; 0000 0167 // Real Baud Rate: 57605,8 (x1 Mode), Error: 0,0 %
; 0000 0168 USARTE0.BAUDCTRLA=0x2E;
	LDI  R30,LOW(46)
	STS  2726,R30
; 0000 0169 USARTE0.BAUDCTRLB=((0x09 << USART_BSCALE_gp) & USART_BSCALE_gm) | 0x08;
	LDI  R30,LOW(152)
	STS  2727,R30
; 0000 016A 
; 0000 016B // Receiver: Off
; 0000 016C // Transmitter: On
; 0000 016D // Double transmission speed mode: Off
; 0000 016E // Multi-processor communication mode: Off
; 0000 016F USARTE0.CTRLB=(USARTE0.CTRLB & (~(USART_RXEN_bm | USART_TXEN_bm | USART_CLK2X_bm | USART_MPCM_bm | USART_TXB8_bm))) |
; 0000 0170 	USART_TXEN_bm;
	LDS  R30,2724
	ANDI R30,LOW(0xE0)
	ORI  R30,8
	STS  2724,R30
; 0000 0171 }
	RET
; .FEND
;
;// Write a character to the USARTE0 Transmitter
;#pragma used+
;void putchar_usarte0(char c)
; 0000 0176 {
_putchar_usarte0:
; .FSTART _putchar_usarte0
; 0000 0177 while ((USARTE0.STATUS & USART_DREIF_bm) == 0);
	ST   -Y,R26
;	c -> Y+0
_0xD:
	LDS  R30,2721
	ANDI R30,LOW(0x20)
	BREQ _0xD
; 0000 0178 USARTE0.DATA=c;
	LD   R30,Y
	STS  2720,R30
; 0000 0179 }
	RJMP _0x20C0018
; .FEND
;#pragma used-
;
;
;// PORTB interrupt 0 service routine
;interrupt [PORTB_INT0_vect] void portb_int0_isr(void)
; 0000 017F {
_portb_int0_isr:
; .FSTART _portb_int0_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0180 PORTD.OUT = buffer_1[b];
	LDI  R26,LOW(_buffer_1)
	LDI  R27,HIGH(_buffer_1)
	ADD  R26,R8
	ADC  R27,R9
	LD   R30,X
	STS  1636,R30
; 0000 0181 if (b<1535)
	LDI  R30,LOW(1535)
	LDI  R31,HIGH(1535)
	CP   R8,R30
	CPC  R9,R31
	BRSH _0x10
; 0000 0182     {
; 0000 0183     b++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0184     }
; 0000 0185 else
	RJMP _0x11
_0x10:
; 0000 0186     {
; 0000 0187     PORTB.OUT CLR_B(0);   //PORTB.0 = 0;   (AVR_READY)
	LDS  R30,1572
	ANDI R30,0xFE
	STS  1572,R30
; 0000 0188     b=0;
	CLR  R8
	CLR  R9
; 0000 0189     }
_0x11:
; 0000 018A }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;
;
;void main(void)
; 0000 018F {
_main:
; .FSTART _main
; 0000 0190 unsigned char n;
; 0000 0191 
; 0000 0192 /* Interrupt system initialization
; 0000 0193    Optimize for speed */
; 0000 0194 #pragma optsize-
; 0000 0195 /* Low level interrupt: On
; 0000 0196    Round-robin scheduling for low level interrupt: Off
; 0000 0197    Medium level interrupt: Off
; 0000 0198    High level interrupt: Off
; 0000 0199    The interrupt vectors will be placed at the start of the Application FLASH section */
; 0000 019A n=(PMIC.CTRL & (~(PMIC_RREN_bm | PMIC_IVSEL_bm | PMIC_HILVLEN_bm | PMIC_MEDLVLEN_bm | PMIC_LOLVLEN_bm))) |
;	n -> R17
; 0000 019B 	PMIC_LOLVLEN_bm | PMIC_HILVLEN_bm;
	LDS  R30,162
	ANDI R30,LOW(0x38)
	ORI  R30,LOW(0x5)
	MOV  R17,R30
; 0000 019C CCP=CCP_IOREG_gc;
	LDI  R30,LOW(216)
	OUT  0x34,R30
; 0000 019D PMIC.CTRL=n;
	STS  162,R17
; 0000 019E /* Set the default priority for round-robin scheduling */
; 0000 019F PMIC.INTPRI=0x00;
	LDI  R30,LOW(0)
	STS  161,R30
; 0000 01A0 /* Restore optimization for size if needed */
; 0000 01A1 #pragma optsize_default
; 0000 01A2 
; 0000 01A3 
; 0000 01A4 system_clocks_init();
	RCALL _system_clocks_init
; 0000 01A5 rtcxm_init();
	RCALL _rtcxm_init
; 0000 01A6 ports_init();
	RCALL _ports_init
; 0000 01A7 PORTD.DIR=0xFF;    //порт-передатчик
	LDI  R30,LOW(255)
	STS  1632,R30
; 0000 01A8 PORTB.OUT CLR_B(0);      //AVR_READY=0;
	LDS  R30,1572
	ANDI R30,0xFE
	STS  1572,R30
; 0000 01A9 PORTB.OUT CLR_B(1);      //RESET ПЛИС  PORTB.1 = 0
	LDS  R30,1572
	ANDI R30,0xFD
	STS  1572,R30
; 0000 01AA b = 0;
	CLR  R8
	CLR  R9
; 0000 01AB usarte0_init();
	RCALL _usarte0_init
; 0000 01AC 
; 0000 01AD 
; 0000 01AE /* globally enable interrupts */
; 0000 01AF #asm("sei")
	sei
; 0000 01B0 
; 0000 01B1 //search = 0;                            //search это значение b (байта, дискреты)   на поиск фрейма уходит около 330мс
; 0000 01B2 //if ((res=f_lseek(&file, search))==FR_OK)    /////////так производится перемещение по файлу
; 0000 01B3 
; 0000 01B4 if ((res=f_mount(0,&fat))==FR_OK)       //////////монтируем подключенный диск mount logical drive 0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(_fat)
	LDI  R27,HIGH(_fat)
	CALL _f_mount
	MOV  R3,R30
; 0000 01B5     {
; 0000 01B6     }
; 0000 01B7 
; 0000 01B8 delay_ms(2000);                                 //задержка при включении, ждем загрузки ПЛИС и STM
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 01B9 
; 0000 01BA while(1)
_0x13:
; 0000 01BB {
; 0000 01BC if ((res=f_open(&file,path,FA_READ))==FR_OK)                /////////////////открываем файл по одресу path для чтения
	LDI  R30,LOW(_file)
	LDI  R31,HIGH(_file)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_path)
	LDI  R31,HIGH(_path)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _f_open
	MOV  R3,R30
	CPI  R30,0
	BREQ PC+2
	RJMP _0x16
; 0000 01BD     {
; 0000 01BE     SEND[0]=path[7]-48;                               /////номер папки пишем в массив
	__GETB1MN _path,7
	SUBI R30,LOW(48)
	STS  _SEND,R30
; 0000 01BF     SEND[1]=(10*(path[15]-48))+path[16]-48;           //Отправляем номер трека
	__GETB1MN _path,15
	SUBI R30,LOW(48)
	LDI  R26,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R26,R30
	__GETB1MN _path,16
	ADD  R26,R30
	LDI  R30,LOW(48)
	CALL __SWAPB12
	SUB  R30,R26
	__PUTB1MN _SEND,1
; 0000 01C0     if ((res=f_lseek(&file, 55))==FR_OK)               //переход к началу точек в файле
	LDI  R30,LOW(_file)
	LDI  R31,HIGH(_file)
	ST   -Y,R31
	ST   -Y,R30
	__GETD2N 0x37
	CALL _f_lseek
	MOV  R3,R30
	CPI  R30,0
	BREQ PC+2
	RJMP _0x17
; 0000 01C1         {
; 0000 01C2         if ((res=f_read(&file,FROM_SD,sizeof(FROM_SD),&nbytes))==FR_OK)              ////Вычитываем горячие точки из фай ...
	LDI  R30,LOW(_file)
	LDI  R31,HIGH(_file)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_FROM_SD)
	LDI  R31,HIGH(_FROM_SD)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R5
	PUSH R4
	CALL _f_read
	POP  R4
	POP  R5
	MOV  R3,R30
	CPI  R30,0
	BREQ PC+2
	RJMP _0x18
; 0000 01C3             {
; 0000 01C4             if ((res=f_stat(path,&finfo))==FR_OK)
	LDI  R30,LOW(_path)
	LDI  R31,HIGH(_path)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_finfo)
	LDI  R27,HIGH(_finfo)
	CALL _f_stat
	MOV  R3,R30
	CPI  R30,0
	BREQ PC+2
	RJMP _0x19
; 0000 01C5                 {
; 0000 01C6                 if ((res=f_read(&file,&analyzing,sizeof(1),&nbytes))==FR_OK)              ////Вычитываем флаг анализиров ...
	LDI  R30,LOW(_file)
	LDI  R31,HIGH(_file)
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R13
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R5
	PUSH R4
	CALL _f_read
	POP  R4
	POP  R5
	POP  R13
	MOV  R3,R30
	CPI  R30,0
	BREQ PC+2
	RJMP _0x1A
; 0000 01C7                     {
; 0000 01C8                     if ((res=f_read(&file,WFM,sizeof(WFM),&nbytes))==FR_OK)              ////Вычитываем Waveform из трек ...
	LDI  R30,LOW(_file)
	LDI  R31,HIGH(_file)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_WFM)
	LDI  R31,HIGH(_WFM)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R5
	PUSH R4
	CALL _f_read
	POP  R4
	POP  R5
	MOV  R3,R30
	CPI  R30,0
	BREQ PC+2
	RJMP _0x1B
; 0000 01C9                         {
; 0000 01CA                         flength=finfo.fsize;                     ////вычисление длины файла в байтах
	LDS  R30,_finfo
	LDS  R31,_finfo+1
	LDS  R22,_finfo+2
	LDS  R23,_finfo+3
	STS  _flength,R30
	STS  _flength+1,R31
	STS  _flength+2,R22
	STS  _flength+3,R23
; 0000 01CB                         flength=flength-124;                     //отнимаем от файла размер заголовка
	__SUBD1N 124
	STS  _flength,R30
	STS  _flength+1,R31
	STS  _flength+2,R22
	STS  _flength+3,R23
; 0000 01CC                         remain=flength/1536;                     //определение колечества посылок по 1536 байт
	LDS  R26,_flength
	LDS  R27,_flength+1
	LDS  R24,_flength+2
	LDS  R25,_flength+3
	__GETD1N 0x600
	CALL __DIVD21U
	MOVW R6,R30
; 0000 01CD                         if(flength>33554431)                                //////////////////////////////////////////// ...
	LDS  R26,_flength
	LDS  R27,_flength+1
	LDS  R24,_flength+2
	LDS  R25,_flength+3
	__CPD2N 0x2000000
	BRLO _0x1C
; 0000 01CE                             {                                               //
; 0000 01CF                             FPGA_TRACK_TIME = 255;                          //
	LDI  R30,LOW(255)
	MOV  R2,R30
; 0000 01D0                             SEND[2]=(256*FROM_SD[0]+FROM_SD[1])/512;        //
	LDS  R31,_FROM_SD
	LDI  R30,LOW(0)
	MOVW R26,R30
	__GETB1MN _FROM_SD,1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __DIVW21
	__PUTB1MN _SEND,2
; 0000 01D1                             SEND[3]=(256*FROM_SD[2]+FROM_SD[3])/512;        //
	__GETB1HMN _FROM_SD,2
	LDI  R30,LOW(0)
	MOVW R26,R30
	__GETB1MN _FROM_SD,3
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __DIVW21
	__PUTB1MN _SEND,3
; 0000 01D2                             flength=381;                                    //
	__GETD1N 0x17D
	RJMP _0x5C
; 0000 01D3                             }                                               //    Вычисление временной переменной для от ...
; 0000 01D4                         else                                                //
_0x1C:
; 0000 01D5                             {                                               //
; 0000 01D6                             FPGA_TRACK_TIME = flength/131587;               //                           и STM
	LDS  R26,_flength
	LDS  R27,_flength+1
	LDS  R24,_flength+2
	LDS  R25,_flength+3
	__GETD1N 0x20203
	CALL __DIVD21U
	MOV  R2,R30
; 0000 01D7                             allsec=flength/65536;                           //
	LDS  R26,_flength
	LDS  R27,_flength+1
	LDS  R24,_flength+2
	LDS  R25,_flength+3
	__GETD1N 0x10000
	CALL __DIVD21U
	MOVW R10,R30
; 0000 01D8                             SEND[2]=(256*FROM_SD[0]+FROM_SD[1])/allsec;     //
	LDS  R31,_FROM_SD
	LDI  R30,LOW(0)
	MOVW R26,R30
	__GETB1MN _FROM_SD,1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R10
	CALL __DIVW21U
	__PUTB1MN _SEND,2
; 0000 01D9                             SEND[3]=(256*FROM_SD[2]+FROM_SD[3])/allsec;     //
	__GETB1HMN _FROM_SD,2
	LDI  R30,LOW(0)
	MOVW R26,R30
	__GETB1MN _FROM_SD,3
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R10
	CALL __DIVW21U
	__PUTB1MN _SEND,3
; 0000 01DA                             flength=flength/88200;                          //
	LDS  R26,_flength
	LDS  R27,_flength+1
	LDS  R24,_flength+2
	LDS  R25,_flength+3
	__GETD1N 0x15888
	CALL __DIVD21U
_0x5C:
	STS  _flength,R30
	STS  _flength+1,R31
	STS  _flength+2,R22
	STS  _flength+3,R23
; 0000 01DB                             }                                               //////////////////////////////////////////// ...
; 0000 01DC                         SEND[4]=flength/256;
	LDS  R26,_flength
	LDS  R27,_flength+1
	LDS  R24,_flength+2
	LDS  R25,_flength+3
	__GETD1N 0x100
	CALL __DIVD21U
	__PUTB1MN _SEND,4
; 0000 01DD                         SEND[5]=flength%256;
	LDS  R30,_flength
	__PUTB1MN _SEND,5
; 0000 01DE                         if(!(analyzing==170))           /////если трек оказался не проанализирован, то место в буффере,  ...
	LDI  R30,LOW(170)
	CP   R30,R13
	BREQ _0x1E
; 0000 01DF                             {
; 0000 01E0                             cnt_uart=0;
	CLR  R12
; 0000 01E1                             while(cnt_uart<64)
_0x1F:
	LDI  R30,LOW(64)
	CP   R12,R30
	BRSH _0x21
; 0000 01E2                                 {
; 0000 01E3                                 WFM[cnt_uart]=0;
	MOV  R30,R12
	LDI  R31,0
	SUBI R30,LOW(-_WFM)
	SBCI R31,HIGH(-_WFM)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 01E4                                 cnt_uart++;
	INC  R12
; 0000 01E5                                 }
	RJMP _0x1F
_0x21:
; 0000 01E6                             }
; 0000 01E7                         cnt_uart=0;
_0x1E:
	CLR  R12
; 0000 01E8                         while(cnt_uart<70)
_0x22:
	LDI  R30,LOW(70)
	CP   R12,R30
	BRSH _0x24
; 0000 01E9                             {
; 0000 01EA                             if(cnt_uart<64)
	LDI  R30,LOW(64)
	CP   R12,R30
	BRSH _0x25
; 0000 01EB                                 {
; 0000 01EC                                 putchar_usarte0(WFM[cnt_uart]);
	MOV  R30,R12
	LDI  R31,0
	SUBI R30,LOW(-_WFM)
	SBCI R31,HIGH(-_WFM)
	RJMP _0x5D
; 0000 01ED                                 }
; 0000 01EE                             else
_0x25:
; 0000 01EF                                 {
; 0000 01F0                                 putchar_usarte0(SEND[cnt_uart-64]);
	MOV  R30,R12
	SUBI R30,LOW(64)
	LDI  R31,0
	SUBI R30,LOW(-_SEND)
	SBCI R31,HIGH(-_SEND)
_0x5D:
	LD   R26,Z
	RCALL _putchar_usarte0
; 0000 01F1                                 }
; 0000 01F2                             cnt_uart++;
	INC  R12
; 0000 01F3                             }
	RJMP _0x22
_0x24:
; 0000 01F4 
; 0000 01F5                         PORTD.OUT=FROM_SD[0];
	LDS  R30,_FROM_SD
	STS  1636,R30
; 0000 01F6                         delay_us(1);
	__DELAY_USB 11
; 0000 01F7                         PORTB.OUT SET_B(0);      //AVR_READY=1;
	LDS  R30,1572
	ORI  R30,1
	STS  1572,R30
; 0000 01F8                         delay_us(1);
	__DELAY_USB 11
; 0000 01F9                         PORTB.OUT CLR_B(0);      //AVR_READY=0;
	LDS  R30,1572
	ANDI R30,0xFE
	STS  1572,R30
; 0000 01FA                         PORTD.OUT=FROM_SD[1];
	__GETB1MN _FROM_SD,1
	STS  1636,R30
; 0000 01FB                         delay_us(1);
	__DELAY_USB 11
; 0000 01FC                         PORTB.OUT SET_B(0);      //AVR_READY=1;
	LDS  R30,1572
	ORI  R30,1
	STS  1572,R30
; 0000 01FD                         delay_us(1);
	__DELAY_USB 11
; 0000 01FE                         PORTB.OUT CLR_B(0);      //AVR_READY=0;
	LDS  R30,1572
	ANDI R30,0xFE
	STS  1572,R30
; 0000 01FF                         PORTD.OUT=FROM_SD[2];
	__GETB1MN _FROM_SD,2
	STS  1636,R30
; 0000 0200                         delay_us(1);
	__DELAY_USB 11
; 0000 0201                         PORTB.OUT SET_B(0);      //AVR_READY=1;
	LDS  R30,1572
	ORI  R30,1
	STS  1572,R30
; 0000 0202                         delay_us(1);
	__DELAY_USB 11
; 0000 0203                         PORTB.OUT CLR_B(0);      //AVR_READY=0;
	LDS  R30,1572
	ANDI R30,0xFE
	STS  1572,R30
; 0000 0204                         PORTD.OUT=FROM_SD[3];
	__GETB1MN _FROM_SD,3
	STS  1636,R30
; 0000 0205                         delay_us(1);
	__DELAY_USB 11
; 0000 0206                         PORTB.OUT SET_B(0);      //AVR_READY=1;
	LDS  R30,1572
	ORI  R30,1
	STS  1572,R30
; 0000 0207                         delay_us(1);
	__DELAY_USB 11
; 0000 0208                         PORTB.OUT CLR_B(0);      //AVR_READY=0;
	LDS  R30,1572
	ANDI R30,0xFE
	STS  1572,R30
; 0000 0209                         PORTD.OUT=FPGA_TRACK_TIME;               /////// отправка временной переменной для FPGA
	STS  1636,R2
; 0000 020A                         delay_us(1);
	__DELAY_USB 11
; 0000 020B                         PORTB.OUT SET_B(0);      //AVR_READY=1;
	LDS  R30,1572
	ORI  R30,1
	STS  1572,R30
; 0000 020C                         delay_us(1);
	__DELAY_USB 11
; 0000 020D                         PORTB.OUT CLR_B(0);      //AVR_READY=0;
	LDS  R30,1572
	ANDI R30,0xFE
	STS  1572,R30
; 0000 020E                         delay_us(1);
	__DELAY_USB 11
; 0000 020F                         play = 1;
	SBI  0x0,0
; 0000 0210                         PORTB.OUT SET_B(1);                   //PORTB.1 = 1  снимаем RESET CPLD
	LDS  R30,1572
	ORI  R30,2
	STS  1572,R30
; 0000 0211                         PORTB.INT0MASK=0x08;                  //включения прерывания
	LDI  R30,LOW(8)
	STS  1578,R30
; 0000 0212                         }
; 0000 0213                     }
_0x1B:
; 0000 0214                 }
_0x1A:
; 0000 0215             }
_0x19:
; 0000 0216         }
_0x18:
; 0000 0217     }
_0x17:
; 0000 0218 else
	RJMP _0x29
_0x16:
; 0000 0219     {
; 0000 021A     PORTB.OUT CLR_B(1);                                   //PORTB.1 = 0
	LDS  R30,1572
	ANDI R30,0xFD
	STS  1572,R30
; 0000 021B     }
_0x29:
; 0000 021C 
; 0000 021D while(play)
_0x2A:
	SBIS 0x0,0
	RJMP _0x2C
; 0000 021E     {
; 0000 021F     if(!(PORTB.OUT&1<<0))
	LDS  R30,1572
	ANDI R30,LOW(0x1)
	BRNE _0x2D
; 0000 0220         {
; 0000 0221         if ((res=f_read(&file,buffer_1,sizeof(buffer_1),&nbytes))==FR_OK)              ////зачитываем данные и пишем в b ...
	LDI  R30,LOW(_file)
	LDI  R31,HIGH(_file)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_buffer_1)
	LDI  R31,HIGH(_buffer_1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1536)
	LDI  R31,HIGH(1536)
	ST   -Y,R31
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R5
	PUSH R4
	CALL _f_read
	POP  R4
	POP  R5
	MOV  R3,R30
	CPI  R30,0
	BRNE _0x2E
; 0000 0222             {
; 0000 0223             PORTB.OUT SET_B(0);        //PORTB.0 = 1    (AVR_READY)
	LDS  R30,1572
	ORI  R30,1
	STS  1572,R30
; 0000 0224             if(remain==0)
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x2F
; 0000 0225                 {
; 0000 0226                 PORTB.INT0MASK=0x00;    //отключаем прерывание
	LDI  R30,LOW(0)
	STS  1578,R30
; 0000 0227                 if ((res=f_close(&file))==FR_OK)     ///////////////////закрываем файл
	LDI  R26,LOW(_file)
	LDI  R27,HIGH(_file)
	CALL _f_close
	MOV  R3,R30
; 0000 0228                     {}
; 0000 0229                 }
; 0000 022A             else
	RJMP _0x31
_0x2F:
; 0000 022B                 {
; 0000 022C                 remain--;
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
	ADIW R30,1
; 0000 022D                 }
_0x31:
; 0000 022E             }
; 0000 022F         }
_0x2E:
; 0000 0230 
; 0000 0231     if((PORTC.IN&1<<1 || PORTC.IN&1<<2) & stt==0)             //нажали клавишу NEXT or FF     PINC.1 или PINC.2
_0x2D:
	LDS  R30,1608
	ANDI R30,LOW(0x2)
	BRNE _0x33
	LDS  R30,1608
	ANDI R30,LOW(0x4)
	BRNE _0x33
	LDI  R30,0
	RJMP _0x34
_0x33:
	LDI  R30,1
_0x34:
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x0,1
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x32
; 0000 0232         {
; 0000 0233         PORTB.OUT CLR_B(0);      //AVR_READY=0;
	LDS  R30,1572
	ANDI R30,0xFE
	STS  1572,R30
; 0000 0234         if(PORTC.IN&1<<1)
	LDS  R30,1608
	ANDI R30,LOW(0x2)
	BREQ _0x35
; 0000 0235             {
; 0000 0236             nxt=1;              //переключаем следующий трек или папку
	SBI  0x0,2
; 0000 0237             }
; 0000 0238         else
	RJMP _0x38
_0x35:
; 0000 0239             {
; 0000 023A             nxt=0;             //переключаем следующий трек или папку
	CBI  0x0,2
; 0000 023B             }
_0x38:
; 0000 023C         fldr=PORTC.IN&1<<3;
	LDS  R30,1608
	ANDI R30,LOW(0x8)
	BRNE _0x3B
	CBI  0x0,3
	RJMP _0x3C
_0x3B:
	SBI  0x0,3
_0x3C:
; 0000 023D         play = 0;
	CBI  0x0,0
; 0000 023E         stt = 1;
	SBI  0x0,1
; 0000 023F         PORTB.INT0MASK=0x00;     //отключаем прерывание
	LDI  R30,LOW(0)
	STS  1578,R30
; 0000 0240         if ((res=f_close(&file))==FR_OK)     ///////////////////закрываем файл
	LDI  R26,LOW(_file)
	LDI  R27,HIGH(_file)
	CALL _f_close
	MOV  R3,R30
	CPI  R30,0
	BRNE _0x41
; 0000 0241         b = 0;
	CLR  R8
	CLR  R9
; 0000 0242         PORTB.OUT CLR_B(1);      //RESET ПЛИС  //PORTB.1 = 0
_0x41:
	LDS  R30,1572
	ANDI R30,0xFD
	STS  1572,R30
; 0000 0243         ////delay_ms(10);           /// задержка нажатия клавиши. для цифрового кода не нужна
; 0000 0244         }
; 0000 0245 
; 0000 0246     if((!(PORTC.IN&1<<1)) & (!(PORTC.IN&1<<2)))                           //отпустили клавишу NEXT or FF
_0x32:
	LDS  R30,1608
	ANDI R30,LOW(0x2)
	CALL __LNEGB1
	MOV  R26,R30
	LDS  R30,1608
	ANDI R30,LOW(0x4)
	CALL __LNEGB1
	AND  R30,R26
	BREQ _0x42
; 0000 0247         {
; 0000 0248         stt = 0;
	CBI  0x0,1
; 0000 0249         }
; 0000 024A     }
_0x42:
	RJMP _0x2A
_0x2C:
; 0000 024B 
; 0000 024C 
; 0000 024D if(fldr==1)                          /////////////////////////////////////////////////////////////переключение треков и  ...
	SBIS 0x0,3
	RJMP _0x45
; 0000 024E     {
; 0000 024F     fldr=0;
	CBI  0x0,3
; 0000 0250     path[15]=48;                    //выставляем Track_01
	LDI  R30,LOW(48)
	__PUTB1MN _path,15
; 0000 0251     path[16]=49;                    //
	LDI  R30,LOW(49)
	__PUTB1MN _path,16
; 0000 0252     if(nxt)
	SBIS 0x0,2
	RJMP _0x48
; 0000 0253         {
; 0000 0254         if(path[7]==54)
	__GETB2MN _path,7
	CPI  R26,LOW(0x36)
	BRNE _0x49
; 0000 0255             {
; 0000 0256             path[7]=49;
	LDI  R30,LOW(49)
	RJMP _0x5E
; 0000 0257             }
; 0000 0258         else
_0x49:
; 0000 0259             {
; 0000 025A             path[7]++;
	__GETB1MN _path,7
	SUBI R30,-LOW(1)
_0x5E:
	__PUTB1MN _path,7
; 0000 025B             }
; 0000 025C         }
; 0000 025D     else
	RJMP _0x4B
_0x48:
; 0000 025E         {
; 0000 025F         nxt=1;
	SBI  0x0,2
; 0000 0260         if(path[7]==49)
	__GETB2MN _path,7
	CPI  R26,LOW(0x31)
	BRNE _0x4E
; 0000 0261             {
; 0000 0262             path[7]=54;
	LDI  R30,LOW(54)
	RJMP _0x5F
; 0000 0263             }
; 0000 0264         else
_0x4E:
; 0000 0265             {
; 0000 0266             path[7]--;
	__GETB1MN _path,7
	SUBI R30,LOW(1)
_0x5F:
	__PUTB1MN _path,7
; 0000 0267             }
; 0000 0268         }
_0x4B:
; 0000 0269     }
; 0000 026A else
	RJMP _0x50
_0x45:
; 0000 026B     {
; 0000 026C     if(nxt)
	SBIS 0x0,2
	RJMP _0x51
; 0000 026D         {
; 0000 026E         if(path[16]==57)
	__GETB2MN _path,16
	CPI  R26,LOW(0x39)
	BRNE _0x52
; 0000 026F             {
; 0000 0270             path[16]=48;
	LDI  R30,LOW(48)
	__PUTB1MN _path,16
; 0000 0271             if(path[15]==57)
	__GETB2MN _path,15
	CPI  R26,LOW(0x39)
	BRNE _0x53
; 0000 0272                 {
; 0000 0273                 path[15]=48;
	__PUTB1MN _path,15
; 0000 0274                 path[16]=49;
	LDI  R30,LOW(49)
	__PUTB1MN _path,16
; 0000 0275                 }
; 0000 0276             else
	RJMP _0x54
_0x53:
; 0000 0277                 {
; 0000 0278                 path[15]++;
	__GETB1MN _path,15
	SUBI R30,-LOW(1)
	__PUTB1MN _path,15
; 0000 0279                 }
_0x54:
; 0000 027A             }
; 0000 027B         else
	RJMP _0x55
_0x52:
; 0000 027C             {
; 0000 027D             path[16]++;
	__GETB1MN _path,16
	SUBI R30,-LOW(1)
	__PUTB1MN _path,16
; 0000 027E             }
_0x55:
; 0000 027F         }
; 0000 0280     else
	RJMP _0x56
_0x51:
; 0000 0281         {
; 0000 0282         if(path[16]==48)
	__GETB2MN _path,16
	CPI  R26,LOW(0x30)
	BRNE _0x57
; 0000 0283             {
; 0000 0284             path[16]=57;
	LDI  R30,LOW(57)
	__PUTB1MN _path,16
; 0000 0285             if(path[15]==48)
	__GETB2MN _path,15
	CPI  R26,LOW(0x30)
	BRNE _0x58
; 0000 0286                 {
; 0000 0287                 path[15]=57;
	__PUTB1MN _path,15
; 0000 0288                 path[16]=57;
	__PUTB1MN _path,16
; 0000 0289                 }
; 0000 028A             else
	RJMP _0x59
_0x58:
; 0000 028B                 {
; 0000 028C                 path[15]--;
	__GETB1MN _path,15
	SUBI R30,LOW(1)
	__PUTB1MN _path,15
; 0000 028D                 }
_0x59:
; 0000 028E             }
; 0000 028F         else
	RJMP _0x5A
_0x57:
; 0000 0290             {
; 0000 0291             path[16]--;
	__GETB1MN _path,16
	SUBI R30,LOW(1)
	__PUTB1MN _path,16
; 0000 0292             }
_0x5A:
; 0000 0293         }
_0x56:
; 0000 0294     }
_0x50:
; 0000 0295 }
	RJMP _0x13
; 0000 0296 }
_0x5B:
	RJMP _0x5B
; .FEND
;
;

	.DSEG

	.CSEG
_crc7_G100:
; .FSTART _crc7_G100
	ST   -Y,R26
	CALL __SAVELOCR4
	LDI  R18,LOW(0)
	LDD  R16,Y+4
_0x2000005:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	LD   R19,X+
	STD  Y+5,R26
	STD  Y+5+1,R27
	LDI  R17,LOW(8)
_0x2000008:
	LSL  R18
	MOV  R30,R18
	EOR  R30,R19
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	LDI  R30,LOW(9)
	EOR  R18,R30
_0x200000A:
	LSL  R19
	SUBI R17,LOW(1)
	BRNE _0x2000008
	SUBI R16,LOW(1)
	BRNE _0x2000005
	MOV  R30,R18
	LSL  R30
	ORI  R30,1
	CALL __LOADLOCR4
	RJMP _0x20C0014
; .FEND
_wait_ready_G100:
; .FSTART _wait_ready_G100
	ST   -Y,R17
	LDI  R30,LOW(50)
	STS  _timer2_G100,R30
	LDI  R30,LOW(255)
	STS  2243,R30
_0x200000B:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x200000B
_0x200000F:
	LDI  R30,LOW(255)
	STS  2243,R30
_0x2000011:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000011
	LDS  R17,2243
	CPI  R17,255
	BREQ _0x2000014
	LDS  R30,_timer2_G100
	CPI  R30,0
	BRNE _0x2000015
_0x2000014:
	RJMP _0x2000010
_0x2000015:
	RJMP _0x200000F
_0x2000010:
	MOV  R30,R17
	RJMP _0x20C0015
; .FEND
_deselect_card_G100:
; .FSTART _deselect_card_G100
	LDI  R30,LOW(16)
	STS  1605,R30
	LDI  R30,LOW(255)
	STS  2243,R30
_0x2000016:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000016
	RET
; .FEND
_rx_datablock_G100:
; .FSTART _rx_datablock_G100
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	LDI  R30,LOW(20)
	STS  _timer1_G100,R30
_0x200001A:
	LDI  R30,LOW(255)
	STS  2243,R30
_0x200001C:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x200001C
	LDS  R17,2243
	CPI  R17,255
	BRNE _0x200001F
	LDS  R30,_timer1_G100
	CPI  R30,0
	BRNE _0x2000020
_0x200001F:
	RJMP _0x200001B
_0x2000020:
	RJMP _0x200001A
_0x200001B:
	CPI  R17,254
	BREQ _0x2000021
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	RJMP _0x20C0017
_0x2000021:
	__GETWRS 18,19,6
_0x2000023:
	LDI  R30,LOW(255)
	STS  2243,R30
_0x2000025:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000025
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	LDS  R30,2243
	POP  R26
	POP  R27
	ST   X,R30
	LDI  R30,LOW(255)
	STS  2243,R30
_0x2000028:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000028
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	LDS  R30,2243
	POP  R26
	POP  R27
	ST   X,R30
	LDI  R30,LOW(255)
	STS  2243,R30
_0x200002B:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x200002B
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	LDS  R30,2243
	POP  R26
	POP  R27
	ST   X,R30
	LDI  R30,LOW(255)
	STS  2243,R30
_0x200002E:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x200002E
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	LDS  R30,2243
	POP  R26
	POP  R27
	ST   X,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,4
	STD  Y+4,R30
	STD  Y+4+1,R31
	BREQ _0x2000024
	RJMP _0x2000023
_0x2000024:
	LDI  R30,LOW(255)
	STS  2243,R30
_0x2000031:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000031
	LDI  R30,LOW(255)
	STS  2243,R30
_0x2000034:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000034
	LDI  R30,LOW(1)
	CALL __LOADLOCR4
	RJMP _0x20C0017
; .FEND
_tx_datablock_G100:
; .FSTART _tx_datablock_G100
	ST   -Y,R26
	CALL __SAVELOCR4
	RCALL _wait_ready_G100
	CPI  R30,LOW(0xFF)
	BREQ _0x2000037
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	RJMP _0x20C0014
_0x2000037:
	LDD  R30,Y+4
	STS  2243,R30
_0x2000038:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000038
	LDD  R26,Y+4
	CPI  R26,LOW(0xFD)
	BREQ _0x200003B
	LDI  R16,LOW(0)
	__GETWRS 18,19,5
_0x200003D:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	STS  2243,R30
_0x200003F:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x200003F
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	STS  2243,R30
_0x2000042:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000042
	SUBI R16,LOW(1)
	BRNE _0x200003D
	LDI  R30,LOW(255)
	STS  2243,R30
_0x2000045:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000045
	LDI  R30,LOW(255)
	STS  2243,R30
_0x2000048:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000048
	LDI  R30,LOW(255)
	STS  2243,R30
_0x200004B:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x200004B
	LDS  R17,2243
	MOV  R30,R17
	ANDI R30,LOW(0x1F)
	CPI  R30,LOW(0x5)
	BREQ _0x200004E
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	RJMP _0x20C0014
_0x200004E:
_0x200003B:
	LDI  R30,LOW(1)
	CALL __LOADLOCR4
	RJMP _0x20C0014
; .FEND
_send_cmd_G100:
; .FSTART _send_cmd_G100
	CALL __PUTPARD2
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+6
	ANDI R30,LOW(0x80)
	BREQ _0x200004F
	LDD  R30,Y+6
	ANDI R30,0x7F
	STD  Y+6,R30
	LDI  R30,LOW(119)
	ST   -Y,R30
	__GETD2N 0x0
	RCALL _send_cmd_G100
	MOV  R16,R30
	CPI  R16,2
	BRLO _0x2000050
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C0014
_0x2000050:
_0x200004F:
	LDD  R26,Y+6
	CPI  R26,LOW(0x4C)
	BREQ _0x2000051
	RCALL _deselect_card_G100
	LDI  R30,LOW(16)
	STS  1606,R30
	RCALL _wait_ready_G100
	CPI  R30,LOW(0xFF)
	BREQ _0x2000052
	LDI  R30,LOW(255)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C0014
_0x2000052:
_0x2000051:
	LDD  R30,Y+6
	STS  2243,R30
_0x2000053:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000053
	LDD  R30,Y+5
	STS  2243,R30
_0x2000056:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000056
	LDD  R30,Y+4
	STS  2243,R30
_0x2000059:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000059
	LDD  R30,Y+3
	STS  2243,R30
_0x200005C:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x200005C
	LDD  R30,Y+2
	STS  2243,R30
_0x200005F:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x200005F
	LDI  R17,LOW(1)
	LDD  R26,Y+6
	CPI  R26,LOW(0x40)
	BRNE _0x2000062
	LDI  R17,LOW(149)
	RJMP _0x2000063
_0x2000062:
	LDD  R26,Y+6
	CPI  R26,LOW(0x48)
	BRNE _0x2000064
	LDI  R17,LOW(135)
_0x2000064:
_0x2000063:
	STS  2243,R17
_0x2000065:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000065
	LDD  R26,Y+6
	CPI  R26,LOW(0x4C)
	BRNE _0x2000068
	LDI  R30,LOW(255)
	STS  2243,R30
_0x2000069:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000069
_0x2000068:
	LDI  R17,LOW(255)
_0x200006D:
	LDI  R30,LOW(255)
	STS  2243,R30
_0x200006F:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x200006F
	LDS  R16,2243
	SBRS R16,7
	RJMP _0x2000072
	SUBI R17,LOW(1)
	BRNE _0x2000073
_0x2000072:
	RJMP _0x200006E
_0x2000073:
	RJMP _0x200006D
_0x200006E:
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C0014
; .FEND
_rx_spi4_G100:
; .FSTART _rx_spi4_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDI  R17,4
_0x2000075:
	LDI  R30,LOW(255)
	STS  2243,R30
_0x2000077:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000077
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	STD  Y+1,R26
	STD  Y+1+1,R27
	SBIW R26,1
	LDS  R30,2243
	ST   X,R30
	SUBI R17,LOW(1)
	BRNE _0x2000075
	RJMP _0x20C0012
; .FEND
_disk_initialize:
; .FSTART _disk_initialize
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR4
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x200007A
	LDI  R30,LOW(1)
	RJMP _0x20C001A
_0x200007A:
	LDI  R30,LOW(10)
	STS  _timer1_G100,R30
_0x200007B:
	LDS  R30,_timer1_G100
	CPI  R30,0
	BRNE _0x200007B
	LDS  R30,_status_G100
	ANDI R30,LOW(0x2)
	BREQ _0x200007E
	RJMP _0x20C0019
_0x200007E:
	LDI  R30,LOW(16)
	STS  1601,R30
	STS  1605,R30
	LDI  R30,LOW(160)
	STS  1606,R30
	LDI  R30,LOW(64)
	STS  1602,R30
	LDI  R30,LOW(24)
	STS  1622,R30
	LDI  R30,LOW(176)
	STS  1601,R30
	LDI  R30,LOW(83)
	STS  2240,R30
	LDI  R19,LOW(5)
_0x2000080:
	LDI  R17,LOW(10)
_0x2000083:
	LDI  R30,LOW(255)
	STS  2243,R30
_0x2000085:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x2000085
	SUBI R17,LOW(1)
	BRNE _0x2000083
	LDI  R30,LOW(64)
	ST   -Y,R30
	__GETD2N 0x0
	RCALL _send_cmd_G100
	MOV  R16,R30
	SUBI R19,LOW(1)
	CPI  R16,1
	BREQ _0x2000088
	CPI  R19,0
	BRNE _0x2000089
_0x2000088:
	RJMP _0x2000081
_0x2000089:
	RJMP _0x2000080
_0x2000081:
	LDI  R19,LOW(0)
	CPI  R16,1
	BREQ PC+2
	RJMP _0x200008A
	LDI  R30,LOW(100)
	STS  _timer1_G100,R30
	LDI  R30,LOW(72)
	ST   -Y,R30
	__GETD2N 0x1AA
	RCALL _send_cmd_G100
	CPI  R30,LOW(0x1)
	BRNE _0x200008B
	MOVW R26,R28
	ADIW R26,4
	RCALL _rx_spi4_G100
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BRNE _0x200008D
	LDD  R26,Y+7
	CPI  R26,LOW(0xAA)
	BREQ _0x200008E
_0x200008D:
	RJMP _0x200008C
_0x200008E:
_0x200008F:
	LDS  R30,_timer1_G100
	CPI  R30,0
	BREQ _0x2000092
	LDI  R30,LOW(233)
	ST   -Y,R30
	__GETD2N 0x40000000
	RCALL _send_cmd_G100
	CPI  R30,0
	BRNE _0x2000093
_0x2000092:
	RJMP _0x2000091
_0x2000093:
	RJMP _0x200008F
_0x2000091:
	LDS  R30,_timer1_G100
	CPI  R30,0
	BREQ _0x2000095
	LDI  R30,LOW(122)
	ST   -Y,R30
	__GETD2N 0x0
	RCALL _send_cmd_G100
	CPI  R30,0
	BREQ _0x2000096
_0x2000095:
	RJMP _0x2000094
_0x2000096:
	MOVW R26,R28
	ADIW R26,4
	RCALL _rx_spi4_G100
	LDD  R30,Y+4
	ANDI R30,LOW(0x40)
	BREQ _0x2000097
	LDI  R30,LOW(12)
	RJMP _0x2000098
_0x2000097:
	LDI  R30,LOW(4)
_0x2000098:
	MOV  R19,R30
_0x2000094:
_0x200008C:
	RJMP _0x200009A
_0x200008B:
	LDI  R30,LOW(233)
	ST   -Y,R30
	__GETD2N 0x0
	RCALL _send_cmd_G100
	CPI  R30,LOW(0x2)
	BRSH _0x200009B
	LDI  R19,LOW(2)
	LDI  R16,LOW(233)
	RJMP _0x200009C
_0x200009B:
	LDI  R19,LOW(1)
	LDI  R16,LOW(65)
_0x200009C:
_0x200009D:
	LDS  R30,_timer1_G100
	CPI  R30,0
	BREQ _0x20000A0
	ST   -Y,R16
	__GETD2N 0x0
	RCALL _send_cmd_G100
	CPI  R30,0
	BRNE _0x20000A1
_0x20000A0:
	RJMP _0x200009F
_0x20000A1:
	RJMP _0x200009D
_0x200009F:
	LDS  R30,_timer1_G100
	CPI  R30,0
	BREQ _0x20000A3
	LDI  R30,LOW(80)
	ST   -Y,R30
	__GETD2N 0x200
	RCALL _send_cmd_G100
	CPI  R30,0
	BREQ _0x20000A2
_0x20000A3:
	LDI  R19,LOW(0)
_0x20000A2:
_0x200009A:
_0x200008A:
	STS  _card_type_G100,R19
	RCALL _deselect_card_G100
	CPI  R19,0
	BREQ _0x20000A5
	LDS  R30,_status_G100
	ANDI R30,0xFE
	STS  _status_G100,R30
	LDI  R30,LOW(208)
	STS  2240,R30
	RJMP _0x20000A6
_0x20000A5:
	LDI  R30,LOW(16)
	STS  1606,R30
	RCALL _wait_ready_G100
	RCALL _deselect_card_G100
	LDI  R30,LOW(0)
	STS  2240,R30
	LDI  R30,LOW(240)
	STS  1602,R30
	LDI  R30,LOW(16)
	STS  1602,R30
	LDS  R30,_status_G100
	ORI  R30,1
	STS  _status_G100,R30
_0x20000A6:
_0x20C0019:
	LDS  R30,_status_G100
_0x20C001A:
	CALL __LOADLOCR4
	ADIW R28,9
	RET
; .FEND
_disk_status:
; .FSTART _disk_status
	ST   -Y,R26
	LD   R30,Y
	CPI  R30,0
	BREQ _0x20000A7
	LDI  R30,LOW(1)
	RJMP _0x20C0018
_0x20000A7:
	LDS  R30,_status_G100
_0x20C0018:
	ADIW R28,1
	RET
; .FEND
_disk_read:
; .FSTART _disk_read
	ST   -Y,R26
	LDD  R30,Y+7
	CPI  R30,0
	BRNE _0x20000A9
	LD   R30,Y
	CPI  R30,0
	BRNE _0x20000A8
_0x20000A9:
	LDI  R30,LOW(4)
	RJMP _0x20C0017
_0x20000A8:
	LDS  R30,_status_G100
	ANDI R30,LOW(0x1)
	BREQ _0x20000AB
	LDI  R30,LOW(3)
	RJMP _0x20C0017
_0x20000AB:
	LDS  R30,_card_type_G100
	ANDI R30,LOW(0x8)
	BRNE _0x20000AC
	__GETD1S 1
	__GETD2N 0x200
	CALL __MULD12U
	__PUTD1S 1
_0x20000AC:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x20000AD
	LDI  R30,LOW(81)
	ST   -Y,R30
	__GETD2S 2
	RCALL _send_cmd_G100
	CPI  R30,0
	BRNE _0x20000AE
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(512)
	LDI  R27,HIGH(512)
	RCALL _rx_datablock_G100
	CPI  R30,0
	BREQ _0x20000AF
	LDI  R30,LOW(0)
	ST   Y,R30
_0x20000AF:
_0x20000AE:
	RJMP _0x20000B0
_0x20000AD:
	LDI  R30,LOW(82)
	ST   -Y,R30
	__GETD2S 2
	RCALL _send_cmd_G100
	CPI  R30,0
	BRNE _0x20000B1
_0x20000B3:
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(512)
	LDI  R27,HIGH(512)
	RCALL _rx_datablock_G100
	CPI  R30,0
	BREQ _0x20000B4
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	SUBI R30,LOW(-512)
	SBCI R31,HIGH(-512)
	STD  Y+5,R30
	STD  Y+5+1,R31
	LD   R30,Y
	SUBI R30,LOW(1)
	ST   Y,R30
	BRNE _0x20000B3
_0x20000B4:
	LDI  R30,LOW(76)
	ST   -Y,R30
	__GETD2N 0x0
	RCALL _send_cmd_G100
_0x20000B1:
_0x20000B0:
	RCALL _deselect_card_G100
	LD   R30,Y
	CPI  R30,0
	BREQ _0x20000B6
	LDI  R30,LOW(1)
	RJMP _0x20000B7
_0x20000B6:
	LDI  R30,LOW(0)
_0x20000B7:
	RJMP _0x20C0017
; .FEND
_disk_write:
; .FSTART _disk_write
	ST   -Y,R26
	LDD  R30,Y+7
	CPI  R30,0
	BRNE _0x20000BA
	LD   R30,Y
	CPI  R30,0
	BRNE _0x20000B9
_0x20000BA:
	LDI  R30,LOW(4)
	RJMP _0x20C0017
_0x20000B9:
	LDS  R30,_status_G100
	ANDI R30,LOW(0x1)
	BREQ _0x20000BC
	LDI  R30,LOW(3)
	RJMP _0x20C0017
_0x20000BC:
	LDS  R30,_status_G100
	ANDI R30,LOW(0x4)
	BREQ _0x20000BD
	LDI  R30,LOW(2)
	RJMP _0x20C0017
_0x20000BD:
	LDS  R30,_card_type_G100
	ANDI R30,LOW(0x8)
	BRNE _0x20000BE
	__GETD1S 1
	__GETD2N 0x200
	CALL __MULD12U
	__PUTD1S 1
_0x20000BE:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x20000BF
	LDI  R30,LOW(88)
	ST   -Y,R30
	__GETD2S 2
	RCALL _send_cmd_G100
	CPI  R30,0
	BRNE _0x20000C0
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(254)
	RCALL _tx_datablock_G100
	CPI  R30,0
	BREQ _0x20000C1
	LDI  R30,LOW(0)
	ST   Y,R30
_0x20000C1:
_0x20000C0:
	RJMP _0x20000C2
_0x20000BF:
	LDS  R30,_card_type_G100
	ANDI R30,LOW(0x6)
	BREQ _0x20000C3
	LDI  R30,LOW(215)
	ST   -Y,R30
	LDD  R26,Y+1
	CLR  R27
	CLR  R24
	CLR  R25
	RCALL _send_cmd_G100
_0x20000C3:
	LDI  R30,LOW(89)
	ST   -Y,R30
	__GETD2S 2
	RCALL _send_cmd_G100
	CPI  R30,0
	BRNE _0x20000C4
_0x20000C6:
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(252)
	RCALL _tx_datablock_G100
	CPI  R30,0
	BREQ _0x20000C7
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	SUBI R30,LOW(-512)
	SBCI R31,HIGH(-512)
	STD  Y+5,R30
	STD  Y+5+1,R31
	LD   R30,Y
	SUBI R30,LOW(1)
	ST   Y,R30
	BRNE _0x20000C6
_0x20000C7:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(253)
	RCALL _tx_datablock_G100
	CPI  R30,0
	BRNE _0x20000C9
	LDI  R30,LOW(1)
	ST   Y,R30
_0x20000C9:
_0x20000C4:
_0x20000C2:
	RCALL _deselect_card_G100
	LD   R30,Y
	CPI  R30,0
	BREQ _0x20000CA
	LDI  R30,LOW(1)
	RJMP _0x20000CB
_0x20000CA:
	LDI  R30,LOW(0)
_0x20000CB:
_0x20C0017:
	ADIW R28,8
	RET
; .FEND
_disk_ioctl:
; .FSTART _disk_ioctl
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,16
	CALL __SAVELOCR4
	LDD  R30,Y+23
	CPI  R30,0
	BREQ _0x20000CD
	LDI  R30,LOW(4)
	RJMP _0x20C0016
_0x20000CD:
	LDS  R30,_status_G100
	ANDI R30,LOW(0x1)
	BREQ _0x20000CE
	LDI  R30,LOW(3)
	RJMP _0x20C0016
_0x20000CE:
	LDI  R17,LOW(1)
	LDD  R30,Y+22
	CPI  R30,0
	BRNE _0x20000D2
	LDI  R30,LOW(16)
	STS  1606,R30
	RCALL _wait_ready_G100
	CPI  R30,LOW(0xFF)
	BRNE _0x20000D3
	LDI  R17,LOW(0)
_0x20000D3:
	RJMP _0x20000D1
_0x20000D2:
	CPI  R30,LOW(0x1)
	BREQ PC+2
	RJMP _0x20000D4
	LDI  R30,LOW(73)
	ST   -Y,R30
	__GETD2N 0x0
	RCALL _send_cmd_G100
	CPI  R30,0
	BRNE _0x20000D6
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	LDI  R27,0
	RCALL _rx_datablock_G100
	CPI  R30,0
	BRNE _0x20000D7
_0x20000D6:
	RJMP _0x20000D5
_0x20000D7:
	LDD  R30,Y+4
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	CPI  R30,LOW(0x1)
	BRNE _0x20000D8
	LDI  R30,0
	LDD  R31,Y+12
	LDD  R26,Y+13
	LDI  R27,0
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	MOVW R18,R30
	MOVW R26,R18
	CLR  R24
	CLR  R25
	LDI  R30,LOW(10)
	RJMP _0x2000104
_0x20000D8:
	LDD  R30,Y+9
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LDD  R30,Y+14
	ANDI R30,LOW(0x80)
	ROL  R30
	LDI  R30,0
	ROL  R30
	ADD  R26,R30
	LDD  R30,Y+13
	ANDI R30,LOW(0x3)
	LSL  R30
	ADD  R30,R26
	SUBI R30,-LOW(2)
	MOV  R16,R30
	LDD  R30,Y+12
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	MOV  R26,R30
	LDD  R30,Y+11
	LDI  R31,0
	CALL __LSLW2
	LDI  R27,0
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+10
	ANDI R30,LOW(0x3)
	LDI  R31,0
	CALL __LSLW2
	MOV  R31,R30
	LDI  R30,0
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	MOVW R18,R30
	MOVW R26,R18
	CLR  R24
	CLR  R25
	MOV  R30,R16
	SUBI R30,LOW(9)
_0x2000104:
	CALL __LSLD12
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL __PUTDP1
	LDI  R17,LOW(0)
_0x20000D5:
	RJMP _0x20000D1
_0x20000D4:
	CPI  R30,LOW(0x2)
	BRNE _0x20000DA
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	ST   X+,R30
	ST   X,R31
	LDI  R17,LOW(0)
	RJMP _0x20000D1
_0x20000DA:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x20000DB
	LDS  R30,_card_type_G100
	ANDI R30,LOW(0x4)
	BREQ _0x20000DC
	LDI  R30,LOW(205)
	ST   -Y,R30
	__GETD2N 0x0
	RCALL _send_cmd_G100
	CPI  R30,0
	BRNE _0x20000DD
	LDI  R30,LOW(255)
	STS  2243,R30
_0x20000DE:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x20000DE
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	LDI  R27,0
	RCALL _rx_datablock_G100
	CPI  R30,0
	BREQ _0x20000E1
	LDI  R16,LOW(48)
_0x20000E3:
	CPI  R16,0
	BREQ _0x20000E4
	LDI  R30,LOW(255)
	STS  2243,R30
_0x20000E5:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x20000E5
	SUBI R16,1
	RJMP _0x20000E3
_0x20000E4:
	LDD  R30,Y+14
	SWAP R30
	ANDI R30,0xF
	__GETD2N 0x10
	CALL __LSLD12
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL __PUTDP1
	LDI  R17,LOW(0)
_0x20000E1:
_0x20000DD:
	RJMP _0x20000E8
_0x20000DC:
	LDI  R30,LOW(73)
	ST   -Y,R30
	__GETD2N 0x0
	RCALL _send_cmd_G100
	CPI  R30,0
	BREQ PC+2
	RJMP _0x20000E9
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	LDI  R27,0
	RCALL _rx_datablock_G100
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20000EA
	LDS  R30,_card_type_G100
	ANDI R30,LOW(0x2)
	BREQ _0x20000EB
	LDD  R30,Y+14
	ANDI R30,LOW(0x3F)
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __LSLD1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+15
	ANDI R30,LOW(0x80)
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(7)
	CALL __LSRD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	__ADDD1N 1
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+17
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	SUBI R30,LOW(1)
	CALL __LSLD12
	RJMP _0x2000105
_0x20000EB:
	LDD  R30,Y+14
	ANDI R30,LOW(0x7C)
	LSR  R30
	LSR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	__ADDD1N 1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+15
	ANDI R30,LOW(0x3)
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(3)
	CALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+15
	ANDI R30,LOW(0xE0)
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__ADDD1N 1
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULD12U
_0x2000105:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL __PUTDP1
	LDI  R17,LOW(0)
_0x20000EA:
_0x20000E9:
_0x20000E8:
	RJMP _0x20000D1
_0x20000DB:
	CPI  R30,LOW(0xA)
	BRNE _0x20000ED
	LDS  R30,_card_type_G100
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	ST   X,R30
	LDI  R17,LOW(0)
	RJMP _0x20000D1
_0x20000ED:
	CPI  R30,LOW(0xB)
	BRNE _0x20000EE
	LDI  R16,LOW(73)
	RJMP _0x20000EF
_0x20000EE:
	CPI  R30,LOW(0xC)
	BRNE _0x20000F1
	LDI  R16,LOW(74)
_0x20000EF:
	ST   -Y,R16
	__GETD2N 0x0
	RCALL _send_cmd_G100
	CPI  R30,0
	BRNE _0x20000F2
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	LDI  R27,0
	RCALL _rx_datablock_G100
	CPI  R30,0
	BREQ _0x20000F3
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(15)
	RCALL _crc7_G100
	MOV  R26,R30
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	LDD  R30,Z+15
	CP   R30,R26
	BRNE _0x20000F4
	LDI  R17,LOW(0)
_0x20000F4:
_0x20000F3:
_0x20000F2:
	RJMP _0x20000D1
_0x20000F1:
	CPI  R30,LOW(0xD)
	BRNE _0x20000F5
	LDI  R30,LOW(122)
	ST   -Y,R30
	__GETD2N 0x0
	RCALL _send_cmd_G100
	CPI  R30,0
	BRNE _0x20000F6
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL _rx_spi4_G100
	LDI  R17,LOW(0)
_0x20000F6:
	RJMP _0x20000D1
_0x20000F5:
	CPI  R30,LOW(0xE)
	BRNE _0x20000FD
	LDI  R30,LOW(205)
	ST   -Y,R30
	__GETD2N 0x0
	RCALL _send_cmd_G100
	CPI  R30,0
	BRNE _0x20000F8
	LDI  R30,LOW(255)
	STS  2243,R30
_0x20000F9:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x20000F9
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(64)
	LDI  R27,0
	RCALL _rx_datablock_G100
	CPI  R30,0
	BREQ _0x20000FC
	LDI  R17,LOW(0)
_0x20000FC:
_0x20000F8:
	RJMP _0x20000D1
_0x20000FD:
	LDI  R17,LOW(4)
_0x20000D1:
	RCALL _deselect_card_G100
	MOV  R30,R17
_0x20C0016:
	CALL __LOADLOCR4
	ADIW R28,24
	RET
; .FEND
_disk_timerproc:
; .FSTART _disk_timerproc
	ST   -Y,R17
	LDS  R17,_timer1_G100
	CPI  R17,0
	BREQ _0x20000FE
	SUBI R17,LOW(1)
	STS  _timer1_G100,R17
_0x20000FE:
	LDS  R17,_timer2_G100
	CPI  R17,0
	BREQ _0x20000FF
	SUBI R17,LOW(1)
	STS  _timer2_G100,R17
_0x20000FF:
	LDS  R30,_status_G100
	ANDI R30,0xFB
	STS  _status_G100,R30
_0x20C0015:
	LD   R17,Y+
	RET
; .FEND

	.CSEG
_get_fattime:
; .FSTART _get_fattime
	SBIW R28,7
	LDS  R26,_prtc_get_time
	LDS  R27,_prtc_get_time+1
	SBIW R26,0
	BREQ _0x2020004
	LDS  R26,_prtc_get_date
	LDS  R27,_prtc_get_date+1
	SBIW R26,0
	BRNE _0x2020003
_0x2020004:
	__GETD1N 0x3A210000
	RJMP _0x20C0014
_0x2020003:
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,7
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	__CALL1MN _prtc_get_time,0
	MOVW R30,R28
	ADIW R30,3
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,4
	__CALL1MN _prtc_get_date,0
	LD   R30,Y
	LDD  R31,Y+1
	SUBI R30,LOW(1980)
	SBCI R31,HIGH(1980)
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(25)
	CALL __LSLD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+2
	LDI  R31,0
	CALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(21)
	CALL __LSLD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+3
	LDI  R31,0
	CALL __CWD1
	CALL __LSLD16
	CALL __ORD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+6
	LDI  R31,0
	CALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(11)
	CALL __LSLD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+5
	LDI  R31,0
	CALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(5)
	CALL __LSLD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDI  R31,0
	ASR  R31
	ROR  R30
	CALL __CWD1
	CALL __ORD12
_0x20C0014:
	ADIW R28,7
	RET
; .FEND
_chk_chrf_G101:
; .FSTART _chk_chrf_G101
	ST   -Y,R26
	ST   -Y,R17
_0x2020006:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020009
	LDD  R30,Y+1
	CP   R30,R17
	BRNE _0x202000A
_0x2020009:
	RJMP _0x2020008
_0x202000A:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
	RJMP _0x2020006
_0x2020008:
	MOV  R30,R17
	LDI  R31,0
	LDD  R17,Y+0
	ADIW R28,4
	RET
; .FEND
_move_window_G101:
; .FSTART _move_window_G101
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,46
	CALL __GETD1P
	__PUTD1S 1
	__GETD1S 5
	__GETD2S 1
	CALL __CPD12
	BRNE PC+2
	RJMP _0x202000B
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	LDD  R30,Z+4
	CPI  R30,0
	BRNE PC+2
	RJMP _0x202000C
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	LDD  R26,Z+1
	ST   -Y,R26
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 4
	CALL __PUTPARD1
	LDI  R26,LOW(1)
	RCALL _disk_write
	CPI  R30,0
	BREQ _0x202000D
	RJMP _0x20C0013
_0x202000D:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,4
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__GETD2Z 34
	MOVW R0,R26
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,26
	CALL __GETD1P
	MOVW R26,R0
	CALL __ADDD12
	__GETD2S 1
	CALL __CPD21
	BRSH _0x202000E
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	LDD  R17,Z+3
_0x2020010:
	CPI  R17,2
	BRLO _0x2020011
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,26
	CALL __GETD1P
	__GETD2S 1
	CALL __ADDD12
	__PUTD1S 1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	LDD  R26,Z+1
	ST   -Y,R26
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 4
	CALL __PUTPARD1
	LDI  R26,LOW(1)
	RCALL _disk_write
	SUBI R17,1
	RJMP _0x2020010
_0x2020011:
_0x202000E:
_0x202000C:
	__GETD1S 5
	CALL __CPD10
	BREQ _0x2020012
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	LDD  R26,Z+1
	ST   -Y,R26
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 8
	CALL __PUTPARD1
	LDI  R26,LOW(1)
	RCALL _disk_read
	CPI  R30,0
	BREQ _0x2020013
_0x20C0013:
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	ADIW R28,11
	RET
_0x2020013:
	__GETD1S 5
	__PUTD1SNS 9,46
_0x2020012:
_0x202000B:
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x20C000E
; .FEND
_sync_G101:
; .FSTART _sync_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2N 0x0
	RCALL _move_window_G101
	MOV  R17,R30
	CPI  R17,0
	BREQ PC+2
	RJMP _0x2020014
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R26,X
	CPI  R26,LOW(0x3)
	BRNE _0x2020016
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R30,Z+5
	CPI  R30,0
	BRNE _0x2020017
_0x2020016:
	RJMP _0x2020015
_0x2020017:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,46
	__GETD1N 0x0
	CALL __PUTDP1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(512)
	LDI  R27,HIGH(512)
	CALL _memset
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,50
	SUBI R30,LOW(-510)
	SBCI R31,HIGH(-510)
	LDI  R26,LOW(43605)
	LDI  R27,HIGH(43605)
	STD  Z+0,R26
	STD  Z+1,R27
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,50
	__GETD2N 0x41615252
	CALL __PUTDZ20
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,50
	SUBI R30,LOW(-484)
	SBCI R31,HIGH(-484)
	__GETD2N 0x61417272
	CALL __PUTDZ20
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,50
	SUBI R30,LOW(-488)
	SBCI R31,HIGH(-488)
	MOVW R0,R30
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,14
	CALL __GETD1P
	MOVW R26,R0
	CALL __PUTDP1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,50
	SUBI R30,LOW(-492)
	SBCI R31,HIGH(-492)
	MOVW R0,R30
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,10
	CALL __GETD1P
	MOVW R26,R0
	CALL __PUTDP1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R26,Z+1
	ST   -Y,R26
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__GETD2Z 18
	CALL __PUTPARD2
	LDI  R26,LOW(1)
	RCALL _disk_write
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,5
	LDI  R30,LOW(0)
	ST   X,R30
_0x2020015:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R26,Z+1
	ST   -Y,R26
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	RCALL _disk_ioctl
	CPI  R30,0
	BREQ _0x2020018
	LDI  R17,LOW(1)
_0x2020018:
_0x2020014:
	MOV  R30,R17
_0x20C0012:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_get_fat:
; .FSTART _get_fat
	CALL __PUTPARD2
	SBIW R28,4
	CALL __SAVELOCR4
	__GETD2S 8
	__CPD2N 0x2
	BRLO _0x202001A
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,30
	CALL __GETD1P
	__GETD2S 8
	CALL __CPD21
	BRLO _0x2020019
_0x202001A:
	__GETD1N 0x1
	RJMP _0x20C0011
_0x2020019:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,34
	CALL __GETD1P
	__PUTD1S 4
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x202001F
	__GETWRS 18,19,8
	MOVW R30,R18
	LSR  R31
	ROR  R30
	__ADDWRR 18,19,30,31
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R18
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __DIVW21U
	__GETD2S 6
	CLR  R22
	CLR  R23
	CALL __ADDD21
	RCALL _move_window_G101
	CPI  R30,0
	BREQ _0x2020020
	RJMP _0x202001E
_0x2020020:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,50
	MOVW R30,R18
	ANDI R31,HIGH(0x1FF)
	ADD  R26,R30
	ADC  R27,R31
	LD   R16,X
	CLR  R17
	__ADDWRN 18,19,1
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R18
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __DIVW21U
	__GETD2S 6
	CLR  R22
	CLR  R23
	CALL __ADDD21
	RCALL _move_window_G101
	CPI  R30,0
	BREQ _0x2020021
	RJMP _0x202001E
_0x2020021:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,50
	MOVW R30,R18
	ANDI R31,HIGH(0x1FF)
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOV  R31,R30
	LDI  R30,0
	__ORWRR 16,17,30,31
	LDD  R30,Y+8
	ANDI R30,LOW(0x1)
	BREQ _0x2020022
	MOVW R30,R16
	CALL __LSRW4
	RJMP _0x202027A
_0x2020022:
	MOVW R30,R16
	ANDI R31,HIGH(0xFFF)
_0x202027A:
	CLR  R22
	CLR  R23
	RJMP _0x20C0011
_0x202001F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2020025
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 10
	__GETD1N 0x100
	CALL __DIVD21U
	__GETD2S 6
	CALL __ADDD21
	RCALL _move_window_G101
	CPI  R30,0
	BRNE _0x202001E
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(2)
	CALL __MULB1W2U
	ANDI R31,HIGH(0x1FF)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,50
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CLR  R22
	CLR  R23
	RJMP _0x20C0011
_0x2020025:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x202001E
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 10
	__GETD1N 0x80
	CALL __DIVD21U
	__GETD2S 6
	CALL __ADDD21
	RCALL _move_window_G101
	CPI  R30,0
	BRNE _0x202001E
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(4)
	CALL __MULB1W2U
	ANDI R31,HIGH(0x1FF)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,50
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	__ANDD1N 0xFFFFFFF
	RJMP _0x20C0011
_0x202001E:
	__GETD1N 0xFFFFFFFF
_0x20C0011:
	CALL __LOADLOCR4
	ADIW R28,14
	RET
; .FEND
_put_fat:
; .FSTART _put_fat
	CALL __PUTPARD2
	SBIW R28,4
	CALL __SAVELOCR6
	__GETD2S 14
	__CPD2N 0x2
	BRLO _0x202002A
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,30
	CALL __GETD1P
	__GETD2S 14
	CALL __CPD21
	BRLO _0x2020029
_0x202002A:
	LDI  R21,LOW(2)
	RJMP _0x202002C
_0x2020029:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,34
	CALL __GETD1P
	__PUTD1S 6
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LD   R30,X
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x2020030
	__GETWRS 16,17,14
	MOVW R30,R16
	LSR  R31
	ROR  R30
	__ADDWRR 16,17,30,31
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __DIVW21U
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __ADDD21
	RCALL _move_window_G101
	MOV  R21,R30
	CPI  R21,0
	BREQ _0x2020031
	RJMP _0x202002F
_0x2020031:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,50
	MOVW R30,R16
	ANDI R31,HIGH(0x1FF)
	ADD  R30,R26
	ADC  R31,R27
	MOVW R18,R30
	LDD  R30,Y+14
	ANDI R30,LOW(0x1)
	BREQ _0x2020032
	MOVW R26,R18
	LD   R30,X
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LDD  R30,Y+10
	LDI  R31,0
	CALL __LSLW4
	OR   R30,R26
	RJMP _0x2020033
_0x2020032:
	LDD  R30,Y+10
_0x2020033:
	MOVW R26,R18
	ST   X,R30
	__ADDWRN 16,17,1
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,4
	LDI  R30,LOW(1)
	ST   X,R30
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __DIVW21U
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __ADDD21
	RCALL _move_window_G101
	MOV  R21,R30
	CPI  R21,0
	BREQ _0x2020035
	RJMP _0x202002F
_0x2020035:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,50
	MOVW R30,R16
	ANDI R31,HIGH(0x1FF)
	ADD  R30,R26
	ADC  R31,R27
	MOVW R18,R30
	LDD  R30,Y+14
	ANDI R30,LOW(0x1)
	BREQ _0x2020036
	__GETD2S 10
	LDI  R30,LOW(4)
	CALL __LSRD12
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP _0x2020037
_0x2020036:
	MOVW R26,R18
	LD   R30,X
	ANDI R30,LOW(0xF0)
	MOV  R1,R30
	__GETD2S 10
	LDI  R30,LOW(8)
	CALL __LSRD12
	CLR  R31
	CLR  R22
	CLR  R23
	ANDI R30,LOW(0xF)
	OR   R30,R1
_0x2020037:
	MOVW R26,R18
	ST   X,R30
	RJMP _0x202002F
_0x2020030:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2020039
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 16
	__GETD1N 0x100
	CALL __DIVD21U
	__GETD2S 8
	CALL __ADDD21
	RCALL _move_window_G101
	MOV  R21,R30
	CPI  R21,0
	BREQ _0x202003A
	RJMP _0x202002F
_0x202003A:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDI  R30,LOW(2)
	CALL __MULB1W2U
	ANDI R31,HIGH(0x1FF)
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,50
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP _0x202002F
_0x2020039:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x202003D
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 16
	__GETD1N 0x80
	CALL __DIVD21U
	__GETD2S 8
	CALL __ADDD21
	RCALL _move_window_G101
	MOV  R21,R30
	CPI  R21,0
	BRNE _0x202002F
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDI  R30,LOW(4)
	CALL __MULB1W2U
	ANDI R31,HIGH(0x1FF)
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,50
	ADD  R30,R26
	ADC  R31,R27
	__GETD2S 10
	CALL __PUTDZ20
	RJMP _0x202002F
_0x202003D:
	LDI  R21,LOW(2)
_0x202002F:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,4
	LDI  R30,LOW(1)
	ST   X,R30
_0x202002C:
	MOV  R30,R21
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_remove_chain_G101:
; .FSTART _remove_chain_G101
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	__GETD2S 5
	__CPD2N 0x2
	BRLO _0x202003F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,30
	CALL __GETD1P
	__GETD2S 5
	CALL __CPD21
	BRLO _0x202003E
_0x202003F:
	LDI  R17,LOW(2)
	RJMP _0x2020041
_0x202003E:
	LDI  R17,LOW(0)
_0x2020042:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,30
	CALL __GETD1P
	__GETD2S 5
	CALL __CPD21
	BRLO PC+2
	RJMP _0x2020044
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 7
	RCALL _get_fat
	__PUTD1S 1
	CALL __CPD10
	BRNE _0x2020045
	RJMP _0x2020044
_0x2020045:
	__GETD2S 1
	__CPD2N 0x1
	BRNE _0x2020046
	LDI  R17,LOW(2)
	RJMP _0x2020044
_0x2020046:
	__GETD2S 1
	__CPD2N 0xFFFFFFFF
	BRNE _0x2020047
	LDI  R17,LOW(1)
	RJMP _0x2020044
_0x2020047:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 7
	CALL __PUTPARD1
	__GETD2N 0x0
	RCALL _put_fat
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x2020044
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__GETD2Z 14
	__CPD2N 0xFFFFFFFF
	BREQ _0x2020049
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,14
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,5
	LDI  R30,LOW(1)
	ST   X,R30
_0x2020049:
	__GETD1S 1
	__PUTD1S 5
	RJMP _0x2020042
_0x2020044:
_0x2020041:
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20C000E
; .FEND
_create_chain_G101:
; .FSTART _create_chain_G101
	CALL __PUTPARD2
	SBIW R28,16
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	ADIW R26,30
	CALL __GETD1P
	CALL __PUTD1S0
	__GETD1S 16
	CALL __CPD10
	BRNE _0x202004A
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	ADIW R26,10
	CALL __GETD1P
	__PUTD1S 4
	__GETD2S 4
	CALL __CPD02
	BREQ _0x202004C
	CALL __GETD1S0
	CALL __CPD21
	BRLO _0x202004B
_0x202004C:
	__GETD1N 0x1
	__PUTD1S 4
_0x202004B:
	RJMP _0x202004E
_0x202004A:
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 18
	RCALL _get_fat
	__PUTD1S 12
	__GETD2S 12
	__CPD2N 0x2
	BRSH _0x202004F
	__GETD1N 0x1
	RJMP _0x20C0010
_0x202004F:
	CALL __GETD1S0
	__GETD2S 12
	CALL __CPD21
	BRSH _0x2020050
	__GETD1S 12
	RJMP _0x20C0010
_0x2020050:
	__GETD1S 16
	__PUTD1S 4
_0x202004E:
	__GETD1S 4
	__PUTD1S 8
_0x2020052:
	__GETD1S 8
	__SUBD1N -1
	__PUTD1S 8
	CALL __GETD1S0
	__GETD2S 8
	CALL __CPD21
	BRLO _0x2020054
	__GETD1N 0x2
	__PUTD1S 8
	__GETD1S 4
	__GETD2S 8
	CALL __CPD12
	BRSH _0x2020055
	__GETD1N 0x0
	RJMP _0x20C0010
_0x2020055:
_0x2020054:
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 10
	RCALL _get_fat
	__PUTD1S 12
	CALL __CPD10
	BREQ _0x2020053
	__GETD2S 12
	__CPD2N 0xFFFFFFFF
	BREQ _0x2020058
	__CPD2N 0x1
	BRNE _0x2020057
_0x2020058:
	__GETD1S 12
	RJMP _0x20C0010
_0x2020057:
	__GETD1S 4
	__GETD2S 8
	CALL __CPD12
	BRNE _0x202005A
	__GETD1N 0x0
	RJMP _0x20C0010
_0x202005A:
	RJMP _0x2020052
_0x2020053:
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 10
	CALL __PUTPARD1
	__GETD2N 0xFFFFFFF
	RCALL _put_fat
	CPI  R30,0
	BREQ _0x202005B
	__GETD1N 0xFFFFFFFF
	RJMP _0x20C0010
_0x202005B:
	__GETD1S 16
	CALL __CPD10
	BREQ _0x202005C
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 18
	CALL __PUTPARD1
	__GETD2S 14
	RCALL _put_fat
	CPI  R30,0
	BREQ _0x202005D
	__GETD1N 0xFFFFFFFF
	RJMP _0x20C0010
_0x202005D:
_0x202005C:
	__GETD1S 8
	__PUTD1SNS 20,10
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	__GETD2Z 14
	__CPD2N 0xFFFFFFFF
	BREQ _0x202005E
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	ADIW R26,14
	CALL __GETD1P_INC
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	CALL __PUTDP1_DEC
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	ADIW R26,5
	LDI  R30,LOW(1)
	ST   X,R30
_0x202005E:
	__GETD1S 8
_0x20C0010:
	ADIW R28,22
	RET
; .FEND
_clust2sect:
; .FSTART _clust2sect
	CALL __PUTPARD2
	CALL __GETD1S0
	__SUBD1N 2
	CALL __PUTD1S0
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__GETD2Z 30
	__GETD1N 0x2
	CALL __SWAPD12
	CALL __SUBD12
	CALL __GETD2S0
	CALL __CPD21
	BRLO _0x202005F
	__GETD1N 0x0
	RJMP _0x20C000A
_0x202005F:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+2
	LDI  R31,0
	CALL __GETD2S0
	CALL __CWD1
	CALL __MULD12U
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,42
	CALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	RJMP _0x20C000A
; .FEND
_dir_seek_G101:
; .FSTART _dir_seek_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__PUTW1SNS 8,4
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,6
	CALL __GETD1P
	__PUTD1S 2
	__GETD2S 2
	__CPD2N 0x1
	BREQ _0x2020061
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,30
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 2
	CALL __CPD21
	BRLO _0x2020060
_0x2020061:
	LDI  R30,LOW(2)
	RJMP _0x20C000F
_0x2020060:
	__GETD1S 2
	CALL __CPD10
	BRNE _0x2020064
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	LD   R26,Z
	CPI  R26,LOW(0x3)
	BREQ _0x2020065
_0x2020064:
	RJMP _0x2020063
_0x2020065:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,38
	MOVW R26,R30
	CALL __GETD1P
	__PUTD1S 2
_0x2020063:
	__GETD1S 2
	CALL __CPD10
	BRNE _0x2020066
	__PUTD1SNS 8,10
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,8
	MOVW R26,R30
	CALL __GETW1P
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x2020067
	LDI  R30,LOW(2)
	RJMP _0x20C000F
_0x2020067:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,38
	MOVW R26,R30
	CALL __GETD1P
	RJMP _0x202027B
_0x2020066:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	LDD  R30,Z+2
	LDI  R26,LOW(16)
	MUL  R30,R26
	MOVW R16,R0
_0x2020069:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R26,R16
	CPC  R27,R17
	BRSH PC+2
	RJMP _0x202006B
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 4
	RCALL _get_fat
	__PUTD1S 2
	__GETD2S 2
	__CPD2N 0xFFFFFFFF
	BRNE _0x202006C
	LDI  R30,LOW(1)
	RJMP _0x20C000F
_0x202006C:
	__GETD2S 2
	__CPD2N 0x2
	BRLO _0x202006E
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,30
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 2
	CALL __CPD21
	BRLO _0x202006D
_0x202006E:
	LDI  R30,LOW(2)
	RJMP _0x20C000F
_0x202006D:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUB  R30,R16
	SBC  R31,R17
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020069
_0x202006B:
	__GETD1S 2
	__PUTD1SNS 8,10
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 4
	RCALL _clust2sect
_0x202027B:
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __LSRW4
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1SNS 8,14
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,50
	MOVW R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	LSL  R30
	CALL __LSLW4
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SNS 8,18
	LDI  R30,LOW(0)
_0x20C000F:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
; .FEND
_dir_next_G101:
; .FSTART _dir_next_G101
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR4
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,4
	CALL __GETW1P
	ADIW R30,1
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x2020071
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,14
	CALL __GETD1P
	CALL __CPD10
	BRNE _0x2020070
_0x2020071:
	LDI  R30,LOW(4)
	RJMP _0x20C000D
_0x2020070:
	MOVW R30,R16
	ANDI R30,LOW(0xF)
	BREQ PC+2
	RJMP _0x2020073
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,14
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,10
	CALL __GETD1P
	CALL __CPD10
	BRNE _0x2020074
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL __GETW1P
	ADIW R30,8
	MOVW R26,R30
	CALL __GETW1P
	CP   R16,R30
	CPC  R17,R31
	BRLO _0x2020075
	LDI  R30,LOW(4)
	RJMP _0x20C000D
_0x2020075:
	RJMP _0x2020076
_0x2020074:
	MOVW R30,R16
	CALL __LSRW4
	MOVW R0,R30
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL __GETW1P
	LDD  R30,Z+2
	LDI  R31,0
	SBIW R30,1
	AND  R30,R0
	AND  R31,R1
	SBIW R30,0
	BREQ PC+2
	RJMP _0x2020077
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	__GETD2Z 10
	RCALL _get_fat
	__PUTD1S 4
	__GETD2S 4
	__CPD2N 0x2
	BRSH _0x2020078
	LDI  R30,LOW(2)
	RJMP _0x20C000D
_0x2020078:
	__GETD2S 4
	__CPD2N 0xFFFFFFFF
	BRNE _0x2020079
	LDI  R30,LOW(1)
	RJMP _0x20C000D
_0x2020079:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL __GETW1P
	ADIW R30,30
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 4
	CALL __CPD21
	BRSH PC+2
	RJMP _0x202007A
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x202007B
	LDI  R30,LOW(4)
	RJMP _0x20C000D
_0x202007B:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	__GETD2Z 10
	RCALL _create_chain_G101
	__PUTD1S 4
	CALL __CPD10
	BRNE _0x202007C
	LDI  R30,LOW(7)
	RJMP _0x20C000D
_0x202007C:
	__GETD2S 4
	__CPD2N 0x1
	BRNE _0x202007D
	LDI  R30,LOW(2)
	RJMP _0x20C000D
_0x202007D:
	__GETD2S 4
	__CPD2N 0xFFFFFFFF
	BRNE _0x202007E
	LDI  R30,LOW(1)
	RJMP _0x20C000D
_0x202007E:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD2N 0x0
	RCALL _move_window_G101
	CPI  R30,0
	BREQ _0x202007F
	LDI  R30,LOW(1)
	RJMP _0x20C000D
_0x202007F:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL __GETW1P
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(512)
	LDI  R27,HIGH(512)
	CALL _memset
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL __GETW1P
	MOVW R26,R30
	ADIW R30,46
	PUSH R31
	PUSH R30
	MOVW R30,R26
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 6
	RCALL _clust2sect
	POP  R26
	POP  R27
	CALL __PUTDP1
	LDI  R19,LOW(0)
_0x2020081:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL __GETW1P
	LDD  R30,Z+2
	CP   R19,R30
	BRSH _0x2020082
	CALL __GETW1P
	ADIW R30,4
	LDI  R26,LOW(1)
	STD  Z+0,R26
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD2N 0x0
	RCALL _move_window_G101
	CPI  R30,0
	BREQ _0x2020083
	LDI  R30,LOW(1)
	RJMP _0x20C000D
_0x2020083:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL __GETW1P
	ADIW R30,46
	MOVW R26,R30
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	SUBI R19,-1
	RJMP _0x2020081
_0x2020082:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL __GETW1P
	ADIW R30,46
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R19
	LDI  R31,0
	CALL __CWD1
	CALL __SWAPD12
	CALL __SUBD12
	POP  R26
	POP  R27
	CALL __PUTDP1
_0x202007A:
	__GETD1S 4
	__PUTD1SNS 9,10
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 6
	RCALL _clust2sect
	__PUTD1SNS 9,14
_0x2020077:
_0x2020076:
_0x2020073:
	MOVW R30,R16
	__PUTW1SNS 9,4
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL __GETW1P
	ADIW R30,50
	MOVW R26,R30
	MOVW R30,R16
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	LSL  R30
	CALL __LSLW4
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SNS 9,18
	LDI  R30,LOW(0)
_0x20C000D:
	CALL __LOADLOCR4
_0x20C000E:
	ADIW R28,11
	RET
; .FEND
_dir_find_G101:
; .FSTART _dir_find_G101
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _dir_seek_G101
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2020084
	CALL __LOADLOCR4
	RJMP _0x20C000A
_0x2020084:
_0x2020086:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2Z 14
	RCALL _move_window_G101
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x2020087
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,18
	LD   R18,X+
	LD   R19,X
	MOVW R26,R18
	LD   R16,X
	CPI  R16,0
	BRNE _0x2020089
	LDI  R17,LOW(4)
	RJMP _0x2020087
_0x2020089:
	MOVW R30,R18
	LDD  R30,Z+11
	ANDI R30,LOW(0x8)
	BRNE _0x202008B
	ST   -Y,R19
	ST   -Y,R18
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+20
	LDD  R27,Z+21
	ST   -Y,R27
	ST   -Y,R26
	LDI  R26,LOW(11)
	LDI  R27,0
	CALL _memcmp
	CPI  R30,0
	BREQ _0x202008C
_0x202008B:
	RJMP _0x202008A
_0x202008C:
	RJMP _0x2020087
_0x202008A:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _dir_next_G101
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2020086
_0x2020087:
	MOV  R30,R17
	CALL __LOADLOCR4
	RJMP _0x20C000A
; .FEND
_dir_register_G101:
; .FSTART _dir_register_G101
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _dir_seek_G101
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x2020099
_0x202009B:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2Z 14
	CALL _move_window_G101
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x202009C
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R26,Z+18
	LDD  R27,Z+19
	LD   R16,X
	CPI  R16,229
	BREQ _0x202009F
	CPI  R16,0
	BRNE _0x202009E
_0x202009F:
	RJMP _0x202009C
_0x202009E:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _dir_next_G101
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x202009B
_0x202009C:
_0x2020099:
	CPI  R17,0
	BRNE _0x20200A1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2Z 14
	CALL _move_window_G101
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x20200A2
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,18
	LD   R18,X+
	LD   R19,X
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(32)
	LDI  R27,0
	CALL _memset
	ST   -Y,R19
	ST   -Y,R18
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+20
	LDD  R27,Z+21
	ST   -Y,R27
	ST   -Y,R26
	LDI  R26,LOW(11)
	LDI  R27,0
	CALL _memcpy
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,20
	CALL __GETW1P
	LDD  R30,Z+11
	ANDI R30,LOW(0x18)
	__PUTB1RNS 18,12
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	ADIW R30,4
	LDI  R26,LOW(1)
	STD  Z+0,R26
_0x20200A2:
_0x20200A1:
	MOV  R30,R17
	CALL __LOADLOCR4
	RJMP _0x20C000A
; .FEND
_create_name_G101:
; .FSTART _create_name_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,5
	CALL __SAVELOCR6
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	ADIW R26,20
	LD   R20,X+
	LD   R21,X
	ST   -Y,R21
	ST   -Y,R20
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R26,LOW(11)
	LDI  R27,0
	CALL _memset
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOV  R17,R30
	MOV  R18,R30
	LDI  R30,LOW(8)
	STD  Y+10,R30
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x20200A5
_0x20200A7:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R16,X
	CPI  R16,46
	BRNE _0x20200AA
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,3
	BRLT _0x20200A9
_0x20200AA:
	RJMP _0x20200A8
_0x20200A9:
	MOV  R30,R18
	SUBI R18,-1
	LDI  R31,0
	ADD  R30,R20
	ADC  R31,R21
	ST   Z,R16
	RJMP _0x20200A7
_0x20200A8:
	CPI  R16,47
	BREQ _0x20200AD
	CPI  R16,92
	BREQ _0x20200AD
	CPI  R16,33
	BRSH _0x20200AE
_0x20200AD:
	RJMP _0x20200AC
_0x20200AE:
	LDI  R30,LOW(6)
	RJMP _0x20C000B
_0x20200AC:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ST   X+,R30
	ST   X,R31
	CPI  R16,33
	BRSH _0x20200AF
	LDI  R30,LOW(36)
	RJMP _0x20200B0
_0x20200AF:
	LDI  R30,LOW(32)
_0x20200B0:
	__PUTB1RNS 20,11
	RJMP _0x20C000C
_0x20200A5:
_0x20200B3:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R16,X
	CPI  R16,33
	BRLO _0x20200B6
	CPI  R16,47
	BREQ _0x20200B6
	CPI  R16,92
	BRNE _0x20200B5
_0x20200B6:
	RJMP _0x20200B4
_0x20200B5:
	CPI  R16,46
	BREQ _0x20200B9
	LDD  R30,Y+10
	CP   R18,R30
	BRLO _0x20200B8
_0x20200B9:
	LDD  R26,Y+10
	CPI  R26,LOW(0x8)
	BRNE _0x20200BC
	CPI  R16,46
	BREQ _0x20200BB
_0x20200BC:
	LDI  R30,LOW(6)
	RJMP _0x20C000B
_0x20200BB:
	LDI  R18,LOW(8)
	LDI  R30,LOW(11)
	STD  Y+10,R30
	LSL  R17
	LSL  R17
	RJMP _0x20200B2
_0x20200B8:
	CPI  R16,128
	BRLO _0x20200BE
	ORI  R17,LOW(3)
	LDI  R30,LOW(6)
	RJMP _0x20C000B
_0x20200BE:
	LDI  R30,LOW(_k1*2)
	LDI  R31,HIGH(_k1*2)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R16
	CALL _chk_chrf_G101
	SBIW R30,0
	BREQ _0x20200C4
	LDI  R30,LOW(6)
	RJMP _0x20C000B
_0x20200C4:
	CPI  R16,65
	BRLO _0x20200C6
	CPI  R16,91
	BRLO _0x20200C7
_0x20200C6:
	RJMP _0x20200C5
_0x20200C7:
	ORI  R17,LOW(2)
	RJMP _0x20200C8
_0x20200C5:
	CPI  R16,97
	BRLO _0x20200CA
	CPI  R16,123
	BRLO _0x20200CB
_0x20200CA:
	RJMP _0x20200C9
_0x20200CB:
	ORI  R17,LOW(1)
	SUBI R16,LOW(32)
_0x20200C9:
_0x20200C8:
	MOV  R30,R18
	SUBI R18,-1
	LDI  R31,0
	ADD  R30,R20
	ADC  R31,R21
	ST   Z,R16
_0x20200B2:
	RJMP _0x20200B3
_0x20200B4:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ST   X+,R30
	ST   X,R31
	CPI  R16,33
	BRSH _0x20200CC
	LDI  R30,LOW(4)
	RJMP _0x20200CD
_0x20200CC:
	LDI  R30,LOW(0)
_0x20200CD:
	MOV  R16,R30
	CPI  R18,0
	BRNE _0x20200CF
	LDI  R30,LOW(6)
	RJMP _0x20C000B
_0x20200CF:
	MOVW R26,R20
	LD   R26,X
	CPI  R26,LOW(0xE5)
	BRNE _0x20200D0
	MOVW R26,R20
	LDI  R30,LOW(5)
	ST   X,R30
_0x20200D0:
	LDD  R26,Y+10
	CPI  R26,LOW(0x8)
	BRNE _0x20200D1
	LSL  R17
	LSL  R17
_0x20200D1:
	MOV  R30,R17
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x1)
	BRNE _0x20200D2
	ORI  R16,LOW(16)
_0x20200D2:
	MOV  R30,R17
	ANDI R30,LOW(0xC)
	CPI  R30,LOW(0x4)
	BRNE _0x20200D3
	ORI  R16,LOW(8)
_0x20200D3:
	MOVW R30,R20
	__PUTBZR 16,11
_0x20C000C:
	LDI  R30,LOW(0)
_0x20C000B:
	CALL __LOADLOCR6
	ADIW R28,15
	RET
; .FEND
_get_fileinfo_G101:
; .FSTART _get_fileinfo_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,2
	CALL __SAVELOCR6
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,9
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADIW R26,14
	CALL __GETD1P
	CALL __CPD10
	BRNE PC+2
	RJMP _0x20200D4
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADIW R26,18
	LD   R20,X+
	LD   R21,X
	MOVW R30,R20
	LDD  R19,Z+12
	LDI  R17,LOW(0)
_0x20200D6:
	CPI  R17,8
	BRSH _0x20200D7
	MOVW R26,R20
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R16,X
	CPI  R16,32
	BREQ _0x20200D7
	CPI  R16,5
	BRNE _0x20200D9
	LDI  R16,LOW(229)
_0x20200D9:
	LDI  R30,LOW(0)
	CPI  R30,0
	BREQ _0x20200DB
	SBRS R19,3
	RJMP _0x20200DB
	CPI  R16,65
	BRLO _0x20200DC
	CPI  R16,91
	BRLO _0x20200DD
_0x20200DC:
	RJMP _0x20200DB
_0x20200DD:
	RJMP _0x20200DE
_0x20200DB:
	RJMP _0x20200DA
_0x20200DE:
	SUBI R16,-LOW(32)
_0x20200DA:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	ST   Z,R16
	SUBI R17,-1
	RJMP _0x20200D6
_0x20200D7:
	MOVW R30,R20
	LDD  R26,Z+8
	CPI  R26,LOW(0x20)
	BREQ _0x20200DF
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(46)
	ST   X,R30
	LDI  R17,LOW(8)
_0x20200E1:
	CPI  R17,11
	BRSH _0x20200E2
	MOVW R26,R20
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R16,X
	CPI  R16,32
	BREQ _0x20200E2
	LDI  R30,LOW(0)
	CPI  R30,0
	BREQ _0x20200E5
	SBRS R19,4
	RJMP _0x20200E5
	CPI  R16,65
	BRLO _0x20200E6
	CPI  R16,91
	BRLO _0x20200E7
_0x20200E6:
	RJMP _0x20200E5
_0x20200E7:
	RJMP _0x20200E8
_0x20200E5:
	RJMP _0x20200E4
_0x20200E8:
	SUBI R16,-LOW(32)
_0x20200E4:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	ST   Z,R16
	SUBI R17,-1
	RJMP _0x20200E1
_0x20200E2:
_0x20200DF:
	MOVW R30,R20
	LDD  R30,Z+11
	__PUTB1SNS 8,8
	MOVW R26,R20
	ADIW R26,28
	CALL __GETD1P
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __PUTDP1
	MOVW R26,R20
	ADIW R26,24
	CALL __GETW1P
	__PUTW1SNS 8,4
	MOVW R26,R20
	ADIW R26,22
	CALL __GETW1P
	__PUTW1SNS 8,6
_0x20200D4:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_follow_path_G101:
; .FSTART _follow_path_G101
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
_0x20200E9:
	LDI  R30,LOW(1)
	CPI  R30,0
	BREQ _0x20200EC
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R26,X
	CPI  R26,LOW(0x20)
	BREQ _0x20200ED
_0x20200EC:
	RJMP _0x20200EB
_0x20200ED:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	RJMP _0x20200E9
_0x20200EB:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R26,X
	CPI  R26,LOW(0x2F)
	BREQ _0x20200EF
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R26,X
	CPI  R26,LOW(0x5C)
	BRNE _0x20200EE
_0x20200EF:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,6
	__GETD1N 0x0
	CALL __PUTDP1
	RJMP _0x20200F1
_0x20200EE:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	ADIW R30,22
	MOVW R26,R30
	CALL __GETD1P
	__PUTD1SNS 6,6
_0x20200F1:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R26,X
	CLR  R27
	SBIW R26,32
	BRSH _0x20200F2
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _dir_seek_G101
	MOV  R17,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RJMP _0x20200F3
_0x20200F2:
_0x20200F5:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,6
	RCALL _create_name_G101
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x20200F7
	RJMP _0x20200F6
_0x20200F7:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL _dir_find_G101
	MOV  R17,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,20
	CALL __GETW1P
	LDD  R30,Z+11
	ANDI R30,LOW(0x4)
	MOV  R16,R30
	CPI  R17,0
	BREQ _0x20200F8
	CPI  R17,4
	BRNE _0x20200FA
	CPI  R16,0
	BREQ _0x20200FB
_0x20200FA:
	RJMP _0x20200F9
_0x20200FB:
	LDI  R17,LOW(5)
_0x20200F9:
	RJMP _0x20200F6
_0x20200F8:
	CPI  R16,0
	BRNE _0x20200F6
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,18
	LD   R18,X+
	LD   R19,X
	MOVW R30,R18
	LDD  R30,Z+11
	ANDI R30,LOW(0x10)
	BRNE _0x20200FD
	LDI  R17,LOW(5)
	RJMP _0x20200F6
_0x20200FD:
	MOVW R26,R18
	ADIW R26,20
	CALL __GETW1P
	CLR  R22
	CLR  R23
	CALL __LSLD16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R26,R18
	ADIW R26,26
	CALL __GETW1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1SNS 6,6
	RJMP _0x20200F5
_0x20200F6:
_0x20200F3:
	MOV  R30,R17
	CALL __LOADLOCR4
	ADIW R28,8
	RET
; .FEND
_check_fs_G101:
; .FSTART _check_fs_G101
	CALL __PUTPARD2
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R26,Z+1
	ST   -Y,R26
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 3
	CALL __PUTPARD1
	LDI  R26,LOW(1)
	CALL _disk_read
	CPI  R30,0
	BREQ _0x20200FE
	LDI  R30,LOW(3)
	RJMP _0x20C000A
_0x20200FE:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,50
	SUBI R30,LOW(-510)
	SBCI R31,HIGH(-510)
	MOVW R26,R30
	CALL __GETW1P
	CPI  R30,LOW(0xAA55)
	LDI  R26,HIGH(0xAA55)
	CPC  R31,R26
	BREQ _0x20200FF
	LDI  R30,LOW(2)
	RJMP _0x20C000A
_0x20200FF:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SUBI R26,LOW(-104)
	SBCI R27,HIGH(-104)
	CALL __GETD1P
	__ANDD1N 0xFFFFFF
	__CPD1N 0x544146
	BRNE _0x2020100
	LDI  R30,LOW(0)
	RJMP _0x20C000A
_0x2020100:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,50
	SUBI R30,LOW(-82)
	SBCI R31,HIGH(-82)
	MOVW R26,R30
	CALL __GETD1P
	__ANDD1N 0xFFFFFF
	__CPD1N 0x544146
	BRNE _0x2020101
	LDI  R30,LOW(0)
	RJMP _0x20C000A
_0x2020101:
	LDI  R30,LOW(1)
_0x20C000A:
	ADIW R28,6
	RET
; .FEND
_chk_mounted:
; .FSTART _chk_mounted
	ST   -Y,R26
	SBIW R28,20
	CALL __SAVELOCR6
	LDD  R26,Y+29
	LDD  R27,Y+29+1
	CALL __GETW1P
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LD   R30,X
	SUBI R30,LOW(48)
	MOV  R16,R30
	CPI  R16,10
	BRSH _0x2020103
	ADIW R26,1
	LD   R26,X
	CPI  R26,LOW(0x3A)
	BREQ _0x2020104
_0x2020103:
	RJMP _0x2020102
_0x2020104:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,2
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R26,Y+29
	LDD  R27,Y+29+1
	ST   X+,R30
	ST   X,R31
	RJMP _0x2020105
_0x2020102:
	LDS  R16,_Drive_G101
_0x2020105:
	CPI  R16,1
	BRLO _0x2020106
	LDI  R30,LOW(11)
	RJMP _0x20C0008
_0x2020106:
	MOV  R30,R16
	LDI  R26,LOW(_FatFs_G101)
	LDI  R27,HIGH(_FatFs_G101)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+27
	LDD  R27,Y+27+1
	ST   X+,R30
	ST   X,R31
	SBIW R30,0
	BRNE _0x2020107
	LDI  R30,LOW(12)
	RJMP _0x20C0008
_0x2020107:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x2020108
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+1
	CALL _disk_status
	MOV  R21,R30
	SBRC R21,0
	RJMP _0x2020109
	LDD  R30,Y+26
	CPI  R30,0
	BREQ _0x202010B
	SBRC R21,2
	RJMP _0x202010C
_0x202010B:
	RJMP _0x202010A
_0x202010C:
	LDI  R30,LOW(10)
	RJMP _0x20C0008
_0x202010A:
	RJMP _0x20C0009
_0x2020109:
_0x2020108:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOV  R30,R16
	__PUTB1SNS 6,1
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+1
	CALL _disk_initialize
	MOV  R21,R30
	SBRS R21,0
	RJMP _0x202010D
	LDI  R30,LOW(3)
	RJMP _0x20C0008
_0x202010D:
	LDD  R30,Y+26
	CPI  R30,0
	BREQ _0x202010F
	SBRC R21,2
	RJMP _0x2020110
_0x202010F:
	RJMP _0x202010E
_0x2020110:
	LDI  R30,LOW(10)
	RJMP _0x20C0008
_0x202010E:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x0
	__PUTD1S 24
	MOVW R26,R30
	MOVW R24,R22
	RCALL _check_fs_G101
	MOV  R17,R30
	CPI  R17,1
	BRNE _0x2020111
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,50
	SUBI R30,LOW(-446)
	SBCI R31,HIGH(-446)
	MOVW R18,R30
	LDD  R30,Z+4
	CPI  R30,0
	BREQ _0x2020112
	MOVW R26,R18
	ADIW R26,8
	CALL __GETD1P
	__PUTD1S 22
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 24
	RCALL _check_fs_G101
	MOV  R17,R30
_0x2020112:
_0x2020111:
	CPI  R17,3
	BRNE _0x2020113
	LDI  R30,LOW(1)
	RJMP _0x20C0008
_0x2020113:
	CPI  R17,0
	BRNE _0x2020115
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,61
	CALL __GETW1P
	CPI  R30,LOW(0x200)
	LDI  R26,HIGH(0x200)
	CPC  R31,R26
	BREQ _0x2020114
_0x2020115:
	LDI  R30,LOW(13)
	RJMP _0x20C0008
_0x2020114:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-72)
	SBCI R27,HIGH(-72)
	CALL __GETW1P
	CLR  R22
	CLR  R23
	__PUTD1S 18
	CALL __CPD10
	BRNE _0x2020117
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-86)
	SBCI R27,HIGH(-86)
	CALL __GETD1P
	__PUTD1S 18
_0x2020117:
	__GETD1S 18
	__PUTD1SNS 6,26
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-66)
	SBCI R31,HIGH(-66)
	LD   R30,Z
	__PUTB1SNS 6,3
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R30,Z+3
	LDI  R31,0
	__GETD2S 18
	CALL __CWD1
	CALL __MULD12U
	__PUTD1S 18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-64)
	SBCI R27,HIGH(-64)
	CALL __GETW1P
	__GETD2S 22
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1SNS 6,34
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R30,Z+63
	__PUTB1SNS 6,2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-67)
	SBCI R27,HIGH(-67)
	CALL __GETW1P
	__PUTW1SNS 6,8
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-69)
	SBCI R27,HIGH(-69)
	CALL __GETW1P
	CLR  R22
	CLR  R23
	__PUTD1S 14
	CALL __CPD10
	BRNE _0x2020118
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-82)
	SBCI R27,HIGH(-82)
	CALL __GETD1P
	__PUTD1S 14
_0x2020118:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-64)
	SBCI R27,HIGH(-64)
	CALL __GETW1P
	__GETD2S 14
	CLR  R22
	CLR  R23
	CALL __SWAPD12
	CALL __SUBD12
	__GETD2S 18
	CALL __SUBD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+8
	LDD  R27,Z+9
	MOVW R30,R26
	CALL __LSRW4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R22
	CLR  R23
	CALL __SUBD21
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R30,Z+2
	LDI  R31,0
	CALL __CWD1
	CALL __DIVD21U
	__ADDD1N 2
	__PUTD1S 10
	__PUTD1SNS 6,30
	LDI  R17,LOW(1)
	__GETD2S 10
	__CPD2N 0xFF7
	BRLO _0x2020119
	LDI  R17,LOW(2)
_0x2020119:
	__GETD2S 10
	__CPD2N 0xFFF7
	BRLO _0x202011A
	LDI  R17,LOW(3)
_0x202011A:
	CPI  R17,3
	BRNE _0x202011B
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-94)
	SBCI R27,HIGH(-94)
	CALL __GETD1P
	RJMP _0x202027C
_0x202011B:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2Z 34
	__GETD1S 18
	CALL __ADDD12
_0x202027C:
	__PUTD1SNS 6,38
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2Z 34
	__GETD1S 18
	CALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+8
	LDD  R27,Z+9
	MOVW R30,R26
	CALL __LSRW4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1SNS 6,42
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,14
	__GETD1N 0xFFFFFFFF
	CALL __PUTDP1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,4
	LDI  R30,LOW(0)
	ST   X,R30
	CPI  R17,3
	BREQ PC+2
	RJMP _0x202011D
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,5
	ST   X,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-98)
	SBCI R27,HIGH(-98)
	CALL __GETW1P
	__GETD2S 22
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1SNS 6,18
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+1
	ST   -Y,R26
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__GETD2Z 18
	CALL __PUTPARD2
	LDI  R26,LOW(1)
	CALL _disk_read
	CPI  R30,0
	BRNE _0x202011F
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,50
	SUBI R30,LOW(-510)
	SBCI R31,HIGH(-510)
	MOVW R26,R30
	CALL __GETW1P
	CPI  R30,LOW(0xAA55)
	LDI  R26,HIGH(0xAA55)
	CPC  R31,R26
	BRNE _0x202011F
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,50
	CALL __GETD1P
	__CPD1N 0x41615252
	BRNE _0x202011F
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,50
	SUBI R30,LOW(-484)
	SBCI R31,HIGH(-484)
	MOVW R26,R30
	CALL __GETD1P
	__CPD1N 0x61417272
	BREQ _0x2020120
_0x202011F:
	RJMP _0x202011E
_0x2020120:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,50
	SUBI R30,LOW(-492)
	SBCI R31,HIGH(-492)
	MOVW R26,R30
	CALL __GETD1P
	__PUTD1SNS 6,10
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,50
	SUBI R30,LOW(-488)
	SBCI R31,HIGH(-488)
	MOVW R26,R30
	CALL __GETD1P
	__PUTD1SNS 6,14
_0x202011E:
_0x202011D:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R17
	ADIW R26,46
	__GETD1N 0x0
	CALL __PUTDP1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,22
	CALL __PUTDP1
	LDS  R30,_Fsid_G101
	LDS  R31,_Fsid_G101+1
	ADIW R30,1
	STS  _Fsid_G101,R30
	STS  _Fsid_G101+1,R31
	__PUTW1SNS 6,6
_0x20C0009:
	LDI  R30,LOW(0)
_0x20C0008:
	CALL __LOADLOCR6
	ADIW R28,31
	RET
; .FEND
_validate_G101:
; .FSTART _validate_G101
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,0
	BREQ _0x2020122
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x2020122
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R26,Z+6
	LDD  R27,Z+7
	LD   R30,Y
	LDD  R31,Y+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x2020121
_0x2020122:
	LDI  R30,LOW(9)
	RJMP _0x20C0007
_0x2020121:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R26,Z+1
	CALL _disk_status
	ANDI R30,LOW(0x1)
	BREQ _0x2020124
	LDI  R30,LOW(3)
	RJMP _0x20C0007
_0x2020124:
	LDI  R30,LOW(0)
_0x20C0007:
	ADIW R28,4
	RET
; .FEND
_f_mount:
; .FSTART _f_mount
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRLO _0x2020125
	LDI  R30,LOW(11)
	RJMP _0x20C0006
_0x2020125:
	LDD  R30,Y+4
	LDI  R26,LOW(_FatFs_G101)
	LDI  R27,HIGH(_FatFs_G101)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R16,X+
	LD   R17,X
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x2020126
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
_0x2020126:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,0
	BREQ _0x2020127
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2020127:
	LDD  R30,Y+4
	LDI  R26,LOW(_FatFs_G101)
	LDI  R27,HIGH(_FatFs_G101)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	STD  Z+0,R26
	STD  Z+1,R27
	LDI  R30,LOW(0)
_0x20C0006:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
_f_open:
; .FSTART _f_open
	ST   -Y,R26
	SBIW R28,34
	CALL __SAVELOCR4
	LDD  R26,Y+41
	LDD  R27,Y+41+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	LDD  R30,Y+38
	ANDI R30,LOW(0x1F)
	STD  Y+38,R30
	MOVW R30,R28
	ADIW R30,39
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,18
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+42
	ANDI R30,LOW(0x1E)
	MOV  R26,R30
	RCALL _chk_mounted
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2020128
	RJMP _0x20C0005
_0x2020128:
	MOVW R30,R28
	ADIW R30,4
	STD  Y+36,R30
	STD  Y+36+1,R31
	MOVW R30,R28
	ADIW R30,16
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+41
	LDD  R27,Y+41+1
	RCALL _follow_path_G101
	MOV  R17,R30
	LDD  R30,Y+38
	ANDI R30,LOW(0x1C)
	BRNE PC+2
	RJMP _0x2020129
	SBIW R28,8
	CPI  R17,0
	BREQ _0x202012A
	CPI  R17,4
	BRNE _0x202012B
	MOVW R26,R28
	ADIW R26,24
	RCALL _dir_register_G101
	MOV  R17,R30
_0x202012B:
	CPI  R17,0
	BREQ _0x202012C
	MOV  R30,R17
	ADIW R28,8
	RJMP _0x20C0005
_0x202012C:
	LDD  R30,Y+46
	ORI  R30,8
	STD  Y+46,R30
	__GETWRS 18,19,42
	RJMP _0x202012D
_0x202012A:
	LDD  R30,Y+46
	ANDI R30,LOW(0x4)
	BREQ _0x202012E
	LDI  R30,LOW(8)
	ADIW R28,8
	RJMP _0x20C0005
_0x202012E:
	__GETWRS 18,19,42
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x2020130
	MOVW R30,R18
	LDD  R30,Z+11
	ANDI R30,LOW(0x11)
	BREQ _0x202012F
_0x2020130:
	LDI  R30,LOW(7)
	ADIW R28,8
	RJMP _0x20C0005
_0x202012F:
	LDD  R30,Y+46
	ANDI R30,LOW(0x8)
	BRNE PC+2
	RJMP _0x2020132
	MOVW R26,R18
	ADIW R26,20
	CALL __GETW1P
	CLR  R22
	CLR  R23
	CALL __LSLD16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R26,R18
	ADIW R26,26
	CALL __GETW1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R22
	CLR  R23
	CALL __ORD12
	CALL __PUTD1S0
	MOVW R30,R18
	ADIW R30,20
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	MOVW R30,R18
	ADIW R30,26
	STD  Z+0,R26
	STD  Z+1,R27
	MOVW R30,R18
	ADIW R30,28
	__GETD2N 0x0
	CALL __PUTDZ20
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	ADIW R26,4
	LDI  R30,LOW(1)
	ST   X,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	ADIW R26,46
	CALL __GETD1P
	__PUTD1S 4
	CALL __GETD1S0
	CALL __CPD10
	BREQ _0x2020133
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 2
	CALL _remove_chain_G101
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2020134
	ADIW R28,8
	RJMP _0x20C0005
_0x2020134:
	CALL __GETD1S0
	__SUBD1N 1
	__PUTD1SNS 24,10
_0x2020133:
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 6
	CALL _move_window_G101
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2020135
	ADIW R28,8
	RJMP _0x20C0005
_0x2020135:
_0x2020132:
_0x202012D:
	LDD  R30,Y+46
	ANDI R30,LOW(0x8)
	BREQ _0x2020136
	MOVW R30,R18
	ADIW R30,11
	LDI  R26,LOW(0)
	STD  Z+0,R26
	CALL _get_fattime
	__PUTD1S 4
	__PUTD1RNS 18,14
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	ADIW R26,4
	LDI  R30,LOW(1)
	ST   X,R30
	LDD  R30,Y+46
	ORI  R30,0x20
	STD  Y+46,R30
_0x2020136:
	ADIW R28,8
	RJMP _0x2020137
_0x2020129:
	CPI  R17,0
	BREQ _0x2020138
	MOV  R30,R17
	RJMP _0x20C0005
_0x2020138:
	__GETWRS 18,19,34
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x202013A
	MOVW R30,R18
	LDD  R30,Z+11
	ANDI R30,LOW(0x10)
	BREQ _0x2020139
_0x202013A:
	LDI  R30,LOW(4)
	RJMP _0x20C0005
_0x2020139:
	LDD  R30,Y+38
	ANDI R30,LOW(0x2)
	BREQ _0x202013D
	MOVW R30,R18
	LDD  R30,Z+11
	ANDI R30,LOW(0x1)
	BRNE _0x202013E
_0x202013D:
	RJMP _0x202013C
_0x202013E:
	LDI  R30,LOW(7)
	RJMP _0x20C0005
_0x202013C:
_0x2020137:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,46
	CALL __GETD1P
	__PUTD1SNS 41,26
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	__PUTW1SNS 41,30
	LDD  R30,Y+38
	__PUTB1SNS 41,4
	MOVW R26,R18
	ADIW R26,20
	CALL __GETW1P
	CLR  R22
	CLR  R23
	CALL __LSLD16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R26,R18
	ADIW R26,26
	CALL __GETW1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1SNS 41,14
	MOVW R26,R18
	ADIW R26,28
	CALL __GETD1P
	__PUTD1SNS 41,10
	LDD  R26,Y+41
	LDD  R27,Y+41+1
	ADIW R26,6
	__GETD1N 0x0
	CALL __PUTDP1
	LDD  R26,Y+41
	LDD  R27,Y+41+1
	ADIW R26,5
	LDI  R30,LOW(255)
	ST   X,R30
	LDD  R26,Y+41
	LDD  R27,Y+41+1
	ADIW R26,22
	__GETD1N 0x0
	CALL __PUTDP1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Y+41
	LDD  R27,Y+41+1
	ST   X+,R30
	ST   X,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,6
	CALL __GETW1P
	__PUTW1SNS 41,2
	LDI  R30,LOW(0)
_0x20C0005:
	CALL __LOADLOCR4
	ADIW R28,43
	RET
; .FEND
_f_read:
; .FSTART _f_read
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,14
	CALL __SAVELOCR6
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	LDD  R26,Z+2
	LDD  R27,Z+3
	RCALL _validate_G101
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x202013F
	RJMP _0x20C0004
_0x202013F:
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	LDD  R26,Z+4
	ANDI R26,LOW(0x80)
	BREQ _0x2020140
	LDI  R30,LOW(2)
	RJMP _0x20C0004
_0x2020140:
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	LDD  R26,Z+4
	ANDI R26,LOW(0x1)
	BRNE _0x2020141
	LDI  R30,LOW(7)
	RJMP _0x20C0004
_0x2020141:
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	__GETD2Z 10
	PUSH R25
	PUSH R24
	PUSH R27
	PUSH R26
	__GETD2Z 6
	POP  R30
	POP  R31
	POP  R22
	POP  R23
	CALL __SUBD12
	__PUTD1S 8
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CLR  R24
	CLR  R25
	CALL __CPD12
	BRSH _0x2020142
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	STD  Y+22,R30
	STD  Y+22+1,R31
_0x2020142:
_0x2020144:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SBIW R30,0
	BRNE PC+2
	RJMP _0x2020145
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	__GETD2Z 6
	MOVW R30,R26
	MOVW R22,R24
	ANDI R31,HIGH(0x1FF)
	SBIW R30,0
	BREQ PC+2
	RJMP _0x2020146
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	LDD  R0,Z+5
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL __GETW1P
	LDD  R30,Z+2
	CP   R0,R30
	BRSH PC+2
	RJMP _0x2020147
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	__GETD2Z 6
	CALL __CPD02
	BRNE _0x2020148
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ADIW R26,14
	CALL __GETD1P
	RJMP _0x2020149
_0x2020148:
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	__GETD2Z 18
	CALL _get_fat
_0x2020149:
	__PUTD1S 16
	__GETD2S 16
	__CPD2N 0x2
	BRSH _0x202014B
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(2)
	RJMP _0x20C0004
_0x202014B:
	__GETD2S 16
	__CPD2N 0xFFFFFFFF
	BRNE _0x202014C
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(1)
	RJMP _0x20C0004
_0x202014C:
	__GETD1S 16
	__PUTD1SNS 26,18
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ADIW R26,5
	LDI  R30,LOW(0)
	ST   X,R30
_0x2020147:
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	__GETD2Z 18
	CALL _clust2sect
	__PUTD1S 12
	CALL __CPD10
	BRNE _0x202014D
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(2)
	RJMP _0x20C0004
_0x202014D:
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	LDD  R30,Z+5
	LDI  R31,0
	__GETD2S 12
	CALL __CWD1
	CALL __ADDD12
	__PUTD1S 12
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __DIVW21U
	MOVW R20,R30
	MOV  R0,R20
	OR   R0,R21
	BRNE PC+2
	RJMP _0x202014E
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	LDD  R30,Z+5
	LDI  R31,0
	ADD  R30,R20
	ADC  R31,R21
	MOVW R0,R30
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL __GETW1P
	LDD  R30,Z+2
	MOVW R26,R0
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x202014F
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL __GETW1P
	LDD  R30,Z+2
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	LDD  R30,Z+5
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
_0x202014F:
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL __GETW1P
	LDD  R30,Z+1
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 15
	CALL __PUTPARD1
	MOV  R26,R20
	CALL _disk_read
	CPI  R30,0
	BREQ _0x2020150
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(1)
	RJMP _0x20C0004
_0x2020150:
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	LDD  R26,Z+4
	ANDI R26,LOW(0x40)
	BREQ _0x2020152
	__GETD2Z 22
	__GETD1S 12
	CALL __SUBD21
	MOVW R30,R20
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRLO _0x2020153
_0x2020152:
	RJMP _0x2020151
_0x2020153:
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	__GETD2Z 22
	__GETD1S 12
	CALL __SUBD21
	__GETD1N 0x200
	CALL __MULD12U
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CLR  R24
	CLR  R25
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(512)
	LDI  R27,HIGH(512)
	CALL _memcpy
_0x2020151:
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ADIW R26,5
	LD   R30,X
	ADD  R30,R20
	ST   X,R30
	MOVW R30,R20
	LSL  R30
	ROL  R31
	MOV  R31,R30
	LDI  R30,0
	MOVW R18,R30
	RJMP _0x2020143
_0x202014E:
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	LDD  R26,Z+4
	ANDI R26,LOW(0x40)
	BREQ _0x2020154
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL __GETW1P
	LDD  R30,Z+1
	ST   -Y,R30
	LDD  R30,Y+27
	LDD  R31,Y+27+1
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+29
	LDD  R31,Y+29+1
	__GETD2Z 22
	CALL __PUTPARD2
	LDI  R26,LOW(1)
	CALL _disk_write
	CPI  R30,0
	BREQ _0x2020155
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(1)
	RJMP _0x20C0004
_0x2020155:
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ADIW R26,4
	LD   R30,X
	ANDI R30,0xBF
	ST   X,R30
_0x2020154:
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	__GETD2Z 22
	__GETD1S 12
	CALL __CPD12
	BREQ _0x2020156
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL __GETW1P
	LDD  R30,Z+1
	ST   -Y,R30
	LDD  R30,Y+27
	LDD  R31,Y+27+1
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 15
	CALL __PUTPARD1
	LDI  R26,LOW(1)
	CALL _disk_read
	CPI  R30,0
	BREQ _0x2020157
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(1)
	RJMP _0x20C0004
_0x2020157:
_0x2020156:
	__GETD1S 12
	__PUTD1SNS 26,22
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ADIW R26,5
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
_0x2020146:
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ADIW R26,6
	CALL __GETW1P
	ANDI R31,HIGH(0x1FF)
	LDI  R26,LOW(512)
	LDI  R27,HIGH(512)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R18,R26
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	CP   R30,R18
	CPC  R31,R19
	BRSH _0x2020158
	__GETWRS 18,19,22
_0x2020158:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	ADIW R26,6
	CALL __GETW1P
	ANDI R31,HIGH(0x1FF)
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	ADIW R26,32
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R18
	CALL _memcpy
_0x2020143:
	MOVW R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	ADIW R30,6
	MOVW R0,R30
	MOVW R26,R30
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R18
	CLR  R22
	CLR  R23
	CALL __ADDD12
	MOVW R26,R0
	CALL __PUTDP1
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL __GETW1P
	ADD  R30,R18
	ADC  R31,R19
	ST   X+,R30
	ST   X,R31
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SUB  R30,R18
	SBC  R31,R19
	STD  Y+22,R30
	STD  Y+22+1,R31
	RJMP _0x2020144
_0x2020145:
	LDI  R30,LOW(0)
_0x20C0004:
	CALL __LOADLOCR6
	ADIW R28,28
	RET
; .FEND
_f_sync:
; .FSTART _f_sync
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR4
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Z+2
	LDD  R27,Z+3
	RCALL _validate_G101
	MOV  R17,R30
	CPI  R17,0
	BREQ PC+2
	RJMP _0x2020175
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Z+4
	ANDI R26,LOW(0x20)
	BRNE PC+2
	RJMP _0x2020176
	LDD  R26,Z+4
	ANDI R26,LOW(0x40)
	BREQ _0x2020177
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	LDD  R30,Z+1
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	__GETD2Z 22
	CALL __PUTPARD2
	LDI  R26,LOW(1)
	CALL _disk_write
	CPI  R30,0
	BREQ _0x2020178
	LDI  R30,LOW(1)
	RJMP _0x20C0003
_0x2020178:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,4
	LD   R30,X
	ANDI R30,0xBF
	ST   X,R30
_0x2020177:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	__GETD2Z 26
	CALL _move_window_G101
	MOV  R17,R30
	CPI  R17,0
	BREQ PC+2
	RJMP _0x2020179
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,30
	LD   R18,X+
	LD   R19,X
	MOVW R26,R18
	ADIW R26,11
	LD   R30,X
	ORI  R30,0x20
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,10
	CALL __GETD1P
	__PUTD1RNS 18,28
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,14
	CALL __GETW1P
	__PUTW1RNS 18,26
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	__GETD2Z 14
	MOVW R30,R26
	MOVW R22,R24
	CALL __LSRD16
	__PUTW1RNS 18,20
	CALL _get_fattime
	__PUTD1S 4
	__PUTD1RNS 18,22
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,4
	LD   R30,X
	ANDI R30,0xDF
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,4
	LDI  R26,LOW(1)
	STD  Z+0,R26
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	MOVW R26,R30
	CALL _sync_G101
	MOV  R17,R30
_0x2020179:
_0x2020176:
_0x2020175:
	MOV  R30,R17
_0x20C0003:
	CALL __LOADLOCR4
	ADIW R28,10
	RET
; .FEND
_f_close:
; .FSTART _f_close
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _f_sync
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x202017A
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x202017A:
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_f_lseek:
; .FSTART _f_lseek
	CALL __PUTPARD2
	SBIW R28,16
	ST   -Y,R17
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	LDD  R26,Z+2
	LDD  R27,Z+3
	RCALL _validate_G101
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2020183
	RJMP _0x20C0002
_0x2020183:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	LDD  R26,Z+4
	ANDI R26,LOW(0x80)
	BREQ _0x2020184
	LDI  R30,LOW(2)
	RJMP _0x20C0001
_0x2020184:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,10
	CALL __GETD1P
	__GETD2S 17
	CALL __CPD12
	BRSH _0x2020186
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	LDD  R26,Z+4
	ANDI R26,LOW(0x2)
	BREQ _0x2020187
_0x2020186:
	RJMP _0x2020185
_0x2020187:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,10
	CALL __GETD1P
	__PUTD1S 17
_0x2020185:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,6
	CALL __GETD1P
	__PUTD1S 1
	__GETD1N 0x0
	__PUTD1S 5
	__PUTD1SNS 21,6
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,5
	LDI  R30,LOW(255)
	ST   X,R30
	__GETD2S 17
	CALL __CPD02
	BRLO PC+2
	RJMP _0x2020188
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CALL __GETW1P
	LDD  R30,Z+2
	LDI  R31,0
	CALL __CWD1
	__GETD2N 0x200
	CALL __MULD12U
	__PUTD1S 9
	__GETD2S 1
	CALL __CPD02
	BRSH _0x202018A
	__GETD1S 17
	__SUBD1N 1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 9
	CALL __DIVD21U
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 1
	__SUBD1N 1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 9
	CALL __DIVD21U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD21
	BRSH _0x202018B
_0x202018A:
	RJMP _0x2020189
_0x202018B:
	__GETD1S 1
	__SUBD1N 1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 9
	__SUBD1N 1
	CALL __COMD1
	CALL __ANDD12
	__PUTD1SNS 21,6
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,6
	CALL __GETD1P
	__GETD2S 17
	CALL __SUBD21
	__PUTD2S 17
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,18
	CALL __GETD1P
	__PUTD1S 13
	RJMP _0x202018C
_0x2020189:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,14
	CALL __GETD1P
	__PUTD1S 13
	CALL __CPD10
	BREQ PC+2
	RJMP _0x202018D
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD2N 0x0
	CALL _create_chain_G101
	__PUTD1S 13
	__GETD2S 13
	__CPD2N 0x1
	BRNE _0x202018E
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(2)
	RJMP _0x20C0001
_0x202018E:
	__GETD2S 13
	__CPD2N 0xFFFFFFFF
	BRNE _0x202018F
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(1)
	RJMP _0x20C0001
_0x202018F:
	__GETD1S 13
	__PUTD1SNS 21,14
_0x202018D:
	__GETD1S 13
	__PUTD1SNS 21,18
_0x202018C:
	__GETD1S 13
	CALL __CPD10
	BRNE PC+2
	RJMP _0x2020190
_0x2020191:
	__GETD1S 9
	__GETD2S 17
	CALL __CPD12
	BRLO PC+2
	RJMP _0x2020193
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	LDD  R26,Z+4
	ANDI R26,LOW(0x2)
	BREQ _0x2020194
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 15
	CALL _create_chain_G101
	__PUTD1S 13
	CALL __CPD10
	BRNE _0x2020195
	__GETD1S 9
	__PUTD1S 17
	RJMP _0x2020193
_0x2020195:
	RJMP _0x2020196
_0x2020194:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 15
	CALL _get_fat
	__PUTD1S 13
_0x2020196:
	__GETD2S 13
	__CPD2N 0xFFFFFFFF
	BRNE _0x2020197
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(1)
	RJMP _0x20C0001
_0x2020197:
	__GETD2S 13
	__CPD2N 0x2
	BRLO _0x2020199
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CALL __GETW1P
	ADIW R30,30
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 13
	CALL __CPD21
	BRLO _0x2020198
_0x2020199:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(2)
	RJMP _0x20C0001
_0x2020198:
	__GETD1S 13
	__PUTD1SNS 21,18
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ADIW R30,6
	MOVW R0,R30
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 9
	CALL __ADDD12
	MOVW R26,R0
	CALL __PUTDP1
	__GETD2S 9
	__GETD1S 17
	CALL __SUBD12
	__PUTD1S 17
	RJMP _0x2020191
_0x2020193:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ADIW R30,6
	MOVW R0,R30
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 17
	CALL __ADDD12
	MOVW R26,R0
	CALL __PUTDP1
	__GETD2S 17
	__GETD1N 0x200
	CALL __DIVD21U
	__PUTB1SNS 21,5
	__GETD1S 17
	ANDI R31,HIGH(0x1FF)
	SBIW R30,0
	BREQ _0x202019B
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 15
	CALL _clust2sect
	__PUTD1S 5
	CALL __CPD10
	BRNE _0x202019C
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(2)
	RJMP _0x20C0001
_0x202019C:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	LDD  R30,Z+5
	LDI  R31,0
	__GETD2S 5
	CALL __CWD1
	CALL __ADDD12
	__PUTD1S 5
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,5
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
_0x202019B:
_0x2020190:
_0x2020188:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	__GETD2Z 6
	MOVW R30,R26
	MOVW R22,R24
	ANDI R31,HIGH(0x1FF)
	SBIW R30,0
	BREQ _0x202019E
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,22
	CALL __GETD1P
	__GETD2S 5
	CALL __CPD12
	BRNE _0x202019F
_0x202019E:
	RJMP _0x202019D
_0x202019F:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	LDD  R26,Z+4
	ANDI R26,LOW(0x40)
	BREQ _0x20201A0
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CALL __GETW1P
	LDD  R30,Z+1
	ST   -Y,R30
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	__GETD2Z 22
	CALL __PUTPARD2
	LDI  R26,LOW(1)
	CALL _disk_write
	CPI  R30,0
	BREQ _0x20201A1
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(1)
	RJMP _0x20C0001
_0x20201A1:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	LD   R30,X
	ANDI R30,0xBF
	ST   X,R30
_0x20201A0:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CALL __GETW1P
	LDD  R30,Z+1
	ST   -Y,R30
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 8
	CALL __PUTPARD1
	LDI  R26,LOW(1)
	CALL _disk_read
	CPI  R30,0
	BREQ _0x20201A2
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(1)
	RJMP _0x20C0001
_0x20201A2:
	__GETD1S 5
	__PUTD1SNS 21,22
_0x202019D:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	__GETD2Z 6
	MOVW R0,R26
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,10
	CALL __GETD1P
	MOVW R26,R0
	CALL __CPD12
	BRSH _0x20201A3
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,6
	CALL __GETD1P
	__PUTD1SNS 21,10
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x20
	ST   X,R30
_0x20201A3:
_0x20C0002:
	MOV  R30,R17
_0x20C0001:
	LDD  R17,Y+0
	ADIW R28,23
	RET
; .FEND
_f_stat:
; .FSTART _f_stat
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,34
	ST   -Y,R17
	MOVW R30,R28
	ADIW R30,37
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,15
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _chk_mounted
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x20201B1
	MOVW R30,R28
	ADIW R30,1
	STD  Y+33,R30
	STD  Y+33+1,R31
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+39
	LDD  R27,Y+39+1
	CALL _follow_path_G101
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x20201B2
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	SBIW R30,0
	BREQ _0x20201B3
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+37
	LDD  R27,Y+37+1
	CALL _get_fileinfo_G101
	RJMP _0x20201B4
_0x20201B3:
	LDI  R17,LOW(6)
_0x20201B4:
_0x20201B2:
_0x20201B1:
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,39
	RET
; .FEND

	.CSEG

	.CSEG
_memcmp:
; .FSTART _memcmp
	ST   -Y,R27
	ST   -Y,R26
    clr  r22
    clr  r23
    ld   r24,y+
    ld   r25,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
memcmp0:
    adiw r24,0
    breq memcmp1
    sbiw r24,1
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    breq memcmp0
memcmp1:
    sub  r22,r23
    brcc memcmp2
    ldi  r30,-1
    ret
memcmp2:
    ldi  r30,0
    breq memcmp3
    inc  r30
memcmp3:
    ret
; .FEND
_memcpy:
; .FSTART _memcpy
	ST   -Y,R27
	ST   -Y,R26
    ldd  r25,y+1
    ld   r24,y
    adiw r24,0
    breq memcpy1
    ldd  r27,y+5
    ldd  r26,y+4
    ldd  r31,y+3
    ldd  r30,y+2
memcpy0:
    ld   r22,z+
    st   x+,r22
    sbiw r24,1
    brne memcpy0
memcpy1:
    ldd  r31,y+5
    ldd  r30,y+4
	ADIW R28,6
	RET
; .FEND
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	ADIW R28,5
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.DSEG
_prtc_get_time:
	.BYTE 0x2
_prtc_get_date:
	.BYTE 0x2
_fat:
	.BYTE 0x232
_file:
	.BYTE 0x220
_finfo:
	.BYTE 0x16
_path:
	.BYTE 0x16
_buffer_1:
	.BYTE 0x600
_FROM_SD:
	.BYTE 0x4
_SEND:
	.BYTE 0x6
_WFM:
	.BYTE 0x40
_flength:
	.BYTE 0x4
_status_G100:
	.BYTE 0x1
_timer1_G100:
	.BYTE 0x1
_timer2_G100:
	.BYTE 0x1
_card_type_G100:
	.BYTE 0x1
_FatFs_G101:
	.BYTE 0x2
_Fsid_G101:
	.BYTE 0x2
_Drive_G101:
	.BYTE 0x1
__seed_G104:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x1F40
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	RET

__ANDD12:
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	RET

__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__LSLD1:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	RET

__LSRD16:
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	RET

__LSLD16:
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__COMD1:
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTDZ20:
	ST   Z,R26
	STD  Z+1,R27
	STD  Z+2,R24
	STD  Z+3,R25
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
