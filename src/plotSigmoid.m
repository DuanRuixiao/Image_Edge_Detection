clc;
close all;
clearvars;

cd ..\outputs\math_images;

x = linspace(-8,8,1024);

y = sigmf(x,[1,0]);

figure(1);
plot(x,y,'k','linewidth',2);
xlabel('x','fontsize',25);
ylabel('f(x)','fontsize',25);
saveas(figure(1),'Original_Signal.png');

y1 = diff(y);
y1 = [y1(1),y1];

figure(2);
plot(x,y1,'k','linewidth',2);
xlabel('x','fontsize',25);
ylabel('f^{(1)}(x)','fontsize',25);
saveas(figure(2),'First_Differential.png');

y2 = diff(y1);
y2 = [y2(1),y2];

figure(3);
plot(x,y2,'k','linewidth',2);
xlabel('x','fontsize',25);
ylabel('f^{(2)}(x)','fontsize',25);
saveas(figure(3),'Second_Differential.png');

y3 = abs(y2);

figure(4);
plot(x,y3,'k','linewidth',2);
xlabel('x','fontsize',25);
ylabel('|f^{(2)}(x)|','fontsize',25);
saveas(figure(4),'Absolute_Second_Differential.png');

cd ..\..\codes;