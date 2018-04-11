function result = ARKFCM(Img,w,opt,cNum,winSize,m,e)
% ARKFCM clustering main function
% Usage:   ARKFCM(Img,w,opt,cNum,winSize,m,e)

% Inputs:
%   Img         The input image.
%   w           The weight associated each pixel (refer to PixWgt).
%   opt         String for filtered image either "average", "median", or "weighted" (default is "median")
%   cNum        Number of clusters.
%   winSize     Size of the local window (default is 3).
%   m           Weighting exponent on each fuzzy membership (default is 2).
%   thrE        Stopping threshold.
% Outputs:
%   result      Struct that contains:
%                       - U     The converged membership function
%                       - iter  Number of iterations to converge
%                       - cost  The objective function at each iteration
%                       - cent  The cluster centers after convergence
% Example:
%   result = ARKFCM(img,w,'average',4,3); (refer to the demo.m)
%
% This function is a part of the implementation of the follwowing paper:
% Ahmed Elazab et. al. "Segmentation of Brain Tissues from Magnetic Resonance
% Images Using Adaptively Regularized Kernel-Based Fuzzy C-Means Clustering". 2015,
% Computational and Mathematical Methods in Medicine

%   Author: Ahmed Elazab. Last update: 18/11/2015

% Note: The codes written here and other functions are not optimized


%   See also PixWgt, gaussKernel, KerWidth, distARKFCM.

if ndims(Img)>2
    error('This function is applicable to 2D images only!');
    return
end

if (nargin < 7)
    e = 1e-2;
    if (nargin < 6)
        m=2;
        if (nargin < 5)
            winSize=3;
            if (nargin < 4)
                cNum=4;
                if (nargin < 3)
                    opt='median';
                    if (nargin < 2)
                        error('No enough inputs !');
                        return
                    end
                end
            end
        end
    end
end

Img=double(Img);
N=winSize^2;
[rn,cn]=size(Img);

if strcmp(opt,'average')
    h = fspecial('average',winSize);
    filtImg=imfilter(Img,h);
elseif strcmp(opt,'median')
    filtImg=medfilt2(Img,[winSize winSize]);
elseif strcmp(opt,'weighted')
    mx=max(w(:));
    a=[1,1,1;1,0,1;1,1,1];
    filtImg=1/(2+mx) *((1+mx)/(N-1)* filter2(a,Img)+Img);
else
    error('Wrong filter name, Please choose among "average", "median", or "weighted" ');
end


w=w(:);
Img=Img(:);
filtImg=filtImg(:);

% Initialization of the fuzzy membership matrix

U0 = rand( rn* cn, cNum-1 )*(1/cNum);
U0(:,cNum) = 1 - sum(U0,2);
U = zeros(rn*cn,cNum);          % membership matrix
iter = 0;                       % iteration counter


% Initialization of cluster centers, for better visualization of the
% segmented image, sometimes it is better to use the cent=[0,50,120,200]';
% cent=[0,50,120,200]';

%% Initialize random clusters centers
cent=sort(round(255*(rand(cNum,1))));

% calculate the kernel width of the GRBF kernel
sgmaImg=kerWidth(Img);
sgmafiltImg=kerWidth(filtImg);

% % % % % % % % % % % % % % % "" Main loop"" % % % % % % % % % % % % % % % %

while (max(max(U0-U)) > e)
    iter = iter + 1;
    U = U0;
    
    %%% Calculating the new cluster centers (Eq. 21)
    
    kerImg=gaussKernel(cent,Img,sgmaImg);              kerImg=kerImg';
    kerfiltImg=gaussKernel(cent,filtImg,sgmafiltImg);    	kerfiltImg=kerfiltImg';
    U = U.^m;
    
    numerC=(U'.*kerImg*Img)+ (U'.*kerfiltImg*(w.*filtImg));        % numerator of the new center (equation 21)
    denomC=sum((U'.*kerImg),2)+sum(((ones(cNum,1)*w').*(U'.*kerfiltImg)),2);     % denominator of the new center (equation 21)
    cent = (numerC./ (denomC));          % the new cluster centers
    
    
    distImg=distARKFCM(cent, Img, max(Img));       % use the maximum gray level to be the kernel width
    dfiltImg=distARKFCM(cent,filtImg,max(Img));
    
    % Caculating the new membership matrix (Eq. 20)
    distImg = (distImg+1e-5).^(-1/(m-1));
    dfiltImg = (dfiltImg+1e-5).^(-1/(m-1));
    
    
    numerU=(distImg+((w*ones(1,cNum)).*dfiltImg));        % numerator of the new center (eq. 20)
    denomU=((sum(dfiltImg.*(w*ones(1,cNum)),2)*ones(1,cNum))+(sum(distImg,2)*ones(1,cNum)));     % denominator of the new center (eq. 21)
    U0 = (numerU./ (denomU));          % the new cluster membership matrix
    
    % Calculating the objective function (Eq. 19)
    J(iter) = sum(sum(U0.*(distImg.^2))) + sum(sum((w*ones(1,cNum)).*U0.*(dfiltImg.^2)));
    
    
    if iter>100
        break;
    end
end             %end of iteration


%result outputs
result.U = U0;
result.iter = iter;
result.cost = J;
result.center=cent;
end


