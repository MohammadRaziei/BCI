clc;
resamp = @(x,tx,a,meth) resample(x,tx,a/(tx(2)-tx(1)),meth,1,1); % 'linear', 'spline', 'pchip'
x0 = 1:0.1:10;
x1 = 1:0.8:10;
figure; 
subplot(211);
hold on;
plot(x0,sin(x0));
plot(x1,sin(x1), 'o');
% a = ( 3/(x1(2)- x1(1)));
% [y,ty] = resample((sin(x1)),x1,a,'spline',1,1);
[y,ty] = resamp(sin(x1),x1,2.4,'spline');
plot(ty,y,'.-');

subplot(212);
hold on;
plot(x0,ones(size(x0)));
plot(x1,ones(size(x1)), 'o');
% a = ( 3/(x1(2)- x1(1)));
% [y,ty] = resample(ones(size(x1)),x1,a,'spline',1,1);
[y,ty] = resamp(ones(size(x1)),x1,2.5,'spline');
plot(ty,y,'.-');