function varargout = Prosbility(varargin)
% PROSbility
% Erdem Balcı, PhD
% Asist. Prof. (Physicist)
% Nuclear Medicine Department
% Gazi University
% +90 312 202 61 75
% Ankara, Turkey
% ebalci@gazi.edu.tr

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Prosbility_OpeningFcn, ...
                   'gui_OutputFcn',  @Prosbility_OutputFcn, ...
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

function Prosbility_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
function varargout = Prosbility_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function axes1_CreateFcn(hObject, eventdata, handles)
set(gca,'ytick',[],'YColor',[.941 .941 .941])

function axes2_CreateFcn(hObject, eventdata, handles)
set(gca,'ytick',[],'YColor',[.941 .941 .941])

function figure1_CreateFcn(hObject, eventdata, handles)

function axes3_CreateFcn(hObject, eventdata, handles)
set(gca,'ytick',[],'YColor',[.941 .941 .941])

function axes4_CreateFcn(hObject, eventdata, handles)
set(gca,'ytick',[],'YColor',[.941 .941 .941])

function axes5_CreateFcn(hObject, eventdata, handles)
set(gca,'ytick',[],'YColor',[.941 .941 .941], 'xlim', [0 50])

function axes7_CreateFcn(hObject, eventdata, handles)
set(gca,'ytick',[],'YColor',[.941 .941 .941])

function axes8_CreateFcn(hObject, eventdata, handles)
set(gca,'ytick',[],'YColor',[.941 .941 .941])

function axes9_CreateFcn(hObject, eventdata, handles)
set(gca,'ytick',[],'YColor',[.941 .941 .941])

function pushbutton2_Callback(hObject, eventdata, handles)
global psa_dt
Psa_level=get(handles.edit2,'String');

adt_select = get(handles.uibuttongroup1, 'SelectedObject');
switch get(adt_select,'Tag')
    
    case 'radiobutton1'
        ADT='"yes"';           
    case 'radiobutton2'
        ADT='"no"';                                    
end

isup_select = get(handles.uibuttongroup2, 'SelectedObject');
switch get(isup_select,'Tag')
    case 'radiobutton3'
        ISUP='"1-3"';          
    case 'radiobutton4'
        ISUP='"4-5"';                                    
end

