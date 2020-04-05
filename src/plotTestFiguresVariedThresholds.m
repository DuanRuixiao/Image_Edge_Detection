clc;
close all;
clearvars;

id = '257098.jpg';
cd ..\inputs\images\test;
I_original = imread(id);
id = erase(id, '.jpg');
I = rgb2gray(I_original);

thresholds = linspace(20,380,5);

for ii = 1:length(thresholds)
    threshold = thresholds(ii);

    BW_sobel = sobelEdgeDetectorWD(I,threshold);

    figure(ii+2);
    imshow(BW_sobel,'border','tight','initialmagnification','fit');
    set(gcf,'position',[0,0,321,481]);
    axis normal;
end

cd ..\..\..\outputs\test_images\varied_thresholds;

for ii = 1:length(thresholds)
    saveas(figure(ii+2),['Test_Sobel_' num2str(id) '_threshold_' num2str(thresholds(ii)) '.png']);
end

cd ..\..\..\codes;