function BW = prewittEdgeDetectorWD(image, threshold)
% image: gray image in int data type [0,255];

%----------Test----------%
% clc;
% close all;
% clearvars;
% cd ../inputs;
% image_original = imread('car_4.jpg');
% image = rgb2gray(image_original);
%------------------------------%

if nargin < 2
    threshold = 110.5528;
end

image = double(image);

Px=[-1 0 1; -1 0 1; -1 0 1];
Py=[-1 -1 -1; 0 0 0; 1 1 1];

Gx = imfilter(image,Px);
Gy = imfilter(image,Py);

Em = sqrt(Gx.*Gx + Gy.*Gy);

BW = imbinarize(Em, threshold);

%----------Test----------%
% figure(1);
% subplot(121);
% imshow(image_original);
% title('Original Image');
% subplot(122);
% imshow(BW);
% title('Sobel Detection');
%------------------------------%
end