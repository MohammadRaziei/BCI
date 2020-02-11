clear;clc;close all;
load('regenerated_data2.mat')
%%
% listnq0=fft(EEG_listening,'',1);
% memor0=fft(EEG_thinking_diff,'',3);
% %%
% 
% 
% mainLobe = 4;
% gaurd = 5;
% 
% filt = [-1/(2*gaurd)*ones(1,gaurd) 1/mainLobe*ones(1,mainLobe) -1/(2*gaurd)*ones(1,gaurd)];
% 
% freqz(filt,1)
% 
% 
% plot((0:1000)/fs, filter(filt,1,listnq0(:,:,1)))
%  
%  
% [coeff,score,latent] = pca([abs(memor0), angle(memor0)]);

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

[ref,~] = resamp(P_noTask,W_noTask,0.0157);% 0.0157 ,0.01825
% [ref,~] = resamp(P_noTask,W_noTask,0.01825);% 0.0157 ,0.01825
ref = smooth2D(ref);
ref = repmat(ref,1,1,20);
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

% listening = log(abs(listening));
% thinking = log(abs(thinking));
% talking = log(abs(talking));


%%
idx0 = find(order_label == 1);
idx1 = find(order_label == 2);
% fitures0 = [myFeatureSelection(thinking(:,:,idx0),8); myFeatureSelection(listening(:,:,idx0),8); myFeatureSelection(talking(:,:,idx0),8)];
% fitures1 = [myFeatureSelection(thinking(:,:,idx1),8); myFeatureSelection(listening(:,:,idx1),8); myFeatureSelection(talking(:,:,idx1),8)];


%%
% chan1 = 1; chan2 = 5;

% % onvecs2=zeros(135,135);
% % for chan1=1:135
% %     for chan2=1:135
% %         train_X=[squeeze(fitures0(:,chan1,:)),squeeze(fitures1(:,chan2,:))]';
% % %         X = log(abs(X));
% %         mdl=fitcsvm(train_X,order_label);%,'Standardize',true);
% % %         mdlSVM = fitPosterior(mdlSVM);
% % %         [c,score_svm] = resubPredict(mdlSVM);
% % %         [Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(order_label,score_svm(:,mdlSVM.ClassNames),'true');
% % 
% %         onvecs2(chan1,chan2)=sum(mdl.IsSupportVector);
% %     end
% % end
% % 
% % min1=min(min(onvecs2))
% % [i,j]=find(onvecs2==min1)

% save onvecs2 onvecs2
% i =
%     51
%     28
%      1
% 
% 
% j =
%     34
%     35
%     89

% log(abs(X))
% i =
% 
%     27
%     49
% 
% j =
%     91
%    101
%%
reshapeTrial = @(a) reshape(permute(a,[2,1,3]),size(a,1)*size(a,2),size(a,3))';

Nfit = 5;
fitures = [myFeatureSelection(thinking,Nfit)];%; myFeatureSelection(listening,Nfit); myFeatureSelection(talking,Nfit)];
% fitures = [(abs(fitures)); (angle(fitures))];
fitures = reshapeTrial(fitures);

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
    [~,idx] = sort(mdl.Beta);
    channel(:,i) = idx;%ceil(idx/(Nfit*2));
end

sum(pred)/20
B = mean(beta,2);
[B,idx]=sort(B);
channel2 = ceil(channel/(Nfit*1));
%%

% chan1 = 51;chan2 = 34;
% train_X=[squeeze(fitures0(:,chan1,:)),squeeze(fitures1(:,chan2,:))]';
% %     
% mdl=fitcsvm(train_X,order_label,'Standardize',true);
% 
% %         mdlSVM = fitPosterior(mdlSVM);
% %         [c,score_svm] = resubPredict(mdl);
% %         [Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(order_label,score_svm(:,mdlSVM.ClassNames),'true');
% sum(mdl.IsSupportVector);

% mdl = fitglm(X./max(X),order_label, 'Distribution','binomial');
% score_log = mdl.Fitted.Probability; % Probability estimates

%%
channels = unique(channel2(1:50,:));

fitures = [myFeatureSelection(thinking,Nfit)];
fitures = fitures(:,channels,:);
fitures = [(abs(fitures)); (angle(fitures))];
fitures = reshapeTrial(fitures);


pred = zeros(20,1);
for i = 1:20
    train_X = fitures; train_Y = order_label;
    train_X(i,:) = []; train_Y(i,:) = [];
    test_X = fitures(i,:); test_Y = order_label(i,:);
    mdl=fitcsvm(train_X, train_Y,'Standardize',true);
    [label,score] = predict(mdl,test_X);
    pred(i) = (label == test_Y);
    beta2(:,i) = mdl.Beta;
    [~,idx] = sort(mdl.Beta);
    channel3(:,i) = idx;%ceil(idx/(Nfit*2));
end

sum(pred)/20
B = mean(beta2,2);
[B,idx]=sort(B);
channel4 = ceil(channel3/(Nfit*1));





