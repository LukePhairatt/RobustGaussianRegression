function varargout = DefectClassGUI(varargin)
% DEFECTCLASSGUI MATLAB code for DefectClassGUI.fig
%      DEFECTCLASSGUI, by itself, creates a new DEFECTCLASSGUI or raises the existing
%      singleton*.
%
%      H = DEFECTCLASSGUI returns the handle to a new DEFECTCLASSGUI or the handle to
%      the existing singleton*.
%
%      DEFECTCLASSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFECTCLASSGUI.M with the given input arguments.
%
%      DEFECTCLASSGUI('Property','Value',...) creates a new DEFECTCLASSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DefectClassGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DefectClassGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DefectClassGUI

% Last Modified by GUIDE v2.5 10-Oct-2011 18:09:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DefectClassGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DefectClassGUI_OutputFcn, ...
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


% --- Executes just before DefectClassGUI is made visible.
function DefectClassGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DefectClassGUI (see VARARGIN)


% plot function
set(hObject,'toolbar','figure');

% Choose default command line output for DefectClassGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DefectClassGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DefectClassGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function FilePath_Callback(hObject, eventdata, handles)
% hObject    handle to FilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FilePath as text
%        str2double(get(hObject,'String')) returns contents of FilePath as a double


% --- Executes during object creation, after setting all properties.
function FilePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Load_Data.
function Load_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile({'*.txt'});
ShowImageFile(filename,pathname,handles);


function ShowImageFile(filename,pathname,handles)
    if ~isequal(filename, 0)
        % file path + name
        fn=strcat(pathname,filename);
        % running algorithm return with parameters
        [Z_original img_b img_a binary_all Z_defect binary_defect img_single ObjList]= DefectObjClass(fn); 
        pause(2);
        % set file name to the text box
        set(handles.FilePath,'String',filename);
        % showing image on the screen
        % result-enhance image
        axes(handles.Defect_Image);
        imshow(img_a);

        %set(handles.axes3,'UserData',A); 
    end


% --- Executes on button press in Clear_WP.
function Clear_WP_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_WP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
