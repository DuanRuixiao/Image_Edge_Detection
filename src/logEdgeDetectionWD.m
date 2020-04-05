function BW = logEdgeDetectionWD(image,gaussian_sigma,threshold)
% image: gray image in int data type [0,255];

%----------Test----------%
% clc;
% close all;
% clearvars;
% cd ../inputs;
% image_original = imread('car_4.jpg');
% image = rgb2gray(image_original);
% gaussian_sigma = 10;
%------------------------------%

if nargin < 3
    threshold = 4.3719;
end

image = double(image);

% Generate gaussian size based on gaussian sigma.
gaussian_size = ceil(8*gaussian_sigma);
if mod(gaussian_size,2) == 0
    gaussian_size = gaussian_size + 1;
end
half_size = (gaussian_size-1) / 2;

% Generate laplacian of gaussian filter.
[m,n] = meshgrid([-half_size:half_size],[-half_size:half_size]);
G = -1/(pi*gaussian_sigma^4)*(1-(m.*m+n.*n)/(2*gaussian_sigma^2)).*exp(-(m.*m+n.*n)/(2*gaussian_sigma^2));

% Apply LoG to image.
J = imfilter(image,G);

% Binarize laplacian image.
BW = abs(J);
BW = imbinarize(BW, threshold);

%----------Test----------%
% figure(1);
% subplot(121);
% imshow(image_original);
% title('Original Image');
% subplot(122);
% imshow(BW);
% title('LoG Detection');
%------------------------------%
end