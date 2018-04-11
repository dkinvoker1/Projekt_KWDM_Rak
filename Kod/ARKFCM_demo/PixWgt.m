function w =PixWgt(img,winSize)
% This function calculates the weight for each pixel based on the local variation coefficient
% Usage: w =PixWgt(img,winSize);

%  Input:
%           img is the input image
%           wsize is the window size (default is 3)
%  Output:
%           w is the final weight to be associated for each pixel 

% Example:  w=PixWgt(img,3);

% This function is a part of the implementation of the follwowing paper:
% Ahmed Elazab et. al. "Segmentation of Brain Tissues from Magnetic Resonance
% Images Using Adaptively Regularized Kernel-Based Fuzzy C-Means Clustering". 2015, 
% Computational and Mathematical Methods in Medicine

% Author: Ahmed Elazab. Last update: 18/11/2015

% Note: The codes written here and other functions are not optimized


% See also ARKFCM, gaussKernel, KerWidth, distARKFCM.


if (nargin < 2)
    winSize=3;
    if (nargin < 1)
        error('No enough inputs !');
        return
    end
end


img=double(img);

h=fspecial('average',winSize);
avg=imfilter(img,h,'replicate');        % local average of every pixel

nhood=ones(winSize);
Vimg=stdfilt(img,nhood).^2;             % local variance of every pixel

LVC=Vimg./(avg.^2);                     % local variation coefficient   
LVC(isnan(LVC))=0;
sumLVC=imfilter(LVC,h,'conv');          % local sum of LVC

eta=exp(-(LVC-sumLVC));                 % Exponential function

tempeta=imfilter(eta,nhood,'conv');     
w=eta./tempeta;                         % weight for every pixel

%%%  caculate the final weights

ind1= find((avg)>img);
ind2= find(uint8(avg)<img);

w(ind1)=2-w(ind1);          % avg(x)>x
w(ind2)=2+w(ind2);          %avg(x)<x
w(uint8(avg)==img)=0;       %avg(x)=x

end