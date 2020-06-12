pred = zeros(9,1);
res = zeros(100,1);
for k = 1:1000
    k
    %fitures_fake = 3e-4*randn(size(fitures));
%     order_label_fake = [ones(10,1);2*ones(10,1)];
    order_label_fake = order_label(randperm(20));
    idx0_fake = find(order_label_fake == 1);
    idx1_fake = find(order_label_fake == 2);
    for i = 1:9
        idx_i = [idx0_fake(i), idx1_fake(i)];
        train_X = fitures; train_Y = order_label_fake;
        train_X(idx_i,:) = []; train_Y(idx_i,:) = [];
        test_X = fitures(idx_i,:); test_Y = order_label_fake(idx_i,:);

        mdl=fitcsvm(train_X, train_Y,'Standardize',true);
        [label,score] = predict(mdl,test_X);
        pred(i) = sum(label == test_Y)/2;
%         beta(:,i) = mdl.Beta;
%         [~,idx] = sort(abs(mdl.Beta));
%         channel_fake(:,i) = idx;%ceil(idx/(Nfit*2));
    end
res(k) = mean(pred);
end
mean(res)

