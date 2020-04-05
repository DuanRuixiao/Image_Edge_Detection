function BW = sobelEdgeDetectorWD(image, threshold)
% image: gray image in int data type [0,255];

%----------Test----------%
% clc;
% close all;
% clearvars;
% cd ../inputs/images/train;
% image_original = imread('100075.jpg');
% image = rgb2gray(image_original);
% threshold = 1000;
%------------------------------%

if nargin < 2
    threshold = 152.1608;
end

image = double(image);

Px=[-1 0 1; -2 0 2; -1 0 1];
Py=[-1 -2 -1; 0 0 0; 1 2 1];

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
% cd ..\..\..\codes;
%------------------------------%
end