a_work_dir=pwd;
a_work_dir=strrep(a_work_dir,'\','/');

fid = fopen('calc.R','wt');
fprintf(fid,['setwd("%s")\n',...
'library(haven)\n',...
'library(tidyverse)\n',...
'library(rms)\n',...
'PSMA_data = read_sav("PSMA_data.sav")\n',...
'PSMA_data$ISUP_Gleason_Grade_Group=as.factor(PSMA_data$ISUP_Gleason_Grade_Group)\n',...
'PSMA_data$ADT=as.factor(PSMA_data$ADT)\n',...
'PSMA_data$PSMA_PETMR_positivity=as.numeric(PSMA_data$PSMA_PETMR_positivity)\n',...
'dd=datadist(PSMA_data)\n',...
'options(datadist=%s)\n',...
'formul_1 = lrm(PSMA_PETMR_positivity ~ Total_PSA + ISUP_Gleason_Grade_Group + ADT + PSA_dt, data = PSMA_data)\n',...
'p=Predict(formul_1, Total_PSA=%s, ISUP_Gleason_Grade_Group=%s, ADT=%s, PSA_dt=%s, fun=plogis)\n',...
'write.csv(p,file="results.csv")\n'],a_work_dir,"'dd'",Psa_level, ISUP, ADT, psa_dt)
fclose(fid);
!Rscript calc.R
sonuc=readtable('results.csv');
possibility=num2str(sonuc.yhat*100);

set(handles.text16, 'String', ['Probability of Ga-68 PSMA positivity in a patient with biochemical recurrence after radical prostatectomy : ', possibility, ' (%)'] );
set(handles.text15, 'String', ['Probability : ', possibility, ' (%)'] );

axes(handles.axes34)

if strcmp(ADT,'"no"')==1;
    adt_range=[.585 .585];
    adt_s='0';
elseif strcmp(ADT,'"yes"')==1;
    adt_range=[.599 .599];
    adt_s='4.1';
end
annotation('textarrow', adt_range, [.84 .80],'String',adt_s,'Color','red','LineWidth', 1.9);

axes(handles.axes33)
if strcmp(ISUP,'"1-3"')==1;
    irange=[.585 .585];
    i_s='0';
elseif strcmp(ISUP,'"4-5"')==1;
    irange=[.629 .629];
    i_s='12.8';
end
annotation('textarrow', irange, [.70 .655],'String',i_s,'Color','red','LineWidth', 1.9);

axes(handles.axes35)
p_range=[(0.132*str2double(Psa_level)+0.585) (0.132*str2double(Psa_level)+0.585)];
p_s= num2str((37.82624*str2double(Psa_level)-3.782624));
annotation('textarrow', p_range, [.56 .512], 'String',p_s,'Color','red','LineWidth', 1.9);

axes(handles.axes37)
pd_range=[ -0.009775*str2double(psa_dt)+0.976 -0.009775*str2double(psa_dt)+0.976];
pd_s= num2str((-2.5*str2double(psa_dt)+100));
annotation('textarrow', pd_range, [.42 .37], 'String',pd_s,'Color','red','LineWidth', 1.9);

axes(handles.axes15)
total_p=str2double(adt_s)+str2double(i_s)+str2double(p_s)+str2double(pd_s);
annotation('textarrow',   [.585+total_p*0.002821429   .585+total_p*0.002821429], [.28 .23], 'String',num2str(total_p),'Color','red','LineWidth', 1.9);
annotation('doublearrow', [.585+total_p*0.002821429   .585+total_p*0.002821429], [.19 .14],'Color','red','LineWidth', 1.9);

function radiobutton3_Callback(hObject, eventdata, handles)

function radiobutton4_Callback(hObject, eventdata, handles)

function radiobutton1_Callback(hObject, eventdata, handles)

function radiobutton2_Callback(hObject, eventdata, handles)

function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)

function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton1_Callback(hObject, eventdata, handles)
global psa_dt
global psa2
psa1 = str2double(get(handles.edit1,'String'));
psa2 = str2double(get(handles.edit2,'String'));
gun = str2double(get(handles.edit3,'String'));
psadt = (log(2)/((log(psa2)-log(psa1))/(gun/31)));
set(handles.edit4,'String',num2str(psadt));
psa_dt=num2str(psadt);

function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function uipanel5_CreateFcn(hObject, eventdata, handles)

function axes15_CreateFcn(hObject, eventdata, handles)

function axes11_CreateFcn(hObject, eventdata, handles)

function pushbutton4_Callback(hObject, eventdata, handles)

delete(findall(gcf,'type','annotation'))
set(handles.edit1, 'String', '');
set(handles.edit2, 'String', '');
set(handles.edit3, 'String', '');
set(handles.edit4, 'String', '');
set(handles.text16, 'String', 'Probability of Ga-68 PSMA positivity in a patient with biochemical recurrence after radical prostatectomy' );
set(handles.text15, 'String', 'Probability' );

function axes33_CreateFcn(hObject, eventdata, handles)

function axes34_CreateFcn(hObject, eventdata, handles)

function axes35_CreateFcn(hObject, eventdata, handles)

function axes37_CreateFcn(hObject, eventdata, handles)

function axes16_CreateFcn(hObject, eventdata, handles)
caxis([59.52361 125.20697]);

colorbar('southoutside','Ticks',[59.52361, 71.64443, 79.70075, 86.30480, 92.36526, 98.42569, 105.02974, 113.08610, 125.20697],...
         'TickLabels',{'10','20','30','40','50','60','70','80','90'},'FontSize',10);
colormap(jet);
