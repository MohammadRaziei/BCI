function [p,w] = pwelchTrial(sig)
    for i = 1:size(sig,3)
       [p0,w0] = pwelch(sig(:,:,i));
       p(:,:,i) = p0;
       w(:,:,i) = w0;
    end
end