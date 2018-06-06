function new_mask = Iterative_activecontour(serie, wl, ww, mask, image_number)
    new_mask = cell(1,size(mask,3));
    new_mask{image_number} = mask{image_number};
    
    series_count = size(serie,4);
    progress = 0;
    f = waitbar(progress,'Proszê czekaæ');
    for i=(image_number-1):-1:1
        new_mask{i} = zeros(size(new_mask{i+1},1), size(new_mask{i+1}, 2));
        objects = bwlabel(new_mask{i+1});
        new_m = activecontour(image_adjust(serie(:,:,1,i), wl, ww), new_mask{i+1});
        
        new_labels = bwlabel(new_m);

        % dla wiêkszej liczby obiektów w masce wejœciowej!
        for k = 1:max(objects(:))
            obj = objects == k;
            
            common_area = new_labels .* obj;
          	label_count = zeros(1, max(common_area(:)));
            for j = 1:max(common_area(:))
                label_count(j) = sum(common_area(:) == j);
            end
            
            [~, ind] = max(label_count);
            if (isempty(label_count)) || (max(label_count) == 0)
                break;
            end
            
            new_mask{i} = new_mask{i} | (new_labels == ind);
        end
             
        progress = progress + 1;
        waitbar(progress/series_count,f, 'Proszê czekaæ');
    end
    for i=(image_number+1):1:series_count
        new_mask{i} = zeros(size(new_mask{i-1},1), size(new_mask{i-1}, 2));
        objects = bwlabel(new_mask{i-1});
        new_m = activecontour(image_adjust(serie(:,:,1,i), wl, ww), new_mask{i-1});
        
        new_labels = bwlabel(new_m);
        common_area = new_labels .* new_mask{i-1};
        label_count = zeros(1, max(common_area(:)));
        % dla wiêkszej liczby obiektów w masce wejœciowej!
        for k = 1:max(objects(:))
            obj = objects == k;
            
            common_area = new_labels .* obj;
            for j = 1:max(common_area(:))
                label_count(j) = sum(common_area(:) == j);
            end
            
            [~, ind] = max(label_count);
            if (isempty(label_count)) || (max(label_count) == 0)
                break;
            end
            
            new_mask{i} = new_mask{i} | (new_labels == ind);
        end
        
        progress = progress + 1;
        waitbar(progress/series_count,f, 'Proszê czekaæ');
    end
    close(f);
end