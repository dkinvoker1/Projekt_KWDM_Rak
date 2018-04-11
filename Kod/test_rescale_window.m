function varargout = test_rescale_window(varargin)
% TEST_RESCALE_WINDOW MATLAB code for test_rescale_window.fig
%      TEST_RESCALE_WINDOW, by itself, creates a new TEST_RESCALE_WINDOW or raises the existing
%      singleton*.
%
%      H = TEST_RESCALE_WINDOW returns the handle to a new TEST_RESCALE_WINDOW or the handle to
%      the existing singleton*.
%
%      TEST_RESCALE_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_RESCALE_WINDOW.M with the given input arguments.
%
%      TEST_RESCALE_WINDOW('Property','Value',...) creates a new TEST_RESCALE_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_rescale_window_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_rescale_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_rescale_window

% Last Modified by GUIDE v2.5 09-Apr-2018 15:45:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_rescale_window_OpeningFcn, ...
                   'gui_OutputFcn',  @test_rescale_window_OutputFcn, ...
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


% --- Executes just before test_rescale_window is made visible.
function test_rescale_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test_rescale_window (see VARARGIN)

% Choose default command line output for test_rescale_window
handles.output = hObject;
global img;
img = double(dicomread('gs.dcm'));
axes(handles.image_axes)
imshow(img, [])
axes(handles.scale_axes)
imshow(repmat(100:-1:1, 100, 1) + repmat(100:-1:1, 100, 1)', [])

h = handles.scale_axes;
h.UserData = handles.image_axes;
set(get(h,'Children'),'ButtonDownFcn',@nana)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test_rescale_window wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_rescale_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over axes background.
function scale_axes_ButtonDownFcn(hObject, eventdata, handles)

cords = get(hObject,'CurrentPoint')

function nana(s, e)
k = get(s, 'Parent');
global img;
cords = e.IntersectionPoint;
cords(end) = [];
axes(k.UserData);
max_val =  max(img(:) * cords(2)/200)
min_val =  min(img(:)) * cords(1)/200
rescaled = rescale_intensity(img,min_val, max_val);
imshow(rescaled,[])
