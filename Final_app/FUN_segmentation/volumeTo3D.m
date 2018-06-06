function [I3D] = volumeTo3D(images)
     I3D = zeros(size(images,1), size(images,2), size(images,4));
     for i = 1:size(images,4)
         I3D(:,:,i) = images(:,:,1,i);
     end
end

