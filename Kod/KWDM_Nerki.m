function varargout = KWDM_Nerki(varargin)
% KWDM_NERKI MATLAB code for KWDM_Nerki.fig
%      KWDM_NERKI, by itself, creates a new KWDM_NERKI or raises the existing
%      singleton*.
%
%      H = KWDM_NERKI returns the handle to a new KWDM_NERKI or the handle to
%      the existing singleton*.
%
%      KWDM_NERKI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KWDM_NERKI.M with the given input arguments.
%
%      KWDM_NERKI('Property','Value',...) creates a new KWDM_NERKI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before KWDM_Nerki_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to KWDM_Nerki_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help KWDM_Nerki

% Last Modified by GUIDE v2.5 15-Dec-2017 15:56:45

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
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to KWDM_Nerki (see VARARGIN)

% Choose default command line output for KWDM_Nerki
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.min_slider, 'Enable', 'off');
set(handles.max_slider, 'Enable', 'off');
set(handles.btn_analyse, 'Enable', 'off');

global selecting_object
selecting_object = 'left';

global left_kidney right_kidney background Imax
Imax = [];
left_kidney = [];
right_kidney = [];
background = [];

set(handles.im_fig,'YTickLabel',[])
set(handles.im_fig,'XTickLabel',[])
% UIWAIT makes KWDM_Nerki wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = KWDM_Nerki_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in choose_dir.
function choose_dir_Callback(hObject, eventdata, handles)
dir_path = uigetdir();

% initializing image paths
global image_paths 
image_paths = dir(strcat(dir_path,'\*.dcm'));
image_paths = string({image_paths.name});
image_paths = strcat(dir_path,'\', image_paths);
% ZAKOMENTOWANE PRZEZ MW NA POTRZEBY PREZENTACJI
%global time
%time = load([dir_path '/time.mat']);

% ploting the first image
axes(handles.im_fig);
image_path = char(image_paths(1));
I = dicomread(image_path);
imshow(I,[]);

global patientName
info = dicominfo(image_path);
patientName = info.PatientName.FamilyName;

% turning off and on the controls
% set(handles.guide, 'String', 'Wybierz sposób wyboru regionu, zdjêcie z widocznymi nerkami i naciœnij przycisk');

set(handles.min_slider, 'Value', 1);
set(handles.max_slider, 'Value', 1);

set(handles.min_slider, 'Enable', 'on');
set(handles.max_slider, 'Enable', 'on');
set(handles.btn_analyse, 'Enable', 'on');

set(handles.min_slider, 'Max', length(image_paths));
set(handles.max_slider, 'Max', length(image_paths));

set(handles.min_slider, 'SliderStep', [1/length(image_paths) , 10/length(image_paths) ]);
set(handles.max_slider, 'SliderStep', [1/length(image_paths) , 10/length(image_paths) ]);

set(handles.choose_region_box,'Enable', 'on');
set(handles.accept_method, 'Enable', 'on');
global left_kidney right_kidney background Imax
Imax = I;
left_kidney = [];
right_kidney = [];
background = [];

global left_kidney_mask right_kidney_mask background_mask 
left_kidney_mask = [];
right_kidney_mask = [];
background_mask = [];


% --- Executes on selection change in choose_region_box.
function choose_region_box_Callback(hObject, eventdata, handles)
% hObject    handle to choose_region_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns choose_region_box contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choose_region_box


% --- Executes during object creation, after setting all properties.
function choose_region_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choose_region_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function min_slider_Callback(hObject, eventdata, handles)
actual_value = round(get(hObject,'Value'));
max_value = round(get(handles.max_slider,'Value'));
if actual_value > max_value
    set(handles.max_slider,'Value', actual_value);
    max_value = actual_value;
end
global image_paths Imax


for i = actual_value:max_value
    if i == actual_value
        Imax = dicomread(char(image_paths(i)));
    else 
        Imax = max(Imax, dicomread(char(image_paths(i))));
    end
end

drawSelection(handles)

% --- Executes during object creation, after setting all properties.
function min_slider_CreateFcn(hObject, eventdata, handles)

% hObject    handle to min_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function max_slider_Callback(hObject, eventdata, handles)
actual_value = round(get(hObject,'Value'));
min_value = round(get(handles.min_slider,'Value'));
if actual_value < min_value
    set(handles.min_slider,'Value', actual_value);
    min_value = actual_value;
end

global image_paths Imax;

for i = min_value:actual_value
    if i == min_value
        Imax = dicomread(char(image_paths(i)));
    else 
        Imax = max(Imax, dicomread(char(image_paths(i))));
    end
end

drawSelection(handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function max_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in accept_method.
function accept_method_Callback(hObject, eventdata, handles)
% set(handles.guide, 'String', 'Wska¿ lew¹ nerkê');

box_value = get(handles.choose_region_box, 'Value');


axes(handles.im_fig), po=Choose_Region(box_value);
pos = po.getPosition;
mask = po.createMask;

% drawing on image

if(box_value ==1)
x = pos(1);
x1 = pos(1)+pos(3);
y = pos(2);
y1 = pos(2)+pos(4);

pos = [x,y;
    x1,y;
    x1,y1;
    x,y1
    x, y];
else
    pos(end+1,:) = pos(1,:);
end

selection = pos;

global left_kidney right_kidney background selecting_object
global left_kidney_mask right_kidney_mask background_mask

switch selecting_object
    case 'left'
        left_kidney = selection;
        left_kidney_mask = mask;
    case 'right'
        right_kidney = selection;
        right_kidney_mask = mask;
    case 'background'
        background = selection;
        background_mask = mask;
end

set(handles.max_slider, 'Enable', 'on');
set(handles.min_slider, 'Enable', 'on');

drawSelection(handles)


% --- Executes when selected object is changed in group_selection_type.
function group_selection_type_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in group_selection_type 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selecting_object
switch hObject.String
    case 'Prawa nerka'
        selecting_object = 'right';
    case 'Lewa nerka'
        selecting_object = 'left';
    case 'T³o'
        selecting_object = 'background';
end


function drawSelection(handles)
global Imax left_kidney right_kidney background
axes(handles.im_fig)
imshow(Imax, [])
hold on
if ~isempty(left_kidney)
    plot(left_kidney(:,1), left_kidney(:,2), 'r');
end
if ~isempty(right_kidney)
    plot(right_kidney(:,1), right_kidney(:,2), 'g');
end
if ~isempty(background)
    plot(background(:,1), background(:,2), 'b');
end
hold off


% --- Executes on button press in btn_analyse.
function btn_analyse_Callback(hObject, eventdata, handles)
global left_kidney_mask right_kidney_mask background_mask image_paths time patientName
if ~(isempty(left_kidney_mask) || isempty(right_kidney_mask) || isempty(background_mask))

[left_kidney_flow, right_kidney_flow] = Get_Flows_Data(image_paths, left_kidney_mask, right_kidney_mask, background_mask);

% Results_GUI(right_kidney_flow, left_kidney_flow);

figure('Name',patientName)
subplot(2,2,1)
Draw_Flow_With_Phases(left_kidney_flow, time.time);
title('Lewa nerka');
axis('tight')

subplot(2,2,2)
Draw_Flow_With_Phases(right_kidney_flow, time.time);
title('Prawa nerka');
axis('tight')

subplot(2,2,[3,4])
Draw_Pie_Chart(left_kidney_flow, right_kidney_flow);
title('Udzia³ nerek w oczyszczaniu krwi')
axis('tight')

end
