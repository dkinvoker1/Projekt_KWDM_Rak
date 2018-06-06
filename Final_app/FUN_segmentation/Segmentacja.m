function [ map ] = Segmentacja(I)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%Dicom - macierz 3d z kolejnymi przekrojami(np 512x512x4)
%bigest_nerka_number - numer przekroju na którym lekarz zaznacza nerke(dobrze by by³o gdyby by³ to obszar z nawiêks¿¹ nerk¹, mo¿e to byæ np numer obecnie widocznego przekroju w przegl¹darce)
%map - mapa wysegmentowanej nerki, jako macierz 3d w formacie takim jak Dicom(1-nerka, 0-t³o)

% map=zeros(size(Dicom));

rozmiar_ucinacza=5;
proc_add=2;

[y,x] = ginput(1);

%%%%%%%%
% Idcm = Dicom(:,:,bigest_nerka_number);
% I = im2double(Idcm);
% I = mat2gray(I);
% 
% I_max = double(max(Idcm(:)));
% I_min = double(min(Idcm(:)));
% 
% w_min = -140;
% w_max = 260;
% 
% norm_min =  (w_min - I_min)/(I_max - I_min);
% norm_max =  (w_max - I_min)/(I_max - I_min);
% 
% I = imadjust(I, [norm_min, norm_max], []);

% I = Dicom(:,:,bigest_nerka_number);

%%%%%%%%

data = [I(:)];
%Number of clusters
num_clust = 5;
% Fuzzy C-means classification with 3 classes
 options = [NaN NaN NaN 0];
[center,U,obj_fcn] = fcm(data,num_clust, options); 
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
% f=figure;imshow(imagNew,[]); 
%figure;imshow(I,[]);

% wybór jednej grupy z fcma i wyzerowanie pozosta³ych etykiet
% close(f);
group=imagNew(int16(x(1)),int16(y(1)));
% czyszczenie obiektów ma³ych
BW=imagNew;
BW(BW~=group)=0;

SE = strel('square',rozmiar_ucinacza);
BW = imerode(BW,SE);
BW = imdilate(BW,SE);
% figure;imshow(BW,[]);

BW = bwareaopen(BW,300);
% figure;imshow(BW,[]);
% metoda ramkowania jeœli to siê rozrasta
% najwiêcej sensu ma grupowanie po 3D
% bwlabel lub bwlabeln do wyodrêbnienia obiektów
L = bwlabel(BW);
%bierzemy nowy group w tych samych miejscach
group=L(int16(x(1)),int16(y(1)));
%usuwamy wszystko poza nerk¹
mapTemp=L;
mapTemp(mapTemp~=group)=0;
% mapTemp(mapTemp==group)=1;

%pierwsza nerka roi
nerka=im2bw(mapTemp,0);
map=nerka;
% figure;imshow(map(:,:,bigest_nerka_number),[]);
% 
% roi_M = max(nerka,[],1);
% nerka_x1= find(roi_M==1, 1, 'first');
% nerka_x2 = find(roi_M==1, 1, 'last');
% 
% roi_M = max(nerka,[],2);
% nerka_y1= find(roi_M==1, 1, 'first');
% nerka_y2 = find(roi_M==1, 1, 'last');
% 
% szerokosc=nerka_x2-nerka_x1;
% wysokosc=nerka_y2-nerka_y1;
% 
% %poszerzenie roi o 10% jeœli siê da
% % proc_szerokosci=szerokosc/10;
% % proc_wyskokosci=wysokosc/10;
% %poszerzenie roi o 10 pix jeœli siê da
% proc_szerokosci=proc_add;
% proc_wyskokosci=proc_add;
% 
% if nerka_x1-proc_szerokosci>0
%    roi_x1= nerka_x1-proc_szerokosci;
% else
%    roi_x1= nerka_x1;
% end
% if nerka_x2+proc_szerokosci<N
%    roi_x2= nerka_x2+proc_szerokosci;
% else
%    roi_x2= nerka_x2;
% end
% roi_szerokosc=roi_x2-roi_x1;
% 
% if nerka_y1-proc_wyskokosci>0
%    roi_y1= nerka_y1-proc_wyskokosci;
% else
%    roi_y1= nerka_y1;
% end
% if nerka_y2+proc_wyskokosci<M
%    roi_y2= nerka_y2+proc_wyskokosci;
% else
%    roi_y2= nerka_y2;
% end
% roi_wysokosc=roi_y2-roi_y1;

