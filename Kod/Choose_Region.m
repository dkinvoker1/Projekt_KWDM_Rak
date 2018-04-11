function reg = Choose_Region( method_index, im_size )

switch method_index
    case 1
        reg = imrect;
    case 2
        reg = imfreehand;
    otherwise
        e = MException('420','Niezaimplementowana metoda wyboru regionu!');
        throw(e);
end
end

