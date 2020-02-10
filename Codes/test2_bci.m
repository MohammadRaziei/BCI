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
[t0,t1] = timesInterval(timestamp_seconds(:,1), timestamp_seconds(:,2), fs, order_label-1);
EEG_listening0 = data_diff(t0,:);
EEG_listening1 = data_diff(t1,:);
[t0,t1] = timesInterval(timestamp_seconds(:,2), timestamp_seconds(:,3), fs, order_label-1);
EEG_thinking0 = data_diff(t0,:);
EEG_thinking1 = data_diff(t1,:);
[t0,t1] = timesInterval(timestamp_seconds(:,3), timestamp_seconds(:,4), fs, order_label-1);
EEG_talking0 = data_diff(t0,:);
EEG_talking1 = data_diff(t1,:);

%% Ploting Separated Tasks in Time Domain
figure;
subplot(4,2,[1 2]); plot(EEG_noTask); title('Taskless EEG');
subplot(423); plot(EEG_listening0); title('Listening EEG 0');
subplot(425); plot(EEG_thinking); title('Thinking EEG 0');
subplot(427); plot(EEG_talking0); title('Talking EEG 0');

subplot(424); plot(EEG_listening1); title('Listening EEG 1');
subplot(426); plot(EEG_thinking1); title('Thinking EEG 1');
subplot(428); plot(EEG_talking1); title('Talking EEG 1');
%% Separating Tasks in Freq Domain
[P_EEG_noTask, W_EEG_noTask] = pwelch(EEG_noTask);
[P_EEG_listening0, W_EEG_listening0] = pwelch(EEG_listening0);
[P_EEG_thinking0, W_EEG_thinking0] = pwelch(EEG_thinking0);
[P_EEG_talking0, W_EEG_talking0] = pwelch(EEG_talking0);

[P_EEG_listening1, W_EEG_listening1] = pwelch(EEG_listening1);
[P_EEG_thinking1, W_EEG_thinking1] = pwelch(EEG_thinking1);
[P_EEG_talking1, W_EEG_talking1] = pwelch(EEG_talking1);
%% Ploting Separated Tasks in Freq Domain
figure;
subplot(2,4,[1,5]); semilogy(W_EEG_noTask / pi, P_EEG_noTask); title('Taskless EEG');
subplot(242); semilogy(W_EEG_listening0 / pi, P_EEG_listening0); title('Listening EEG 0');
subplot(243); semilogy(W_EEG_thinking0 / pi, P_EEG_thinking0); title('Thinking EEG 0');
subplot(244); semilogy(W_EEG_talking0 / pi, P_EEG_talking0); title('Talking EEG 0');

subplot(246); semilogy(W_EEG_listening1 / pi, P_EEG_listening1); title('Listening EEG 1');
subplot(247); semilogy(W_EEG_thinking1 / pi, P_EEG_thinking1); title('Thinking EEG 1');
subplot(248); semilogy(W_EEG_talking1 / pi, P_EEG_talking1); title('Talking EEG 1');
% subplot(411);pwelch(EEG_noTask);
% subplot(412);pwelch(EEG_listening);
% subplot(413);pwelch(EEG_thinking);
% subplot(414);pwelch(EEG_talking);
%% 
