function BW = cannyEdgeDetectorWD(image,operator,gaussian_sigma)
% image: gray image in int data type [0,255];
% gaussian_size, gaussian_sigma: parameters of Gaussian filter;
% operator: 'sobel' or 'perwitt', define type of gradient operator;
% low_threshold, high_threshold: thresholds used for double threshold to
%                                determine potential edges.

%----------Test----------%
% clc;
% close all;
% clearvars;
% cd ../inputs;
% image_original = imread('car_4.jpg');
% image = rgb2gray(image_original);
% operator = 'prewitt';
% gaussian_sigma = 1.5;
%------------------------------%

%----------Gaussian Filter to Smooth Image----------%
image = double(image);
% Create a Gaussian filter G.
gaussian_size = ceil(4*gaussian_sigma);
if mod(gaussian_size,2) == 0
    gaussian_size = gaussian_size + 1;
end
G = fspecial('gaussian',gaussian_size,gaussian_sigma);
% Filter original image with Gaussian filter, and J is the same size of
% image.
J = imfilter(image,G);
%------------------------------%

%----------Find Intensity Gradient----------%
% Create x and y gradient Sobel or Perwitt operator.
Px = fspecial(operator);
Py = Px';

% Get vertical and horizontal derivative applying operator.
Ex = imfilter(J,Px);
Ey = imfilter(J,Py);

% Get magnitude and direction estimation.
Es = sqrt(Ex.*Ex + Ey.*Ey);
Eo = atan(Ex./Ey);

% Normalize direction estimation.
Eo(Eo<pi/8 & Eo>=-pi/8) = 0;
Eo(Eo>=3/8*pi | Eo<-3/8*pi) = -pi/2;
Eo(Eo>=pi/8 & Eo<3/8*pi) = pi/4;
Eo(Eo>=-3/8*pi & Eo<-1/8*pi) = -pi/4;
%------------------------------%

%----------Apply Non-Maximum Suppression----------%
% If Es[ii,jj] is smaller than at least one of its neighbors along
% Eo[ii,jj], then I_N[ii,jj] = 0; otherwise, I_N[ii,jj] = Es[ii,jj].
I_N = Es;
[M,N] = size(I_N);
for ii = 2 : M-1
    for jj = 2 : N-1
        if Eo(ii,jj) == 0
            x = I_N(ii,jj);
            x1 = I_N(ii-1,jj);
            x2 = I_N(ii+1,jj);
            if x == max(x,max(x1,x2))
                I_N(ii,jj) = I_N(ii,jj);
            else
                I_N(ii,jj) = 0;
            end
        elseif Eo(ii,jj) == pi/4
            x = I_N(ii,jj);
            x1 = I_N(ii+1,jj-1);
            x2 = I_N(ii-1,jj+1);
            if x == max(x,max(x1,x2))
                I_N(ii,jj) = I_N(ii,jj);
            else
                I_N(ii,jj) = 0;
            end
        elseif Eo(ii,jj) == pi/2
            x = I_N(ii,jj);
            x1 = I_N(ii,jj-1);
            x2 = I_N(ii,jj+1);
            if x == max(x,max(x1,x2))
                I_N(ii,jj) = I_N(ii,jj);
            else
                I_N(ii,jj) = 0;
            end
        elseif Eo(ii,jj) == -pi/4
            x = I_N(ii,jj);
            x1 = I_N(ii-1,jj-1);
            x2 = I_N(ii+1,jj+1);
            if x == max(x,max(x1,x2))
                I_N(ii,jj) = I_N(ii,jj);
            else
                I_N(ii,jj) = 0;
            end
        end
    end
end
I_N(1,:) = 0;
I_N(M,:) = 0;
I_N(:,1) = 0;
I_N(:,N) = 0;
%------------------------------%

%----------Apply Double Threshold----------%
% Get histogram of I_N.
[counts,bin_locations] = imhist(uint8(I_N));
high_threshold = bin_locations(find(cumsum(counts(2:end)) > 0.9*(M*N-counts(1)),1,'first'));
low_threshold = 0.5 * high_threshold;

I_double_threshold = I_N;
I_double_threshold(I_double_threshold>high_threshold) = 255;
I_double_threshold(I_double_threshold>low_threshold & I_double_threshold<high_threshold) = 100;
I_double_threshold(I_double_threshold<low_threshold) = 0;
%------------------------------%

%----------Track Edge by Hysteresis----------%
I_tracked = I_double_threshold;
for ii = 1 : M
    for jj = 1 : N
        if I_tracked(ii,jj) == 100
            y1 = I_tracked(ii-1,jj-1);
            y2 = I_tracked(ii-1,jj);
            y3 = I_tracked(ii-1,jj+1);
            y4 = I_tracked(ii,jj-1);
            y5 = I_tracked(ii,jj+1);
            y6 = I_tracked(ii+1,jj-1);
            y7 = I_tracked(ii+1,jj);
            y8 = I_tracked(ii+1,jj+1);
            y = [y1,y2,y3,y4,y5,y6,y7,y8];
            index = y == 255;
            if sum(index) > 0
                I_tracked(ii,jj) = 255;
            else
                I_tracked(ii,jj) = 0;
            end
        end
    end
end
%------------------------------%

BW = imbinarize(I_tracked);

%----------Test----------%
% figure(1);
% subplot(121);
% imshow(image_original);
% title('Original Image');
% subplot(122);
% imshow(BW);
% title('Canny Detection');
%------------------------------%
end