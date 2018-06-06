function varargout = test_painter_window(varargin)
% TEST_PAINTER_WINDOW MATLAB code for test_painter_window.fig
%      TEST_PAINTER_WINDOW, by itself, creates a new TEST_PAINTER_WINDOW or raises the existing
%      singleton*.
%
%      H = TEST_PAINTER_WINDOW returns the handle to a new TEST_PAINTER_WINDOW or the handle to
%      the existing singleton*.
%
%      TEST_PAINTER_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_PAINTER_WINDOW.M with the given input arguments.
%
%      TEST_PAINTER_WINDOW('Property','Value',...) creates a new TEST_PAINTER_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_painter_window_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_painter_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_painter_window

% Last Modified by GUIDE v2.5 11-Apr-2018 19:56:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_painter_window_OpeningFcn, ...
                   'gui_OutputFcn',  @test_painter_window_OutputFcn, ...
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

global event_lock
% --- Executes just before test_painter_window is made visible.
function test_painter_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test_painter_window (see VARARGIN)

% Choose default command line output for test_painter_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test_painter_window wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_painter_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;

function image_axes_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
axes(hObject);
img = double(dicomread('gs.dcm'));
img = img - min(img(:));
img = img / max(img(:));
img = repmat(img, 1, 1, 3);
imshow(img,[]);
set(gcf,'WindowButtonMotionFcn',@paint_it_red)
child = get(hObject,'Children');
set(child, 'ButtonDownFcn', @start_painting)
set(gcf, 'WindowButtonUpFcn', @stop_painting)

r = 5;
n = 0;
SE = strel('disk',r,n);
ball = SE.Neighborhood;

hObject.UserData = struct('img', img, 'ball', ball, 'mask', false(size(img(:,:,1))));

handles.image_axes = gca;
guidata(gca, handles);




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


% --- Executes when selected object is changed in pointers_grp.
function pointers_grp_SelectionChangedFcn(hObject, eventdata, handles)
axes = handles.image_axes;
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

function start_painting(img_handle, event_data)
    global event_lock;
    event_lock = 1;

function stop_painting(img_handle, event_data)
    global event_lock;
    event_lock = 0;

function paint_it_red(fig_handle, event_data)
global event_lock;

if(event_lock)
event_lock = 0;
% PAINTING FUNCTION
handles = get(fig_handle, 'Children');
img_handle = get(handles(3), 'Children');
img = img_handle.CData;
cords = round(event_data.IntersectionPoint);
cords(end) = [];

parent = get(img_handle, 'Parent');
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

        % change pixels value
        img(:,:, 1) = img(:,:, 1) + mask;
        img(img > 1) = 1;

        img_handle.CData = img;
        event_lock = 1;
    end
end

function erase(fig_handle, event_data )
% ERASING FUNCTION
global event_lock;

if(event_lock)
event_lock = 0;
% PAINTING FUNCTION
handles = get(fig_handle, 'Children');
img_handle = get(handles(3), 'Children');
img = img_handle.CData;
cords = round(event_data.IntersectionPoint);
cords(end) = [];

parent = get(img_handle, 'Parent');
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

        % change pixels value
        img(:,:, 1) = img(:,:, 1) - mask;
        indexes = img(:,:,1) <= 0;
        img_red = img(:,:,1);
        img_green = img(:,:,2);
        img_red(indexes) = img_green(indexes);
        img(:,:,1) = img_red;

        img_handle.CData = img;
        event_lock = 1;
    end
end


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
