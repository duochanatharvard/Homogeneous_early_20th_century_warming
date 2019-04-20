% ICOADS_Step_01_ascii2mat(yr, mon)
%
%  This function takes in files in __IMMA__ format,
%  convert variables, and save __Matlab mat__ files.
%
%  Currently only variables that are associated with the
%  spatial and temporal position of measurements, collector
%  (including nation, deck, and callsign), SST, Air temperature,
%  wind, SLP, cloud, ship size, universial ID, and
%  quality control flags are processed.
%  Users can modify corresponding lines to customize and output new variables.
%
%  Saved variables are in format of "__CX\_YYY__",
%  where __X__ is the number of ICOADS Table,
%  and __YYY__ is the short name of variable.
%
% Last update: 2018-08-15

function ICOADS_Step_01_ascii2mat(yr,mon)

    % Set direcotry and files  --------------------------------------------
    dir_load = ICOADS_OI('raw_data');
    dir_save  = ICOADS_OI('mat_files');
    cmon = '00';  cmon(end-size(num2str(mon),2)+1:end) = num2str(mon);
    file_load = [dir_load,'IMMA1_R3.0.0_',num2str(yr),'-',cmon];
    file_save = [dir_save,'IMMA1_R3.0.0_',num2str(yr),'-',cmon,'.mat'];


    % Convert the files  --------------------------------------------------

    fid=fopen(file_load,'r');

    if fid > 0,

        disp([file_load ,' is started!']);
        words=fscanf(fid,'%c',10000000000000);
        fclose(fid);
        num = [0 find(words == 10)];

        for i = 1:max(size(num))-1
            temp = words(num(i)+1:num(i+1)-1);
            if(strcmp(temp(1:4),repmat(' ',1,4)))      C0_YR(i)  = NaN; else C0_YR(i)  = str2num(temp(1:4)); end
            if(strcmp(temp(5:6),repmat(' ',1,2)))      C0_MO(i)  = NaN; else C0_MO(i)  = str2num(temp(5:6)); end
            if(strcmp(temp(7:8),repmat(' ',1,2)))      C0_DY(i)  = NaN; else C0_DY(i)  = str2num(temp(7:8)); end
            if(strcmp(temp(9:12),repmat(' ',1,4)))     C0_HR(i)  = NaN; else C0_HR(i)  = str2num(temp(9:12))/100; end
            if(strcmp(temp(13:17),repmat(' ',1,5)))    C0_LAT(i) = NaN; else C0_LAT(i) = str2num(temp(13:17))/100; end
            if(strcmp(temp(18:23),repmat(' ',1,6)))    C0_LON(i) = NaN; else C0_LON(i) = str2num(temp(18:23))/100; end
            if(strcmp(temp(26),' '))  C0_ATTC(i) = NaN; elseif(any(temp(26)=='ABCDEFGHIJKLMNOPQRSTUVWXYZ')) C0_ATTC(i)  = temp(26)-55; else C0_ATTC(i) = str2num(temp(26)); end
            if(strcmp(temp(27),repmat(' ',1,1)))       C0_TI(i)  = NaN; else C0_TI(i)  = str2num(temp(27)); end
            if(strcmp(temp(28),repmat(' ',1,1)))       C0_LI(i)  = NaN; else C0_LI(i)  = str2num(temp(28)); end
            if(strcmp(temp(29),repmat(' ',1,1)))       C0_DS(i)  = NaN; else C0_DS(i)  = str2num(temp(29)); end
            if(strcmp(temp(30),repmat(' ',1,1)))       C0_VS(i)  = NaN; else C0_VS(i)  = str2num(temp(30)); end
            if(strcmp(temp(31:32),repmat(' ',1,2)))    C0_NID(i) = NaN; else C0_NID(i) = str2num(temp(31:32)); end
            if(strcmp(temp(33:34),repmat(' ',1,2)))    C0_II(i)  = NaN; else C0_II(i)  = str2num(temp(33:34)); end
            C0_ID(i,:) = temp(35:43);
            C0_C1(i,:) = temp(44:45);
            temp(1:45) = [];

            if(strcmp(temp(1),repmat(' ',1,1)))        C0_DI(i)  = NaN; else C0_DI(i)  = str2num(temp(1)); end
            if(strcmp(temp(2:4),repmat(' ',1,3)))      C0_D(i)   = NaN; else C0_D(i)   = str2num(temp(2:4)); end
            if(strcmp(temp(5),repmat(' ',1,1)))        C0_WI(i)  = NaN; else C0_WI(i)  = str2num(temp(5)); end
            if(strcmp(temp(6:8),repmat(' ',1,3)))      C0_W(i)   = NaN; else C0_W(i)   = str2num(temp(6:8))/10; end
            if(strcmp(temp(9),repmat(' ',1,1)))        C0_VI(i)  = NaN; else C0_VI(i)  = str2num(temp(9)); end
            if(strcmp(temp(10:11),repmat(' ',1,2)))    C0_VV(i)  = NaN; else C0_VV(i)  = str2num(temp(10:11)); end
            if(strcmp(temp(12:13),repmat(' ',1,2)))    C0_WW(i)  = NaN; else C0_WW(i)  = str2num(temp(12:13)); end
            if(strcmp(temp(14),repmat(' ',1,1)))       C0_W1(i)  = NaN; else C0_W1(i)  = str2num(temp(14)); end
            if(strcmp(temp(15:19),repmat(' ',1,5)))    C0_SLP(i) = NaN; else C0_SLP(i) = str2num(temp(15:19))/10; end
            if(strcmp(temp(20),repmat(' ',1,1)))       C0_A(i)   = NaN; else C0_A(i)   = str2num(temp(20)); end
            if(strcmp(temp(21:23),repmat(' ',1,3)))    C0_PPP(i) = NaN; else C0_PPP(i) = str2num(temp(21:23))/10; end
            if(strcmp(temp(24),repmat(' ',1,1)))       C0_IT(i)  = NaN; else C0_IT(i)  = str2num(temp(24)); end
            if(strcmp(temp(25:28),repmat(' ',1,4)))    C0_AT(i)  = NaN; else C0_AT(i)  = str2num(temp(25:28))/10; end
            if(strcmp(temp(29),repmat(' ',1,1)))       C0_WBTI(i)= NaN; else C0_WBTI(i)= str2num(temp(29)); end
            if(strcmp(temp(30:33),repmat(' ',1,4)))    C0_WBT(i) = NaN; else C0_WBT(i) = str2num(temp(30:33))/10; end
            if(strcmp(temp(34),repmat(' ',1,1)))       C0_DPTI(i)= NaN; else C0_DPTI(i)= str2num(temp(34)); end
            if(strcmp(temp(35:38),repmat(' ',1,4)))    C0_DPT(i) = NaN; else C0_DPT(i) = str2num(temp(35:38))/10; end
            if(strcmp(temp(39:40),repmat(' ',1,2)))    C0_SI(i)  = NaN; else C0_SI(i)  = str2num(temp(39:40)); end
            if(strcmp(temp(41:44),repmat(' ',1,4)))    C0_SST(i) = NaN; else C0_SST(i) = str2num(temp(41:44))/10; end
            if(strcmp(temp(45),repmat(' ',1,1)))       C0_N(i)   = NaN; else C0_N(i)   = str2num(temp(45)); end
            if(strcmp(temp(46),repmat(' ',1,1)))       C0_NH(i)  = NaN; else C0_NH(i)  = str2num(temp(46)); end
            if(strcmp(temp(47),' '))  C0_CL(i) = NaN; elseif(strcmp(temp(47),'A')) C0_CL(i) = 10; else C0_CL(i) = str2num(temp(47)); end
            if(strcmp(temp(48),repmat(' ',1,1)))       C0_HI(i)  = NaN; else C0_HI(i)  = str2num(temp(48)); end
            if(strcmp(temp(49),' '))  C0_H(i)  = NaN; elseif(strcmp(temp(49),'A')) C0_H(i)  = 10; else C0_H(i)  = str2num(temp(49)); end
            if(strcmp(temp(50),' '))  C0_CM(i) = NaN; elseif(strcmp(temp(50),'A')) C0_CM(i) = 10; else C0_CM(i) = str2num(temp(50)); end
            if(strcmp(temp(51),' '))  C0_CH(i) = NaN; elseif(strcmp(temp(51),'A')) C0_CH(i) = 10; else C0_CH(i) = str2num(temp(51)); end
            if(strcmp(temp(52:53),repmat(' ',1,2)))    C0_WD(i)  = NaN; else C0_WD(i)  = str2num(temp(52:53)); end
            if(strcmp(temp(54:55),repmat(' ',1,2)))    C0_WP(i)  = NaN; else C0_WP(i)  = str2num(temp(54:55)); end
            if(strcmp(temp(56:57),repmat(' ',1,2)))    C0_WH(i)  = NaN; else C0_WH(i)  = str2num(temp(56:57)); end
            if(strcmp(temp(58:59),repmat(' ',1,2)))    C0_SD(i)  = NaN; else C0_SD(i)  = str2num(temp(58:59)); end
            if(strcmp(temp(60:61),repmat(' ',1,2)))    C0_SP(i)  = NaN; else C0_SP(i)  = str2num(temp(60:61)); end
            if(strcmp(temp(62:63),repmat(' ',1,2)))    C0_SH(i)  = NaN; else C0_SH(i)  = str2num(temp(62:63)); end
            temp(1:63) = [];

            if(isempty(temp) == 0)
                temp_att = str2num(temp(1:2));
                if(temp_att == 1)
                    if(strcmp(temp(11:13),repmat(' ',1,3)))      C1_DCK(i)  = NaN; else C1_DCK(i)  = str2num(temp(11:13)); end
                    if(strcmp(temp(14:16),repmat(' ',1,3)))      C1_SID(i)  = NaN; else C1_SID(i)  = str2num(temp(14:16)); end
                    if(strcmp(temp(17:18),repmat(' ',1,2)))      C1_PT(i)   = NaN; else C1_PT(i)   = str2num(temp(17:18)); end
                    if(strcmp(temp(19:20),repmat(' ',1,2)))      C1_DUPS(i) = NaN; else C1_DUPS(i) = str2num(temp(19:20)); end
                    if(strcmp(temp(21),repmat(' ',1,1)))         C1_DUPC(i) = NaN; else C1_DUPC(i) = str2num(temp(21)); end
                    if(strcmp(temp(22),repmat(' ',1,1)))         C1_TC(i)   = NaN; else C1_TC(i)   = str2num(temp(22)); end
                    if(strcmp(temp(23),repmat(' ',1,1)))         C1_PB(i)   = NaN; else C1_PB(i)   = str2num(temp(23)); end
                    if(strcmp(temp(24),repmat(' ',1,1)))         C1_WX(i)   = NaN; else C1_WX(i)   = str2num(temp(24)); end
                    if(strcmp(temp(25),repmat(' ',1,1)))         C1_SX(i)   = NaN; else C1_SX(i)   = str2num(temp(25)); end
                    C1_C2(i,:) = temp(26:27);
                    if(strcmp(temp(40),repmat(' ',1,1)))         C1_ND(i)   = NaN; else C1_ND(i)   = str2num(temp(40)); end
                    if(strcmp(temp(41),' '))  C1_SF(i)  = NaN; elseif(any(temp(41) == 'ABCDEF')) C1_SF(i)  = temp(41)-55; else C1_SF(i)  = str2num(temp(41)); end
                    if(strcmp(temp(42),' '))  C1_AF(i)  = NaN; elseif(any(temp(42) == 'ABCDEF')) C1_AF(i)  = temp(42)-55; else C1_AF(i)  = str2num(temp(42)); end
                    if(strcmp(temp(43),' '))  C1_UF(i)  = NaN; elseif(any(temp(43) == 'ABCDEF')) C1_UF(i)  = temp(43)-55; else C1_UF(i)  = str2num(temp(43)); end
                    if(strcmp(temp(44),' '))  C1_VF(i)  = NaN; elseif(any(temp(44) == 'ABCDEF')) C1_VF(i)  = temp(44)-55; else C1_VF(i)  = str2num(temp(44)); end
                    if(strcmp(temp(45),' '))  C1_PF(i)  = NaN; elseif(any(temp(45) == 'ABCDEF')) C1_PF(i)  = temp(45)-55; else C1_PF(i)  = str2num(temp(45)); end
                    if(strcmp(temp(46),' '))  C1_RF(i)  = NaN; elseif(any(temp(46) == 'ABCDEF')) C1_RF(i)  = temp(46)-55; else C1_RF(i)  = str2num(temp(46)); end
                    if(strcmp(temp(47),' '))  C1_ZNC(i) = NaN; elseif(strcmp(temp(47),'A')) C1_ZNC(i) = 10; else C1_ZNC(i) = str2num(temp(47)); end
                    if(strcmp(temp(48),' '))  C1_WNC(i) = NaN; elseif(strcmp(temp(48),'A')) C1_WNC(i) = 10; else C1_WNC(i) = str2num(temp(48)); end
                    if(strcmp(temp(49),' '))  C1_BNC(i) = NaN; elseif(strcmp(temp(49),'A')) C1_BNC(i) = 10; else C1_BNC(i) = str2num(temp(49)); end
                    if(strcmp(temp(50),' '))  C1_XNC(i) = NaN; elseif(strcmp(temp(50),'A')) C1_XNC(i) = 10; else C1_XNC(i) = str2num(temp(50)); end
                    if(strcmp(temp(51),' '))  C1_YNC(i) = NaN; elseif(strcmp(temp(51),'A')) C1_YNC(i) = 10; else C1_YNC(i) = str2num(temp(51)); end
                    if(strcmp(temp(52),' '))  C1_PNC(i) = NaN; elseif(strcmp(temp(52),'A')) C1_PNC(i) = 10; else C1_PNC(i) = str2num(temp(52)); end
                    if(strcmp(temp(53),' '))  C1_ANC(i) = NaN; elseif(strcmp(temp(53),'A')) C1_ANC(i) = 10; else C1_ANC(i) = str2num(temp(53)); end
                    if(strcmp(temp(54),' '))  C1_GNC(i) = NaN; elseif(strcmp(temp(54),'A')) C1_GNC(i) = 10; else C1_GNC(i) = str2num(temp(54)); end
                    if(strcmp(temp(55),' '))  C1_DNC(i) = NaN; elseif(strcmp(temp(55),'A')) C1_DNC(i) = 10; else C1_DNC(i) = str2num(temp(55)); end
                    if(strcmp(temp(56),' '))  C1_SNC(i) = NaN; elseif(strcmp(temp(56),'A')) C1_SNC(i) = 10; else C1_SNC(i) = str2num(temp(56)); end
                    if(strcmp(temp(57),' '))  C1_CNC(i) = NaN; elseif(strcmp(temp(57),'A')) C1_CNC(i) = 10; else C1_CNC(i) = str2num(temp(57)); end
                    if(strcmp(temp(58),' '))  C1_ENC(i) = NaN; elseif(strcmp(temp(58),'A')) C1_ENC(i) = 10; else C1_ENC(i) = str2num(temp(58)); end
                    if(strcmp(temp(59),' '))  C1_FNC(i) = NaN; elseif(strcmp(temp(59),'A')) C1_FNC(i) = 10; else C1_FNC(i) = str2num(temp(59)); end
                    if(strcmp(temp(60),' '))  C1_TNC(i) = NaN; elseif(strcmp(temp(60),'A')) C1_TNC(i) = 10; else C1_TNC(i) = str2num(temp(60)); end
                    if(strcmp(temp(63),repmat(' ',1,1)))         C1_LZ(i)   = NaN; else C1_LZ(i)   = str2num(temp(63)); end
                    temp(1:65)=[];
                else
                    C1_DCK(i)  = NaN;
                    C1_SID(i)  = NaN;
                    C1_PT(i)   = NaN;
                    C1_DUPS(i) = NaN;
                    C1_DUPC(i) = NaN;
                    C1_TC(i)   = NaN;
                    C1_PB(i)   = NaN;
                    C1_WX(i)   = NaN;
                    C1_SX(i)   = NaN;
                    C1_C2(i,:) = '  ';
                    C1_ND(i)   = NaN;
                    C1_SF(i)   = NaN;
                    C1_AF(i)   = NaN;
                    C1_UF(i)   = NaN;
                    C1_VF(i)   = NaN;
                    C1_PF(i)   = NaN;
                    C1_RF(i)   = NaN;
                    C1_ZNC(i)  = NaN;
                    C1_WNC(i)  = NaN;
                    C1_BNC(i)  = NaN;
                    C1_XNC(i)  = NaN;
                    C1_YNC(i)  = NaN;
                    C1_PNC(i)  = NaN;
                    C1_ANC(i)  = NaN;
                    C1_GNC(i)  = NaN;
                    C1_DNC(i)  = NaN;
                    C1_SNC(i)  = NaN;
                    C1_CNC(i)  = NaN;
                    C1_ENC(i)  = NaN;
                    C1_FNC(i)  = NaN;
                    C1_TNC(i)  = NaN;
                    C1_LZ(i)   = NaN;
                end
            end

            if(isempty(temp) == 0)
                temp_att = str2num(temp(1:2));
                if(temp_att == 5)
                    if(strcmp(temp(55:57),repmat(' ',1,3)))      C5_HDG(i)   = NaN; else C5_HDG(i)   = str2num(temp(55:57)); end
                    if(strcmp(temp(58:60),repmat(' ',1,3)))      C5_COG(i)   = NaN; else C5_COG(i)   = str2num(temp(58:60)); end
                    if(strcmp(temp(61:62),repmat(' ',1,2)))      C5_SOG(i)   = NaN; else C5_SOG(i)   = str2num(temp(61:62)); end
                    if(strcmp(temp(68:70),repmat(' ',1,3)))      C5_RWD(i)   = NaN; else C5_RWD(i)   = str2num(temp(68:70)); end
                    if(strcmp(temp(71:73),repmat(' ',1,3)))      C5_RWS(i)   = NaN; else C5_RWS(i)   = str2num(temp(71:73))/10; end
                    if(strcmp(temp(68:70),repmat(' ',1,3)))      C5_RWD(i)   = NaN; else C5_RWD(i)   = str2num(temp(68:70)); end
                    if(strcmp(temp(82:85),repmat(' ',1,4)))      C5_RH(i)    = NaN; else C5_RH(i)    = str2num(temp(82:85)); end
                    if(strcmp(temp(86),repmat(' ',1,1)))         C5_RHI(i)   = NaN; else C5_RHI(i)   = str2num(temp(86)); end

                    temp(1:94)=[];
                else
                    C5_HDG(i)   = NaN;
                    C5_COG(i)   = NaN;
                    C5_SOG(i)   = NaN;
                    C5_RWD(i)   = NaN;
                    C5_RWS(i)   = NaN;
                    C5_RH(i)    = NaN;
                    C5_RHI(i)   = NaN;
                end
            end

            if(isempty(temp) == 0)
                temp_att = str2num(temp(1:2));
                if(temp_att == 6)
                    temp(1:68)=[];
                else
                end
            end

            if(isempty(temp) == 0)
                temp_att = str2num(temp(1:2));
                if(temp_att == 7)
                    C7_C1M(i,:) = temp(6:7);
                    if(strcmp(temp(8:9),repmat(' ',1,2)))        C7_OPM(i)   = NaN; else C7_OPM(i)   = str2num(temp(8:9)); end
                    C7_KOV(i,:) = temp(10:11);
                    C7_TOT(i,:) = temp(17:19);
                    C7_EOT(i,:) = temp(20:21);
                    C7_SIM(i,:) = temp(27:29);
                    if(strcmp(temp(30:32),repmat(' ',1,3)))      C7_LOV(i)   = NaN; else C7_LOV(i)   = str2num(temp(30:32)); end
                    if(strcmp(temp(33:34),repmat(' ',1,2)))      C7_DOS(i)   = NaN; else C7_DOS(i)   = str2num(temp(33:34)); end
                    if(strcmp(temp(35:37),repmat(' ',1,3)))      C7_HOP(i)   = NaN; else C7_HOP(i)   = str2num(temp(35:37)); end
                    if(strcmp(temp(38:40),repmat(' ',1,3)))      C7_HOT(i)   = NaN; else C7_HOT(i)   = str2num(temp(38:40)); end
                    if(strcmp(temp(41:43),repmat(' ',1,3)))      C7_HOB(i)   = NaN; else C7_HOB(i)   = str2num(temp(41:43)); end
                    if(strcmp(temp(44:46),repmat(' ',1,3)))      C7_HOA(i)   = NaN; else C7_HOA(i)   = str2num(temp(44:46)); end
                    temp(1:58)=[];
                else
                     C7_C1M(i,:) = '  ';
                     C7_OPM(i)   = NaN;
                     C7_KOV(i,:) = '  ';
                     C7_TOT(i,:) = '   ';
                     C7_EOT(i,:) = '  ';
                     C7_SIM(i,:) = '   ';
                     C7_LOV(i)   = NaN;
                     C7_DOS(i)   = NaN;
                     C7_HOP(i)   = NaN;
                     C7_HOT(i)   = NaN;
                     C7_HOB(i)   = NaN;
                     C7_HOA(i)   = NaN;
                end
            end

            if(isempty(temp) == 0)
                temp_att = str2num(temp(1:2));
                if(temp_att == 8)
                    if(strcmp(temp(5:9),repmat(' ',1,5)))        C8_OTV(i)   = NaN; else C8_OTV(i)   = str2num(temp(5:9))/1000; end
                    if(strcmp(temp(10:13),repmat(' ',1,4)))      C8_OTZ(i)   = NaN; else C8_OTZ(i)   = str2num(temp(10:13))/100; end
                    temp(1:102)=[];
                else
                    C8_OTV(i)   = NaN;
                    C8_OTZ(i)   = NaN;
                end
            end

            if(isempty(temp) == 0)
                temp_att = str2num(temp(1:2));
                if(temp_att == 9)
                    if(strcmp(temp(8),repmat(' ',1,1)))         C9_Ne(i)   = NaN; else C9_Ne(i)   = str2num(temp(8)); end
                    if(strcmp(temp(9),repmat(' ',1,1)))         C9_NHe(i)  = NaN; else C9_NHe(i)  = str2num(temp(9)); end
                    if(strcmp(temp(16:18),repmat(' ',1,3)))     C9_AM(i)   = NaN; else C9_AM(i)   = str2num(temp(16:18)); end
                    if(strcmp(temp(19:21),repmat(' ',1,3)))     C9_AH(i)   = NaN; else C9_AH(i)   = str2num(temp(19:21)); end
                    if(strcmp(temp(29:32),repmat(' ',1,4)))     C9_RI(i)   = NaN; else C9_RI(i)   = str2num(temp(29:32)); end
                    temp(1:32)=[];
                else
                    C9_Ne(i)   = NaN;
                    C9_NHe(i)  = NaN;
                    C9_AM(i)   = NaN;
                    C9_AH(i)   = NaN;
                    C9_RI(i)   = NaN;
                end
            end

            if(isempty(temp) == 0)
                temp_att = str2num(temp(1:2));
                if(temp_att == 95)
                    temp(1:61)=[];
                else
                end
            end

            if(isempty(temp) == 0)
                temp_att = str2num(temp(1:2));
                if(temp_att == 96)
                    temp(1:53)=[];
                else
                end
            end

            if(isempty(temp) == 0)
                temp_att = str2num(temp(1:2));
                if(temp_att == 97)
                    temp(1:32)=[];
                else
                end
            end

            if(isempty(temp) == 0)
                temp_att = str2num(temp(1:2));
                if(temp_att == 98)
                    clear('C98_temp')
                    C98_temp = temp(5:10);
                    if(strcmp(C98_temp,'      ')==0)
                        C98_temp = C98_temp - '0';
                        C98_temp(C98_temp>9) = C98_temp(C98_temp>9)-7;
                        C98_UID(i) = C98_temp(1)*36^5 + C98_temp(2)*36^4 + C98_temp(3)*36^3 + C98_temp(4)*36^2 + C98_temp(5)*36 + C98_temp(6);
                    else
                        C98_UID(i) = NaN;
                    end
                    if(strcmp(temp(15),repmat(' ',1,1)))      C98_IRF(i)   = NaN; else C98_IRF(i)   = str2num(temp(15)); end
                    temp(1:15)=[];
                else
                    C98_UID(i) = NaN;
                    C98_IRF(i) = NaN;
                end
            end
        end

        clear('words','num','fid','i','ans','C98_temp','temp','temp_att','file_load');
        save([file_save],'-v7.3');
    else
        disp([file_load ,' does not exist!']);
    end
    disp([file_save ,' is finished!']);
    disp([' ']);
end
