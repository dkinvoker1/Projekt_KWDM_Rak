function new_mask = Iterative_activecontour(serie, mask, image_number)
    new_mask = zeros(size(mask, 1), size(mask, 2), size(mask,3));
    new_mask(:,:,image_number) = mask(:,:,image_number);
    for i=(image_number-1):-1:1
        new_mask(:,:,i) = activecontour(serie(:,:,i+1), new_mask(:,:,i+1));
    end
    for i=(image_number+1):1:size(serie,3)
        new_mask(:,:,i) = activecontour(serie(:,:,i-1), new_mask(:,:,i-1));
    end
end