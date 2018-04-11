clc; close all; clear all;
[file,folder]=uigetfile('../Serie/*.dcm','MultiSelect','on')
fic=fullfile(folder,file)

for i=1:size(fic,2)
    Dicom = dicomread(fic{i});
    median_filter = medfilt2(Dicom);
    median_filter = double(median_filter);
    figure
    imshow(median_filter,[]);
end