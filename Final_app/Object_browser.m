function varargout = Object_browser(varargin)
% OBJECT_BROWSER MATLAB code for Object_browser.fig
%      OBJECT_BROWSER, by itself, creates a new OBJECT_BROWSER or raises the existing
%      singleton*.
%
%      H = OBJECT_BROWSER returns the handle to a new OBJECT_BROWSER or the handle to
%      the existing singleton*.
%
%      OBJECT_BROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OBJECT_BROWSER.M with the given input arguments.
%
%      OBJECT_BROWSER('Property','Value',...) creates a new OBJECT_BROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Object_browser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Object_browser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Object_browser

% Last Modified by GUIDE v2.5 09-May-2018 19:41:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Object_browser_OpeningFcn, ...
                   'gui_OutputFcn',  @Object_browser_OutputFcn, ...
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


% --- Executes just before Object_browser is made visible.
function Object_browser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Object_browser (see VARARGIN)

% Choose default command line output for Object_browser
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Object_browser wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global objects_vol mask_index 
mask_index = 1;

image_in_series = size(objects_vol{mask_index},3);

handles.slider_slice.Min = 1;
handles.slider_slice.Max = image_in_series;
handles.slider_slice.SliderStep = [1/(image_in_series-1), 0.1];

handles.slider_slice.Value = 1;

masks_string = cell(1, length(objects_vol));
for i = 1:length(objects_vol)
    masks_string{i} = ['maska' num2str(i)];
end

handles.pop_object.String = masks_string;

show_mask(1, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Object_browser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in pop_object.
function pop_object_Callback(hObject, eventdata, handles)
% hObject    handle to pop_object (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  mask_index
mask_index = hObject.Value;

value = handles.slider_slice.Value;
show_mask(value, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns pop_object contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_object


% --- Executes during object creation, after setting all properties.
function pop_object_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_object (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_slice_Callback(hObject, eventdata, handles)
% hObject    handle to slider_slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value = round(hObject.Value);
hObject.Value = value;

show_mask(value, handles);

% --- Executes during object creation, after setting all properties.
function slider_slice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function show_mask(slice, handles)
global info objects_vol mask_index 

axes(handles.axes_img)
imshow(objects_vol{mask_index}(:,:,slice))

pixelSpaxing = info.PixelSpacing;
current_object = objects_vol{mask_index}(:,:,slice);
current_area = sum(current_object(:)).*pixelSpaxing(1).*pixelSpaxing(2)/100;

sliceThickness = info.SliceThickness;
volume = sum(objects_vol{mask_index}(:)).*pixelSpaxing(1).*pixelSpaxing(2).*sliceThickness/1000;

handles.txt_area.String = num2str(current_area);
handles.txt_volume.String = num2str(volume);


