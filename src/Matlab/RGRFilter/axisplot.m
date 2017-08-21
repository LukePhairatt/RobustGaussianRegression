function varargout = axisplot(varargin)
% AXISPLOT MATLAB code for axisplot.fig
%      AXISPLOT, by itself, creates a new AXISPLOT or raises the existing
%      singleton*.
%
%      H = AXISPLOT returns the handle to a new AXISPLOT or the handle to
%      the existing singleton*.
%
%      AXISPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AXISPLOT.M with the given input arguments.
%
%      AXISPLOT('Property','Value',...) creates a new AXISPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before axisplot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to axisplot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help axisplot

% Last Modified by GUIDE v2.5 30-Sep-2011 11:59:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @axisplot_OpeningFcn, ...
                   'gui_OutputFcn',  @axisplot_OutputFcn, ...
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


% --- Executes just before axisplot is made visible.
function axisplot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to axisplot (see VARARGIN)

% plot function
set(hObject,'toolbar','figure');
%img=ones(10,10,3);
%axes(handles.axes3);
%imagesc(img);
        % Initialising X-Y cut module to handles class 
        axes(handles.axes11);
        hold on
        X = (0:269);
        Y = (0:269); 
        % assigning hX and hY to handles property
        % using get() and set() method
        handles.hX = plot(X,135);
        handles.hY = plot(135,Y);
        hold off
        
        % Initialising defect size variables (used by slider bar scaling)
        handles.defectX = 0;
        handles.defectY = 0;

% Choose default command line output for axisplot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes axisplot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = axisplot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in plotAxes1_pushbutton.
function plotAxes1_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to plotAxes1_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%selects axes1 as the current axes, so that
%Matlab knows where to plot the data
axes(handles.axes11);
set(handles.text8,'FontSize',16);

%adds a title, x-axis description, and y-axis description
%title('Axes 1');
%xlabel('X data');
%ylabel('Y data');

guidata(hObject, handles); %updates the handles


% --- Executes on button press in plotAxes2_pushbutton.
function plotAxes2_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to plotAxes2_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes2);

%creates a vector from 0 to 10, [0 1 2 3 . . . 10]
x = 0:10;
%creates a vector  [0 1 4 9 . . . 100]
y = x.^2;

%plots the x and y data
plot(x,y);
%adds a title, x-axis description, and y-axis description
title('Axes 2');
xlabel('X data');
ylabel('Y data');
guidata(hObject, handles); %updates the handles


% --- Executes on button press in clearAxes_pushbutton.
function clearAxes_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearAxes_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%these two lines of code clears both axes
cla(handles.axes1,'reset');
cla(handles.axes2,'reset');
guidata(hObject, handles); %updates the handles


% --- Executes on button press in Load_Image.
function Load_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%[filename,pathname] = uigetfile({'*.tif';'*.tiff';'*.jpg';'*.jpeg'});
[filename,pathname] = uigetfile({'*.txt'});
ShowImageFile(filename,pathname,handles);

function ShowImageFile(filename,pathname,handles)
    if ~isequal(filename, 0)
        % file path + name
        fn=strcat(pathname,filename);
        % running algorithm return with parameters
        [Z_original img_b img_a binary_all Z_defect binary_defect img_single ObjList]= DefectObjClass(fn); 
        pause(2);
        % set file name on the text box
        set(handles.FilePath,'String',filename);
        % ploting image on the axes
        % original mesh
        axes(handles.axes3);
        mesh(Z_original);
        axis equal;
        % single defect
        axes(handles.axes9);
        mesh(Z_defect);
        axis equal;
        % image before enhance
        axes(handles.axes6);
        imshow(img_b);
        % image after enhance
        axes(handles.axes7);
        imshow(img_a);
        % binary output all defects
        axes(handles.axes8);
        imshow(binary_all);
        % binary SINGLE defects
        axes(handles.axes10);
        imshow(binary_defect);
        
        % X-Y cut panel
        axes(handles.axes11);
        imshow(img_single);
       
        %set(handles.axes3,'UserData',A); 
    end


    
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


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%obtains the slider value from the slider component
sliderValue = get(handles.slider1,'Value');

%puts the slider value into the edit text component
set(handles.text8,'String', num2str(sliderValue));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
