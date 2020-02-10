function [out1, out2] = timesInterval(t1,t2,fs,vec)
    out1 = []; out2 = [];
    for i = 1:length(t1)
        if vec(i) == 0
            out1 = [out1,floor(fs*t1(i)):floor(fs*t2(i))];
        elseif vec(i) == 1
            out2 = [out2,floor(fs*t1(i)):floor(fs*t2(i))];
        end
    end
end