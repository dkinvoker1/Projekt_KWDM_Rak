function dist = distARKFCM(center, img, sgma)
%  This function calculates the distance between cluster centers and the pixels using GRBF Kernel

%  Input:
%           center is the cluster center vector
%           img is the input image
%           sgma is the kernel width (refer to kerWidth.m)

%  Output:
%           dist is an array with distance from every pixel to each cluster center
%           
% Hint:      

% This function is a part of the implementation of the follwowing paper:
% Ahmed Elazab et. al. "Segmentation of Brain Tissues from Magnetic Resonance
% Images Using Adaptively Regularized Kernel-Based Fuzzy C-Means Clustering". 2015, 
% Computational and Mathematical Methods in Medicine

%   Author: Ahmed Elazab. Last update: 18/11/2015

%   See also ARKFCM, PixWgt, gaussKernel, distARKFCM.

if (nargin < 3)
     error('No enough inputs !');
end


cluster_n = size(center, 1);
data_n = size(img, 1);
dist = zeros(cluster_n, data_n);
for i = 1:cluster_n
    cent_i = center(i,:);
    dist(i,:) = 2-2*gaussKernel(cent_i,img,sgma);
end
dist=dist';
end