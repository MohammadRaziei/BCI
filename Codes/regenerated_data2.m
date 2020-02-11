clear;clc;close all;
load('regenerated_data.mat')


[b,a] =  butter(5,[0.5*2/fs, 200*2/fs],'bandpass');
data = filtfilt(b,a,data);


data_diff = diff(data)*fs;
data_diff = ( data_diff - mean(data_diff) );
t_diff = t(2:end);

% [Pdata,Wdata] = pwelch(data_diff);
% loglog(Wdata,Pdata);
% 
% [Pdata,Wdata] = pwelch(data);
% loglog(Wdata,Pdata);

NumTrial = size(timestamp_seconds,1);
trial_samps = 2*fs+1;
EEG_listening = zeros([trial_samps ,size(data,2), NumTrial]);
EEG_thinking = zeros([trial_samps ,size(data,2), NumTrial]);
EEG_talking = zeros([trial_samps ,size(data,2), NumTrial]);

EEG_noTask = data(1:floor(fs * timestamp_seconds(1) ),:);
EEG_noTask_diff = data_diff(1:floor(fs * timestamp_seconds(1) ),:);
% timestamp_seconds2 = timestamp_seconds -  timestamp_seconds(1);
% EEG_listening = data_diff(timesInterval(timestamp_seconds(:,1), timestamp_seconds(:,2), fs),:);
% EEG_thinking = data_diff(timesInterval(timestamp_seconds(:,2), timestamp_seconds(:,3), fs),:);
% EEG_talking = data_diff(timesInterval(timestamp_seconds(:,3), timestamp_seconds(:,4), fs),:);

for i = 1:NumTrial
    time_listening = timestamp_seconds(i, 1);
    EEG_listening(:,:,i) = data(time_listening*fs : (time_listening + 2)*fs,:);
    EEG_listening_diff(:,:,i) = data_diff(time_listening*fs : (time_listening + 2)*fs,:);
    time_thinking = timestamp_seconds(i, 2);
    EEG_thinking(:,:,i) = data(time_thinking*fs : (time_thinking + 2)*fs,:);
    EEG_thinking_diff(:,:,i) = data_diff(time_thinking*fs : (time_thinking + 2)*fs,:);
    time_talking = timestamp_seconds(i, 3);
    EEG_talking(:,:,i) = data(time_talking*fs : (time_talking + 2)*fs,:);   
    EEG_talking_diff(:,:,i) = data_diff(time_talking*fs : (time_talking + 2)*fs,:);   
end


save('regenerated_data2.mat', ...
    'fs', 't', 't_diff', 'NumTrial', 'trial_samps', ...
    'EEG_noTask', 'EEG_noTask_diff', ...
    'EEG_listening', 'EEG_listening_diff', ...
    'EEG_thinking', 'EEG_thinking_diff', ...
    'EEG_talking', 'EEG_talking_diff', ...
    'order_label', 'word_label', 'task_order', 'timestamp_seconds')
