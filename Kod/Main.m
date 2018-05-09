% clc; close all; clear all;
% [file,folder]=uigetfile('../Serie/*.dcm','MultiSelect','on')
% fic=fullfile(folder,file)
% 
% Dicom=dicomread(fic{1});
% for i=2:size(fic,2)
%     Dicom = cat(3,Dicom,dicomread(fic{i}));
% %     median_filter = medfilt2(Dicom);
% %     median_filter = double(median_filter);
% %     figure
% %     imshow(median_filter,[]);
% end

map = Segmentacja( Dicom , 40);

figure
rows=6;
for i=1:size(map,3)
    subplot(rows,ceil(size(map,3)/rows),i);
    imshow(map(:,:,i));
end