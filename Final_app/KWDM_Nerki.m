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

global dcmaet dcmaec peer port pacs_config
load config.mat
pacs_config = config;
if ~isempty(config)
    config_list = [pacs_config{:}];
    config_list = {config_list.Name};
    handles.pop_pacs.String = config_list;
    handles.pop_pacs.Value = 1;
    
    dcmaet = pacs_config{1}.AET;
    dcmaec = pacs_config{1}.AEC;
    peer = pacs_config{1}.Peer;
    port = pacs_config{1}.Port;
else
    handles.pop_pacs.String = '';
end


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

new_series = {};
global masks_list
masks_list = {};

ser_id = 1;
mas_id = 1;
for i = 1:length(series_list)
   if strcmp(series_list{i}(1:5), 'Maska')
       masks_list{mas_id} = series{i};
       mas_id = mas_id + 1;
   else
       new_series{ser_id} = series{i};
       ser_id = ser_id + 1;
   end
end

series = new_series;

series_list = [series{:}];
series_list = {series_list.SeriesUID};

handles.lb_series.String = series_list;

if ~isempty(masks_list)
    mas_list = [masks_list{:}];
    mas_list = {mas_list.SeriesUID};

    handles.lb_masks.String = mas_list;
else
	handles.lb_masks.String = '';
end


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
global dcmaet dcmaec peer port pacs_config conf_index
global patients
clear_images();

conf_index = handles.pop_pacs.Value;
dcmaet = pacs_config{conf_index}.AET;
dcmaec = pacs_config{conf_index}.AEC;
peer = pacs_config{conf_index}.Peer;
port = pacs_config{conf_index}.Port;

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

wl = handles.slider_WL.Value;
ww = handles.slider_WW.Value;

image_show = image_adjust(I, wl, ww);

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


% --- Executes on button press in btn_active_conturs.
function btn_active_conturs_Callback(hObject, eventdata, handles)
% hObject    handle to btn_active_conturs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global images masks index_selected
wl = handles.slider_WL.Value;
ww = handles.slider_WW.Value;

new_mask = Iterative_activecontour(images, wl, ww, masks, index_selected);

for i = 1:length(masks)
   if ~isempty(masks{i})
       masks{i} = masks{i} | new_mask{i};  
   else
       masks{i} = new_mask{i};  
   end
end
show_image(index_selected, handles);


% --- Executes on selection change in lb_masks.
function lb_masks_Callback(hObject, eventdata, handles)
% hObject    handle to lb_masks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_masks contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_masks
global dcmaet dcmaec peer port 
global patients studies masks_list masks index_selected
 
index_selected = handles.lb_patients.Value;
patient = patients{index_selected};
patient_id = patient.PatientId;

index_selected = handles.lb_studies.Value;
study = studies{index_selected};
study_uid = study.StudyUID;

index_selected = handles.lb_series.Value;
serie = masks_list{index_selected};
series_uid = serie.SeriesUID;


clear_masks();

[info, masks_4D, spatial] = get_masks(dcmaet, dcmaec, peer, port, patient_id, study_uid, series_uid);

masks = {};
for i = 1:size(masks_4D, 4)
    masks{i} = double(masks_4D(:,:,1,i));
end

value = round(handles.slider_series.Value);
handles.slider_series.Value = value;

index_selected = value;

%% show image
axes(handles.axes_image);
show_image(index_selected, handles);




% --- Executes during object creation, after setting all properties.
function lb_masks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_masks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_pacs.
function pop_pacs_Callback(hObject, eventdata, handles)
% hObject    handle to pop_pacs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_pacs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_pacs
global dcmaet dcmaec peer port
global conf_index pacs_config
conf_index = hObject.Value;
    
dcmaet = pacs_config{conf_index}.AET;
dcmaec = pacs_config{conf_index}.AEC;
peer = pacs_config{conf_index}.Peer;
port = pacs_config{conf_index}.Port;


% --- Executes during object creation, after setting all properties.
function pop_pacs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_pacs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_add.
function btn_add_Callback(hObject, eventdata, handles)
% hObject    handle to btn_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global edition conf_index popup
edition = false;
conf_index = handles.pop_pacs.Value;
popup = handles.pop_pacs;
PACS_confif();


% --- Executes on button press in btn_delete.
function btn_delete_Callback(hObject, eventdata, handles)
% hObject    handle to btn_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pacs_config
conf_index = handles.pop_pacs.Value;
new_conf = {};
ind = 1;
for i = 1:length(pacs_config)
   if i ~= conf_index
       new_conf{ind} = pacs_config{ind};
       ind = ind + 1;
   end
end
pacs_config = new_conf;
config_list = [pacs_config{:}];
config_list = {config_list.Name};
handles.pop_pacs.Value = 1;
handles.pop_pacs.String = config_list;
config = pacs_config;
save('config.mat', 'config');


% --- Executes on button press in btn_edit.
function btn_edit_Callback(hObject, eventdata, handles)
% hObject    handle to btn_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global edition conf_index popup
edition = true;
conf_index = handles.pop_pacs.Value;
popup = handles.pop_pacs;
PACS_confif();
