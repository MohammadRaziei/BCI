function out = smooth2D(ref)
for i = 1:size(ref,2)
    out(:,i) = smooth(ref(:,1),10);
end