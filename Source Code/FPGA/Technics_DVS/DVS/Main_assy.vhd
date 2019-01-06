----------------------------------------------------------------------------------
-- Create Date:    14:30:56 06/18/2015 
-- Design Name: 
-- Module Name:    Main_assy - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Main_assy is
	 Port ( Audio_data   : in		STD_LOGIC_VECTOR (7 downto 0);
			  RAM_Adress	: out 	STD_LOGIC_VECTOR (12 downto 0);
			  RAM_Data 		: inout 	STD_LOGIC_VECTOR (15 downto 0);
			  RAS    	 	: out  	STD_LOGIC;
			  CAS    	 	: out  	STD_LOGIC;
			  BA     		: out  	STD_LOGIC_VECTOR (1 downto 0);
			  DQM				: out 	STD_LOGIC_VECTOR (1 downto 0);
			  CS				: out  	STD_LOGIC;
			  WE     		: out  	STD_LOGIC;
			  RAM_clk		: out  	STD_LOGIC;
			  RAM_clk_en	: out  	STD_LOGIC;
			  serato_L 		: in  	STD_LOGIC;
			  serato_R 		: in  	STD_LOGIC;
			  clk     		: in  	STD_LOGIC;
			  avr_ready		: in  	STD_LOGIC;
			  avrclk     	: out  	STD_LOGIC;
			  G44   			: out  	STD_LOGIC;
			  NXT   			: in  	STD_LOGIC;
			  CUE_A   		: in  	STD_LOGIC;			-------------------------------------
			  CUE_B   		: in  	STD_LOGIC;			--	
			  REC_PLAY 		: in  	STD_LOGIC;			--	интерфейсные входы
			  SEARCH   		: in  	STD_LOGIC;			--	сигналы от интерфейсной ATmega
			  LOOP_MARK 	: in  	STD_LOGIC;			--
			  LOOP_ENABLE  : in  	STD_LOGIC;			-------------------------------------
			  Audio_out  	: out 	STD_LOGIC_VECTOR (15 downto 0);
			  UART			: out		STD_LOGIC
			 );
end Main_assy;

architecture Behavioral of Main_assy is

