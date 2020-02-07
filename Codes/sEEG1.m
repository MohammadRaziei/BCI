%In the name of God
%sEEG Analysis
% x=data;
% tims=timestamp_seconds;
% timn=floor(tims*500);
% avg=mean(x);
% x2=x-avg;
% y=fft(x2);
% 
% y2=y;
% y2([1:180,14501:165500,179821:180000],:)=0;  % removing (0~0.5)Hz & (f>40.27Hz) frequency bands
% x3=ifft(y2,'symmetric');
% x3(:,[56,57,58,59])=[];
% x4=x3(timn(1):timn(end),:);
% avg=mean(x4');                             % refrencing to average of all channels  
% %std1=std(x4);
% x5=(x4-avg');
% D=1140;
% listn=zeros(20,135,D);
% timn=timn-timn(1)+1;
% for i=1:20
%     i
%     listn(i,:,1:D)=x5(timn(i,1):timn(i,1)+D-1,:)';
%     
% end
% 
% powers=sum(listn.^2,3);
% words=find(SP_condition_order ==1);
% fakes=find(SP_condition_order ==0);
% wpows=mean(powers(words,:));
% fpows=mean(powers(fakes,:));
% 
% 
% D=1100;
% memor=zeros(20,135,D);
% timn=timn-timn(1)+1;
% for i=1:20
%     i
%     memor(i,:,1:D)=x5(timn(i,2):timn(i,2)+D-1,:)';
%     
% end
% 
% mempows=sum(memor.^2,3);
% wmpows=mean(mempows(words,:));
% fmpows=mean(mempows(fakes,:));

% create & select frequency features
listnq0=fft(listn2,'',3);

memorq=fft(memor22,'',3);
%memorq=abs(memorq);
memorp=memorq(:,:,[1:100,1001:1100]); % selecting the true bandwidth (non-zero spectrum) by low-pass filtering
memor1=memorp(words,:,:);
memor2=memorp(fakes,:,:);
% start of PCA
memor3=reshape(memor1,[1350,200]);
memor4=reshape(memor2,[1350,200]);

% [memcoef,scor1,lat1] = pca(memor3);
% memor5=scor1(:,1:5);
% memor5=reshape(memor5,[10,135,5]);
% 
% [memcoef2,scor2,lat2] = pca(memor4);
% memor6=scor2(:,1:5);
% memor6=reshape(memor6,[10,135,5]);
numf=8;
memor33=[abs(memor3),angle(memor3)];
memor44=[abs(memor4),angle(memor4)];
% memor33=angle(memor3);
% memor44=angle(memor4);
[memcoef,scor1,lat1] = pca(memor33);
memor5=scor1(:,1:numf);
memor5=reshape(memor5,[10,135,numf]);

[memcoef2,scor2,lat2] = pca(memor44);
memor6=scor2(:,1:numf);
memor6=reshape(memor6,[10,135,numf]);

onvecs=zeros(135,1);
y=[ones(10,1);-ones(10,1)];
% for channel=1:135
%    X=[squeeze(memor5(:,channel,:));squeeze(memor6(:,channel,:))];
%    svm1=fitcsvm(X,y);
%    onvecs(channel)=sum(svm1.IsSupportVector);
% end

% X2=[[squeeze(memor5(:,115,:)),squeeze(memor5(:,117,:))];...
%     [squeeze(memor6(:,115,:)),squeeze(memor6(:,117,:))]];

onvecs2=zeros(135,135);
for chan1=1:135
    for chan2=1:135
        X2=[squeeze(memor5(:,chan1,:));squeeze(memor6(:,chan2,:))];
    
        svm1=fitcsvm(X2,y);
        onvecs2(chan1,chan2)=sum(svm1.IsSupportVector);
    end
end

min1=min(min(onvecs2))
[i,j]=find(onvecs2==min1)

