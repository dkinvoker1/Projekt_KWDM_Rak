function varargout = PACS_confif(varargin)
% PACS_CONFIF MATLAB code for PACS_confif.fig
%      PACS_CONFIF, by itself, creates a new PACS_CONFIF or raises the existing
%      singleton*.
%
%      H = PACS_CONFIF returns the handle to a new PACS_CONFIF or the handle to
%      the existing singleton*.
%
%      PACS_CONFIF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PACS_CONFIF.M with the given input arguments.
%
%      PACS_CONFIF('Property','Value',...) creates a new PACS_CONFIF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PACS_confif_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PACS_confif_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PACS_confif

% Last Modified by GUIDE v2.5 17-May-2018 11:57:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PACS_confif_OpeningFcn, ...
                   'gui_OutputFcn',  @PACS_confif_OutputFcn, ...
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


% --- Executes just before PACS_confif is made visible.
function PACS_confif_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PACS_confif (see VARARGIN)

% Choose default command line output for PACS_confif
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PACS_confif wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global pacs_config conf_index edition
if edition
    config = pacs_config{conf_index};
    handles.et_name.String = config.Name;
    handles.et_name.Enable = 'off';
    handles.et_peer.String = config.Peer;
    handles.et_port.String = config.Port;
    handles.et_aet.String = config.AET;
    handles.et_aec.String = config.AEC;
end



% --- Outputs from this function are returned to the command line.
function varargout = PACS_confif_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function et_name_Callback(hObject, eventdata, handles)
% hObject    handle to et_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_name as text
%        str2double(get(hObject,'String')) returns contents of et_name as a double


% --- Executes during object creation, after setting all properties.
function et_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_peer_Callback(hObject, eventdata, handles)
% hObject    handle to et_peer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_peer as text
%        str2double(get(hObject,'String')) returns contents of et_peer as a double


% --- Executes during object creation, after setting all properties.
function et_peer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_peer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_port_Callback(hObject, eventdata, handles)
% hObject    handle to et_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_port as text
%        str2double(get(hObject,'String')) returns contents of et_port as a double


% --- Executes during object creation, after setting all properties.
function et_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_aet_Callback(hObject, eventdata, handles)
% hObject    handle to et_aet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_aet as text
%        str2double(get(hObject,'String')) returns contents of et_aet as a double


% --- Executes during object creation, after setting all properties.
function et_aet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_aet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_aec_Callback(hObject, eventdata, handles)
% hObject    handle to et_aec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_aec as text
%        str2double(get(hObject,'String')) returns contents of et_aec as a double


% --- Executes during object creation, after setting all properties.
function et_aec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_aec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_accept.
function btn_accept_Callback(hObject, eventdata, handles)
% hObject    handle to btn_accept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pacs_config conf_index edition 
config.Name = handles.et_name.String;
config.Peer = handles.et_peer.String;
config.Port = handles.et_port.String;
config.AET =  handles.et_aet.String;
config.AEC = handles.et_aec.String;
if edition
    pacs_config{conf_index} = config;
else
    pacs_config{end + 1} = config;
end
config = pacs_config;
save('config.mat', 'config');

global popup
config_list = [config{:}];
config_list = {config_list.Name};
popup.String = config_list;

close();
