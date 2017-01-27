classdef DECTDecFunctions
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static)
        
        
        function ProcessAllImages(handles)
            handles.Aborted = 0;
            guidata(handles.figure1,handles);
            
            % == INPUT images:
            InputPathE1 = handles.Settings.InputFolderE1;
            if DECTDecFunctions.CheckFolder(InputPathE1) == false
                msgbox(['Directory "',InputPathE1,'" does not exist!'],'Input Images Energy 1','error');
                return
            end
            InputPathE2 = handles.Settings.InputFolderE2;
            if DECTDecFunctions.CheckFolder(InputPathE2) == false
                msgbox(['Directory "',InputPathE2,'" does not exist!'],'Input Images Energy 2','error');
                return
            end
            
            % == OUTPUT images:
            OutputPathMat1 = handles.Settings.OutputFolderMat1;
            if DECTDecFunctions.CheckFolder(OutputPathMat1) == false && get(handles.checkbox_CreateOutputFolder,'Value') == 1
                DECTDecFunctions.CreateFolder(OutputPathMat1);
            end
            if DECTDecFunctions.CheckFolder(OutputPathMat1) == false
                msgbox(['Directory "',OutputPathMat1,'" does not exist or could not be created!'],'Output Images Material 1','error');
                return
            end
            OutputPathMat2 = handles.Settings.OutputFolderMat2;
            if DECTDecFunctions.CheckFolder(OutputPathMat2) == false && get(handles.checkbox_CreateOutputFolder,'Value') == 1
                DECTDecFunctions.CreateFolder(OutputPathMat2);
            end
            if DECTDecFunctions.CheckFolder(OutputPathMat2) == false
                msgbox(['Directory "',OutputPathMat2,'" does not exist or could not be created!'],'Output Images Material 2','error');
                return
            end
            OutputPathMat3 = handles.Settings.OutputFolderMat3;
            if DECTDecFunctions.CheckFolder(OutputPathMat3) == false && get(handles.checkbox_CreateOutputFolder,'Value') == 1
                DECTDecFunctions.CreateFolder(OutputPathMat3);
            end
            if DECTDecFunctions.CheckFolder(OutputPathMat3) == false
                msgbox(['Directory "',OutputPathMat3,'" does not exist or could not be created!'],'Output Images Material 3','error');
                return
            end
            
            % Create an array of filenames that make up the image sequence
            % Energy 1:
            dirInputE1 = dir(InputPathE1);
            dirIndicesE1 = cell2mat({dirInputE1.isdir});
            dirInputE1(dirIndicesE1) = [];
            fileNamesE1 = {dirInputE1.name};
            numPicsE1 = numel(fileNamesE1);
            % Energy 2:
            dirInputE2 = dir(InputPathE2);
            dirIndicesE2 = cell2mat({dirInputE2.isdir});
            dirInputE2(dirIndicesE2) = [];
            fileNamesE2 = {dirInputE2.name};
            numPicsE2 = numel(fileNamesE2);
            
            if numPicsE1 ~= numPicsE2
                msgbox('different image number in between input folder!','','error');
                return
            end
            
            set(handles.text_Status,'String','please wait','BackgroundColor','yellow');
            drawnow();
            
            tic;
            % process all files - file-per-file ... :
            for i = 1:numPicsE1
                
                set(handles.text_Status,'String',['processing ',num2str(i),' of ',num2str(numPicsE1)]);
                drawnow;
                
                try
                    InputImageE1 = imread(fullfile(InputPathE1,fileNamesE1{i}));
                catch ex
                    msgbox(['error reading input-file!',char(10),...
                        '-> ',fullfile(InputPathE1,fileNamesE1{i})],'Read Input Image','error');
                    DECTDecFunctions.SetBroken(handles);
                    return
                end
                try
                    InputImageE2 = imread(fullfile(InputPathE2,fileNamesE2{i}));
                catch ex
                    msgbox(['error reading input-file!',char(10),...
                        '-> ',fullfile(InputPathE2,fileNamesE2{i})],'Read Input Image','error');
                    DECTDecFunctions.SetBroken(handles);
                    return
                end
                
                % !!!! here comes the image-per-image - processing:
                [OutputImage1,OutputImage2,OutputImage3] = ...
                    DECTDecFunctions.ProcessImages(InputImageE1,InputImageE2,handles);
                
                % compose filename:
                StandardOutputName = get(handles.edit_StandardOutputName,'String');
                iStr = num2str(i);
                % output 1:
                if get(handles.checkbox_SuffixMat1,'Value') == 1
                    OutputFileNameMat1 = [StandardOutputName,get(handles.edit_AffixMat1,'String'),'_',iStr,'.tif'];
                elseif get(handles.checkbox_PraefixMat1,'Value') == 1
                    OutputFileNameMat1 = [get(handles.edit_AffixMat1,'String'),StandardOutputName,'_',iStr,'.tif'];
                end
                % output 2:
                if get(handles.checkbox_SuffixMat2,'Value') == 1
                    OutputFileNameMat2 = [StandardOutputName,get(handles.edit_AffixMat2,'String'),'_',iStr,'.tif'];
                elseif get(handles.checkbox_PraefixMat2,'Value') == 1
                    OutputFileNameMat2 = [get(handles.edit_AffixMat2,'String'),StandardOutputName,'_',iStr,'.tif'];
                end
                % output 3:
                if get(handles.checkbox_SuffixMat3,'Value') == 1
                    OutputFileNameMat3 = [StandardOutputName,get(handles.edit_AffixMat3,'String'),'_',iStr,'.tif'];
                elseif get(handles.checkbox_PraefixMat3,'Value') == 1
                    OutputFileNameMat3 = [get(handles.edit_AffixMat3,'String'),StandardOutputName,'_',iStr,'.tif'];
                end
                
                % write images
                try
                    imwrite(OutputImage1,fullfile(OutputPathMat1,OutputFileNameMat1));
                    imwrite(OutputImage2,fullfile(OutputPathMat2,OutputFileNameMat2));
                    imwrite(OutputImage3,fullfile(OutputPathMat3,OutputFileNameMat3));
                catch ex
                    msgbox(ex.message,'Write Output Images','error');
                    DECTDecFunctions.SetBroken(handles);
                    return
                end
                
                handles = guidata(handles.figure1); if handles.Aborted == 1; return; end;
                                
            end %for-loop
            elapsed = toc;
            set(handles.text_Status,'String',['done (',num2str(elapsed),' sec)'],'BackgroundColor','green');
            
        end % function ProcessAllImages
         
        
        function Preview(handles)
            
            % == INPUT images:
            InputPathE1 = handles.Settings.InputFolderE1;
            if DECTDecFunctions.CheckFolder(InputPathE1) == false
                msgbox(['Directory "',InputPathE1,'" does not exist!'],'Input Images Energy 1','error');
                return
            end
            InputPathE2 = handles.Settings.InputFolderE2;
            if DECTDecFunctions.CheckFolder(InputPathE2) == false
                msgbox(['Directory "',InputPathE2,'" does not exist!'],'Input Images Energy 2','error');
                return
            end
            
            % == Create an array of filenames that make up the image sequence
            % Energy 1:
            dirInputE1 = dir(InputPathE1);
            dirIndicesE1 = cell2mat({dirInputE1.isdir});
            dirInputE1(dirIndicesE1) = [];
            fileNamesE1 = {dirInputE1.name};
            numPicsE1 = numel(fileNamesE1);
            % Energy 2:
            dirInputE2 = dir(InputPathE2);
            dirIndicesE2 = cell2mat({dirInputE2.isdir});
            dirInputE2(dirIndicesE2) = [];
            fileNamesE2 = {dirInputE2.name};
            numPicsE2 = numel(fileNamesE2);
            
            ListStr = {num2str((1:numPicsE1)')};
            [answer,ok] = listdlg('PromptString','select image number:','Name','Preview','ListString',ListStr',...
                'ListSize',[200 300],'SelectionMode','single','CancelString','ESC');
            if ok == 0
                return
            else
                imgNr = answer;
            end

            
            % == read images:
            try
                InputImageE1 = imread(fullfile(InputPathE1,fileNamesE1{imgNr}));
                InputImageE2 = imread(fullfile(InputPathE2,fileNamesE2{imgNr}));
            catch ex
                msgbox(['error reading input-file!',char(10),...
                    '(',ex.message,')'],'Read Input Image','error');
                return
            end
            
            [OutputImage1,OutputImage2,OutputImage3] = ...
                DECTDecFunctions.ProcessImages(InputImageE1,InputImageE2,handles);
            
            warning('off','images:initSize:adjustingMag');
            
            f1 = figure('Name',['Input Image Energy 1 (',fullfile(InputPathE1,fileNamesE1{imgNr}),')']);
            imshow(InputImageE1);
            f2 = figure('Name',['Input Image Energy 2 (',fullfile(InputPathE2,fileNamesE2{imgNr}),')']);
            imshow(InputImageE2);
            f3 = figure('Name','Output Image Material 1');
            imshow(OutputImage1);
            f4 = figure('Name','Output Image Material 2');
            imshow(OutputImage2);
            f5 = figure('Name','Output Image Material 3');
            imshow(OutputImage3);
            
            prevhandles = getappdata(handles.pushbutton_PreviewClose,'prevhandles');
            setappdata(handles.pushbutton_PreviewClose,'prevhandles',[prevhandles f1 f2 f3 f4 f5]);
            
        end % function Preview
       
        
        function [OutputImage1,OutputImage2,OutputImage3] = ProcessImages(InputImageE1,InputImageE2,handles)
            
            sizeInE1 = size(InputImageE1(:,:,1));
            sizeInE2 = size(InputImageE2(:,:,1));
            if sizeInE1 ~= sizeInE2
                msgbox('different image dimensions!','','error');
                DECTDecFunctions.SetBroken(handles);
                return
            end
            
            % Preparing the array with absorption properties
            E1Mat1 = handles.Settings.Energy1.Mat1;            % Mat1 = absorption of material 1 at energy 1
            E1Mat2 = handles.Settings.Energy1.Mat2;            % Mat2 = absorption of material 2 at energy 1
            E1Mat3 = handles.Settings.Energy1.Mat3;            % Mat3 = absorption of material 3 at energy 1
            E2Mat1 = handles.Settings.Energy2.Mat1;            % Mat1 = absorption of material 1 at energy 2
            E2Mat2 = handles.Settings.Energy2.Mat2;            % Mat2 = absorption of material 2 at energy 2
            E2Mat3 = handles.Settings.Energy2.Mat3;            % Mat3 = absorption of material 3 at energy 2
            
            A = [E1Mat1 E1Mat2 E1Mat3; E2Mat1 E2Mat2 E2Mat3; 1 1 1];
            AINV = inv(A);
            
            % Reshape Image 1 to single row vector
            vector1 = reshape(InputImageE1, [], 1);
            vector1rot = rot90(vector1);
            
            % Reshape Image 2 to single row vector
            vector2 = reshape(InputImageE2, [], 1);
            vector2rot = rot90(vector2);
            
            % Assemble matrix (3 rows; Enery 1, Energy 2, 1)
            matrix = vertcat(vector1rot,vector2rot);
            matrix(3,:) = 1;
            matrixdouble = double(matrix);
            
            % Dual energy decomposition
            Result(:,:) = AINV * matrixdouble(:,:);
            
            % Build matrix from images
            Resultflip = flipud(Result);
            matrixbackrot = rot90(Resultflip, -1);
            
            %Extract material 1 and reshape matrix to image
            Material1 = matrixbackrot(:,1);
            decomposite1 = reshape(Material1, [sizeInE1, 1]);
            decomposite1 = decomposite1 * 65535;
            OutputImage1 = uint16(decomposite1);
            
            %Extract material 2 and reshape matrix to image
            Material2 = matrixbackrot(:,2);
            decomposite2 = reshape(Material2, [sizeInE1, 1]);
            decomposite2 = decomposite2 * 65535;
            OutputImage2 = uint16(decomposite2);
            
            %Extract material 3 and reshape matrix to image
            Material3 = matrixbackrot(:,3);
            decomposite3 = reshape(Material3, [sizeInE1, 1]);
            decomposite3 = decomposite3 * 65535;
            OutputImage3 = uint16(decomposite3);
            
        end % function ProcessImage
        
        
        function LoadLastSettings(handles)
            
            LastSettings = struct;
            try
                LastSettings = struct2array(load('LastSettings.mat'));
                fclose all;     % release all files ...
            catch ex
                % could not read file ...
                uiwait(msgbox('Could not load last settings; loading default values instead ...','DECTDec: Load Last Settings','warn'));
                return
            end
            
            try
                handles.Settings.Energy1 = LastSettings.Energy1;
                handles.Settings.Energy2 = LastSettings.Energy2;
                handles.Settings.WorkingDir = LastSettings.WorkingDir;
                handles.Settings.InputFolderE1 = LastSettings.InputFolderE1;
                handles.Settings.InputFolderE2 = LastSettings.InputFolderE2;
                handles.Settings.OutputName = LastSettings.OutputName;
                handles.Settings.OutputFolderMat1 = LastSettings.OutputFolderMat1;
                handles.Settings.OutputFolderMat2 = LastSettings.OutputFolderMat2;
                handles.Settings.OutputFolderMat3 = LastSettings.OutputFolderMat3;
                handles.Settings.AffixMat1 = LastSettings.AffixMat1;
                handles.Settings.AffixMat2 = LastSettings.AffixMat2;
                handles.Settings.AffixMat3 = LastSettings.AffixMat3;
                handles.Settings.AffixMat1pos = LastSettings.AffixMat1pos;
                handles.Settings.AffixMat2pos = LastSettings.AffixMat2pos;
                handles.Settings.AffixMat3pos = LastSettings.AffixMat3pos;
                
                set(handles.text_Energy1,'String',handles.Settings.Energy1.EnergyName);
                set(handles.edit_Energy1_Mat1,'String',handles.Settings.Energy1.Mat1);
                set(handles.text_Energy1_Mat1,'String',handles.Settings.Energy1.Mat1name);
                set(handles.edit_Energy1_Mat2,'String',handles.Settings.Energy1.Mat2);
                set(handles.text_Energy1_Mat2,'String',handles.Settings.Energy1.Mat2name);
                set(handles.edit_Energy1_Mat3,'String',handles.Settings.Energy1.Mat3);
                set(handles.text_Energy1_Mat3,'String',handles.Settings.Energy1.Mat3name);
                
                set(handles.text_Energy2,'String',handles.Settings.Energy2.EnergyName);
                set(handles.edit_Energy2_Mat1,'String',handles.Settings.Energy2.Mat1);
                set(handles.text_Energy2_Mat1,'String',handles.Settings.Energy2.Mat1name);
                set(handles.edit_Energy2_Mat2,'String',handles.Settings.Energy2.Mat2);
                set(handles.text_Energy2_Mat2,'String',handles.Settings.Energy2.Mat2name);
                set(handles.edit_Energy2_Mat3,'String',handles.Settings.Energy2.Mat3);
                set(handles.text_Energy2_Mat3,'String',handles.Settings.Energy2.Mat3name);
                
                set(handles.text_WorkingDir,'String',handles.Settings.WorkingDir);
                set(handles.text_InputFolderE1,'String',handles.Settings.InputFolderE1);
                set(handles.text_InputFolderE2,'String',handles.Settings.InputFolderE2);
                set(handles.edit_StandardOutputName,'String',handles.Settings.OutputName);
                set(handles.text_OutputFolderMat1,'String',handles.Settings.OutputFolderMat1);
                set(handles.text_OutputFolderMat2,'String',handles.Settings.OutputFolderMat2);
                set(handles.text_OutputFolderMat3,'String',handles.Settings.OutputFolderMat3);
                set(handles.edit_AffixMat1,'String',handles.Settings.AffixMat1);
                set(handles.checkbox_PraefixMat1,'Value',~handles.Settings.AffixMat1pos);
                set(handles.checkbox_SuffixMat1,'Value',handles.Settings.AffixMat1pos);
                set(handles.edit_AffixMat2,'String',handles.Settings.AffixMat2);
                set(handles.checkbox_PraefixMat2,'Value',~handles.Settings.AffixMat2pos);
                set(handles.checkbox_SuffixMat2,'Value',handles.Settings.AffixMat2pos);
                set(handles.edit_AffixMat3,'String',handles.Settings.AffixMat3);
                set(handles.checkbox_PraefixMat3,'Value',~handles.Settings.AffixMat3pos);
                set(handles.checkbox_SuffixMat3,'Value',handles.Settings.AffixMat3pos);
                
                guidata(handles.figure1, handles);
                
            catch ex
                uiwait(msgbox('could not load last settings; loading default values instead ...','DECTDec: Load Last Settings','warn'));
                delete('LastSettings.mat');
            end
        end %function LoadLastSettings
        
        function SaveLastSettings(handles)
            % write last settings:
            LastSettings = handles.Settings;
            save('LastSettings.mat','LastSettings');
            fclose all;     % release all files ...
        end %function SaveLastSettings
        
        
        
        % % % ========== Helper functions ==========
        
        function SetBroken(handles)
            
            set(handles.text_Status,'String','broken','BackgroundColor','red');
            
        end % function SetBroken
        
        function [logical] = CheckFolder(FolderPath)
            try
                if ~isequal(exist(FolderPath, 'dir'),7) % 7 = directory
                    logical = false;
                    return
                else
                    logical = true;
                end
            catch ME
                msgbox(ME.message);
                logical = false;
                return
            end
        end % function CheckFolder
        
        function [logical] = CreateFolder(NewFolder)
            [SUCCESS,MESSAGE,MESSAGEID] = mkdir(NewFolder);
            if SUCCESS == 1
                logical = true;
            else
                msgbox(MESSAGE,'','error');
            end
        end % function CreateFolder
        
        function [logical] = CheckIfNumber(ControlHandle)
            value = get(ControlHandle,'String');
            ist_zahl = regexp(value,'^[+-]?[0-9]*(\.(\d)+)?([eE]([+-])?(\d)+)?$','once');
            if isempty(ist_zahl)
                if ishandle(ControlHandle)
                    set(ControlHandle,'UserData',get(ControlHandle,'TooltipString'));
                    set(ControlHandle,'TooltipString','this is not a valid number!','BackgroundColor','red');
                end
                % %         Value = sscanf(Value, '%f');
                logical = false;
            else
                if ishandle(ControlHandle)
                    strTooltip = get(ControlHandle,'UserData');
                    if isempty(strTooltip)
                        strTooltip = '';
                    end
                    set(ControlHandle,'TooltipString',strTooltip,'BackgroundColor','white');
                end
                logical = true;
            end
        end % function CheckIfNumber
        
    end %methods
    
end %Classdef

