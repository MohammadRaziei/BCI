function out = timesInterval(t1,t2,fs)
    out = [];
    for i = 1:length(t1)
        out = [out,floor(fs*t1(i)):floor(fs*t2(i))];
    end
end