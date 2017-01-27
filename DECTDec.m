function varargout = DECTDec(varargin)
    % DECTDEC MATLAB code for DECTDec.fig
    %      DECTDEC, by itself, creates a new DECTDEC or raises the existing
    %      singleton*.
    %
    %      H = DECTDEC returns the handle to a new DECTDEC or the handle to
    %      the existing singleton*.
    %
    %      DECTDEC('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in DECTDEC.M with the given input arguments.
    %
    %      DECTDEC('Property','Value',...) creates a new DECTDEC or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before DECTDec_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to DECTDec_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES
    
    % Edit the above text to modify the response to help DECTDec
    
    % Last Modified by GUIDE v2.5 15-Sep-2016 17:04:16
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @DECTDec_OpeningFcn, ...
        'gui_OutputFcn',  @DECTDec_OutputFcn, ...
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
    
    
    % --- Executes just before DECTDec is made visible.
function DECTDec_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to DECTDec (see VARARGIN)
    
    % Choose default command line output for DECTDec
    handles.output = hObject;
    handles.Aborted = 0;
    handles.GUIwidth = 1145;
    handles.GUIheight = 550;
    
    handles.Settings.WorkingDir = '';
    handles.Settings.InputFolderE1 = '';
    handles.Settings.InputFolderE2 = '';
    handles.Settings.OutputName = 'Output';
    handles.Settings.OutputFolderMat1 = '';
    handles.Settings.OutputFolderMat2 = '';
    handles.Settings.OutputFolderMat3 = '';
    handles.Settings.AffixMat1 = '_Material1';
    handles.Settings.AffixMat1pos = 1;   % 0==praefix, 1==suffix
    handles.Settings.AffixMat2 = '_Material2';
    handles.Settings.AffixMat2pos = 1;
    handles.Settings.AffixMat3 = '_Material3';
    handles.Settings.AffixMat3pos = 1;
    handles.Settings.Energy1.EnergyName = 'Energy 1';
    handles.Settings.Energy1.Mat1 = 0;
    handles.Settings.Energy1.Mat1name = 'Material 1';
    handles.Settings.Energy1.Mat2 = 0;
    handles.Settings.Energy1.Mat2name = 'Material 2';
    handles.Settings.Energy1.Mat3 = 0;
    handles.Settings.Energy1.Mat3name = 'Material 3';
    handles.Settings.Energy2.EnergyName = 'Energy 2';
    handles.Settings.Energy2.Mat1 = 0;
    handles.Settings.Energy2.Mat1name = 'Material 1';
    handles.Settings.Energy2.Mat2 = 0;
    handles.Settings.Energy2.Mat2name = 'Material 2';
    handles.Settings.Energy2.Mat3 = 0;
    handles.Settings.Energy2.Mat3name = 'Material 3';
    
    % set Icons on buttons:
    set(handles.uitoolbar1,'Visible','off');
    set(handles.pushbutton_WorkingDir,'cdata',get(handles.uipushtool_SetWorkingDir,'CData'));
    set(handles.pushbutton_InputFolderE1,'cdata',get(handles.uipushtool_IconFolderOpen,'CData'));
    set(handles.pushbutton_InputFolderE2,'cdata',get(handles.uipushtool_IconFolderOpen,'CData'));
    set(handles.pushbutton_OutputFolderMat1,'cdata',get(handles.uipushtool_IconFolderSave,'CData'));
    set(handles.pushbutton_OutputFolderMat2,'cdata',get(handles.uipushtool_IconFolderSave,'CData'));
    set(handles.pushbutton_OutputFolderMat3,'cdata',get(handles.uipushtool_IconFolderSave,'CData'));
    set(handles.pushbutton_SaveEnergy1,'cdata',get(handles.uipushtool_IconFolderSave,'CData'));
    set(handles.pushbutton_SaveEnergy2,'cdata',get(handles.uipushtool_IconFolderSave,'CData'));
    set(handles.pushbutton_LoadEnergy1,'cdata',get(handles.uipushtool_IconFolderOpen,'CData'));
    set(handles.pushbutton_LoadEnergy2,'cdata',get(handles.uipushtool_IconFolderOpen,'CData'));
    
    
    % Update handles structure
    guidata(hObject, handles);
    
    % load last settings:
    DECTDecFunctions.LoadLastSettings(handles);
    
    
    
    % --- Outputs from this function are returned to the command line.
function varargout = DECTDec_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    
    % write last settings:
    DECTDecFunctions.SaveLastSettings(handles);
    
    % Hint: delete(hObject) closes the figure
    delete(hObject);
    
function handles = figure1_ResizeFcn(hObject, eventdata, handles)
    if ~isfield(handles,'GUIwidth');
        return;
    end;
    
    newFigPos = get(hObject,'Position');
    GUIwidth = handles.GUIwidth;
    wDelta = GUIwidth - newFigPos(3);
    
    GUIheight = handles.GUIheight;
    hDelta = GUIheight - newFigPos(4);
    
    kids = get(hObject,'Children');
    
    for i = 1:size(kids,1)
        iType = get(kids(i),'Type');
        iTag = get(kids(i),'Tag');
        
        if strcmp(iType,'uitoolbar') == 0 && ...
                strcmp(iType,'uicontextmenu') == 0 && ...
                strcmp(iType,'uimenu') == 0
            Pos = get(kids(i),'Position');
            set(kids(i),'Position',[Pos(1) Pos(2)-hDelta Pos(3) Pos(4)]);
        end
        
        AnchorRight = {'text_AffixLabelMat1','edit_AffixMat1','checkbox_PraefixMat1','checkbox_SuffixMat1',...
            'text_AffixLabelMat2','edit_AffixMat2','checkbox_PraefixMat2','checkbox_SuffixMat2',...
            'text_AffixLabelMat3','edit_AffixMat3','checkbox_PraefixMat3','checkbox_SuffixMat3'};
        if find(strncmp(AnchorRight,iTag,length(iTag))) > 0
            if isempty(iTag) == 0
                set(kids(i),'Position',[Pos(1)-wDelta Pos(2)-hDelta Pos(3) Pos(4)]);
            end
        end
        
        AnchorLeftRight = {'text_WorkingDir','text_InputFolderE1','text_InputFolderE2',...
            'text_OutputFolderMat1','text_OutputFolderMat2','text_OutputFolderMat3'};
        if find(strncmp(AnchorLeftRight,iTag,length(iTag))) > 0
            if isempty(iTag) == 0
                set(kids(i),'Position',[Pos(1) Pos(2)-hDelta Pos(3)-wDelta Pos(4)]);
            end
        end

        
    end
    
    handles.GUIwidth = newFigPos(3);
    handles.GUIheight = newFigPos(4);
    guidata(hObject, handles);
    
    
function edit_Energy1_Mat1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function edit_Energy1_Mat1_Callback(hObject, eventdata, handles)
    if DECTDecFunctions.CheckIfNumber(hObject) == true
        handles.Settings.Energy1.Mat1 = str2double(get(hObject,'String')) ;
        guidata(handles.figure1, handles);
    end
    
function edit_Energy1_Mat2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function edit_Energy1_Mat2_Callback(hObject, eventdata, handles)
    if DECTDecFunctions.CheckIfNumber(hObject) == true
        handles.Settings.Energy1.Mat2 = str2double(get(hObject,'String')) ;
        guidata(handles.figure1, handles);
    end
    
function edit_Energy1_Mat3_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function edit_Energy1_Mat3_Callback(hObject, eventdata, handles)
    if DECTDecFunctions.CheckIfNumber(hObject) == true
        handles.Settings.Energy1.Mat3 = str2double(get(hObject,'String')) ;
        guidata(handles.figure1, handles);
    end
    
function edit_Energy2_Mat1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function edit_Energy2_Mat1_Callback(hObject, eventdata, handles)
    if DECTDecFunctions.CheckIfNumber(hObject) == true
        handles.Settings.Energy2.Mat1 = str2double(get(hObject,'String')) ;
        guidata(handles.figure1, handles);
    end
    
function edit_Energy2_Mat2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function edit_Energy2_Mat2_Callback(hObject, eventdata, handles)
    if DECTDecFunctions.CheckIfNumber(hObject) == true
        handles.Settings.Energy2.Mat2 = str2double(get(hObject,'String')) ;
        guidata(handles.figure1, handles);
    end
    
function edit_Energy2_Mat3_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function edit_Energy2_Mat3_Callback(hObject, eventdata, handles)
    if DECTDecFunctions.CheckIfNumber(hObject) == true
        handles.Settings.Energy2.Mat3 = str2double(get(hObject,'String')) ;
        guidata(handles.figure1, handles);
    end
    
    
function pushbutton_OK_Callback(hObject, eventdata, handles)
    DECTDecFunctions.ProcessAllImages(handles);
    
    handles = guidata(handles.figure1);
    if handles.Aborted == 1
        set(handles.text_Status,'String','aborted','BackgroundColor','red');
        set(handles.togglebutton_Abort,'Value',0);
        handles.Aborted = 0;
        guidata(handles.figure1,handles);
    end
    
function togglebutton_Abort_Callback(hObject, eventdata, handles)
    handles.Aborted = get(hObject,'Value');
    guidata(handles.figure1,handles);
    
    
function pushbutton_WorkingDir_Callback(hObject, eventdata, handles)
    WorkingDir = uigetdir(handles.Settings.WorkingDir, 'Set working directory:');
    if WorkingDir == 0
        return
    else
        handles.Settings.WorkingDir = WorkingDir;
        set(handles.text_WorkingDir,'String',WorkingDir);
        
        if get(handles.checkbox_CreateOutputFolder,'Value') == 1
            handles.Settings.OutputFolderMat1 = [WorkingDir,'\OutputMaterial1\'];
            set(handles.text_OutputFolderMat1,'String',handles.Settings.OutputFolderMat1);
            handles.Settings.OutputFolderMat2 = [WorkingDir,'\OutputMaterial2\'];
            set(handles.text_OutputFolderMat2,'String',handles.Settings.OutputFolderMat2);
            handles.Settings.OutputFolderMat3 = [WorkingDir,'\OutputMaterial3\'];
            set(handles.text_OutputFolderMat3,'String',handles.Settings.OutputFolderMat3);
        end
        
        guidata(handles.figure1, handles);
    end
    
    
    % % == Input Energy 1
function pushbutton_InputFolderE1_Callback(hObject, eventdata, handles)
    InputFolder = uigetdir(handles.Settings.WorkingDir, 'Choose a directory, where the images for energy 1 are stored:');
    if InputFolder == 0
        return
    else
        handles.Settings.InputFolderE1 = InputFolder;
        set(handles.text_InputFolderE1,'String',InputFolder);
        guidata(handles.figure1, handles);
    end
    
    % % == Input Energy 2
function pushbutton_InputFolderE2_Callback(hObject, eventdata, handles)
    InputFolder = uigetdir(handles.Settings.WorkingDir, 'Choose a directory, where the images for energy 2 are stored:');
    if InputFolder == 0
        return
    else
        handles.Settings.InputFolderE2 = InputFolder;
        set(handles.text_InputFolderE2,'String',InputFolder);
        guidata(handles.figure1, handles);
    end
    
function edit_StandardOutputName_Callback(hObject, eventdata, handles)
    handles.Settings.OutputName = get(hObject,'String');
    guidata(handles.figure1, handles);
    
    
function checkbox_CreateOutputFolder_Callback(hObject, eventdata, handles)
    if get(handles.checkbox_CreateOutputFolder,'Value') == 1
        handles.Settings.OutputFolderMat1 = [handles.Settings.WorkingDir,'\OutputMaterial1\'];
        set(handles.text_OutputFolderMat1,'String',handles.Settings.OutputFolderMat1);
        handles.Settings.OutputFolderMat2 = [handles.Settings.WorkingDir,'\OutputMaterial2\'];
        set(handles.text_OutputFolderMat2,'String',handles.Settings.OutputFolderMat2);
        handles.Settings.OutputFolderMat3 = [handles.Settings.WorkingDir,'\OutputMaterial3\'];
        set(handles.text_OutputFolderMat3,'String',handles.Settings.OutputFolderMat3);
    end
    guidata(handles.figure1, handles);
    
    % % == Output Material 1
function pushbutton_OutputFolderMat1_Callback(hObject, eventdata, handles)
    OutputFolder = uigetdir(handles.Settings.WorkingDir, 'Choose or create a directory, where all generated images for material 1 should be saved:');
    if OutputFolder == 0
        return
    else
        handles.Settings.OutputFolderMat1 = OutputFolder;
        set(handles.text_OutputFolderMat1,'String',OutputFolder);
        guidata(handles.figure1, handles);
    end
    
function edit_AffixMat1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function edit_AffixMat1_Callback(hObject, eventdata, handles)
    handles.Settings.AffixMat1 = get(hObject,'String');
    guidata(handles.figure1, handles);
function checkbox_PraefixMat1_Callback(hObject, eventdata, handles)
    val = get(handles.checkbox_PraefixMat1,'Value');
    handles.Settings.AffixMat1pos = ~val;
    set(handles.checkbox_SuffixMat1,'Value',~val);
    guidata(handles.figure1, handles);
    
function checkbox_SuffixMat1_Callback(hObject, eventdata, handles)
    val = get(handles.checkbox_SuffixMat1,'Value');
    handles.Settings.AffixMat1pos = val;
    set(handles.checkbox_PraefixMat1,'Value',~val);
    guidata(handles.figure1, handles);
    
    
    % % == Output Material 2
function pushbutton_OutputFolderMat2_Callback(hObject, eventdata, handles)
    OutputFolder = uigetdir(handles.Settings.WorkingDir, 'Choose or create a directory, where all generated images for material 2 should be saved:');
    if OutputFolder == 0
        return
    else
        handles.Settings.OutputFolderMat2 = OutputFolder;
        set(handles.text_OutputFolderMat2,'String',OutputFolder);
        guidata(handles.figure1, handles);
    end
    
function edit_AffixMat2_CreateFcn(hObject, eventdata, handles)
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function edit_AffixMat2_Callback(hObject, eventdata, handles)
    handles.Settings.AffixMat2 = get(hObject,'String');
    guidata(handles.figure1, handles);
    
function checkbox_PraefixMat2_Callback(hObject, eventdata, handles)
    val = get(handles.checkbox_PraefixMat2,'Value');
    handles.Settings.AffixMat2pos = ~val;
    set(handles.checkbox_SuffixMat2,'Value',~val);
    guidata(handles.figure1, handles);
function checkbox_SuffixMat2_Callback(hObject, eventdata, handles)
    val = get(handles.checkbox_SuffixMat2,'Value');
    handles.Settings.AffixMat2pos = val;
    set(handles.checkbox_PraefixMat2,'Value',~val);
    guidata(handles.figure1, handles);
    
    
    % % == Output Material 3
function pushbutton_OutputFolderMat3_Callback(hObject, eventdata, handles)
    OutputFolder = uigetdir(handles.Settings.WorkingDir, 'Choose or create a directory, where all generated images for material 3 should be saved:');
    if OutputFolder == 0
        return
    else
        handles.Settings.OutputFolderMat3 = OutputFolder;
        set(handles.text_OutputFolderMat3,'String',OutputFolder);
        guidata(handles.figure1, handles);
    end
    
function edit_AffixMat3_CreateFcn(hObject, eventdata, handles)
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function edit_AffixMat3_Callback(hObject, eventdata, handles)
    handles.Settings.AffixMat3 = get(hObject,'String');
    guidata(handles.figure1, handles);
    
function checkbox_PraefixMat3_Callback(hObject, eventdata, handles)
    val = get(handles.checkbox_PraefixMat3,'Value');
    handles.Settings.AffixMat3pos = ~val;
    set(handles.checkbox_SuffixMat3,'Value',~val);
    guidata(handles.figure1, handles);
function checkbox_SuffixMat3_Callback(hObject, eventdata, handles)
    val = get(handles.checkbox_SuffixMat3,'Value');
    handles.Settings.AffixMat3pos = val;
    set(handles.checkbox_PraefixMat3,'Value',~val);
    guidata(handles.figure1, handles);
    
    
    
function pushbutton_Preview_Callback(hObject, eventdata, handles)
    DECTDecFunctions.Preview(handles);
    
function pushbutton_PreviewClose_Callback(hObject, eventdata, handles)
    try
        close(getappdata(hObject,'prevhandles'));
    catch ex
    end
    setappdata(hObject,'prevhandles',[]);
    
    
    
function pushbutton_SaveEnergy1_Callback(hObject, eventdata, handles)
    [FileName, PathName, FilterIndex] = uiputfile( ...
        {'*.mat', 'MAT (MATLAB Data) (*.mat)'; ...
        '*.*',    'All Files (*.*)'}, ...
        'Save Settings File for Energy 1','.mat');
    if FileName == 0; return; end;
    SettingsFile = fullfile(PathName,FileName);
    
    EnergySetting = handles.Settings.Energy1;
    
    save(SettingsFile,'EnergySetting');
    fclose all;     % release all files ...
    
function pushbutton_LoadEnergy1_Callback(hObject, eventdata, handles)
    [FileName,PathName] = uigetfile('*.mat','Select Settings File for Energy 1');    % OpenFile-Dialog
    if FileName == 0
        return
    else
        SettingsFileE1 = fullfile(PathName,FileName);
% % %         SettingsX = struct('Energy1',{'X1','X2','X3'});
SettingsE1 = struct([]);
        try
            SettingsE1 = (load(SettingsFileE1));
            fclose all;     % release all files ...
        catch ex
            % could not read file ...
            msgbox({'Could not read ',['   ',SettingsFileE1],...
                '---',...
                ex.message},'Open Settings File for Energy 1','warn');
            return
        end
        
        try
            handles.Settings.Energy1 = SettingsE1.EnergySetting;
        catch ex
            % wrong file ...
            msgbox({'Could not find data for Energy 1 in ',['   ',SettingsFileE1],...
                'Maybe wrong *.mat - file?',...
                '---',...
                ex.message},'Open Settings File for Energy 1','warn');
            return
        end
        set(handles.edit_Energy1_Mat1,'String',handles.Settings.Energy1.Mat1);
        set(handles.edit_Energy1_Mat2,'String',handles.Settings.Energy1.Mat2);
        set(handles.edit_Energy1_Mat3,'String',handles.Settings.Energy1.Mat3);
        set(handles.text_Energy1,'String',SettingsE1.EnergySetting.EnergyName);
        set(handles.text_Energy1_Mat1,'String',SettingsE1.EnergySetting.Mat1name);
        set(handles.text_Energy1_Mat2,'String',SettingsE1.EnergySetting.Mat2name);
        set(handles.text_Energy1_Mat3,'String',SettingsE1.EnergySetting.Mat3name);
        
        guidata(handles.figure1, handles);
    end
    
function pushbutton_SaveEnergy2_Callback(hObject, eventdata, handles)
    [FileName, PathName, FilterIndex] = uiputfile( ...
        {'*.mat', 'MAT (MATLAB Data) (*.mat)'; ...
        '*.*',    'All Files (*.*)'}, ...
        'Save Settings File for Energy 2','.mat');
    if FileName == 0; return; end;
    SettingsFile = fullfile(PathName,FileName);
    
    EnergySetting = handles.Settings.Energy2;
    
    save(SettingsFile,'EnergySetting');
    fclose all;     % release all files ...
    
function pushbutton_LoadEnergy2_Callback(hObject, eventdata, handles)
    [FileName,PathName] = uigetfile('*.mat','Select Settings File for Energy 2');    % OpenFile-Dialog
    if FileName == 0
        return
    else
        SettingsFileE2 = fullfile(PathName,FileName);
        SettingsE2 = struct('Energy2',{'Y1','Y2','Y3'});
        try
            SettingsE2 = (load(SettingsFileE2));
            fclose all;     % release all files ...
        catch ex
            % could not read file ...
            msgbox({'Could not read ',['   ',SettingsFileE2],...
                '---',...
                ex.message},'Open Settings File for Energy 2','warn');
            return
        end
        
        try
            handles.Settings.Energy2 = SettingsE2.EnergySetting;
        catch ex
            % wrong file ...
            msgbox({'Could not find data for Energy 2 in ',['   ',SettingsFileE2],...
                'Maybe wrong *.mat - file?',...
                '---',...
                ex.message},'Open Settings File for Energy 2','warn');
            return
        end
        set(handles.edit_Energy2_Mat1,'String',handles.Settings.Energy2.Mat1);
        set(handles.edit_Energy2_Mat2,'String',handles.Settings.Energy2.Mat2);
        set(handles.edit_Energy2_Mat3,'String',handles.Settings.Energy2.Mat3);
        set(handles.text_Energy2,'String',SettingsE2.EnergySetting.EnergyName);
        set(handles.text_Energy2_Mat1,'String',SettingsE2.EnergySetting.Mat1name);
        set(handles.text_Energy2_Mat2,'String',SettingsE2.EnergySetting.Mat2name);
        set(handles.text_Energy2_Mat3,'String',SettingsE2.EnergySetting.Mat3name);

        guidata(handles.figure1, handles);
    end
    
    
    % == set names for energies and materials:
function newName = SetName(hObject,prompt,oldName)
    oldCol = get(hObject,'BackgroundColor');
    set(hObject,'BackgroundColor','green');
    newName = inputdlg(prompt,'Set Name',1,{oldName});
    if isempty(newName)
        newName = oldName;
    end
    newName = char(newName);
    set(hObject,'String',newName,'BackgroundColor',oldCol);
    
    
function text_Energy1_ButtonDownFcn(hObject, eventdata, handles)
    handles.Settings.Energy1.EnergyName = SetName(hObject,{'Enter new name for Energy 1:'},get(hObject,'String'));
    guidata(handles.figure1, handles);
    
function text_Energy1_Mat1_ButtonDownFcn(hObject, eventdata, handles)
    handles.Settings.Energy1.Mat1name = SetName(hObject,{'Enter new name for Material 1 of Energy 1:'},get(hObject,'String'));
    guidata(handles.figure1, handles);
    
function text_Energy1_Mat2_ButtonDownFcn(hObject, eventdata, handles)
    handles.Settings.Energy1.Mat2name = SetName(hObject,{'Enter new name for Material 2 of Energy 1:'},get(hObject,'String'));
    guidata(handles.figure1, handles);
    
function text_Energy1_Mat3_ButtonDownFcn(hObject, eventdata, handles)
    handles.Settings.Energy1.Mat3name = SetName(hObject,{'Enter new name for Material 3 of Energy 1:'},get(hObject,'String'));
    guidata(handles.figure1, handles);
    
    
function text_Energy2_ButtonDownFcn(hObject, eventdata, handles)
    handles.Settings.Energy2.EnergyName = SetName(hObject,{'Enter new name for Energy 2:'},get(hObject,'String'));
    guidata(handles.figure1, handles);
    
function text_Energy2_Mat1_ButtonDownFcn(hObject, eventdata, handles)
    handles.Settings.Energy2.Mat1name = SetName(hObject,{'Enter new name for Material 1 of Energy 2:'},get(hObject,'String'));
    guidata(handles.figure1, handles);
    
function text_Energy2_Mat2_ButtonDownFcn(hObject, eventdata, handles)
    handles.Settings.Energy2.Mat2name = SetName(hObject,{'Enter new name for Material 2 of Energy 2:'},get(hObject,'String'));
    guidata(handles.figure1, handles);
    
function text_Energy2_Mat3_ButtonDownFcn(hObject, eventdata, handles)
    handles.Settings.Energy2.Mat3name = SetName(hObject,{'Enter new name for Material 3 of Energy 2:'},get(hObject,'String'));
    guidata(handles.figure1, handles);
    % == end set names for energies and materials
