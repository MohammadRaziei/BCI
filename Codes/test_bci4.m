clear;clc;close all;
load('regenerated_data2.mat')
%%
% [P_noTask, W_noTask] = pwelch(EEG_noTask_diff);
% [P_listening,W_listening] = pwelchTrial(EEG_listening_diff);
% [P_thinking,W_thinking] = pwelchTrial(EEG_thinking_diff);
% [P_talking,W_talking] = pwelchTrial(EEG_talking_diff);

[P_noTask, W_noTask] = pwelch(EEG_noTask);
[P_listening,W_listening] = pwelchTrial(EEG_listening);
[P_thinking,W_thinking] = pwelchTrial(EEG_thinking);
[P_talking,W_talking] = pwelchTrial(EEG_talking);

% P_noTask = fft(EEG_noTask,[],1); W_noTask = linspace(0,pi,size(P_noTask,1));
% P_listening = fft(EEG_listening,[],1);
% P_thinking = fft(EEG_thinking,[],1);
% P_talking = fft(EEG_talking,[],1);

%%
resamp = @(x,tx,a) resample(x,tx,a/(tx(2)-tx(1)),'linear',1,1); % 'linear', 'spline', 'pchip'

listening = P_listening;
thinking = P_thinking;
talking = P_talking;

[ref0,w_ref] = resamp(P_noTask,W_noTask,0.0157);% 0.0157 ,0.01825
% [ref,W_noTask] = resamp(P_noTask,W_noTask,0.01825);% 0.0157 ,0.01825
ref1 = smooth2D(ref0);
ref = repmat(ref1,1,1,20);
listening = listening ./ ref;
thinking = thinking ./ ref;
talking = talking ./ ref;

F_cutoff = 45;
F_cuton = 5;
Narr = size(P_listening,1);
cutoff = floor(F_cutoff * 2 / fs * Narr);
cuton = ceil(F_cuton * 2 / fs * Narr);
listening = listening(cuton:cutoff,:,:);
thinking = thinking(cuton:cutoff,:,:);
talking = talking(cuton:cutoff,:,:);


%%
idx0 = find(order_label == 1);
idx1 = find(order_label == 2);

%%
reshapeTrial = @(a) reshape(permute(a,[2,1,3]),size(a,1)*size(a,2),size(a,3))';

Nfit = 5;
fitures0 = [myFeatureSelection(thinking,Nfit)];%; myFeatureSelection(listening,Nfit); myFeatureSelection(talking,Nfit)];
% fitures = [(abs(fitures)); 15*(angle(fitures)-pi/2)];
fitures = reshapeTrial(fitures0);

%%
pred = zeros(20,1);
for i = 1:20
    train_X = fitures; train_Y = order_label;
    train_X(i,:) = []; train_Y(i,:) = [];
    test_X = fitures(i,:); test_Y = order_label(i,:);
    mdl=fitcsvm(train_X, train_Y,'Standardize',true);
    [label,score] = predict(mdl,test_X);
    pred(i) = (label == test_Y);
    beta(:,i) = mdl.Beta;
    [~,idx] = sort(abs(mdl.Beta));
    channel(:,i) = idx;%ceil(idx/(Nfit*2));
end

sum(pred)/20
B = mean(beta,2);
[B,idx]=sort(abs(B));
channel2 = ceil(channel/(Nfit*1));

%%
channels = unique(channel2(end-8:end,:));
% channels = unique(channel2(1:8,:));
%%
fitures2 = fitures0(:,channels,:);
fitures = [(abs(fitures2)); 15*(angle(fitures2))];
fitures = reshapeTrial(fitures);
%%

pred2 = zeros(20,1);
for i = 1:20
    train_X = fitures; train_Y = order_label;
    train_X(i,:) = []; train_Y(i,:) = [];
    test_X = fitures(i,:); test_Y = order_label(i,:);
    mdl=fitcsvm(train_X, train_Y,'Standardize',true);
    [label,score] = predict(mdl,test_X);
    pred2(i) = (label == test_Y);
    beta2(:,i) = mdl.Beta;
    [~,idx] = sort(mdl.Beta);
    channel3(:,i) = idx;%ceil(idx/(Nfit*2));
end

sum(pred2)/20
B = mean(beta2,2);
[B,idx]=sort(abs(B));
channel4 = ceil(channel3/(Nfit*2));


%%
% channels = unique(channel4(end-50:end,:));
% channels = unique(channel2(1:100,:));
%%
% fitures = fitures2(:,channels,:);
% % fitures = [(abs(fitures)); 15*(angle(fitures))];
% fitures = reshapeTrial(fitures);
% 
% 
% pred = zeros(20,1);
% for i = 1:20
%     train_X = fitures; train_Y = order_label;
%     train_X(i,:) = []; train_Y(i,:) = [];
%     test_X = fitures(i,:); test_Y = order_label(i,:);
%     mdl=fitcsvm(train_X, train_Y,'Standardize',true);
%     [label,score] = predict(mdl,test_X);
%     pred(i) = (label == test_Y);
%     beta3(:,i) = mdl.Beta;
%     [~,idx] = sort(mdl.Beta);
%     channel5(:,i) = idx;%ceil(idx/(Nfit*2));
% end
% 
% sum(pred)/20
% B = mean(beta3,2);
% [B,idx]=sort(abs(B));
% channel6 = ceil(channel5/(Nfit*2));

