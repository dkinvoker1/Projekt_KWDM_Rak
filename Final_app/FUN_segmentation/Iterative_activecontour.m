function new_mask = Iterative_activecontour(serie, wl, ww, mask, image_number)
    new_mask = cell(1,size(mask,3));
    new_mask{image_number} = mask{image_number};
    
    series_count = size(serie,4);
    progress = 0;
    f = waitbar(progress,'Proszê czekaæ');
    for i=(image_number-1):-1:1
        new_mask{i} = activecontour(image_adjust(serie(:,:,1,i), wl, ww), new_mask{i+1});
        
        progress = progress + 1;
        waitbar(progress/series_count,f, 'Proszê czekaæ');
    end
    for i=(image_number+1):1:series_count
        new_mask{i} = activecontour(image_adjust(serie(:,:,1,i), wl, ww), new_mask{i-1});
        
        progress = progress + 1;
        waitbar(progress/series_count,f, 'Proszê czekaæ');
    end
    close(f);
end