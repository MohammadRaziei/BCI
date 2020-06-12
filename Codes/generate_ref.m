EEG_noTask_sliced = zeros(1001,135, floor(size(EEG_noTask,1)/1001));
for i = 0:size(EEG_noTask_sliced,3)-1
    start = (i*1001+1);
    EEG_noTask_sliced(:,:,i+1) = EEG_noTask(start:(start+1000),:);
end

[P_noTask_sliced,W_noTask_sliced] = pwelchTrial(EEG_noTask_sliced);

P_noTask_mean = mean(P_noTask_sliced, 3);

P_noTask_tel = zeros(size(P_noTask_sliced,1),135,size(P_noTask_sliced,3)-1);

for i = 1:size(P_noTask_tel,3)
    P_noTask_tel(:,:,i) = P_noTask_sliced(:,:,i) ./ P_noTask_sliced(:,:,i+1);    
end

P_noTask_tel_mean = mean(P_noTask_tel, 3);
%%
randIdx0 = randperm( floor(size(EEG_noTask,1)/1001) );
randIdx1 = randIdx0(1:20);
randIdx2 = randIdx0(end-19:end);

x_sliced = P_noTask_sliced(:,:,randIdx1);
d_sliced = P_noTask_sliced(:,:,randIdx2);

x = mean(x_sliced,3);
d = mean(d_sliced,3);

%%
% rlsFilt = dsp.RLSFilter(13);
% [

% P_noTask_ref = P_noTask_mean ./ P_noTask_tel_mean;

%% plot
figure;
subplot(311); semilogy(P_noTask_ref) i
subplot(312); semilogy(smooth2D(P_noTask_mean1)-smooth2D(P_noTask_mean2))
subplot(313); semilogy(P_noTask_mean2)
%% save
% save('noTask_ref.mat', 'P_noTask_ref');