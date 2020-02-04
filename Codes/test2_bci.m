clear;clc;close all;
load('regenerated_data.mat')

% plot(data)


% pwelch(data)

% % f_Noise = 0.2*fs/2;
% % Noise = 1*cos(2*pi*f_Noise*t + 2*pi*rand)';

% % rlsFilt = dsp.RLSFilter(10);
% [y,e] = rlsFilt(Noise,d);

% pwelch([d,e])
%%
% A = (mean(diff(d)))*pi;


% % clf
% % Noise_pink = [zeros(1,size(data,2));0.008*ones(size(data,1)-1,size(data,2))];
% % data_DN = data - Noise_pink;
% d = data_DN(:,1);
% diff


% d = data_diff(:,1);
% [pdd,w] = pwelch(d);
% semilogy(w,abs(pdd),'k');




[b,a] =  butter(5,[10*2/fs, 200*2/fs],'bandpass');
data = filtfilt(b,a,data);
wo = 0.2;
bw = wo / 55;
[b,a] = iirnotch(wo,bw);
data = filtfilt(b,a,data);
wo = 0.6;
[b,a] = iirnotch(wo,bw*1.5);
data = filtfilt(b,a,data);




data_diff = diff(data)*fs;
data_diff = ( data_diff - mean(data_diff) );
t_diff = t(2:end);
%%  
[pdd,w] = pwelch( data_diff(:,100) );
semilogy(w,abs(pdd),'k');


% rlsFilt = dsp.RLSFilter(10);
% [y,e] = rlsFilt(Noise,d);
% % pwelch([d,e])
% [pee,w] = pwelch(e);
% % loglog(w,abs(pee),'k');
% [b,a] = butter(5,[4*2/fs,40*2/fs],'bandpass');


% A = 10*mean(diff(d))/mean(diff(s));
% A = 0.008;
% [pss,w] = pwelch(s*A);
% loglog(w,abs(pss),'y');hold on
% [pdd,w] = pwelch(d);
% loglog(w,abs(pdd),'k');
%% Separating Tasks in Time Domain
EEG_noTask = data_diff(1:floor(fs * timestamp_seconds(1) ),:);
% timestamp_seconds2 = timestamp_seconds -  timestamp_seconds(1);
EEG_listening = data_diff(timesInterval(timestamp_seconds(:,1), timestamp_seconds(:,2), fs),:);
EEG_thinking = data_diff(timesInterval(timestamp_seconds(:,2), timestamp_seconds(:,3), fs),:);
EEG_talking = data_diff(timesInterval(timestamp_seconds(:,3), timestamp_seconds(:,4), fs),:);
%% Ploting Separated Tasks in Time Domain
figure;
subplot(141); plot(EEG_noTask); title('Taskless EEG');
subplot(142); plot(EEG_listening); title('Listening EEG');
subplot(143); plot(EEG_thinking); title('Thinking EEG');
subplot(144); plot(EEG_talking); title('Talking EEG');

%% Separating Tasks in Freq Domain
[P_EEG_noTask, W_EEG_noTask] = pwelch(EEG_noTask);
[P_EEG_listening, W_EEG_listening] = pwelch(EEG_listening);
[P_EEG_thinking, W_EEG_thinking] = pwelch(EEG_thinking);
[P_EEG_talking, W_EEG_talking] = pwelch(EEG_talking);
%% Ploting Separated Tasks in Freq Domain
figure;
subplot(141); semilogy(W_EEG_noTask / pi, P_EEG_noTask); title('Taskless EEG');
subplot(142); semilogy(W_EEG_listening / pi, P_EEG_listening); title('Listening EEG');
subplot(143); semilogy(W_EEG_thinking / pi, P_EEG_thinking); title('Thinking EEG');
subplot(144); semilogy(W_EEG_talking / pi, P_EEG_talking); title('Talking EEG');
% subplot(411);pwelch(EEG_noTask);
% subplot(412);pwelch(EEG_listening);
% subplot(413);pwelch(EEG_thinking);
% subplot(414);pwelch(EEG_talking);



