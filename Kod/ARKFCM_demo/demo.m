
%% This script to run the ARKFCM clustering on different images, more details refer to the following paper

% This function is a part of the implementation of the follwowing paper:
% Ahmed Elazab et. al. "Segmentation of Brain Tissues from Magnetic Resonance
% Images Using Adaptively Regularized Kernel-Based Fuzzy C-Means Clustering". 2015, 
% Computational and Mathematical Methods in Medicine

%   Author: Ahmed Elazab. Last update: 18/11/2015

%   See also ARKFCM, PixWgt, gaussKernel, kerWidth, distARKFCM.



clear all
close all
clc

load('nery.mat')
load('noise.mat')
%%%%%% Initialization %%%%%%%%%

winSize=3;          % Size of the local window
cNum=4;             % Number of clusters
opt='median';      % Filtered image version "average", "median", or "weighted"


%%%%% Uncomment the desired image to run the experiment (for more details, plz refer to the paper)

% img=Dicom;
img=no720_100A;       % Axial slice no. 100 corrupted with 7% noise and 20% grayscale non-uniformity
% img=no720_100S;      % Sagital slice no. 100 corrupted with 7% noise and 20% grayscale non-uniformity
% img=rice10_91A;       % Axial slice no. 91 corrupted with 10% Rician noise

% img=Brats1;          % Slices no. 80 from pat266_1 (Brats challenge 2014) 
% img=Brats2;          % Slices no. 86 from pat192_1 (Brats challenge 2014) 


[r,c]=size(img);
img=double(img);

%%% Function calls %%%%

w=PixWgt(img,winSize);
segment=ARKFCM(img,w,opt,cNum);

%%% Defuzzification process

[mMax,segment]=max(segment.U,[],2);
segment=reshape(segment,r,c);

%%% Note: the appearance of the segmented image may look different due to
%%% the order of the label values

titl=strcat('Segmentation with ' , ' "', opt, '" filtered image');
figure,
subplot(121),imshow(img,[]), title('Input Image');
subplot(122),imshow(segment,[]),title(titl)

clear r c cNum mMax opt t w winSize
