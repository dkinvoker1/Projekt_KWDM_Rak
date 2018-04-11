function groups = devide(image,x1,x2,y1,y2,groups)
if size(x1:x2,2)>400
    max_var=20;
    
    img_var=var(var(image(x1:x2,y1:y2)));
    
    if img_var>max_var
        groups_number=max(max(groups(x1:x2,y1:y2)));
        
        groups_number=groups_number+1;
        groups(x1:x2/2,y1:y2/2)=groups_number;
        
        groups_number=groups_number+1;
        groups(x2/2:x2,y1:y2/2)=groups_number;
        
        groups_number=groups_number+1;
        groups(x1:x2/2,y2/2:y2)=groups_number;
        
        groups_number=groups_number+1;
        groups(x2/2:x2,y2/2:y2)=groups_number;
        
        groups = devide(image,x1,x2/2,y1,y2/2,groups);
        groups = devide(image,x2/2,x2,y1,y2/2,groups);
        groups = devide(image,x1,x2/2,y2/2,y2,groups);
        groups = devide(image,x2/2,x2,y2/2,y2,groups);
    end
end
end