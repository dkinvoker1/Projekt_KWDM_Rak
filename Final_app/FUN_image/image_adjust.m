
function image_show = image_adjust(I, wl, ww)
image_show = im2double(I);
image_show = mat2gray(image_show);

I_max = double(max(I(:)));
I_min = double(min(I(:)));
    
w_min = wl - ww/2;
w_max = wl + ww/2;

norm_min =  (w_min - I_min)/(I_max - I_min);
norm_max =  (w_max - I_min)/(I_max - I_min);

if norm_min < 0
    norm_min = 0;
end
if norm_max > 1
    norm_max = 1;
end

if norm_max == 1 && norm_min == 1
    norm_min = 0.99;
end
if norm_max == 0 && norm_min == 0
    norm_max = 0.01;
end

image_show = imadjust(image_show, [norm_min, norm_max], []);

end
