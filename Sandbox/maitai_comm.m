%function maitai_comm(varargin)
clear all
delete(instrfindall)
clc


%%
% make a structure with fields
% human readable fieldname
% serial command
% returned value
% numerical value
% probe all these from the maitai and show them in some sort of realtime
% way, while doing the startup procedure

field_nr=1;
maitai=struct('fieldName','','serialCommand','','returnedFormat','%s','returnedValue','','numericalValue',[]);

% maitai(field_nr).fieldName='Identification';
% maitai(field_nr).serialCommand='*IDN?';
% maitai(field_nr).returnedFormat='%s';
% maitai(field_nr).returnedValue='';
% maitai(field_nr).numericalValue=[];
% field_nr=field_nr+1;

% maitai(field_nr).fieldName='Product Status Byte';
% maitai(field_nr).serialCommand='*STB?';
% maitai(field_nr).returnedFormat='%f';
% field_nr=field_nr+1;


maitai(field_nr).fieldName='Percentage Warmed Up';
maitai(field_nr).serialCommand='READ:PCTWarmedup?';
maitai(field_nr).returnedFormat='%f%%';
field_nr=field_nr+1;

% maitai(field_nr).fieldName='Current Mode';
% maitai(field_nr).serialCommand='MODE?';
% maitai(field_nr).returnedFormat='%s';
% field_nr=field_nr+1;

maitai(field_nr).fieldName='Current Power';
maitai(field_nr).serialCommand='POW?';
maitai(field_nr).returnedFormat='%fW';
field_nr=field_nr+1;

maitai(field_nr).fieldName='Pump Laser Power';
maitai(field_nr).serialCommand='READ:PLASER:POWER?';
maitai(field_nr).returnedFormat='%fW';
field_nr=field_nr+1;

maitai(field_nr).fieldName='Pump Laser Current';
maitai(field_nr).serialCommand='READ:PLASER:PCURRENT?';
maitai(field_nr).returnedFormat='%f%%';
field_nr=field_nr+1;

% maitai(field_nr).fieldName='Pump Laser SHG status';
% maitai(field_nr).serialCommand='READ:PLASER:SHGSTATUS?';
% maitai(field_nr).returnedFormat='%f';
% field_nr=field_nr+1;
% maitai(field_nr).fieldName='Mai-Tai Serial Number';
% maitai(field_nr).serialCommand='READ:PLASER:SNUM?';
% maitai(field_nr).returnedFormat='%s';
% field_nr=field_nr+1;

for diode_nr=1:2
    maitai(field_nr).fieldName=['Diode ' num2str(diode_nr) ' Current'];
    maitai(field_nr).serialCommand=['READ:PLASER:DIODE' num2str(diode_nr) ':CURRENT?'];
    maitai(field_nr).returnedFormat='%fA1';
    field_nr=field_nr+1;
    maitai(field_nr).fieldName=['Diode ' num2str(diode_nr) ' Temperature'];
    maitai(field_nr).serialCommand=['READ:PLASER:DIODE' num2str(diode_nr) ':TEMPERATURE?'];
    maitai(field_nr).returnedFormat='%fC1';
    field_nr=field_nr+1;
%     maitai(field_nr).fieldName=['Diode ' num2str(diode_nr) ' Hours'];
%     maitai(field_nr).serialCommand=['READ:PLASER:DIODE' num2str(diode_nr) ':HOURS?'];
%     maitai(field_nr).returnedFormat='%fH1';
%     field_nr=field_nr+1;
%     maitai(field_nr).fieldName=['Diode ' num2str(diode_nr) ' Serial Number'];
%     maitai(field_nr).serialCommand=['READ:PLASER:DIODE' num2str(diode_nr) ':SNUM??'];
%     maitai(field_nr).returnedFormat='%s';
%     field_nr=field_nr+1;
end


maitai(field_nr).fieldName='Shutter';
maitai(field_nr).serialCommand='SHUTTER?';
maitai(field_nr).returnedFormat='%f';
field_nr=field_nr+1;

