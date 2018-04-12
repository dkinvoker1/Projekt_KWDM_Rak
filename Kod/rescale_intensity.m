function [ rescaled_Img ] = rescale_intensity( img, min, max )

I = double(img);

I(I<min) = min;
I(I>max) = max;

I = I - min;
max = max - min;

rescaled_Img = I/max;
end

