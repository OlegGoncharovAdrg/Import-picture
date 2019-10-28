clear; close all; clc;

instrreset
oldobjs = instrfind;
if (~isempty(oldobjs))
       fclose(oldobjs);   
    delete(oldobjs);
end
clear oldobjs;
fieldFox = visa('agilent', 'TCPIP0::192.168.0.1::inst0::INSTR');
set(fieldFox,'InputBufferSize', 640000);
set(fieldFox,'OutputBufferSize', 640000);
fopen(fieldFox);
fprintf(fieldFox, '*CLS');
fprintf(fieldFox, 'SYST:ERR?');
[errIdentifyStart,~] = fscanf(fieldFox, '%c');
['Initial error check results: ', errIdentifyStart]
fprintf(fieldFox, '*IDN?');
[idn,~] = fscanf(fieldFox, '%c');
['Instrument identified as: ', idn]
fprintf(fieldFox, 'MMEM:CDIR "[INTERNAL]:"');
fprintf(fieldFox, 'MMEM:STOR:IMAG "TestImage.png"');
fprintf(fieldFox, 'MMEM:DATA? "TestImage.png"');
screenPNG = binblockread(fieldFox,'uint8'); fread(fieldFox,1);
fid = fopen('C:\Temp\TransferedTestImage.jpg','w');
fwrite(fid,screenPNG,'uint8');
fclose(fid);
fprintf(fieldFox, 'SYST:ERR?');
[errIdentifyStop,~] = fscanf(fieldFox, '%c');
['Final error check results: ', errIdentifyStop]
fclose(fieldFox);
delete(fieldFox);
clear fieldFox;