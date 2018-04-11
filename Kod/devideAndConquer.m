function result = devideAndConquer(image)
    groups=ones(size(image));   
    groups = devide(image,1,512,1,512,groups);
    imshow(groups,[]);
end