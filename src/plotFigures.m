clc;
close all;
clearvars;

cd ..\inputs\images\train;

I_original = imread('2092.jpg');
I = rgb2gray(I_original);

operator = 'prewitt';   % 'sobel' or 'prewitt'
gaussian_sigma = 1.5;
BW_canny = cannyEdgeDetectorWD(I,operator,gaussian_sigma);
BW_LoG = logEdgeDetectionWD(I,gaussian_sigma);
BW_sobel = sobelEdgeDetectorWD(I);
BW_prewitt = prewittEdgeDetectorWD(I);
BW_roberts = robertsEdgeDetectorWD(I);

cd ..\..\ground_truth\train;

load('2092.mat');

subject1 = groundTruth{1,1}.Boundaries;
subject2 = groundTruth{1,2}.Boundaries;
subject3 = groundTruth{1,3}.Boundaries;

cd ..\..\..\outputs\train_images;

figure(1);
imshow(I_original);
saveas(figure(1),'Train_Original_Image.png');

figure(2);
imshow(subject1);
saveas(figure(2),'Train_Boundary_Subject_1.png');

figure(3);
imshow(subject2);
saveas(figure(3),'Train_Boundary_Subject_2.png');

figure(4);
imshow(subject3);
saveas(figure(4),'Train_Boundary_Subject_3.png');

cd ..\true_boundaries\train;
load('2092.mat');
figure(5);
imshow(true_boundary);

cd ..\..\train_images;
saveas(figure(5), 'Train_True_Boundaries.png');

cd ..\..\codes;