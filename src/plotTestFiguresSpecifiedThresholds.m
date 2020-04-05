clc;
close all;
clearvars;

id = '80090.jpg';
cd ..\inputs\images\test;
I_original = imread(id);
I = rgb2gray(I_original);
operator = 'prewitt';   % 'sobel' or 'prewitt'
gaussian_sigma = 1.5;
BW_canny = cannyEdgeDetectorWD(I,operator,gaussian_sigma);
BW_LoG = logEdgeDetectionWD(I,gaussian_sigma);
BW_sobel = sobelEdgeDetectorWD(I);
BW_prewitt = prewittEdgeDetectorWD(I);
BW_roberts = robertsEdgeDetectorWD(I);

cd ..\..\..\outputs\true_boundaries\test;
id = erase(id, '.jpg');
load([id '.mat']);

figure(2);
imshow(I_original,'border','tight','initialmagnification','fit');
set(gcf,'position',[0,0,321,481]);
axis normal;

figure(3);
imshow(BW_canny,'border','tight','initialmagnification','fit');
set(gcf,'position',[0,0,321,481]);
axis normal;

figure(4);
imshow(BW_LoG,'border','tight','initialmagnification','fit');
set(gcf,'position',[0,0,321,481]);
axis normal;

figure(5);
imshow(BW_sobel,'border','tight','initialmagnification','fit');
set(gcf,'position',[0,0,321,481]);
axis normal;

figure(6);
imshow(true_boundary,'border','tight','initialmagnification','fit');
set(gcf,'position',[0,0,321,481]);
axis normal;

cd ..\..\..\outputs\test_images\specified_thresholds;
saveas(figure(2),['Test_Original_Image_' num2str(id) '.png']);
saveas(figure(3),['Test_Canny_' num2str(id) '.png']);
saveas(figure(4),['Test_LoG_' num2str(id) '.png']);
saveas(figure(5),['Test_Sobel_' num2str(id) '.png']);
saveas(figure(6),['Test_True_Boundary_' num2str(id) '.png']);

cd ..\..\..\codes;