clear;clc;close all;
addpath('..\sEEG Data')
load('Data_Memory_Subject3_Block3_sEEG.mat');
load('Data_Memory_Subject3_Block3_parameters.mat');
load('Data_Memory_Subject3_Block3_timestamps.mat')

%%play audio:
% sound(vec2mat(SP_audioSignalMatrix,1),44100)
fs = 500;
data(:,[56, 57, 58, 59]) = [];
data = data - mean(data,1);

t = (0:length(data)-1)/fs;

all_task_orders = zeros(10,2,2);
all_task_orders(:,:,1) = SP_task_order_1;
all_task_orders(:,:,2) = SP_task_order_2;
all_word_labels = cell(1,2);
all_word_labels{1} = SP_selected_word_labels_1;
all_word_labels{2} = SP_selected_word_labels_2;

task_order = zeros(20,2);
word_label = cell(20,2);
order_label = zeros(10,1);
c = [0,0];
for i=1:length(SP_condition_order)
    order = SP_condition_order(i)+1;
    c = c + [order==1,order==2];
    order_label(i) = order;
    task_order(i,:) = all_task_orders(c(order),:,order);
    word_label{i,1} = all_word_labels{order}{task_order(i,1)};
    word_label{i,2} = all_word_labels{order}{task_order(i,2)};
end

save('regenerated_data.mat', 'data','fs', 't', 'order_label', 'word_label', 'task_order', 'timestamp_seconds')

