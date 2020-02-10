function out = myFeatureSelection(P_EEG,len)
%     size(squeeze(P_EEG))
%     [coeff,score,latent] = pca(squeeze(P_EEG));
% %     plot(latent,'o')
%     k = sum(latent > 0.01*max(latent));
%     out = score(1:k,:);
out = zeros(len, size(P_EEG,2), size(P_EEG,3));
for i = 1:size(P_EEG,3)
    [~,s,~] = pca(P_EEG(:,:,i)','NumComponents',len); 
    out(:,:,i) = s';
end

end