signal  clk_dev      	: integer range 0 to 32767;			--16383;
signal  clk_devs     	: integer range 0 to 32766;			--16382;
signal  read_dev     	: integer range 0 to 90;
signal  rdy					: STD_LOGIC;
signal  part				: bit;
signal  need_frame		: bit;
signal  need_buffer		: bit;
signal  Audio_reg			: STD_LOGIC_VECTOR (15 downto 0);
signal  frame				: STD_LOGIC_VECTOR (15 downto 0);
signal  wadress	   	: STD_LOGIC_VECTOR (23 downto 0);
signal  radress	   	: STD_LOGIC_VECTOR (23 downto 0);
signal  radress_t	   	: STD_LOGIC_VECTOR (23 downto 0);
signal  reg   		   	: integer range 0 to 43;
signal  reg_1   	   	: integer range 0 to 43;
signal  spd       		: integer range 1 to 32767;			--16383;
signal  spd_1       		: integer range 1 to 32767;			--16383;
signal  spdr 		   	: integer range 1 to 32766;			--16382;
signal  clk_filters  	: integer range 0 to 32766;			--16382;
signal  clk_filter   	: integer range 0 to 32767;			--16383;
signal  rzr      			: bit;
signal  rzrr     			: bit;
signal  rzr_1    			: bit;
signal  rzr_2	  			: bit;
signal  direct	  			: STD_LOGIC;
signal  outenable			: bit;
signal  G44_sost			: bit;
signal  serato_d 			: STD_LOGIC;
signal  serato_d_0 		: STD_LOGIC;
signal  serato_d_1 		: STD_LOGIC;
signal  serato_d_2 		: STD_LOGIC;
signal  serato_x 			: STD_LOGIC;
signal  serato_x_0		: STD_LOGIC;
signal  serato_x_1 		: STD_LOGIC;
signal  serato_x_2		: STD_LOGIC;
signal  s_clock      	: integer range 0 to 2;
signal  CUE_1				: STD_LOGIC_VECTOR (15 downto 0);
signal  CUE_2				: STD_LOGIC_VECTOR (15 downto 0);
signal  LOOP_IN_reg		: STD_LOGIC_VECTOR (15 downto 0);
signal  LOOP_OUT_reg		: STD_LOGIC_VECTOR (15 downto 0);
signal  rcue_1				: bit;		--------------------------------
signal  rcue_2				: bit;		--
signal  playcue_1			: bit;		--
signal  playcue_2			: bit;		--		внутренние сигналы 
signal  srchplus			: bit;		--		интерфесного управления
signal  srchminus			: bit;		--
signal  loopin				: bit;		--
signal  loopout			: bit;		--
signal  loopen				: bit;		---------------------------------
signal  sst      			: bit;
signal  pulse_counter   : integer range 0 to 5:=0;	---счетчик импульсов обмена горячими точками с ATXmega
signal  flag      		: bit:='0';						--флаг разрешения входа в цикл
signal  flagPORT      	: bit:='0';						--флаг разрешения входа в цикл
signal  a_clock      	 : integer range 0 to 3;	-----------------------------------------
signal  avr_ready_buff	 : STD_LOGIC;					--
signal  avr_ready_buff_0 : STD_LOGIC;					--		переменные для фильтрации
signal  avr_ready_buff_1 : STD_LOGIC;					--		сигнала AVR_READY
signal  avr_ready_buff_2 : STD_LOGIC;					--
signal  avr_ready_buff_3 : STD_LOGIC;					-----------------------------------------
signal  TRACK_TIME 		 : STD_LOGIC_VECTOR(7 downto 0);	 --адрес конца трека
signal  uart_dev     	 : integer range 0 to 500;			 --переменная для деления частоты uart
signal  uart_operation   : integer range 0 to 50;			 --счетчик номера операции выполнения USART
signal  uart_send_buffer : STD_LOGIC_VECTOR (9 downto 0); 
signal  uart_start_send	 : bit;				---команда начала передачи по uart
signal  one_second     	 : integer range 0 to 44100; --переменная для подсчета промежутка времени в 1 секунду проигрывания трека

begin
play : process(clk, NXT)

