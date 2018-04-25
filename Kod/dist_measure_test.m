function varargout = dist_measure_test(varargin)
% DIST_MEASURE_TEST MATLAB code for dist_measure_test.fig
%      DIST_MEASURE_TEST, by itself, creates a new DIST_MEASURE_TEST or raises the existing
%      singleton*.
%
%      H = DIST_MEASURE_TEST returns the handle to a new DIST_MEASURE_TEST or the handle to
%      the existing singleton*.
%
%      DIST_MEASURE_TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIST_MEASURE_TEST.M with the given input arguments.
%
%      DIST_MEASURE_TEST('Property','Value',...) creates a new DIST_MEASURE_TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dist_measure_test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dist_measure_test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dist_measure_test

% Last Modified by GUIDE v2.5 23-Apr-2018 14:25:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dist_measure_test_OpeningFcn, ...
                   'gui_OutputFcn',  @dist_measure_test_OutputFcn, ...
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


% --- Executes just before dist_measure_test is made visible.
function dist_measure_test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dist_measure_test (see VARARGIN)

% Choose default command line output for dist_measure_test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dist_measure_test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dist_measure_test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
imshow(dicomread('gs.dcm'), [])
di = dicominfo('gs.dcm');

imgH = get(gca,'Children');

set(gcf, 'WindowButtonUpFcn', @measure_dist)
xData= get(imgH,'XData')*di.PixelSpacing(1); 
yData = get(imgH,'XData')*di.PixelSpacing(2);
set(gca, 'XLim', xData, 'YLim', yData)
set(imgH, 'XData', xData, 'YData', yData)
global clicked;
clicked = [];

function measure_dist(o, e)
global clicked;
if(~isempty(clicked))
    global spacing;
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
% 
 function blabla(pos)
     global clicked;
     if(~isempty(clicked))
         delete(clicked{1});
         clicked = [];         
     end
