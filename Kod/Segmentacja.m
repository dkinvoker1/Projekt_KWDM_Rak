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

[y,x] = ginput(2);
group=imagNew(int16(x(1)),int16(y(1)))

map=zeros(size(imagNew));
oldMap=map;
c1=1;
map(int16(x(1)),int16(y(1)))=c1;
c2=2;
map(int16(x(2)),int16(y(2)))=c2;

figure
while ~isequal(oldMap,map)
    oldMap=map;
    for x=2:size(imagNew,1)-1
        for y=2:size(imagNew,2)-1
            if oldMap(x,y)==0 && imagNew(x,y)==group && (oldMap(x-1,y)==c1 || oldMap(x+1,y)==c1 || oldMap(x,y-1)==c1 || oldMap(x,y+1)==c1) 
                map(x,y)=c1;
            end
            if oldMap(x,y)==0 && imagNew(x,y)==group && (oldMap(x-1,y)==c2 || oldMap(x+1,y)==c2 || oldMap(x,y-1)==c2 || oldMap(x,y+1)==c2)
                map(x,y)=c2;
            end
        end
    end
    imshow(map,[])
end
% imshow(map,[])
hold on
%pierwsza nerka
nerka=map==1;
M = max(nerka,[],1);
nerka_x1= find(M==1, 1, 'first');
nerka_x2 = find(M==1, 1, 'last');

M = max(nerka,[],2);
nerka_y1= find(M==1, 1, 'first');
nerka_y2 = find(M==1, 1, 'last');

rectangle('Position',[nerka_x1 nerka_y1 nerka_x2-nerka_x1 nerka_y2-nerka_y1],'EdgeColor','r')
%druga nerka
nerka=map==2;
M = max(nerka,[],1);
nerka2_x1= find(M==1, 1, 'first');
nerka2_x2 = find(M==1, 1, 'last');

M = max(nerka,[],2);
nerka2_y1= find(M==1, 1, 'first');
nerka2_y2 = find(M==1, 1, 'last');
rectangle('Position',[nerka2_x1 nerka2_y1 nerka2_x2-nerka2_x1 nerka2_y2-nerka2_y1],'EdgeColor','g')


end

