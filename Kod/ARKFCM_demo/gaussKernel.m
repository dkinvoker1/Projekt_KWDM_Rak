function Ker = gaussKernel(center,img,sgma)
% This function calculates the Gaussian RBF kernel used as distance metric
% Usage: d =gaussKernel(img,winSize);

%  Input:
%           center is the cluster center
%           img is the input image
%           sgma is the kernel width of GRBF (refer to KerWidth.m)
%  Output:
%           d is the output kernel used to calculate the distance (refer to distARKFCM.m)

% Example:  w=PixWgt(img,3);

% This function is a part of the implementation of the follwowing paper:
% Ahmed Elazab et. al. "Segmentation of Brain Tissues from Magnetic Resonance
% Images Using Adaptively Regularized Kernel-Based Fuzzy C-Means Clustering". 2015,
% Computational and Mathematical Methods in Medicine

% Author: Ahmed Elazab. Last update: 18/11/2015
% Note: The codes written here and other functions are not optimized


%   See also ARKFCM, PixWgt, KerWidth, distARKFCM.

if (nargin < 3)
    error('No enough inputs, must enter: cluster center, input image, and kernel width !');
end
dist = zeros(size(center, 1), size(img, 1));
for k = 1:size(center, 1)
    dist(k, :) = sqrt(sum(((img-ones(size(img,1),1)*center(k,:)).^2)',1));
end
Ker = exp(-dist.^2./sgma'.^2);
Ker=Ker';
end