function [ ] = Segmentacja( Dicom )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

I = im2double(Dicom);
I = imadjust(I);
data = [I(:)];
%Number of clusters
num_clust = 5;
% Fuzzy C-means classification with 3 classes
[center,U,obj_fcn] = fcm(data,num_clust); 
% Finding the pixels for each class
maxU = max(U);
fcmImage(1:length(data))=0; 
for n_c= 1:num_clust
    index1{n_c} = find(U(n_c,:) == maxU);
end
% Assigning pixel to each class by giving them a specific value
% fcmImage(index1{1,1})= 1;
% fcmImage(index1{1,2})= 20;
% fcmImage(index1{1,3})= 30;
for n_c= 1:num_clust
    fcmImage(index1{1,n_c})= n_c;
end


[M,N] = size(I);
% Reshapeing the array to a image
imagNew = reshape(fcmImage,M,N);
figure;imshow(imagNew,[]); 
%figure;imshow(I,[]);
end

