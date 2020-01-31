clear;clc;close all;
addpath('..\sEEG Data')
load('Data_Memory_Subject3_Block3_sEEG.mat');
load('Data_Memory_Subject3_Block3_parameters.mat');
load('Data_Memory_Subject3_Block3_timestamps.mat')

Data = data(:,1:5)-mean(data(:,1:5),1);
Tt = (SP_timestampMatrix(end,5) - SP_timestampMatrix(1,5) )*60 + ...
    (SP_timestampMatrix(end,6) - SP_timestampMatrix(1,6) );

x_label = (1:length(data))/length(data) * Tt;
T_label = (SP_timestampMatrix(:,5)-SP_timestampMatrix(1,5) )*60 + ...
    (SP_timestampMatrix(:,6) - SP_timestampMatrix(1,6) );
TStam = timestamp_seconds - timestamp_seconds(1,1);
[pxx,w] = pwelch(Data(:,2));
Fs = length(data) / Tt;
figure;plot(x_label,Data)
Fs = 500;
Fc = 0.2*Fs/2;
% y = ammod(Data(:,2),Fc,Fs);
figure;loglog(w/pi,pxx);
hold on;
fn = 10^(-3.5)./w.^2*mean(pxx);
loglog(w/pi,fn)
figure
y = Data(:,2);
% y = diff(diff(y));
y = ifft(pxx-fn);
plot(y);
figure;
pwelch(y);
[b,a] =  butter(5,[10*2/Fs, 200*2/Fs],'bandpass');
y = filtfilt(b,a,y);
wo = 0.200;
bw = wo / 55;
[b,a] = iirnotch(wo,bw);
y = filtfilt(b,a,y);
wo = 0.6;
[b,a] = iirnotch(wo,bw*1.5);
y = filtfilt(b,a,y);

figure; plot(y)
figure; pwelch(y)
% plot(x_label,y)
%%
% y = exp(2i*pi*Fc*x_label)*Data(:,2);
% plot(x_label,abs(y));
figure;spectrogram(y)
level = 6;
wpt = wpdec(y,level,'sym6');
figure;
[S,T,F] = wpspectrum(wpt,Fs,'plot');

%%




