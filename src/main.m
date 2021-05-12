clc;clf;clear all;
im1 = imread('object_2.png');
%im1 = imread('object_0.jpg');
im1r = flip(im1,1);
figure(1);
subplot(131);imshow(im1);
[w,l,h] = size(im1);
full_image = [];

global n;
n = 150;   %Divide the picture equally
wi = ceil(w/n);
kMax = 0;
kMin = 990;
%compute the trace
x0 = 0;
xf = 1.0;    %object distance
y0 = 0.06;   %height of eye
e = -3.40;   %inferior mirage
%e = 0.05;   %superior mirage

for i0 = 0:0.01:pi*3/4
    y10 = 1/tan(i0);
    %linear model
    df = @(x,y)[y(2);(e/sin(i0))^2*y(1)-e/(sin(i0))^2];
    [x,y] = ode45(df,[x0,xf],[y0,y10]);
    k = self_classify(y(end,1),w);
    %Determine imaging position
    if k >= kMax
        kMax = k;
    end
    if k <= kMin
        kMin = k;
    end
    if k == 1
        partial_image = im1r(1:wi*k,:,:);
        full_image = [full_image;partial_image];
        subplot(132);
        plot(x,y(:,1),'-','linewidth',2) %plot light trajectory
        hold on;
    elseif wi*k > w 
        continue;
    elseif k == 0
        continue;
    else        
        partial_image = im1r(wi*(k-1):wi*k,:,:);
        full_image = [full_image;partial_image];
        subplot(132);
        plot(x,y(:,1),'-','linewidth',2) %plot light trajectory
        hold on;
    end
end
subplot(132);
xlabel('x/km');
ylabel("z/km");
xlim([x0 ,xf]);
ylim([0 ,14.5]);
grid on;

subplot(133);
imshow(full_image);%show the mirage
size(full_image)
