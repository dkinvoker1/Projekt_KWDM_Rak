function sgma=kerWidth(Img)
%  This function calculates the kernel base (sigma) for GRBF Kernel Function

%  Input:
%           img is the input image

%  Output:
%           sgma is the kernel width for Gaussian Radial Basis Function
%           
% Hint:      
% According to Fuzzy c-means clustering with local infrmation and kernel metric for image segmentation TIP 2013

% This function is a part of the implementation of the follwowing paper:
% Ahmed Elazab et. al. "Segmentation of Brain Tissues from Magnetic Resonance
% Images Using Adaptively Regularized Kernel-Based Fuzzy C-Means Clustering". 2015, 
% Computational and Mathematical Methods in Medicine

%   Author: Ahmed Elazab. Last update: 18/11/2015

%   See also ARKFCM, PixWgt, gaussKernel, distARKFCM.

if (nargin < 1)
     error('No enough inputs !');
end

Img=Img(:);
n=numel(Img);
avgX=mean(Img);     % The average of all points

d=abs(Img-avgX);    % Distance (absolute values between every point and average)

avgD=mean(d);       % Average of all distances 

sgma=sqrt(sum((d-avgD).^2)/n-1);    % Kernel width