% rectangle('Position',[roi_x1 roi_y1 roi_szerokosc roi_wysokosc],'EdgeColor','r')
% Proi_x1 = roi_x1;
% Proi_y1 = roi_y1;
% Proi_x2 = roi_x2;
% Proi_y2 = roi_y2
%druga nerka
% nerka=map==2;
% M = max(nerka,[],1);
% nerka2_x1= find(M==1, 1, 'first');
% nerka2_x2 = find(M==1, 1, 'last');
% 
% M = max(nerka,[],2);
% nerka2_y1= find(M==1, 1, 'first');
% nerka2_y2 = find(M==1, 1, 'last');
% rectangle('Position',[nerka2_x1 nerka2_y1 nerka2_x2-nerka2_x1 nerka2_y2-nerka2_y1],'EdgeColor','g')

% %segmentacja dla pozosta³ych warstw
% %segmentacja warstw poprzedzaj¹cych
% progress=0;
% f = waitbar(progress,'Proszê czekaæ')
% if bigest_nerka_number-1>1
%     for i=bigest_nerka_number-1:-1:1
% %         I = im2double(Dicom(:,:,i));
% %         I = imadjust(I);
%         I = Dicom(:,:,i);
%         data = [I(:)];
%         %Number of clusters
%         num_clust = 5;
%         % Fuzzy C-means classification with 3 classes
%         options = [NaN NaN NaN 0];
%         [center,U,obj_fcn] = fcm(data,num_clust,options); 
%         % Finding the pixels for each class
%         maxU = max(U);
%         fcmImage(1:length(data))=0; 
%         for n_c= 1:num_clust
%             index1{n_c} = find(U(n_c,:) == maxU);
%         end
%         % Assigning pixel to each class by giving them a specific value
%         for n_c= 1:num_clust
%             fcmImage(index1{1,n_c})= n_c;
%         end
% 
%         [M,N] = size(I);
%         % Reshapeing the array to a image
%         imagNew = reshape(fcmImage,M,N);
% %         figure;imshow(imagNew,[]); 
%         %wybranie jako nerki najwiêkszego obszaru z roi
%         roi=imagNew(roi_y1:roi_y2,roi_x1:roi_x2);
%         groups=unique(roi);
%         liczebnosc=[];
%         for j=1:size(groups,1)
%             liczebnosc(j)=sum(sum(roi(:) == groups(j)));
%         end
%         [mLicz,ind] = max(liczebnosc);
%         group=groups(ind);
%         
%         %mapa dla ca³ego obrazu
%         mapTemp=imagNew;
%         mapTemp(1:roi_y1,:)=0;
%         mapTemp(roi_y2:end,:)=0;
%         mapTemp(:,1:roi_x1)=0;
%         mapTemp(:,roi_x2:end)=0;
%         mapTemp(mapTemp~=group)=0;
%         mapTemp(mapTemp==group)=1;
%         
%         %usuwanie ma³ych po³¹czeñ i ma³ych objektów
%         SE = strel('square',rozmiar_ucinacza);
%         mapTemp = imerode(mapTemp,SE);
%         mapTemp = imdilate(mapTemp,SE);
% %         figure;imshow(mapTemp,[]);
%         mapTemp = bwareaopen(mapTemp,300);
%         mapTemp = bwlabel(mapTemp);
%                 %wybranie jako nerki najwiêkszego obszaru z pe³nego obrazu
%         groups=unique(mapTemp);
%         groups(groups==0)=[];
%         liczebnosc=[];
%         for j=1:size(groups,1)
%             liczebnosc(j)=sum(sum(mapTemp(:) == groups(j)));
%         end
%         [mLicz,ind] = max(liczebnosc);
%         group=groups(ind);
%         mapTemp(mapTemp~=group)=0;
% %         mapTemp(mapTemp==group)=1;
% %                 figure;imshow(mapTemp,[]);
%         
%         %nerka roi
%         nerka=im2bw(mapTemp,0);
%         roi_M = max(nerka,[],1);
%         nerka_x1= find(roi_M==1, 1, 'first');
%         nerka_x2 = find(roi_M==1, 1, 'last');
% 
%         roi_M = max(nerka,[],2);
%         nerka_y1= find(roi_M==1, 1, 'first');
%         nerka_y2 = find(roi_M==1, 1, 'last');
% 
%         szerokosc_nowa=nerka_x2-nerka_x1;
%         wysokosc_nowa=nerka_y2-nerka_y1;
%         
%         %jeœli to co wysz³o jest za ma³e to nie licz dalej
% %         if(szerokosc<10)||(wysokosc<10)
% %             progress=bigest_nerka_number-1;
% %             break;
% %         end
% 
%         %poszerzenie roi o 10% jeœli siê da
% %         proc_szerokosci=szerokosc/10;
% %         proc_wyskokosci=wysokosc/10;
%         %poszerzenie roi o 10 pix jeœli siê da
% %         if szerokosc<szerokosc_nowa
% %             szerokosc=szerokosc_nowa;
%             proc_szerokosci=proc_add;
% %         else
% %             szerokosc=szerokosc_nowa;
% %             proc_szerokosci=1;
% %         end
% %         if wysokosc<wysokosc_nowa
% %             wysokosc=wysokosc_nowa;
%             proc_wyskokosci=proc_add;
% %         else
% %             wysokosc=wysokosc_nowa;
% %             proc_wyskokosci=1;
% %         end
%         
%         if nerka_x1-proc_szerokosci>0
%            roi_x1= nerka_x1-proc_szerokosci;
%         else
%            roi_x1= nerka_x1;
%         end
%         if nerka_x2+proc_szerokosci<N
%            roi_x2= nerka_x2+proc_szerokosci;
%         else
%            roi_x2= nerka_x2;
%         end
%         roi_szerokosc=roi_x2-roi_x1;
% 
%         if nerka_y1-proc_wyskokosci>0
%            roi_y1= nerka_y1-proc_wyskokosci;
%         else
%            roi_y1= nerka_y1;
%         end
%         if nerka_y2+proc_wyskokosci<M
%            roi_y2= nerka_y2+proc_wyskokosci;
%         else
%            roi_y2= nerka_y2;
%         end
%         roi_wysokosc=roi_y2-roi_y1;
%         
%         %sprawdzenie czy roi ma sensowny zakres
% %         if (roi_y1<0)||(roi_y2<0)||(roi_x1<0)||(roi_x2<0)
% %             progress=bigest_nerka_number-1;
% %             break;
% %         end
%         
%         %przypisanie mapy
%         map(:,:,i)=nerka;
%         
% %         figure; imshow(nerka,[])
%         rect=[roi_x1 roi_y1 roi_szerokosc roi_wysokosc];
% %         rectangle('Position',rect,'EdgeColor','r')
%         
%         progress=progress+1;
%         waitbar(progress/(size(Dicom,3)-1),f,'Proszê czekaæ');
%     end
% end
% 
% %segmentacja warstw nastêpnych
% if bigest_nerka_number-1<size(Dicom,3)
%     roi_x1 = Proi_x1;
%     roi_y1 = Proi_y1;
%     roi_x2 = Proi_x2;
%     roi_y2 = Proi_y2;
%     for i=bigest_nerka_number+1:1:size(Dicom,3)
% %         I = im2double(Dicom(:,:,i));
% %         I = imadjust(I);
%         I = Dicom(:,:,i);
% 
%         data = [I(:)];
%         %Number of clusters
%         num_clust = 5;
%         % Fuzzy C-means classification with 3 classes
%         options = [NaN NaN NaN 0];
%         [center,U,obj_fcn] = fcm(data,num_clust,options); 
%         % Finding the pixels for each class
%         maxU = max(U);
%         fcmImage(1:length(data))=0; 
%         for n_c= 1:num_clust
%             index1{n_c} = find(U(n_c,:) == maxU);
%         end
%         % Assigning pixel to each class by giving them a specific value
%         for n_c= 1:num_clust
%             fcmImage(index1{1,n_c})= n_c;
%         end
% 
%         [M,N] = size(I);
%         % Reshapeing the array to a image
%         imagNew = reshape(fcmImage,M,N);
% %         figure;imshow(imagNew,[]); 
%         %wybranie jako nerki najwiêkszego obszaru z roi
%         roi=imagNew(roi_y1:roi_y2,roi_x1:roi_x2);
%         groups=unique(roi);
%         liczebnosc=[];
%         for j=1:size(groups,1)
%             liczebnosc(j)=sum(sum(roi(:) == groups(j)));
%         end
%         [mLicz,ind] = max(liczebnosc);
%         group=groups(ind);
%         
%         %mapa dla ca³ego obrazu
%         mapTemp=imagNew;
%         mapTemp(1:roi_y1,:)=0;
%         mapTemp(roi_y2:end,:)=0;
%         mapTemp(:,1:roi_x1)=0;
%         mapTemp(:,roi_x2:end)=0;
%         mapTemp(mapTemp~=group)=0;
%         mapTemp(mapTemp==group)=1;
%         
%         %usuwanie ma³ych po³¹czeñ i ma³ych objektów
%         SE = strel('square',rozmiar_ucinacza);
%         mapTemp = imerode(mapTemp,SE);
%         mapTemp = imdilate(mapTemp,SE);
% %         figure;imshow(mapTemp,[]);
%         mapTemp = bwareaopen(mapTemp,300);
%         mapTemp = bwlabel(mapTemp);
%                 %wybranie jako nerki najwiêkszego obszaru z pe³nego obrazu
%         groups=unique(mapTemp);
%         groups(groups==0)=[];
%         liczebnosc=[];
%         for j=1:size(groups,1)
%             liczebnosc(j)=sum(sum(mapTemp(:) == groups(j)));
%         end
%         [mLicz,ind] = max(liczebnosc);
%         group=groups(ind);
%         mapTemp(mapTemp~=group)=0;
% %         mapTemp(mapTemp==group)=1;
% %                 figure;imshow(mapTemp,[]);
%         
%         %nerka roi
%         nerka=im2bw(mapTemp,0);
%         roi_M = max(nerka,[],1);
%         nerka_x1= find(roi_M==1, 1, 'first');
%         nerka_x2 = find(roi_M==1, 1, 'last');
% 
%         roi_M = max(nerka,[],2);
%         nerka_y1= find(roi_M==1, 1, 'first');
%         nerka_y2 = find(roi_M==1, 1, 'last');
% 
%         szerokosc_nowa=nerka_x2-nerka_x1;
%         wysokosc_nowa=nerka_y2-nerka_y1;
%         
%         %jeœli to co wysz³o jest za ma³e to nie licz dalej
% %         if(szerokosc<10)||(wysokosc<10)
% %             progress=bigest_nerka_number-1;
% %             break;
% %         end
% 
%         %poszerzenie roi o 10% jeœli siê da
% %         proc_szerokosci=szerokosc/10;
% %         proc_wyskokosci=wysokosc/10;
%         %poszerzenie roi o 10 pix jeœli siê da
% %         if szerokosc<szerokosc_nowa
% %             szerokosc=szerokosc_nowa;
%             proc_szerokosci=proc_add;
% %         else
% %             szerokosc=szerokosc_nowa;
% %             proc_szerokosci=1;
% %         end
% %         if wysokosc<wysokosc_nowa
% %             wysokosc=wysokosc_nowa;
%             proc_wyskokosci=proc_add;
% %         else
% %             wysokosc=wysokosc_nowa;
% %             proc_wyskokosci=1;
% %         end
%         
%         if nerka_x1-proc_szerokosci>0
%            roi_x1= nerka_x1-proc_szerokosci;
%         else
%            roi_x1= nerka_x1;
%         end
%         if nerka_x2+proc_szerokosci<N
%            roi_x2= nerka_x2+proc_szerokosci;
%         else
%            roi_x2= nerka_x2;
%         end
%         roi_szerokosc=roi_x2-roi_x1;
% 
%         if nerka_y1-proc_wyskokosci>0
%            roi_y1= nerka_y1-proc_wyskokosci;
%         else
%            roi_y1= nerka_y1;
%         end
%         if nerka_y2+proc_wyskokosci<M
%            roi_y2= nerka_y2+proc_wyskokosci;
%         else
%            roi_y2= nerka_y2;
%         end
%         roi_wysokosc=roi_y2-roi_y1;
%         
%         %sprawdzenie czy roi ma sensowny zakres
% %         if (roi_y1<0)||(roi_y2<0)||(roi_x1<0)||(roi_x2<0)
% %             progress=bigest_nerka_number-1;
% %             break;
% %         end
%         
%         %przypisanie mapy
%         map(:,:,i)=nerka;
%         
% %         figure; imshow(nerka,[])
%         rect=[roi_x1 roi_y1 roi_szerokosc roi_wysokosc];
% %         rectangle('Position',rect,'EdgeColor','r')
%         
%         progress=progress+1;
%         waitbar(progress/(size(Dicom,3)-1),f,'Proszê czekaæ');
%     end
% end
% close(f);
end