begin
if(clk'event and clk='0') then
	if(NXT='0') then				--сброс
		frame<="1000000010000000";
		need_frame<='1';
		need_buffer<='1';
		radress<=(others=>'0');
		radress_t<=(others=>'0');
		wadress<=(others=>'0');
		RAM_Data<=(others=>'Z');
		CS<='0';
		CAS<='1';
		RAS<='1';
		WE<='1';				
		DQM<="00";			--установлен статически
		RAM_clk_en<='1';	--установлен статически
		RAM_clk<='0';
		CS<='1';				
		part<='0';
		rdy<='0';
		LOOP_IN_reg<=(others=>'0');
		LOOP_OUT_reg<=(others=>'0');
		sst<='0';
		uart_start_send<='0';
		uart_send_buffer<=(others=>'0');
		one_second<=0;
		
		if(avr_ready_buff='1') then
			if(flag='1') then
				pulse_counter<=pulse_counter+1;
				flagPORT<='1';
				flag<='0';
			end if;
		else
			flag<='1';
		end if;
		
		if(flagPORT='1') then
			flagPORT<='0';
			if(pulse_counter=1) then
				CUE_1(15 downto 8)<=Audio_data;
			elsif(pulse_counter=2) then
				CUE_1(7 downto 0)<=Audio_data;
			elsif(pulse_counter=3) then
				CUE_2(15 downto 8)<=Audio_data;
			elsif(pulse_counter=4) then
				CUE_2(7 downto 0)<=Audio_data;
			elsif(pulse_counter=5) then
				TRACK_TIME(7 downto 0)<=Audio_data;	
			end if;
		end if;
	else
		flag<='0';
		flagPORT<='0';
		pulse_counter<=0;
		if(uart_operation=5) then	--когда пошел процесс передачи по UART, сигнал старта передачи возвращаем в ноль
			uart_start_send<='0';
		end if;
		if(srchplus='1' and sst='0') then				---перемотка вперед
			sst<='1';
			if(not(radress(23 downto 16)=TRACK_TIME(7 downto 0))) then
				radress<=radress+"000000010000000000000000";
				one_second<=0;
				if(uart_operation=50) then																						-----------------------------------------------
					uart_send_buffer(9 downto 0)<=radress(23 downto 14);												--		формирование команды на передачу по UART
					uart_start_send<='1';																						--		занесение данных в буффер передачи
				end if;																												-----------------------------------------------
			end if;
		elsif(srchminus='1' and sst='0') then			---перемотка назад
			sst<='1';
			if(not(radress(23 downto 16)="00000000")) then
				radress<=radress-"000000010000000000000000";
				one_second<=0;
				if(uart_operation=50) then																						-----------------------------------------------
					uart_send_buffer(9 downto 0)<=radress(23 downto 14);												--		формирование команды на передачу по UART
					uart_start_send<='1';																						--		занесение данных в буффер передачи
				end if;																												-----------------------------------------------
			end if;
		elsif(rcue_1='1' and sst='0') then				
			sst<='1';
			CUE_1<=radress(23 downto 8);
		elsif(rcue_2='1' and sst='0') then
			sst<='1';
			CUE_2<=radress(23 downto 8);	
		elsif(playcue_1='1' and sst='0') then
			sst<='1';
			radress(23 downto 8)<=CUE_1;
			one_second<=0;
			if(uart_operation=50) then																					-----------------------------------------------
				uart_send_buffer(9 downto 0)<=CUE_1(15 downto 6);											--		формирование команды на передачу по UART
				uart_start_send<='1';																					--		занесение данных в буффер передачи
			end if;																											-----------------------------------------------
		elsif(playcue_2='1' and sst='0') then
			sst<='1';
			radress(23 downto 8)<=CUE_2;
			one_second<=0;
			if(uart_operation=50) then																					-----------------------------------------------
				uart_send_buffer(9 downto 0)<=CUE_2(15 downto 6);											--		формирование команды на передачу по UART
				uart_start_send<='1';																					--		занесение данных в буффер передачи
			end if;																											-----------------------------------------------
		elsif(loopin='1' and sst='0') then
			sst<='1';
			LOOP_IN_reg<=radress(23 downto 8);
		elsif(loopout='1' and sst='0') then
			sst<='1';
			LOOP_OUT_reg<=radress(23 downto 8);
		elsif(rcue_1='0' and rcue_2='0' and playcue_1='0' and playcue_2='0' and sst='1' and srchplus='0' and srchminus='0' and loopen='0') then
			sst<='0';
		end if;
		
		if(clk_dev=2) then			--чтение
			Audio_out<=frame;
			need_frame<='1';
		elsif(clk_dev=50) then
			if(loopen='1' and radress(23 downto 8)=LOOP_OUT_reg) then	--отработка режима LOOP
				radress(23 downto 8)<=LOOP_IN_reg;
				one_second<=0;
				if(uart_operation=50) then																							-----------------------------------------------
					uart_send_buffer(9 downto 0)<=radress(23 downto 14);													--		формирование команды на передачу по UART
					uart_start_send<='1';																							--		занесение данных в буффер передачи
				end if;																													-----------------------------------------------
			else
				if(direct='1') then						-------счетчик адреса воспроизведения реверсивный
					if(radress>wadress and need_buffer='1') then
						radress<=wadress;
					elsif(not(radress(23 downto 16)=TRACK_TIME(7 downto 0) and radress(15 downto 0)="1111111111111111")) then
						radress<=radress+'1';
						if(one_second<44099) then
							one_second<=one_second+1;
						else
							one_second<=0;
							if(uart_operation=50) then																						-----------------------------------------------
								uart_send_buffer(9 downto 0)<=radress(23 downto 14);												--		формирование команды на передачу по UART
								uart_start_send<='1';																						--		занесение данных в буффер передачи
							end if;																												-----------------------------------------------
						end if;
					end if;
				else
					if(not(radress="000000000000000000000000")) then
						radress<=radress-'1';
						if(one_second>0) then
							one_second<=one_second-1;
						else
							one_second<=44099;
							if(uart_operation=50) then																						-----------------------------------------------
								uart_send_buffer(9 downto 0)<=radress(23 downto 14);												--		формирование команды на передачу по UART
								uart_start_send<='1';																						--		занесение данных в буффер передачи
							end if;																												-----------------------------------------------
						end if;
					end if;
				end if;
			end if;
		end if;

		if((read_dev=15 or read_dev=13 or read_dev=11 or read_dev=9 or read_dev=7 or read_dev=5 or read_dev=3) and rdy='1') then
			RAM_clk<='1';	
		elsif(read_dev=2 and rdy='1') then			--запись в SDRAM
			RAM_clk<='0';
			CS<='0';
			CAS<='0';
			RAS<='0';
			WE<='0';
			BA<=(others=>'0');
			RAM_Adress<="0000000100000";
			RAM_Data<=Audio_reg;
		elsif(read_dev=4 and rdy='1') then
			RAM_clk<='0';	
			WE<='1';
		elsif(read_dev=6 and rdy='1') then
			RAM_clk<='0';
			WE<='0';	
			CAS<='1';
			BA<=wadress(1 downto 0);
		elsif(read_dev=8 and rdy='1') then
			RAM_clk<='0';
			WE<='1';
			RAM_Adress<=wadress(14 downto 2);
		elsif(read_dev=10 and rdy='1') then	
			RAM_clk<='0';
			RAS<='1';
			CAS<='0';
			WE<='0';
			RAM_Adress(8 downto 0)<=wadress(23 downto 15);
			RAM_Adress(10)<='1';	
		elsif(read_dev=12 and rdy='1') then	
			RAM_clk<='0';	
			WE<='1';
		elsif(read_dev=14 and rdy='1') then	
			RAM_clk<='0';	
			CAS<='1';		
		elsif(read_dev=16 and rdy='1') then	
			RAM_clk<='0';	
			CS<='1';
		elsif(read_dev=17 and rdy='1') then	
			RAM_clk<='1';
			rdy<='0';
			RAM_Data<=(others=>'Z');
			wadress<=wadress+'1';
			if(wadress(23 downto 0)="111111111111111111111111") then
				need_buffer<='0';	
			end if;
					
		elsif(read_dev=42) then					--refresh memory
			RAM_Data<=(others=>'Z');
			if(need_buffer='1' and avr_ready='1') then
				avrclk<='0';
				if(part='0') then
					Audio_reg(7 downto 0)<=Audio_data;
					part<='1';
				else
					Audio_reg(15 downto 8)<=Audio_data;
					part<='0';
					rdy<='1';
				end if;
			else
				rdy<='0';
			end if;	
		elsif(read_dev=43) then
			if(need_frame='0' or spdr<160) then
				radress_t<=radress;
			end if;
		
		elsif(read_dev=45 or read_dev=47 or read_dev=49 or read_dev=51 or read_dev=53 or read_dev=55 or read_dev=59 or read_dev=61) then
			RAM_clk<='1';
		elsif(read_dev=44) then						--чтение из SDRAM
			RAM_clk<='0';
			CS<='0';
			CAS<='0';
			RAS<='0';
			WE<='0';
			BA<=(others=>'0');
			RAM_Adress<="0000000100000";
		elsif(read_dev=46) then	
			RAM_clk<='0';	
			WE<='1';
			avrclk<='1';
		elsif(read_dev=48) then	
			RAM_clk<='0';	
			WE<='0';
			CAS<='1';
			BA<=radress_t(1 downto 0);
		elsif(read_dev=50) then	
			RAM_clk<='0';	
			WE<='1';
			RAM_Adress<=radress_t(14 downto 2);
		elsif(read_dev=52) then	
			RAM_clk<='0';	
			CAS<='0';
			RAS<='1';
			--WE<='0';----------------------------------------------------------убрал и заработало
			RAM_Adress(8 downto 0)<=radress_t(23 downto 15);
			RAM_Adress(10)<='1';
		elsif(read_dev=54) then	
			RAM_clk<='0';	
			--WE<='1';		
		elsif(read_dev=56) then	
			RAM_clk<='0';
		elsif(read_dev=57) then	
			RAM_clk<='1';
			if(need_frame='1') then
				frame<=RAM_Data;
				need_frame<='0';
			end if;	
		elsif(read_dev=58) then
			RAM_clk<='0';	
			CAS<='1';	
		elsif(read_dev=60) then
			RAM_clk<='0';
			CS<='1';
			--avrclk<='1';
		end if;
	end if;
end if;
end process play;

--avr_process
avr : process(clk)						--фильтр сигнала AVR_READY
	begin
	if(clk'event and clk='0') then
		if(avr_ready_buff_1=avr_ready_buff_0 and avr_ready_buff_2=avr_ready_buff_0 and avr_ready_buff_3=avr_ready_buff_0) then
			avr_ready_buff<=avr_ready_buff_0;
		end if;
		
		if(a_clock<3) then
			a_clock<=a_clock+1;
		else
			a_clock<=0;
			avr_ready_buff_0<=avr_ready;
		end if;
		if(a_clock=1) then
			avr_ready_buff_1<=avr_ready;
		elsif(a_clock=2) then
			avr_ready_buff_2<=avr_ready;
		elsif(a_clock=3) then
			avr_ready_buff_3<=avr_ready;
		end if;
	end if;
end process avr;


gen : process(clk)	--генератор
begin
if(clk'event and clk='0') then
	if(serato_d='0' and rzr_2='0') then
		rzr_2<='1';
		direct<=serato_x;
		if(rzr_1='0') then
			rzr_1<='1';
		else
			rzr_1<='0';
		end if;
	elsif(serato_d='1' and rzr_2='1') then
		rzr_2<='0';	
	end if;
	if(rzr_1='0') then
		if(reg=43) then
			reg<=0;
			if(spd<32766) then				-----16382
				spd<=spd+1;	
				outenable<='1';
			else
				outenable<='0';
			end if;
		else
			reg<=reg+1;
		end if;
		if(rzrr='0') then
			if(spd_1>160) then
				spdr<=(spdr+spd_1)/2;
			end if;
			rzrr<='1';
		else
			spd_1<=1;
		end if;
		reg_1<=0;
		rzr<='0';
	else
		if(reg_1=43) then
			reg_1<=0;
			if(spd_1<32766) then				-----16382
				spd_1<=spd_1+1;
				outenable<='1';
			else
				outenable<='0';
			end if;
		else
			reg_1<=reg_1+1;
		end if;
		if(rzr='0') then
			if(spd>160) then
				spdr<=(spdr+spd)/2;
			end if;
			rzr<='1';
		else
			spd<=1;
		end if;
		reg<=0;
		rzrr<='0';		
	end if;
end if;	
end process gen;


--devider 44100Hz
devider : process(clk, NXT)
begin
if(NXT='0') then				--сброс
clk_dev<=0;
elsif(clk'event and clk='0') then
	if(clk_dev=clk_devs) then
		clk_dev<=0;
		clk_devs<=spdr;		
	else
		if(outenable='1') then
			clk_dev<=clk_dev+1;
		else
			clk_dev<=1;
		end if;
	end if;
end if;
end process devider;


--filter clock 2MHz
clock_for_filter : process(clk, NXT)
begin
if(NXT='0') then
	G44<='0';
elsif(clk'event and clk='0') then
	if(clk_filter>clk_filters) then
		clk_filter<=0;
		if(spdr<900) then
			clk_filters<=600;		------------750
		else
			clk_filters<=spdr-300;		---------------нелинейное поведение фильтра
		end if;
		
		if(G44_sost='1') then
			G44<='0';
			G44_sost<='0';
		else
			G44<='1';
			G44_sost<='1';
		end if;
	else
		if(outenable='1') then
			clk_filter<=clk_filter+55;				--------------71  коэффициент перед введением нелинейной зависимости поведения фильтра
		else
			clk_filter<=0;
		end if;
	end if;
end if;
end process clock_for_filter;


--read devider 100kHz
read_devider : process(clk, NXT)
begin
if(NXT='0') then				--сброс
read_dev<=0;
elsif(clk'event and clk='0') then		
	if(read_dev=90) then
		read_dev<=0;
	else
		read_dev<=read_dev+1;	
	end if;
end if;
end process read_devider;

--delay_process
delay : process(clk)
	begin
	if(clk'event and clk='0') then
		if(serato_d_0=serato_d_1 and serato_d_0=serato_d_2) then
			serato_d<=serato_d_0;
		end if;
		if(serato_x_0=serato_x_1 and serato_x_0=serato_x_2) then
			serato_x<=serato_x_0;
		end if;
		if(s_clock<2) then
			s_clock<=s_clock+1;
		else
			s_clock<=0;					
			serato_d_0<=serato_L;		
			serato_x_0<=serato_R;		
		end if;
		if(s_clock=1) then
			serato_d_1<=serato_L;
			serato_x_1<=serato_R;
		elsif(s_clock=2) then
			serato_d_2<=serato_L;
			serato_x_2<=serato_R;
		end if;
	end if;
end process delay;

--interface_process
interface : process(clk, NXT)
	begin
	if(NXT='0') then				--сброс
		rcue_1<='0';			
		rcue_2<='0';			
		playcue_1<='0';		
		playcue_2<='0';		
		srchplus<='0';		
		srchminus<='0';		
		loopin<='0';			
		loopout<='0';			
		loopen<='0';			
	elsif(clk'event and clk='0') then
		if(CUE_A='1' and CUE_B='0' and SEARCH='0' and REC_PLAY='0' and LOOP_MARK='0' and LOOP_ENABLE='0') then	--вызвали CUE_1
			rcue_1<='0';			
			rcue_2<='0';			
			playcue_1<='1';		
			playcue_2<='0';		
			srchplus<='0';		
			srchminus<='0';		
			loopin<='0';			
			loopout<='0';			
			loopen<='0';
		elsif(CUE_A='0' and CUE_B='1' and SEARCH='0' and REC_PLAY='0' and LOOP_MARK='0' and LOOP_ENABLE='0') then	--вызвали CUE_2
			rcue_1<='0';			
			rcue_2<='0';			
			playcue_1<='0';		
			playcue_2<='1';		
			srchplus<='0';		
			srchminus<='0';		
			loopin<='0';			
			loopout<='0';			
			loopen<='0';		
		elsif(CUE_A='1' and CUE_B='0' and SEARCH='0' and REC_PLAY='1' and LOOP_MARK='0' and LOOP_ENABLE='0') then	--записали CUE_1
			rcue_1<='1';			
			rcue_2<='0';			
			playcue_1<='0';		
			playcue_2<='0';		
			srchplus<='0';		
			srchminus<='0';		
			loopin<='0';			
			loopout<='0';			
			loopen<='0';
		elsif(CUE_A='0' and CUE_B='1' and SEARCH='0' and REC_PLAY='1' and LOOP_MARK='0' and LOOP_ENABLE='0') then	--записали CUE_2
			rcue_1<='0';			
			rcue_2<='1';			
			playcue_1<='0';		
			playcue_2<='0';		
			srchplus<='0';		
			srchminus<='0';		
			loopin<='0';			
			loopout<='0';			
			loopen<='0';
		elsif(CUE_A='1' and CUE_B='0' and SEARCH='1' and REC_PLAY='0' and LOOP_MARK='0' and LOOP_ENABLE='0') then	--перемотка назад
			rcue_1<='0';			
			rcue_2<='0';			
			playcue_1<='0';		
			playcue_2<='0';		
			srchplus<='0';		
			srchminus<='1';		
			loopin<='0';			
			loopout<='0';			
			loopen<='0';
		elsif(CUE_A='0' and CUE_B='1' and SEARCH='1' and REC_PLAY='0' and LOOP_MARK='0' and LOOP_ENABLE='0') then	--перемотка вперед
			rcue_1<='0';			
			rcue_2<='0';			
			playcue_1<='0';		
			playcue_2<='0';		
			srchplus<='1';		
			srchminus<='0';		
			loopin<='0';			
			loopout<='0';			
			loopen<='0';
		elsif(CUE_A='1' and CUE_B='0' and SEARCH='0' and REC_PLAY='0' and LOOP_MARK='1') then	--установка точки LOOP_IN
			rcue_1<='0';			
			rcue_2<='0';			
			playcue_1<='0';		
			playcue_2<='0';		
			srchplus<='0';		
			srchminus<='0';		
			loopin<='1';			
			loopout<='0';			
			loopen<='0';
		elsif(CUE_A='0' and CUE_B='1' and SEARCH='0' and REC_PLAY='0' and LOOP_MARK='1') then	--установка точки LOOP_OUT
			rcue_1<='0';			
			rcue_2<='0';			
			playcue_1<='0';		
			playcue_2<='0';		
			srchplus<='0';		
			srchminus<='0';		
			loopin<='0';			
			loopout<='1';			
			loopen<='1';
		elsif(LOOP_ENABLE='1') then	--удержание режима петли						
			loopen<='1';
		else
			rcue_1<='0';			
			rcue_2<='0';			
			playcue_1<='0';		
			playcue_2<='0';		
			srchplus<='0';		
			srchminus<='0';		
			loopin<='0';			
			loopout<='0';			
			loopen<='0';
		end if;
	end if;
end process interface;

--UART process
UART_send : process(clk, NXT, uart_start_send)
begin
if(NXT='0') then				--сброс
uart_dev<=0;
uart_operation<=0;
UART<='1';
elsif(clk'event and clk='0') then
	if(uart_dev=500) then
		uart_dev<=0;
		if(uart_start_send='1' and uart_operation=50) then
			uart_operation<=0;
		end if;
		if(not(uart_operation=50)) then
			uart_operation<=uart_operation+1;
			if(uart_operation=5) then
				UART<='0';
			elsif(uart_operation=6) then
				UART<=uart_send_buffer(0);
			elsif(uart_operation=7) then
				UART<=uart_send_buffer(1);
			elsif(uart_operation=8) then
				UART<=uart_send_buffer(2);
			elsif(uart_operation=9) then
				UART<=uart_send_buffer(3);
			elsif(uart_operation=10) then
				UART<=uart_send_buffer(4);
			elsif(uart_operation=11) then
				UART<=uart_send_buffer(5);
			elsif(uart_operation=12) then
				UART<=uart_send_buffer(6);
			elsif(uart_operation=13) then
				UART<=uart_send_buffer(7);
			elsif(uart_operation=14) then
				UART<='1';
			elsif(uart_operation=15) then
				UART<='0';
			elsif(uart_operation=16) then
				UART<=uart_send_buffer(8);
			elsif(uart_operation=17) then
				UART<=uart_send_buffer(9);
			elsif(uart_operation=18) then
				UART<='0';
			elsif(uart_operation=24) then
				UART<='1';
			end if;
		end if;
	else
		uart_dev<=uart_dev+1;	
	end if;	
end if;
end process UART_send;

end Behavioral;

