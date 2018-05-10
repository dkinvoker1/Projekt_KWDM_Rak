function varargout = KWDM_Nerki(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @KWDM_Nerki_OpeningFcn, ...
                   'gui_OutputFcn',  @KWDM_Nerki_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before KWDM_Nerki is made visible.
function KWDM_Nerki_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for KWDM_Nerki
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes KWDM_Nerki wait for user response (see UIRESUME)
% uiwait(handles.figure1);
initialize();

global dcmaet dcmaec peer port
dcmaet = 'KLIENTL';
dcmaec = 'ARCHIWUM';
peer = '127.0.0.1';
port = '10110';



% --- Outputs from this function are returned to the command line.
function varargout = KWDM_Nerki_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on selection change in lb_patients.
function lb_patients_Callback(hObject, eventdata, handles)
global dcmaet dcmaec peer port
global patients studies
clear_images();

index_selected = get(hObject,'Value');
patient = patients{index_selected};

studies = get_studies(dcmaet, dcmaec, peer, port, patient.PatientId);
studies_list = [studies{:}];
studies_list = {studies_list.StudyUID};

handles.lb_studies.String = studies_list;


% --- Executes during object creation, after setting all properties.
function lb_patients_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_patients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_studies.
function lb_studies_Callback(hObject, eventdata, handles)
global dcmaet dcmaec peer port
global patients studies series index_selected
clear_images();

index_selected = handles.lb_patients.Value;
patient = patients{index_selected};

index_selected = hObject.Value;
study = studies{index_selected};

series = get_series(dcmaet, dcmaec, peer, port, patient.PatientId, study.StudyUID);
series_list = [series{:}];
series_list = {series_list.SeriesUID};

handles.lb_series.String = series_list;


% --- Executes during object creation, after setting all properties.
function lb_studies_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_series.
function lb_series_Callback(hObject, eventdata, handles)
global dcmaet dcmaec peer port
global patients studies series images info spatial

global previous_series 

    
    index_selected = handles.lb_patients.Value;
    patient = patients{index_selected};
    patient_id = patient.PatientId;
    
    index_selected = handles.lb_studies.Value;
    study = studies{index_selected};
    study_uid = study.StudyUID;
    
    index_selected = hObject.Value;
    serie = series{index_selected};
    series_uid = serie.SeriesUID;
    
if ~strcmp(previous_series, serie.SeriesUID)
    clear_images();
    
    [info, images, spatial] = get_images(dcmaet, dcmaec, peer, port, patient_id, study_uid, series_uid);
    
    previous_series = series_uid;
    %% intensity sliders
    I_max = max(images(:));
    I_min = min(images(:));
    handles.slider_WL.Min = I_min;
    handles.slider_WL.Max = I_max;
    
    handles.slider_WL.Value = 60;
    
    handles.slider_WW.Min = 1;
    handles.slider_WW.Max = I_max - I_min;
    
    handles.slider_WW.Value = 400;
    
    %% prepare mask
    image_in_series = size(images, 4);
    
    global masks
    masks = cell(1, image_in_series);
    
    %% show image
    axes(handles.axes_image);
    show_image(1, handles);
    
    %% set series slider
    handles.txt_img.String = 1;
    handles.txt_all_img.String = image_in_series;
    
    handles.slider_series.Value = 1;
    
    
    handles.slider_series.Min = 1;
    handles.slider_series.Max = image_in_series;
    handles.slider_series.SliderStep = [1/(image_in_series-1), 0.1];
end


% --- Executes during object creation, after setting all properties.
function lb_series_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_patients.
function btn_patients_Callback(hObject, eventdata, handles)
global dcmaet dcmaec peer port
global patients 
clear_images();

patients = get_patients(dcmaet, dcmaec, peer, port);
patients_list = [patients{:}];
names_list = {patients_list.PatientName};

handles.lb_patients.String = names_list;

% --- Executes on slider movement.
function slider_series_Callback(hObject, eventdata, handles)
value = round(hObject.Value);
hObject.Value = value;

global index_selected
index_selected = value;

show_image(value, handles);

% --- Executes during object creation, after setting all properties.
function slider_series_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function show_image(index, handles)
global images masks

I = images(:,:,1,index);

image_show = im2double(I);
image_show = mat2gray(image_show);

I_max = double(max(I(:)));
I_min = double(min(I(:)));

wl = handles.slider_WL.Value;
ww = handles.slider_WW.Value;

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

if (~isempty(masks)) && (~isempty(masks{index}))
    image_show = setmask(image_show, masks{index});
end
handles.axes_image;
imshow(image_show, []);

handles.txt_img.String = index;


%% MW POMIAR ODLEG£OŒCI
% --- Executes on button press in btn_distance_measure.
function btn_distance_measure_Callback(hObject, eventdata, handles)
% hObject    handle to btn_distance_measure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global info counter
counter = 0;
% imgH = get(gca,'Children');
child = get(handles.axes_image, 'Children');
set(child, 'ButtonDownFcn', '');
set(gcf, 'WindowButtonUpFcn', '');

set(gcf, 'WindowButtonUpFcn', @measure_dist);
% xData= get(imgH,'XData')*info.PixelSpacing(1); 
% yData = get(imgH,'XData')*info.PixelSpacing(2);
% set(gca, 'XLim', xData, 'YLim', yData);
% set(imgH, 'XData', xData, 'YData', yData);
global clicked;
clicked = [];


function measure_dist(o, e)
global clicked counter
counter = counter + 1;
if(~isempty(clicked))
    delete(clicked{1});
    old_pos = clicked{2};
    cur_pos = e.IntersectionPoint;
    line = imdistline(gca, [old_pos(1), cur_pos(1)], [old_pos(2), cur_pos(2)]);
    setLabelTextFormatter(line, '%0.2fmm');
    
    addNewPositionCallback(line, @blabla);
    clicked = [];
else
    pos = e.IntersectionPoint;
    pos(end) = [];
    clicked = {impoint(gca, pos), pos};
end
if counter >= 2
    set(gcf, 'WindowButtonUpFcn', '')
end
% 
 function blabla(pos)
     global clicked;
     if(~isempty(clicked))
         delete(clicked{1});
         clicked = [];         
     end
     
%% MW rêczna segmentacja
% --- Executes when selected object is changed in pointers_grp.
function pointers_grp_SelectionChangedFcn(hObject, eventdata, handles)
axes = handles.axes_image;
new_data = axes.UserData;
new_data.ball = initialize_ball(eventdata.NewValue.UserData, 4);
handles.image_axes.UserData = new_data;

% --- Executes when selected object is changed in tools_grp.
function tools_grp_SelectionChangedFcn(hObject, eventdata, handles)
selected = eventdata.NewValue.String;
switch(selected)
    case 'Marker'
        set(gcf,'WindowButtonMotionFcn',@paint_it_red)
    case 'Eraser'
        set(gcf,'WindowButtonMotionFcn',@erase)
end


% --- Executes during object creation, after setting all properties.
function small_pointer_CreateFcn(hObject, eventdata, handles)
ball = initialize_ball(4,0);
img = initialize_pointer_image(ball);
axes(hObject)
imshow(img,[])
hObject.UserData = ball;


% --- Executes during object creation, after setting all properties.
function medium_pointer_CreateFcn(hObject, eventdata, handles)
ball = initialize_ball(10,0);
img = initialize_pointer_image(ball);
axes(hObject)
imshow(img,[])
hObject.UserData = ball;


% --- Executes during object creation, after setting all properties.
function big_pointer_CreateFcn(hObject, eventdata, handles)
ball = initialize_ball(20,0);
img = initialize_pointer_image(ball);
axes(hObject)
imshow(img,[]);
hObject.UserData = ball;

% --- Executes on button press in btn_tool.
function btn_tool_Callback(hObject, eventdata, handles)
global images index_selected masks
set(gcf, 'WindowButtonUpFcn', '')

set(gcf,'WindowButtonMotionFcn',@paint_it_red)
child = get(handles.axes_image, 'Children');
set(child, 'ButtonDownFcn', @start_painting)
set(gcf, 'WindowButtonUpFcn', @stop_painting)

selected = handles.tools_grp.SelectedObject.String;
switch(selected)
    case 'Marker'
        set(gcf,'WindowButtonMotionFcn',@paint_it_red)
    case 'Eraser'
        set(gcf,'WindowButtonMotionFcn',@erase)
end

ball = initialize_ball(handles.pointers_grp.SelectedObject.UserData, 4);

old_mask = false(size(images(:,:,1,index_selected)));
if ~isempty(masks{index_selected})
    old_mask = masks{index_selected};
end
    
handles.image_axes.UserData = struct('img', images(:,:,1,index_selected), 'ball', ball, 'mask', old_mask);

handles.image_axes = gca;
guidata(gca, handles);


function ball = initialize_ball(r, n)
n=0;
SE = strel('disk',r,n);
ball = SE.Neighborhood;

function ball_img = initialize_pointer_image(ball)
ball_img = zeros(50);

cords = ceil(size(ball_img)/2) + 1;

s = size(ball);
rows = s(1);
columns = s(2);

first_row = cords(1) - ceil(rows/2) - 1;
first_col = cords(2) - ceil(columns/2) - 1;

last_row = first_row + rows - 1;
last_col = first_col + columns - 1;

ball_img(first_col:last_col, first_row:last_row) = ball;


function start_painting(img_handle, event_data)
    global event_lock;
    event_lock = 1;

function stop_painting(img_handle, event_data)
    global event_lock;
    event_lock = 0;

function paint_it_red(fig_handle, event_data)
global event_lock;
global masks index_selected

if(event_lock)
event_lock = 0;
% PAINTING FUNCTION
handles = get(fig_handle, 'Children');
img_handle = get(handles(end), 'Children');
img = img_handle(end).CData;
cords = round(event_data.IntersectionPoint);
cords(end) = [];

parent = get(img_handle(end), 'Parent');
ball = parent.UserData.ball;
s = size(ball);
rows_count = s(1);
columns_count = s(2);

    if(all(cords <= size(img(:,:,1)) - size(ball)/2))

        first_row = cords(1) - floor(rows_count/2);
        first_col = cords(2) - floor(columns_count/2);
        
        last_row = first_row + rows_count - 1;
        last_col = first_col + columns_count - 1;
        
        rows = first_row:last_row;
        cols = first_col:last_col;
        
        mask = false(size(img(:,:,1)));
        mask(cols, rows) = ball(1:rows_count, 1:columns_count);
        bin_img = parent.UserData.mask;
        bin_img = bin_img | mask;
        parent.UserData.mask = bin_img;

        masks{index_selected} = bin_img;
        % change pixels value
        if size(img, 3) == 1
            img = cat(3, img, img, img);
        end
        img(:,:, 1) = img(:,:, 1) + mask;
        img(img > 1) = 1;
        img = mat2gray(img);

        img_handle(end).CData = img;
        event_lock = 1;
    end
end

function erase(fig_handle, event_data )
% ERASING FUNCTION
global event_lock;
global masks index_selected

if(event_lock)
event_lock = 0;
% PAINTING FUNCTION
handles = get(fig_handle, 'Children');
img_handle = get(handles(end), 'Children');
img = img_handle(end).CData;
cords = round(event_data.IntersectionPoint);
cords(end) = [];

parent = get(img_handle(end), 'Parent');
ball = parent.UserData.ball;
s = size(ball);
rows_count = s(1);
columns_count = s(2);

    if(all(cords <= size(img(:,:,1)) - size(ball)/2))

        first_row = cords(1) - floor(rows_count/2);
        first_col = cords(2) - floor(columns_count/2);
        
        last_row = first_row + rows_count - 1;
        last_col = first_col + columns_count - 1;
        
        rows = first_row:last_row;
        cols = first_col:last_col;
        
        mask = false(size(img(:,:,1)));
        mask(cols, rows) = ball(1:rows_count, 1:columns_count);
        bin_img = parent.UserData.mask;
        bin_img = bin_img & ~mask;
        parent.UserData.mask = bin_img;
        
        masks{index_selected} = bin_img;

        % change pixels value
        img(:,:, 1) = img(:,:, 1) - mask;
        indexes = img(:,:,1) <= 0;
        img_red = img(:,:,1);
        img_green = img(:,:,2);
        img_red(indexes) = img_green(indexes);
        img(:,:,1) = img_red;

        img_handle(end).CData = img;
        event_lock = 1;
    end
end

%% DL
function img_mask = setmask(img, mask)
    if size(img, 3) == 1
        img = cat(3, img, img, img);
    end
    img(:,:, 1) = img(:,:, 1) + mask;
    img(img > 1) = 1;
    img_mask = mat2gray(img);


% --- Executes on button press in btn_segmentation.
function btn_segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to btn_segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global images index_selected masks
map = Segmentacja(double(images(:,:,1,index_selected)));
if isempty(masks{index_selected})
    masks{index_selected} = zeros(size(images,1), size(images,2));
end
masks{index_selected} = masks{index_selected} | map; 

show_image(index_selected, handles);


% --- Executes on slider movement.
function slider_WL_Callback(hObject, eventdata, handles)
% hObject    handle to slider_WL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global index_selected
show_image(index_selected, handles);

% --- Executes during object creation, after setting all properties.
function slider_WL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_WL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_WW_Callback(hObject, eventdata, handles)
% hObject    handle to slider_WW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global index_selected
show_image(index_selected, handles);

% --- Executes during object creation, after setting all properties.
function slider_WW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_WW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btn_default.
function btn_default_Callback(hObject, eventdata, handles)
% hObject    handle to btn_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.slider_WL.Value = 60;
handles.slider_WW.Value = 400;

global index_selected
show_image(index_selected, handles);


% --- Executes on button press in btn_params.
function btn_params_Callback(hObject, eventdata, handles)
% hObject    handle to btn_params (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global masks index_selected images objects_vol

current_mask = masks{index_selected};
objects = bwlabel(current_mask);
objects_count = max(objects(:));

objects_3D = cell(objects_count, length(masks));

objects_vol = cell(1,objects_count);
for i = 1:objects_count
    obj = objects == i;
    objects_3D{i, index_selected} = obj;
    % go up
    for j = (index_selected+1):length(masks)
        common_area = 0;
        if ~isempty(masks{j})
            common_area =  objects_3D{i, j-1} .* masks{j};
        end
        if max(common_area(:)) > 0
             objects_3D{i, j} = imreconstruct(logical(common_area),masks{j});
        else 
            break;
        end
    end
    % go down
    for k = (index_selected-1):-1:1
        common_area = 0;
        if ~isempty(masks{k})
            common_area =  objects_3D{i, k+1} .* masks{k};
        end
        if max(common_area(:)) > 0
             objects_3D{i, k} = imreconstruct(logical(common_area),masks{k});
        else
            break;
        end
    end
    
    objects_vol{i} = zeros(size(images, 1), size(images, 2), size(images, 4));
    for m = 1:length(masks)
        if ~isempty(objects_3D{i, m})
            objects_vol{i}(:,:,m) = objects_3D{i, m};
        end
    end
end

Object_browser();



% --- Executes on button press in btn_clear.
function btn_clear_Callback(hObject, eventdata, handles)
% hObject    handle to btn_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global masks index_selected
masks{index_selected} = zeros(size(masks{index_selected}));
show_image(index_selected, handles);


% --- Executes on button press in btn_save_results.
function btn_save_results_Callback(hObject, eventdata, handles)
% hObject    handle to btn_save_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global masks info spatial series

path = 'Results\';

series_index = length(series) + 1;

info.SeriesInstanceUID = [sprintf('Maska_%03d_', series_index) info.SeriesInstanceUID];
for i = 1:length(masks)
    info.SliceLocation =  spatial.PatientPositions(i, 3);
    info.ImagePositionPatient(3) =  spatial.PatientPositions(i, 3);
    
    cur_mask = zeros(info.Rows, info.Columns);
    if ~isnan(masks{i})
        cur_mask = masks{i};
    end
    dicomwrite(cur_mask, [path 'mask' num2str(i)], info);
end

global dcmaet dcmaec peer port
send_mask(dcmaet, dcmaec, peer, port);

lb_studies_Callback(handles.lb_studies, eventdata, handles)