maitai(field_nr).fieldName='Body Temperature';
maitai(field_nr).serialCommand='READ:TEMPerature:BODY?';
maitai(field_nr).returnedFormat='%fCb';
field_nr=field_nr+1;

maitai(field_nr).fieldName='Control Temperature';
maitai(field_nr).serialCommand='READ:TEMPerature:CONTROL?';
maitai(field_nr).returnedFormat='%fCb';
field_nr=field_nr+1;

maitai(field_nr).fieldName='RF Temperature';
maitai(field_nr).serialCommand='READ:TEMPerature:RF?';
maitai(field_nr).returnedFormat='%fCb';
field_nr=field_nr+1;

maitai(field_nr).fieldName='Tower Temperature';
maitai(field_nr).serialCommand='READ:TEMPerature:TOWER?';
maitai(field_nr).returnedFormat='%fCb';
field_nr=field_nr+1;

% maitai(field_nr).fieldName='Bandwidth';
% maitai(field_nr).serialCommand='BANDwidth?';
% maitai(field_nr).returnedFormat='%fnm';
% field_nr=field_nr+1;

maitai(field_nr).fieldName='Wavelength';
maitai(field_nr).serialCommand='READ:WAV?';
maitai(field_nr).returnedFormat='%fnm';
field_nr=field_nr+1;

maitai(field_nr).fieldName='Humidity';
%maitai(field_nr).serialCommand='READ:HUMIDITY?';
maitai(field_nr).serialCommand='READ:HUM?';
maitai(field_nr).returnedFormat='%f HUM';
field_nr=field_nr+1;

maitai(field_nr).fieldName='Current IR Power';
%maitai(field_nr).serialCommand='READ:IRPOWER?';
maitai(field_nr).serialCommand='READ:POWER?';
maitai(field_nr).returnedFormat='%f';
field_nr=field_nr+1;


%msg='*IDN?';

%msg='ON';
% msg='READ:PCTWarmedup?'; % if 100% advance
%msg='ON'; % emission!
%msg='SHUTTER 1';

%msg='SHUTTER 0';
%msg='OFF';

%% Set up and connect Comm

s=serial('COM4');
s.name='MaiTai';
s.BaudRate=38400;
s.FlowControl='none';
s.Terminator='LF';
s.Timeout=2;

fopen(s);

%% Issue startup command
%fprintf(s,'ON');

%%
f = figure(1);
d = gallery('integerdata',100,[10 3],0);
t = uitable(f,'Units','Normalized','Position',[.05 .05 .9 .9],'Data',d,'ColumnWidth',{250 200});
handles.maitai=rmfield(maitai,{'serialCommand','returnedFormat','numericalValue'});
guidata(f,handles)
writeSummaryTable(t,'maitai')

%% Monitor progress
for iField=1:length(maitai)
    command=maitai(iField).serialCommand;
    fprintf(s,command);
    if strfind(command,'?')
        res=fscanf(s,'%c');
        maitai(iField).returnedValue=res(1:end-1);
        %maitai(iField).numericalValue=str2double(res(1:end-2));
        if strcmpi(maitai(iField).returnedFormat,'%s')
            maitai(iField).numericalValue=NaN;
        else
            maitai(iField).numericalValue=sscanf(res,maitai(iField).returnedFormat);           
        end
    end
end

%cat(1,maitai.numericalValue)
handles.maitai=rmfield(maitai,{'serialCommand','returnedFormat','numericalValue'});
guidata(f,handles)
writeSummaryTable(t,'maitai')
% needs to be refreshed every 'watchdog time' seconds to stay active
% disable using TIMer:WATChdog (n)
% need to get our hands on current IR power

%%
%fprintf(s,'SHUTTER 1')
%fprintf(s,'OFF');
%fclose(s);

%%% to startup in calibration mode
% set WAVE 730.0
% set MODE PPOWER
% set PLASER:POWER 7.3
% go back using
% set MODE POWER
% set WAVE 920.0

