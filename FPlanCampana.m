function DataOut=FPlanCampana(Op);
%This function compute total time of a cruise plan.
%
% The cruise plan is in a file named strcat('Estaciones',Op.Cruise,'.csv')
% for example: 'EstacionesRaprocan1810.csv'.
% It will have a line for operation, with the folliwing format:
% Name of the station;longitude in decial degrees;latitude in decimal degrees;type of operation
% for exacmple; 24;-18.4963;29.1667;1
%
% Always the first line would be the departure port: Santa Cruz;-16.2300;28.4800;10
% and the last line the arrival port: Santa Cruz;-16.2300;28.4800; 9
%
% The tyes of operations (fourth field in the station file) are:
%
% 10 - Departure port
%  1 - CTD station       - Compute the time in station using the depth and Op.VelocityCTD
% 11 - WP2 Zoo
% 12 - Bongo Ictio
% 13 - Manta microplasticos
% 14 - Box Core          -
% 15 - Gravity Core      -
% 16 - ROV station       -
%  2 - Waypoint
%  3 - Deploy lander     - Compute the time in station using the depth and Op.VelocityLander
%  4 - Recovery lander   - Compute the time in station using the depth and Op.VelocityLander
%  7 - Deploy mooring    - Compute the time in station using the depth and Op.VelocityCTD
%  8 - Recovery mooring  - Compute the time in station using the depth and Op.VelocityCTD
%  9 - Arrival port
% <0 - Waiting time in days
%
%----Opuration parameters:
%
% Op.Cruise='Raprocan1810';
% Op.DepartingDate=datenum(2018,10,20,23,00,00); %Fecha salida
%
%Geographic limits
% Op.Region='CanaryIslands';
% Op.lat_min=24.25;
% Op.lat_max=29.50;
% Op.lon_min=340;
% Op.lon_max=352;
% Op.LonEConvMap=-360;      %For the case of map in 0-360 coodinates Elon 360
% Op.Proj=1;                %1 'mercator', 2'Mollweide'
%
% Op.Delay=0.0/24;          % [days]
% Op.DepthROV=1500;         % Maximum depth of ROV[m]
% Op.DailyAOperation=0.0;   % Daily time [h] for additional operations
% Op.TStation=0.50;         % Time [h] for operation righ after station
% Op.TWP2=0.5;              % Time [h] for WP2 operation.
% Op.TBongo=0.5;            % Time [h] for Bongo operation.
% Op.TAvani=0.5;           % Time [h] for Avani operation.
% Op.TLander=1.0;           % Time [h] for operation righ after recover/deploy mooring.
% Op.TMooring=0.5;          % Time [h] for operation righ after recover/deploy mooring.
% Op.VelocityVessel=9.5;    % [knots]
% Op.VelocityCTD=55;        % [m/min]
% Op.VelocityBC=55;         % [m/min]
% Op.VelocityGC=55;         % [m/min]
% Op.VelocityROV=40;        % [m/min]
% Op.VelocityLander=30;     % [m/min]
% Op.VelocityMooring=55;    % [m/min]
%
% Op.Batimetry=1;           %[1/0] to add batythemtry
% Op.BatimetryIso=[-1000];  %Isobaths to contour
% Op.BatimetryIsoLabel=[0 0 0 0];%Isobaths to label
% Op.BatimetryColor=0;      %[1/0] to add color batythemtry
% Op.ZEE=1;                 %[1/0] to add ZEE lines
% Op.VesselTrack=1;         %[1/0] to add vessel track. 2 for track with time
%
% Op.StaTicks=10;           %Cada cuanto se etiquetan las stations
% Op.StaSpecMarks1=[];      %Stationes especiales a marcar
% Op.StaSpecMarks1Color='r';
% Op.StaSpecMarks1Ticks=0;  %Flag to label special stations
% Op.Subtitle=1;            %[0/1/2] for [no/short/long] subtitle
%
% Op.MoorTick=1;            %A ñade nombre de fondeo
%
% Op.OutputKml=1;
% Op.OutputMat=1;
% Op.OutputGPX=1;
% Op.OutputFigures=[4 7];
%
% Op.ImagenSatelite=0;  %Si hay imagen por satelite la incluye de fondo. [1]MADT [2]SST [3] Manual
% Op.ImagenSateliteTitulo='Chl 9 Octubre';
% Op.ImagenSateliteFile='201310151405MSN19';
%
% Pedro Velez Belchi (IEO) - 2002



%% Begining

fprintf('>>>>>Cruise plan for: %s \n',Op.Cruise)

if isfield(Op,'BatimetryIso')==0;       Op.BatimetryIso=[-1000 -2000];end
if isfield(Op,'BatimetryIsoLabel')==0;  Op.BatimetryIsoLabel=[1 1 1];end
if isfield(Op,'DailyAOperation')==0;    Op.DailyAOperation=0.0;end
if isfield(Op,'DepthROV')==0;           Op.DepthROV=1500;end
if isfield(Op,'Idioma')==0;             Op.Idioma=1;end
if isfield(Op,'ImagenSatelite')==0;     Op.ImagenSatelite=0;end
if isfield(Op,'Legend')==0;             Op.Legend=1;end
if isfield(Op,'Logo')==0;               Op.Logo=1;end
if isfield(Op,'MaxProfCTD')==0;         Op.MaxProfCTD=0;end
if isfield(Op,'MoorTick')==0;           Op.MoorTick=0;end
if isfield(Op,'Plot3d')==0;             Op.Plot3d=0;end
if isfield(Op,'Proj')==0;               Op.Proj='mercator';end
if isfield(Op,'Ruler')==0;              Op.Ruler=0;end
if isfield(Op,'StaSpecMarks1')==0;      Op.StaSpecMarks1=[];end
if isfield(Op,'StaSpecMarks1Color')==0; Op.StaSpecMarks1Color='r';end
if isfield(Op,'StaSpecMarks1Ticks')==0; Op.StaSpecMarks1Ticks=0;end
if isfield(Op,'StaSpecMarks2')==0;      Op.StaSpecMarks2=[];end
if isfield(Op,'StaSpecMarks2Color')==0; Op.StaSpecMarks2Color='g';end
if isfield(Op,'StaSpecMarks2Ticks')==0; Op.StaSpecMarks2Ticks=0;end
if isfield(Op,'Subtitle')==0;           Op.Subtitle=1;end
if isfield(Op,'TWP2')==0;               Op.TWP2=0.5;end
if isfield(Op,'TBongo')==0;             Op.TBongo=0.5;end
if isfield(Op,'TAvani')==0;            Op.TAvani=0.5;end
if isfield(Op,'TStation')==0;           Op.TStation=0.5;end
if isfield(Op,'TLander')==0;            Op.TLander=1.0;end
if isfield(Op,'TMooring')==0;           Op.TMooring=0.5;end
if isfield(Op,'VelocityVessel')==0;     Op.VelocityVessel=9;end
if isfield(Op,'VelocityCTD')==0;        Op.VelocityCTD=55;end
if isfield(Op,'VelocityGC')==0;         Op.VelocityGC=50;end
if isfield(Op,'VelocityBC')==0;         Op.VelocityBC=50;end
if isfield(Op,'VelocityROV')==0;        Op.VelocityROV=40;end
if isfield(Op,'VelocityMooring')==0;    Op.VelocityMooring=55;end
if isfield(Op,'VelocityLander')==0;     Op.VelocityLander=30;end

if isfield(Op,'ZEE')==0;                Op.ZEE=0;end

%%
%% Español
if Op.Idioma==1
    OperationID{ 1} ='EstacionCTD '  ; %  1 Station CTD
    OperationID{11} ='Red WP2     '  ; %  11 Station CTD
    OperationID{12} ='Red Bongo 90'  ; %  12 Station CTD
    OperationID{13} ='Red Avani   '  ; %  13 Station CTD
    OperationID{14} ='BC'            ; %  14 Station BC [Box Core]
    OperationID{15} ='GC'            ; %  15 Station GC [Gravity Core]
    OperationID{16} ='ROV'           ; %  16 Station ROV
    OperationID{ 2} ='Waypoint'      ; %  2 WP
    OperationID{ 3} ='Despl.lander'  ; %  3 Poner lander
    OperationID{ 4} ='Recup.lander'  ; %  4 Quitar lander
    OperationID{ 7} ='Despl.fondeo'  ; %  7 Poner fondeo
    OperationID{ 8} ='Recup.fondeo'  ; %  8 Quitar fondeo
    OperationID{ 9} ='P. llegada  '  ; %  9 Puerto de llegada
    OperationID{10} ='P. Salida   '  ; %  0 Puerto de Salida
    OperationID{20} ='Operaciones '  ; % <0 Parados tiempo en days
else
    OperationID{ 1} ='Station CTD'   ; %  1 Station CTD
    OperationID{11} ='Net WP2     '  ; %  1 Station CTD
    OperationID{12} ='Net Bongo 90'  ; %  1 Station CTD
    OperationID{13} ='Net Avani   '  ; %  1 Station CTD
    OperationID{14} ='BC'            ; %  14 Station BC [Box Core]
    OperationID{15} ='GC'            ; %  15 Station GC [Gravity Core]
    OperationID{16} ='ROV'           ; %  16 Station ROV
    OperationID{ 2} ='Waypoint'      ; %  2 WP
    OperationID{ 3} ='DeployLander'  ; %  3 Poner lander
    OperationID{ 4} ='Recov.Lander'  ; %  4 Quitar lander
    OperationID{ 7} ='Depl.Mooring'  ; %  7 Poner fondeo
    OperationID{ 8} ='Reco.Mooring'  ; %  8 Quitar fondeo
    OperationID{ 9} ='Arrival port'  ; %  9 Puerto de llegada
    OperationID{10} ='Depart. port'  ; %  0 Puerto de Salida
    OperationID{20} ='Operations'    ; % <0 Parados tiempo en days
end


%% Load regional settings
if isfield(Op,'Region')
    if exist('Globales.mat','file')== 2
        load Globales
        if exist(fullfile(GlobalSU.LibPath,'Settings',strcat('DS',Op.Region)),'file') == 1
            load(fullfile(GlobalSU.LibPath,'Settings',strcat('DS',Op.Region)));
        else
            load(fullfile(strcat('DS',Op.Region)));
        end
        BAT=load(GlobalDS.filebat);
        if isfield(BAT,'batylon')==0;BAT.batylon=BAT.bathylon;end
        if isfield(BAT,'batylat')==0;BAT.batylat=BAT.bathylat;end
    else
        fprintf('    > There is not Globales.mat file, taking baty fron the local directory \n')
        BAT=load(strcat(Op.Region,'Bat.mat'));
        GlobalDS.filecoast=strcat(Op.Region,'Coast.mat');
    end
end


%% Load stations
if exist(strcat('Estaciones',Op.Cruise,'.dat'),'file')>0
    StationsFile=strcat('Estaciones',Op.Cruise,'.dat');
elseif exist(strcat('Estaciones',Op.Cruise,'.txt'),'file')>0
    StationsFile=strcat('Estaciones',Op.Cruise,'.txt');
elseif exist(strcat('Estaciones',Op.Cruise,'.csv'),'file')>0
    StationsFile=strcat('Estaciones',Op.Cruise,'.csv');
end

fid = fopen(strcat(StationsFile));np=0;
while feof(fid)==0
    str=fgetl(fid);
    if ~isempty(str)
        if strcmp(str(1),'%')==0
            np=np+1;
            in=strfind(str,';');
            PointName{np} =deblank(str(1:in(1)-1));
            Point(np).name=deblank(str(1:in(1)-1));
            PointLon(np)=str2double(str(in(1)+1:in(2)-1));
            Point(np).Lon=str2double(str(in(1)+1:in(2)-1));
            if PointLon(np)>180
                PointLon(np)=PointLon(np)-360;
            end
            PointLat(np)=str2double(str(in(2)+1:in(3)-1));
            Point(np).Lat=str2double(str(in(2)+1:in(3)-1));
            PointID(np)=str2double(str(in(3)+1:end));
            Point(np).ID=str2double(str(in(3)+1:end));
        end
    end
end
fclose(fid);

%Find oceanographic stations (1=CTD,11=WP2, 14=BC,15=GC,16=ROV)
indiceEST=find(PointID==1 | PointID==11 | PointID==12 |PointID==13 |PointID==14 | PointID==15| PointID==16| PointID<0);

%Find moorings/landers
indiceMOOR=find(PointID==3 | PointID==4 | PointID==7 | PointID==8);

% Compute bottom depth at the stations
PointDepth=PointLon*0;
for ii=1:length(indiceEST)
    if max(PointLon)<180
        PointDepth(indiceEST(ii))=-BAT.elevations( ...
            Locate(BAT.batylat,PointLat(indiceEST(ii))), ...
            Locate(BAT.batylon,PointLon(indiceEST(ii))));
    else
        PointDepth(indiceEST(ii))=-BAT.elevations( ...
            Locate(BAT.batylat,PointLat(indiceEST(ii))), ...
            Locate(BAT.batylon,PointLon(indiceEST(ii))));
    end
end

%Find moorings or landers
for ii=1:length(indiceMOOR)
    PointDepth(indiceMOOR(ii))= -BAT.elevations(...
        Locate(BAT.batylat,PointLat(indiceMOOR(ii))), ...
        Locate(BAT.batylon,PointLon(indiceMOOR(ii))));
end
lonPg=fix(PointLon);
lonPm=(abs(PointLon)-abs(fix(PointLon)))*60;
latPg=fix(PointLat);
latPm=(abs(PointLat)-abs(fix(PointLat)))*60;

%% Make figure
figure(1)
m_proj(Op.Proj, ...
    'long',[Op.lon_min Op.lon_max],'lat',[Op.lat_min Op.lat_max]);hold on

if Op.ImagenSatelite==1 %Anado imagen de satelite si hubiera
    D=AddImageSatelite(Op.ImagenSateliteType,Op.ImagenSateliteDayi,GlobalDS);
    tituloIs=sprintf('%s %s',D.instrument,D.platform);
    tituloVarIs=sprintf('%s\n(%s)',D.long_name,D.units);
    tituloFechaIs=sprintf('%s:%s',D.TimeStart(1:10),D.TimeEnd(1:10));
    subfilename=sprintf('%s %s %s. %s:%s', ...
        D.instrument,D.platform,D.standard_name,D.TimeStart(1:10),D.TimeEnd(1:10));
end

% Add Batimetry
if Op.BatimetryColor==1 && Op.ImagenSatelite==0
    [CS,~]=m_contourf(BAT.batylon+Op.LonEConvMap,BAT.batylat,BAT.elevations,40,'edgecolor','none');hold on
    clim([min(min(BAT.elevations)) 0])
    colorbar
    colormap(m_colmap('blues'));
    set(gcf,'color','w');
end
if Op.BatimetryColor==2 && Op.ImagenSatelite==0
    [CS,~]=m_shadedrelief(BAT.batylon+Op.LonEConvMap,BAT.batylat,BAT.elevations);hold on
    clim([min(min(BAT.elevations)) 0])
    colorbar
    colormap(m_colmap('blues'));
    set(gcf,'color','w');
end
if Op.Batimetry==1
    Op.BatimetryIso=sort(Op.BatimetryIso,'descend');
    cbiso=linspace(0.5,1,length(Op.BatimetryIso));
    for iiso=1:length(Op.BatimetryIso)
        if Op.LonEConvMap==0
            [C,h]=m_contour(BAT.batylon,BAT.batylat,BAT.elevations, ...
                [Op.BatimetryIso(iiso) Op.BatimetryIso(iiso)],'color',cbiso(iiso)*[1 1 1]);
        else
            [C,h]=m_contour(BAT.batylon+360,BAT.batylat,BAT.elevations,...
                [Op.BatimetryIso(iiso) Op.BatimetryIso(iiso)],'color',cbiso(iiso)*[1 1 1]);
        end
        if Op.BatimetryIsoLabel(iiso)==1
            clabel(C,h,'FontSize',9,'LabelSpacing',500,'Color',cbiso(iiso)*[1 1 1])
        end
    end
end

%Add boxes if exist
if isfield(Op,'BoxCoor')
    for ic = 1:length(Op.BoxCoor.X)
        if isfield(Op.BoxCoor,'C')
            ColBox=Op.BoxCoor.C{ic};
        else
            ColBox='y';
        end
        m_line(Op.BoxCoor.X{ic}, Op.BoxCoor.Y{ic},'color',ColBox,'linewidth',2)
    end
end

m_grid('linestyle',':','fontsize',10)

if Op.Ruler==1
    m_ruler([.05 .35],.95,'tickdir','out','ticklen',[.007 .007]);
end

m_usercoast(GlobalDS.filecoast,'patch',[.7 .6 .4,],'edgecolor',[.7 .6 .4,]);

% Define color for the marks. It changes depending on the background color
if Op.BatimetryColor==1
    mfc='y'; %Marker face color
    mec='k'; %Marker edge color
    ctrack=rgb('gray');
elseif Op.ImagenSatelite>0
    %mfc=[0.85 0.85 0.85]; %Marker Face Color
    mfc='y';
    mec='r'; %Marker edge color
    ctrack=[0.85,0.85,0.85];
else
    mfc=rgb('black'); %Marker Face Color
    mec=rgb('black'); %Marker edge color
    ctrack=rgb('gray');
end

%Markers size
msports= 8;
msests = 8; %Markers size stations
msmo   = 10;


%% Departing and arrival ports
ihp=1;

for ii=1:length(PointLon)
    if PointID(ii)==10
        hp(ihp)=m_plot(PointLon(ii)+Op.LonEConvMap,PointLat(ii),'marker','o','markersize', ...
            msports,'MarkerEdgeColor','k','MarkerFaceColor','w');
        ihp=ihp+1;
    elseif PointID(ii)==9
        hp(ihp)=m_plot(PointLon(ii)+Op.LonEConvMap,PointLat(ii),'marker','o','markersize',...
            msports,'MarkerEdgeColor','k','MarkerFaceColor','w');
        ihp=ihp+1;
    end
end

%% Add stations
for ii=1:length(PointLon)
    estCTDnombre=str2double(PointName{ii});
    if PointID(ii)==1 || PointID(ii)==11 || PointID(ii)==12 || PointID(ii)==13 || PointID(ii)==14 || PointID(ii)==15 || PointID(ii)<0
        if any(estCTDnombre==Op.StaSpecMarks1)
            hp(ihp)=m_plot(PointLon(ii)+Op.LonEConvMap,PointLat(ii),'marker','o','markersize',msests+4, ...
                'MarkerEdgeColor',Op.StaSpecMarks1Color,'MarkerFaceColor',Op.StaSpecMarks1Color,'linestyle','none');
            if exist('hpstaSpec1','var') == 0
                hpstaSpec1=hp(ihp);
            end
            ihp=ihp+1;
        end
        if any(estCTDnombre==Op.StaSpecMarks2)
            hp(ihp)=m_plot(PointLon(ii)+Op.LonEConvMap,PointLat(ii),'s','markersize',msests+8, ...
                'MarkerEdgeColor',Op.StaSpecMarks2Color,'linestyle','none');
            if exist('hpstaSpec2','var') == 0
                hpstaSpec2=hp(ihp);
            end
            ihp=ihp+1;
        end
        hp(ihp)=m_plot(PointLon(ii)+Op.LonEConvMap,PointLat(ii),'marker','o','markersize',msests, ...
            'MarkerEdgeColor',mec,'MarkerFaceColor',mfc,'linestyle','none');
        if exist('hpstaSpec1','var') == 0
            hpsta=hp(ihp);
        end
        ihp=ihp+1;

    elseif PointID(ii)==2
        if Op.VesselTrack==1
            hp(ihp)=m_plot(PointLon(ii)+Op.LonEConvMap,PointLat(ii), ...
                'marker','.','markersize',2,'MarkerEdgeColor',mec,'MarkerFaceColor',mfc);
        end
    end
end

%% Add stations moorigns / landers
for ii=1:length(PointLon)
    if PointID(ii)==3
        hp(ihp)=m_plot(PointLon(ii)+Op.LonEConvMap,PointLat(ii),'marker','v', ...
            'markersize',msmo,'MarkerEdgeColor','k','MarkerFaceColor','y','linestyle','none');
        if exist('hpDLander','var') == 0
            hpDLander=hp(ihp);
        end
    elseif PointID(ii)==4
        hp(ihp)=m_plot(PointLon(ii)+Op.LonEConvMap,PointLat(ii),'marker','^', ...
            'markersize',msmo,'MarkerEdgeColor','k','MarkerFaceColor','y','linestyle','none');
        if exist('hpRLander','var') == 0
            hpRLander=hp(ihp);
        end
    elseif PointID(ii)==7
        hp(ihp)=m_plot(PointLon(ii)+Op.LonEConvMap,PointLat(ii),'marker','v', ...
            'markersize',msmo,'MarkerEdgeColor','k','MarkerFaceColor','y','linestyle','none');
        if exist('hpDMoor','var') == 0
            hpDMoor=hp(ihp);
        end
    elseif PointID(ii)==8
        hp(ihp)=m_plot(PointLon(ii)+Op.LonEConvMap,PointLat(ii), 'marker','^',...
            'markersize',msmo,'MarkerEdgeColor','k','MarkerFaceColor','y','linestyle','none');
        if exist('hpRMoor','var') == 0
            hpRMoor=hp(ihp);
        end
    end
end

%% Add Label the stations
DisTc=(Op.lat_max-Op.lat_min)/22;
if Op.StaTicks>=1
    for ii=1:length(PointID)
        estCTDnombre=str2double(PointName{ii});
        if ceil(estCTDnombre/Op.StaTicks)==estCTDnombre/Op.StaTicks
            %If the station is included in the Op.StaSpecMarks1 list it is
            %not labelled here
            if Op.StaSpecMarks1Ticks == 1
                if ~any(estCTDnombre==Op.StaSpecMarks1)
                    m_text(PointLon(ii)+Op.LonEConvMap,PointLat(ii)+DisTc,deblank(PointName{ii}), ...
                        'color',mec,'Fontsize',11,'HorizontalAlignment','center','VerticalAlignment','top');
                end
            else
                m_text(PointLon(ii)+Op.LonEConvMap,PointLat(ii)+DisTc,deblank(PointName{ii}), ...
                    'color',mec,'Fontsize',11,'HorizontalAlignment','center','VerticalAlignment','top');
            end
        end
    end
end

if Op.MoorTick == 1
    DisTcM=(Op.lat_max-Op.lat_min)/15;
    for ii=1:length(PointID)
        if PointID(ii)==3 || PointID(ii)==4 || PointID(ii)==7 || PointID(ii)==8
            m_text(PointLon(ii)+Op.LonEConvMap,PointLat(ii)+DisTcM,deblank(PointName{ii}), ...
                'color',mec,'backgroundcolor','y','Fontsize',11,'HorizontalAlignment','center','VerticalAlignment','top');

        end
    end
end
if Op.StaSpecMarks1Ticks == 1
    for ii=1:length(PointID)
        estCTDnombre=str2double(PointName{ii});
        if any(estCTDnombre==Op.StaSpecMarks1)
            m_text(PointLon(ii)+Op.LonEConvMap,PointLat(ii)+0.20,deblank(PointName{ii}), ...
                'color',mec,'Fontsize',11,'HorizontalAlignment','center','VerticalAlignment','top');
        end
    end
end

%% Titulos
if Op.ImagenSatelite>0 && isfield(Op,'ImagenSateliteTitulo')
    titulo=sprintf('%s %s',Op.Cruise,Op.ImagenSateliteTitulo);
else
    titulo=sprintf('%s',Op.Cruise);
end

%% Compute the dates of the stations
for ii=1:length(PointLon)-1
    %Distancia a la siguiente estacion o WP
    DistanciaPP(ii) = sw_dist([PointLat(ii) PointLat(ii+1)],[PointLon(ii) PointLon(ii+1)]);
end

%Output file
fid = fopen(strcat('PlanCampanha',Op.Cruise,'.txt'),'w');

%Output format f
StrFmt1= '%-19s;%-12s;%4d;%6.3f; %3d;%6.3f;%5.0f;%8s; %5.1f;%4.1f;%5.1f\n'; %CTD
StrFmt2= '%-19s;%-12s;%4d;%6.3f; %3d;%6.3f;%5s;%8s; %5s;%4.1f;%5.1f\n';  %Waypoint
StrFmt9= '%-19s;%-12s;%4d;%6.3f; %3d;%6.3f;%5s;%8s; %5s;%4.1f;%5s\n';    %ArrivalPort
StrFmt10='%-19s;%-12s;%4d;%6.3f; %3d;%6.3f;%5s;%8s; %5s;%4.1f;%5.1f\n';  %DeparturePort

%Output format format for Kml
StrFmtKml0= 'Navegacion a la primera estación:%5.1f miles\n Fecha llegada primera estación:%s\n';
StrFmtKml1a='Station %s - %s\nFecha llegada a la estación %s\n';
StrFmtKml1b='Profundidad estación:%5.0f metros\n';
StrFmtKml1c='Tiempo en estación:%4.2f horas\n Navegacion a la siguiente estación:%5.1f miles';
StrFmtKml1=[StrFmtKml1a StrFmtKml1b StrFmtKml1c];

%Header output file
if Op.Idioma==2
    fprintf(fid,'Station            ;Operation   ;LonG;LonM  ;LatG;LatM  ;Dep-m;Arrival date   ;Hour ;Whours;Day ;Naveg\n');
    fprintf(    '------------------------------------------------------------------------------------------------------\n');
    fprintf(    'Station            ;Operation   ;LonG;LonM  ;LatG;LatM  ;Dep-m;Arrival date   ;Hour ;Whours;Day ;Naveg\n');

elseif Op.Idioma==1
    fprintf(fid,'Estación           ;Operación   ;LonG;LonM  ;LatG;LatM  ;Pro-m;Fecha llegada  ;Hora ;horasT;Dia ;Naveg\n');
    fprintf(    '------------------------------------------------------------------------------------------------------\n');
    fprintf(    'Estación           ;Operación   ;LonG;LonM  ;LatG;LatM  ;Pro-m;Fecha llegada  ;Hora ;horasT;Dia ;Naveg\n');

end


%Departing port
ii=1;
TimeAtPoint(ii)=0;
DateAfterPoint(ii)=Op.DepartingDate;
DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

fprintf(fid,StrFmt10,PointName{ii},OperationID{10},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii),'-----', ...
    datestr(DateAfterPoint(ii),'ddd dd mmm yyyy;HH:MM'),'-----',DiaCampana(ii),DistanciaPP(ii));
fprintf(    StrFmt10,PointName{ii},OperationID{10},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii),'-----', ...
    datestr(DateAfterPoint(ii),'ddd dd mmm yyyy;HH:MM'),'-----',DiaCampana(ii),DistanciaPP(ii));

KmlNombrePunto{ii} =PointName{ii};
KmlDescripcionPunto{ii} =sprintf(StrFmtKml0,DistanciaPP(ii),datestr(Op.DepartingDate,0));

%Stations (CTD,BC,GC,ROV,Operations) and arrival port
diaOperacionDiaria=Op.DepartingDate;
StationNumber=0;

for ii=2:length(PointLon)
    %CTD code 1
    if PointID(ii)==1
        StationNumber=StationNumber+1;

        if Op.MaxProfCTD>0
            if PointDepth(ii)>Op.MaxProfCTD
                PointDepth(ii)=Op.MaxProfCTD;
            end
        end

        %Subida y bajada a 1 m/s, mas tiempo por estación para cosas varias.
        TimeAtPoint(ii)=(2*PointDepth(ii)*(60/Op.VelocityCTD)/3600)+Op.TStation; %En horas
        TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
        DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
        FechaTrasStation(StationNumber)=DateAfterPoint(ii);
        DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

        KmlDescripcionPunto{ii} =sprintf(StrFmtKml1,PointName{ii},OperationID{1},...
            datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24, ...
            'ddd dd mmm yyyy - HH:MM'),PointDepth(ii),TimeAtPoint(ii),DistanciaPP(ii));
        KmlNombrePunto{ii} =PointName{ii};

        % Add Daily time for operations
        if Op.DailyAOperation>0
            [y,mo,d,~,~,~] = datevec(DateAfterPoint(ii));
            if ceil(DateAfterPoint(ii))~=diaOperacionDiaria %Hemos cambiado de dia
                diaOperacionDiaria=ceil(DateAfterPoint(ii));
                fprintf('               ;Daily Op.   ;    ;      ;    ;      ;     ;%s\n',datestr(datenum(y,mo,d),1))
                TimeAtPoint(ii)=TimeAtPoint(ii)+Op.DailyAOperation;
                TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
                DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
                FechaTrasStation(StationNumber)=DateAfterPoint(ii);
                DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;
            end
        end

        StrOut=sprintf(StrFmt1,PointName{ii},OperationID{1},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii), ...
            PointDepth(ii),datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy;HH:MM'), ...
            TimeAtPoint(ii),DiaCampana(ii),DistanciaPP(ii));
        fprintf(fid,StrOut);
        fprintf(StrOut);

        %WP2 code 11
    elseif PointID(ii)==11
        StationNumber=StationNumber+1;
        %Subida y bajada a 1 m/s, mas tiempo por estación para cosas varias.
        TimeAtPoint(ii)=Op.TWP2;
        TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
        DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
        FechaTrasStation(StationNumber)=DateAfterPoint(ii);
        DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

        KmlDescripcionPunto{ii} =sprintf(StrFmtKml1,PointName{ii},OperationID{11},...
            datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24, ...
            'ddd dd mmm yyyy - HH:MM'),PointDepth(ii),TimeAtPoint(ii),DistanciaPP(ii));
        KmlNombrePunto{ii} =PointName{ii};

        % Add Daily time for operations
        if Op.DailyAOperation>0
            [y,mo,d,~,~,~] = datevec(DateAfterPoint(ii));
            if ceil(DateAfterPoint(ii))~=diaOperacionDiaria %Hemos cambiado de dia
                diaOperacionDiaria=ceil(DateAfterPoint(ii));
                fprintf('               ;Daily Op.   ;    ;      ;    ;      ;     ;%s\n',datestr(datenum(y,mo,d),1))
                TimeAtPoint(ii)=TimeAtPoint(ii)+Op.DailyAOperation;
                TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
                DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
                FechaTrasStation(StationNumber)=DateAfterPoint(ii);
                DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;
            end
        end

        StrOut=sprintf(StrFmt1,PointName{ii},OperationID{11},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii), ...
            PointDepth(ii),datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy;HH:MM'), ...
            TimeAtPoint(ii),DiaCampana(ii),DistanciaPP(ii));
        fprintf(fid,StrOut);
        fprintf(StrOut);

        %Bongo code 12
    elseif PointID(ii)==12
        StationNumber=StationNumber+1;
        %Subida y bajada a 1 m/s, mas tiempo por estación para cosas varias.
        TimeAtPoint(ii)=Op.TBongo;
        TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
        DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
        FechaTrasStation(StationNumber)=DateAfterPoint(ii);
        DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

        KmlDescripcionPunto{ii} =sprintf(StrFmtKml1,PointName{ii},OperationID{12},...
            datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24, ...
            'ddd dd mmm yyyy - HH:MM'),PointDepth(ii),TimeAtPoint(ii),DistanciaPP(ii));
        KmlNombrePunto{ii} =PointName{ii};

        % Add Daily time for operations
        if Op.DailyAOperation>0
            [y,mo,d,~,~,~] = datevec(DateAfterPoint(ii));
            if ceil(DateAfterPoint(ii))~=diaOperacionDiaria %Hemos cambiado de dia
                diaOperacionDiaria=ceil(DateAfterPoint(ii));
                fprintf('               ;Daily Op.   ;    ;      ;    ;      ;     ;%s\n',datestr(datenum(y,mo,d),1))
                TimeAtPoint(ii)=TimeAtPoint(ii)+Op.DailyAOperation;
                TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
                DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
                FechaTrasStation(StationNumber)=DateAfterPoint(ii);
                DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;
            end
        end

        StrOut=sprintf(StrFmt1,PointName{ii},OperationID{12},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii), ...
            PointDepth(ii),datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy;HH:MM'), ...
            TimeAtPoint(ii),DiaCampana(ii),DistanciaPP(ii));
        fprintf(fid,StrOut);
        fprintf(StrOut);


        %Red Avani
    elseif PointID(ii)==13
        StationNumber=StationNumber+1;
        %Subida y bajada a 1 m/s, mas tiempo por estación para cosas varias.
        TimeAtPoint(ii)=Op.TAvani;
        TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
        DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
        FechaTrasStation(StationNumber)=DateAfterPoint(ii);
        DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

        KmlDescripcionPunto{ii} =sprintf(StrFmtKml1,PointName{ii},OperationID{13},...
            datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24, ...
            'ddd dd mmm yyyy - HH:MM'),PointDepth(ii),TimeAtPoint(ii),DistanciaPP(ii));
        KmlNombrePunto{ii} =PointName{ii};

        % Add Daily time for operations
        if Op.DailyAOperation>0
            [y,mo,d,~,~,~] = datevec(DateAfterPoint(ii));
            if ceil(DateAfterPoint(ii))~=diaOperacionDiaria %Hemos cambiado de dia
                diaOperacionDiaria=ceil(DateAfterPoint(ii));
                fprintf('               ;Daily Op.   ;    ;      ;    ;      ;     ;%s\n',datestr(datenum(y,mo,d),1))
                TimeAtPoint(ii)=TimeAtPoint(ii)+Op.DailyAOperation;
                TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
                DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
                FechaTrasStation(StationNumber)=DateAfterPoint(ii);
                DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;
            end
        end

        StrOut=sprintf(StrFmt1,PointName{ii},OperationID{13},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii), ...
            PointDepth(ii),datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy;HH:MM'), ...
            TimeAtPoint(ii),DiaCampana(ii),DistanciaPP(ii));
        fprintf(fid,StrOut);
        fprintf(StrOut);

    elseif PointID(ii)==14 %BoxCore
        StationNumber=StationNumber+1;
        %Subida y bajada a 1 m/s, mas tiempo por estación para cosas varias.
        TimeAtPoint(ii)=(2*PointDepth(ii)*(60/Op.VelocityBC)/3600);
        TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24;
        DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
        FechaTrasStation(StationNumber)=DateAfterPoint(ii);
        DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

        KmlDescripcionPunto{ii} =sprintf(StrFmtKml1,PointName{ii},OperationID{14},...
            datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24, ...
            'ddd dd mmm yyyy - HH:MM'),PointDepth(ii),TimeAtPoint(ii),DistanciaPP(ii));
        KmlNombrePunto{ii} =PointName{ii};

        % Add Daily time for operations
        if Op.DailyAOperation>0
            [y,mo,d,~,~,~] = datevec(DateAfterPoint(ii));
            if ceil(DateAfterPoint(ii))~=diaOperacionDiaria %Hemos cambiado de dia
                diaOperacionDiaria=ceil(DateAfterPoint(ii));
                fprintf('               ;Daily Op.   ;    ;      ;    ;      ;     ;%s\n',datestr(datenum(y,mo,d),1))
                TimeAtPoint(ii)=TimeAtPoint(ii)+Op.DailyAOperation;
                TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
                DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
                FechaTrasStation(StationNumber)=DateAfterPoint(ii);
                DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;
            end
        end

        StrOut=sprintf(StrFmt1,PointName{ii},OperationID{12},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii),...
            PointDepth(ii),datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy;HH:MM'),...
            TimeAtPoint(ii),DiaCampana(ii),DistanciaPP(ii));
        fprintf(fid,StrOut);
        fprintf(StrOut);

        %GravityCore
    elseif PointID(ii)==15
        StationNumber=StationNumber+1;
        TimeAtPoint(ii)=(2*PointDepth(ii)*(60/Op.VelocityGC)/3600);
        TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24;
        DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
        FechaTrasStation(StationNumber)=DateAfterPoint(ii);
        DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

        KmlDescripcionPunto{ii} =sprintf(StrFmtKml1,PointName{ii},OperationID{15},...
            datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy - HH:MM'),PointDepth(ii),...
            TimeAtPoint(ii),DistanciaPP(ii));
        KmlNombrePunto{ii} =PointName{ii};

        % Add Daily time for operations
        if Op.DailyAOperation>0
            [y,mo,d,~,~,~] = datevec(DateAfterPoint(ii));
            if ceil(DateAfterPoint(ii))~=diaOperacionDiaria %Hemos cambiado de dia
                diaOperacionDiaria=ceil(DateAfterPoint(ii));
                fprintf('               ;Daily Op.   ;    ;      ;    ;      ;     ;%s\n',datestr(datenum(y,mo,d),1))
                TimeAtPoint(ii)=TimeAtPoint(ii)+Op.DailyAOperation;
                TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
                DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
                FechaTrasStation(StationNumber)=DateAfterPoint(ii);
                DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;
            end
        end

        StrOut=sprintf(StrFmt1,PointName{ii},OperationID{15},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii), ...
            PointDepth(ii),datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy;HH:MM'),...
            TimeAtPoint(ii),DiaCampana(ii),DistanciaPP(ii));
        fprintf(fid,StrOut);
        fprintf(    StrOut);

        %ROV
    elseif PointID(ii)==16
        StationNumber=StationNumber+1;
        if PointDepth(ii)>Op.DepthROV
            PointDepth(ii)=Op.DepthROV;
        end
        %Subida y bajada a 1 m/s, mas tiempo por estación para cosas varias.
        TimeAtPoint(ii)=(2*PointDepth(ii)*(60/Op.VelocityROV)/3600);
        TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24;
        DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
        FechaTrasStation(StationNumber)=DateAfterPoint(ii);
        DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

        KmlDescripcionPunto{ii} =sprintf(StrFmtKml1,PointName{ii},OperationID{16},...
            datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy - HH:MM'),...
            PointDepth(ii),TimeAtPoint(ii),DistanciaPP(ii));
        KmlNombrePunto{ii}=PointName{ii};

        % Add Daily time for operations
        if Op.DailyAOperation>0
            [y,mo,d,~,~,~] = datevec(DateAfterPoint(ii));
            if ceil(DateAfterPoint(ii))~=diaOperacionDiaria %Hemos cambiado de dia
                diaOperacionDiaria=ceil(DateAfterPoint(ii));
                fprintf('               ;Daily Op.   ;    ;      ;    ;      ;     ;%s\n',datestr(datenum(y,mo,d),1))
                TimeAtPoint(ii)=TimeAtPoint(ii)+Op.DailyAOperation;
                TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
                DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
                FechaTrasStation(StationNumber)=DateAfterPoint(ii);
                DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;
            end
        end

        StrOut=sprintf(StrFmt1,PointName{ii},OperationID{16},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii),...
            PointDepth(ii),datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy;HH:MM'),...
            TimeAtPoint(ii),DiaCampana(ii),DistanciaPP(ii));
        fprintf(fid,StrOut);
        fprintf(    StrOut);


        %Operations by time
    elseif (PointID(ii)<0)
        StationNumber=StationNumber+1;
        TimeAtPoint(ii)=-PointID(ii)*24; %Tiempo es estación para cosas varias.
        TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24;
        DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
        FechaTrasStation(StationNumber)=DateAfterPoint(ii);
        DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

        KmlDescripcionPunto{ii} =sprintf(StrFmtKml1,PointName{ii},OperationID{11}, ...
            datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy - HH:MM'), ...
            PointDepth(ii),TimeAtPoint(ii),DistanciaPP(ii));
        KmlNombrePunto{ii} =PointName{ii};

        % Add Daily time for operations
        if Op.DailyAOperation>0
            [y,mo,d,~,~,~] = datevec(DateAfterPoint(ii));
            if ceil(DateAfterPoint(ii))~=diaOperacionDiaria %Hemos cambiado de dia
                diaOperacionDiaria=ceil(DateAfterPoint(ii));
                fprintf('               ;Daily Op.   ;    ;      ;    ;      ;     ;%s\n',datestr(datenum(y,mo,d),1))
                TimeAtPoint(ii)=TimeAtPoint(ii)+Op.DailyAOperation;
                TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
                DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
                FechaTrasStation(StationNumber)=DateAfterPoint(ii);
                DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;
            end
        end

        StrOut=sprintf(StrFmt1,PointName{ii},OperationID{20},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii), ...
            PointDepth(ii),datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy;HH:MM'), ...
            TimeAtPoint(ii),DiaCampana(ii),DistanciaPP(ii));
        fprintf(fid,StrOut);
        fprintf(    StrOut);

        % WayPoint
    elseif PointID(ii)==2
        TimeAtPoint(ii)=0;
        TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24;
        DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
        DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

        KmlDescripcionPunto{ii} =sprintf('Waypoint navegation to next station (nm) %5.1f \nDate %s \n', ...
            DistanciaPP(ii),datestr(DateAfterPoint(ii),0));
        KmlNombrePunto{ii} =PointName{ii};

        % Add Daily time for operations
        if Op.DailyAOperation>0
            [y,mo,d,~,~,~] = datevec(DateAfterPoint(ii));
            if ceil(DateAfterPoint(ii))~=diaOperacionDiaria %Hemos cambiado de dia
                diaOperacionDiaria=ceil(DateAfterPoint(ii));
                fprintf('               ;Daily Op.   ;    ;      ;    ;      ;     ;%s\n',datestr(datenum(y,mo,d),1))
                TimeAtPoint(ii)=TimeAtPoint(ii)+Op.DailyAOperation;
                TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
                DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
                DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;
            end
        end

        StrOut=sprintf(StrFmt2,PointName{ii},OperationID{2},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii), ...
            '-----',datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy;HH:MM'),'-----', ...
            DiaCampana(ii),DistanciaPP(ii));
        fprintf(fid,StrOut);
        fprintf(    StrOut);

        %Deploy lander (3)
    elseif (PointID(ii)==3)
        %Subida y bajada a  m/s, mas tiempo por estación para cosas varias.
        TimeAtPoint(ii)=(2*PointDepth(ii)*(60/Op.VelocityLander)/3600)+Op.TLander;
        TimeAtPoint(ii)=2*(2*PointDepth(ii)/3600)+Op.TLander; %El lander sube y baja a 30m/min,
        TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24;
        DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
        DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

        KmlDescripcionPunto{ii} ='DLander';
        KmlNombrePunto{ii} =PointName{ii};

        % Add Daily time for operations
        if Op.DailyAOperation>0
            [y,mo,d,~,~,~] = datevec(DateAfterPoint(ii));
            if ceil(DateAfterPoint(ii))~=diaOperacionDiaria %Hemos cambiado de dia
                diaOperacionDiaria=ceil(DateAfterPoint(ii));
                fprintf('               ;Daily Op.   ;    ;      ;    ;      ;     ;%s\n',datestr(datenum(y,mo,d),1))
                TimeAtPoint(ii)=TimeAtPoint(ii)+Op.DailyAOperation;
                TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
                DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
                FechaTrasStation(StationNumber)=DateAfterPoint(ii);
                DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;
            end
        end

        StrOut=sprintf(StrFmt1,PointName{ii},OperationID{3},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii),...
            PointDepth(ii),datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy;HH:MM'), ...
            TimeAtPoint(ii),DiaCampana(ii),DistanciaPP(ii));
        fprintf(fid,StrOut);
        fprintf(    StrOut);

        % Recover lander (4)
    elseif PointID(ii)==4
        %Subida y bajada a 1 m/s, mas tiempo por estación para cosas varias.
        TimeAtPoint(ii)=2*(2*PointDepth(ii)/3600)+Op.TLander; %El lander sube y baja a 30m/min,
        TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24;
        DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
        DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

        KmlDescripcionPunto{ii} ='RLander';
        KmlNombrePunto{ii} =PointName{ii};

        % Add Daily time for operations
        if Op.DailyAOperation>0
            [y,mo,d,~,~,~] = datevec(DateAfterPoint(ii));
            if ceil(DateAfterPoint(ii))~=diaOperacionDiaria %Hemos cambiado de dia
                diaOperacionDiaria=ceil(DateAfterPoint(ii));
                fprintf('               ;Daily Op.   ;    ;      ;    ;      ;     ;%s\n',datestr(datenum(y,mo,d),1))
                TimeAtPoint(ii)=TimeAtPoint(ii)+Op.DailyAOperation;
                TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
                DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
                FechaTrasStation(StationNumber)=DateAfterPoint(ii);
                DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;
            end
        end

        StrOut=sprintf(StrFmt1,PointName{ii},OperationID{4},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii), ...
            PointDepth(ii),datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy;HH:MM'), ...
            TimeAtPoint(ii),DiaCampana(ii),DistanciaPP(ii));
        fprintf(fid,StrOut);
        fprintf(    StrOut);

        % Deploy Mooring (7)
    elseif (PointID(ii)==7)
        %Subida y bajada a 1 m/s, mas tiempo por estación para cosas varias.
        TimeAtPoint(ii)=(2*PointDepth(ii)/3600)+Op.TMooring;
        TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24;
        DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
        DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

        KmlDescripcionPunto{ii} ='Deploy Mooring';
        KmlNombrePunto{ii} =PointName{ii};

        % Add Daily time for operations
        if Op.DailyAOperation>0
            [y,mo,d,~,~,~] = datevec(DateAfterPoint(ii));
            if ceil(DateAfterPoint(ii))~=diaOperacionDiaria %Hemos cambiado de dia
                diaOperacionDiaria=ceil(DateAfterPoint(ii));
                fprintf('               ;Daily Op.   ;    ;      ;    ;      ;     ;%s\n',datestr(datenum(y,mo,d),1))
                TimeAtPoint(ii)=TimeAtPoint(ii)+Op.DailyAOperation;
                TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
                DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
                FechaTrasStation(StationNumber)=DateAfterPoint(ii);
                DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;
            end
        end

        StrOut=sprintf(StrFmt1,PointName{ii},OperationID{7},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii),...
            PointDepth(ii),datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy;HH:MM'), ...
            TimeAtPoint(ii),DiaCampana(ii),DistanciaPP(ii));
        fprintf(fid,StrOut);
        fprintf(    StrOut);

        %Recover Mooring (8)
    elseif (PointID(ii)==8)
        %Subida y bajada a 1 m/s, mas tiempo por estación para cosas varias.
        TimeAtPoint(ii)=(2*PointDepth(ii)/3600)+Op.TMooring;
        TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24;
        DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
        DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

        KmlDescripcionPunto{ii} ='Recover mooring';
        KmlNombrePunto{ii} =PointName{ii};

        % Add Daily time for operations
        if Op.DailyAOperation>0
            [y,mo,d,~,~,~] = datevec(DateAfterPoint(ii));
            if ceil(DateAfterPoint(ii))~=diaOperacionDiaria %Hemos cambiado de dia
                diaOperacionDiaria=ceil(DateAfterPoint(ii));
                fprintf('               ;Daily Op.   ;    ;      ;    ;      ;     ;%s\n',datestr(datenum(y,mo,d),1))
                TimeAtPoint(ii)=TimeAtPoint(ii)+Op.DailyAOperation;
                TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24; %En dias
                DateAfterPoint(ii)=Op.DepartingDate+Op.Delay+TimeAfterPoint(ii);
                FechaTrasStation(StationNumber)=DateAfterPoint(ii);
                DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;
            end
        end

        StrOut=sprintf(StrFmt1,PointName{ii},OperationID{8},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii), ...
            PointDepth(ii),datestr(DateAfterPoint(ii)-TimeAtPoint(ii)/24,'ddd dd mmm yyyy;HH:MM'), ...
            TimeAtPoint(ii),DiaCampana(ii),DistanciaPP(ii));
        fprintf(fid,StrOut);
        fprintf(    StrOut);

        %Arrival port
    elseif (PointID(ii)==9) && ii>1
        TimeAtPoint(ii)=0;
        TimeAfterPoint(ii)=(sum(DistanciaPP(1:ii-1))/Op.VelocityVessel)/24+sum(TimeAtPoint(2:ii))/24;
        DateAfterPoint(ii)=Op.DepartingDate+TimeAfterPoint(ii)+Op.Delay;
        DiaCampana(ii)=DateAfterPoint(ii)-TimeAtPoint(ii)/24-Op.DepartingDate+1;

        KmlDescripcionPunto{ii} =sprintf('%s, \n LLegada el fecha%s\n', ...
            OperationID{9},datestr(DateAfterPoint(ii),0));
        KmlNombrePunto{ii} =PointName{ii};

        StrOut=sprintf(StrFmt9,PointName{ii},OperationID{9},lonPg(ii),lonPm(ii),latPg(ii),latPm(ii), ...
            '-----',datestr(DateAfterPoint(ii),'ddd dd mmm yyyy;HH:MM'),'-----',DiaCampana(ii),'-----');
        fprintf(fid,StrOut);
        fprintf(    StrOut);
    end

end

% Compute total time and distance
TotalDistance=sum(DistanciaPP);%Distancia total recorrida
TotalTimeStations=sum(TimeAtPoint);%Tiempo total en stations en horas

%% Vessel track
if Op.VesselTrack==1
    m_plot(PointLon+Op.LonEConvMap,PointLat,'--','color',ctrack,'linewidth',1)
elseif Op.VesselTrack==2
    m_track(PointLon+Op.LonEConvMap,PointLat,DateAfterPoint, ...
        'ticks',24*60,'times',-1,'dates',-1,'orien','upright','datef',24)
end


%% Añadir ZEEs
if Op.ZEE==1
    fprintf(    'Adding ZEEs');
    load('Globales.mat','GlobalSU')
    if exist(strcat(GlobalSU.DatPath,'/Costa/WorldEEZ/eez_v10.shp'),'file')==2
        S=shaperead(strcat(GlobalSU.DatPath,'/Costa/WorldEEZ/eez_v10.shp'));
        for i1=1:length(S)
            m_plot(S(i1).X+Op.LonEConvMap,S(i1).Y,'-','color',[0.75 0.75 0.75]);hold on
        end
    else
        fprintf(    'There is not .shp file in GlobalSU.DatPath/Costa/WorldEEZ/eez_v10.shp');
    end
end

%% Add subtitle
if Op.Subtitle==1
    if Op.Idioma==1
        Subtitulo=sprintf('%s - %s.\n%d estaciones, %2d fondeos, %5.1f millas', ...
            PointName{1},PointName{end},length(indiceEST),length(indiceMOOR),TotalDistance);
    elseif Op.Idioma==2
        Subtitulo=sprintf('%s - %s.\n%d stations, %2d moorings, %5.1f miles', ...
            PointName{1},PointName{end},length(indiceEST),length(indiceMOOR),TotalDistance);
    end
elseif Op.Subtitle==2
    TotalTime=(TotalDistance/Op.VelocityVessel)/24+TotalTimeStations/24;
    if Op.Idioma==1
        Subtitulo=sprintf('%s [%s] - %s [%s].\n%d estaciones, %2d fondeos, %5.1f millas, %6.2f dias a %3.1f nudos', ...
            PointName{1},datestr(DateAfterPoint(1),1),PointName{end},datestr(DateAfterPoint(end),1), ...
            length(indiceEST),length(indiceMOOR),TotalDistance,TotalTime,Op.VelocityVessel);
    elseif Op.Idioma==2
        Subtitulo=sprintf('%s [%s] - %s [%s].\n%d stations, %2d moorings, %5.1f miles, %6.2f days at %3.1f knots', ...
            PointName{1},datestr(DateAfterPoint(1),1),PointName{end},datestr(DateAfterPoint(end),1), ...
            length(indiceEST),length(indiceMOOR),TotalDistance,TotalTime,Op.VelocityVessel);
    end
elseif Op.Subtitle==0
    Subtitulo='';
end

if isfield(Op,'XL1') && isfield(Op,'YL1') &&  isfield(Op,'XL2') && isfield(Op,'YL2')
    m_text(Op.XL1,Op.YL1,titulo, ...
        'Interpreter','none','HorizontalAlignment','center','FontSize',16, ...
        'FontWeight','bold');
    m_text(Op.XL2,Op.YL2,Subtitulo , ...
        'Interpreter','none','HorizontalAlignment','center','FontSize',12);
else
    ht=title(titulo,'interpreter','none');
    ht.FontSize=14;
    xlabel(Subtitulo);
end


%% Add Logo
if Op.Logo==1
    Logo;
end

%% legenda
if Op.Legend==1
    ileg=1;
    if exist('hpsta','var')
        hpsL(ileg)=hpsta;
        textsL{ileg}=OperationID{ 1};
        ileg=ileg+1;
    end
    if isfield(Op,'StaSpecMarks1Legend') & exist('hpstaSpec1','var')
        hpsL(ileg)=hpstaSpec1;
        textsL{ileg}=Op.StaSpecMarks1Legend;
        ileg=ileg+1;
    end
    if isfield(Op,'StaSpecMarks2Legend') & exist('hpstaSpec2','var')
        hpsL(ileg)=hpstaSpec2;
        textsL{ileg}=Op.StaSpecMarks2Legend;
        ileg=ileg+1;
    end
    if exist('hpLander','var')
        hpsL(ileg)=hpLander;
        textsL{ileg}=OperationID{ 3};
        ileg=ileg+1;
    end
    if exist('hpDMoor','var')
        hpsL(ileg)=hpDMoor;
        textsL{ileg}=OperationID{ 7};
        ileg=ileg+1;
    end

    if exist('hpRMoor','var')
        hpsL(ileg)=hpRMoor;
        textsL{ileg}=OperationID{ 8};
        ileg=ileg+1;
    end

    hpLegend=legend(hpsL, textsL);
    hpLegend.FontSize=12;
end
Dataout.hpLegend=hpLegend;


%% Summary

fprintf(fid,'\n------------------------------------------------------------------------------------------------------\n');
fprintf(    '\n------------------------------------------------------------------------------------------------------\n');

if Op.Idioma==1
    fprintf('RESUMEN ----------------------------------------------------------------------------------------------\n\n');
    fprintf('%s: %s [%s] - %s [%s], %4d estaciones, %5.1f millas, %5.2f dias a %3.1f nudos\n\n', ...
        Op.Cruise,PointName{1},datestr(DateAfterPoint(1),0),PointName{end},datestr(DateAfterPoint(end),0), ...
        length(indiceEST),TotalDistance,DateAfterPoint(end)-Op.DepartingDate,Op.VelocityVessel);
    fprintf(fid,'RESUMEN ----------------------------------------------------------------------------------------------\n\n');
    fprintf(fid,'%s: %s [%s] - %s [%s], %4d estaciones, %5.1f miles, %5.2f days at %3.1f knots\n\n', ...
        Op.Cruise,PointName{1},datestr(DateAfterPoint(1),0),PointName{end},datestr(DateAfterPoint(end),0), ...
        length(indiceEST),TotalDistance,DateAfterPoint(end)-Op.DepartingDate,Op.VelocityVessel);

elseif Op.Idioma==2
    fprintf('SUMMARY ----------------------------------------------------------------------------------------------\n\n');
    fprintf('%s: %s [%s] - %s [%s], %4d stations, %5.1f miles, %5.2f days at %3.1f knots\n\n', ...
        Op.Cruise,PointName{1},datestr(DateAfterPoint(1),0),PointName{end},datestr(DateAfterPoint(end),0), ...
        length(indiceEST),TotalDistance,DateAfterPoint(end)-Op.DepartingDate,Op.VelocityVessel);
    fprintf(fid,'SUMMARY ----------------------------------------------------------------------------------------------\n\n');
    fprintf(fid,'%s: %s [%s] - %s [%s], %4d stations, %5.1f miles, %5.2f days at %3.1f knots\n\n', ...
        Op.Cruise,PointName{1},datestr(DateAfterPoint(1),0),PointName{end},datestr(DateAfterPoint(end),0), ...
        length(indiceEST),TotalDistance,DateAfterPoint(end)-Op.DepartingDate,Op.VelocityVessel);
end

for i1=[1,11,12,13,14,15,3,4,5,6,7,8]
    if ~isempty(find(PointID==i1, 1))
        fprintf('%s: %3d [', OperationID{ i1}, length(find(PointID==i1)));
        fprintf(fid  ,'%s: %3d [', OperationID{ i1}, length(find(PointID==i1)));
        estaciones=find(PointID==i1);
        for i2=1: length(estaciones)
            if i2==length(estaciones)
                fprintf('%s]\n\n',PointName{estaciones(i2)});
                fprintf(fid,'%s] \n\n',PointName{estaciones(i2)});
            else
                fprintf('%s, ',PointName{estaciones(i2)});
                fprintf(fid,'%s, ',PointName{estaciones(i2)});
            end
        end
    end
end
if ~isempty(find(PointID<0, 1))
    fprintf('%s: %3d [', OperationID{20}, length(find(PointID<0)));
    fprintf(fid  ,'%s: %3d [', OperationID{20}, length(find(PointID<0)));
    estaciones=find(PointID<0);
    for i2=1: length(estaciones)
        if i2==length(estaciones)
            fprintf('%s]\n\n',PointName{estaciones(i2)});
            fprintf(fid,'%s] \n\n',PointName{estaciones(i2)});
        else
            fprintf('%s, ',PointName{estaciones(i2)});
            fprintf(fid,'%s, ',PointName{estaciones(i2)});
        end
    end
end

if Op.Delay>0
    fprintf('Time delay used for adjustment: %4.2f \n\n', Op.Delay);
    fprintf(fid,  'Time delay used for adjustment: %4.2f \n\n', Op.Delay);
elseif Op.Delay<0
    fprintf('WARNING Time delay used for adjustment: %4.2f \n\n', Op.Delay);
    fprintf(fid,  'WARNING Time delay used for adjustment: %4.2f \n\n', Op.Delay);
end

if Op.Idioma==1
    fprintf(fid,  'El tiempo en cada estación se ha estimado usando la profundidad y una velocidad de descenso/ascenso de %2d/%2d/%2d/%2d (CTD/BC/GC/ROV) m/min. ', ...
        Op.VelocityCTD,Op.VelocityBC,Op.VelocityGC,Op.VelocityROV);
    fprintf('El tiempo en cada estación se ha estimado usando la profundidad y una velocidad de descenso/ascenso de %2d/%2d/%2d/%2d (CTD/BC/GC/ROV) m/min.\n', ...
        Op.VelocityCTD,Op.VelocityBC,Op.VelocityGC,Op.VelocityROV);
elseif Op.Idioma==2
    fprintf(fid,   'Time in each stations has been estimated using the actual depth and a descend/ascend velocity of %2d/%2d/%2d/%2d (CTD/BC/GC/ROV) m/min. ', ...
        Op.VelocityCTD,Op.VelocityBC,Op.VelocityGC,Op.VelocityROV);
    fprintf('Time in each stations has been estimated using the actual depth and a descend/ascend velocity of %2d/%2d/%2d/%2d (CTD/BC/GC/ROV) m/min.\n', ...
        Op.VelocityCTD,Op.VelocityBC,Op.VelocityGC,Op.VelocityROV);
end

if Op.Idioma==1
    fprintf(fid,  'En cada estación CTD se han añadido %3.2f h para posicionamiento.\n',Op.TStation);
    fprintf(      'En cada estación CTD se han añadido %3.2f h para posicionamiento.\n',Op.TStation);
elseif Op.Idioma==2
    fprintf(fid,  'In each CTD station %3.2f h has been added for positioning.\n',Op.TStation);
    fprintf(      'In each CTD station %3.2f h has been added for positioning.\n',Op.TStation);
end


if ~isempty(indiceMOOR)
    if Op.Idioma==1
        fprintf(fid,   'Para los fondeos/landers el tiempo se ha estimado usando la profundidad, con una velocidad de largado de  %2d/%2d m/min, y %3.2f/%3.2f h adicionales. \n\n', ...
            Op.VelocityMooring,Op.VelocityLander,Op.TMooring,Op.TLander);
        fprintf('Para los fondeos/landers el tiempo se ha estimado usando la profundidad, con una velocidad de largado de  %2d/%2d m/min, y %3.2f/%3.2f h adicionales. \n\n', ...
            Op.VelocityMooring,Op.VelocityLander,Op.TMooring,Op.TLander);
    elseif Op.Idioma==2
        fprintf(fid,   'For the moorings/landers the time has been estimated using the actual depth and a descend/ascend velocity of %2d/%2d m/min and additional %3.2f/%3.2f hours. \n\n', ...
            Op.VelocityMooring,Op.VelocityLander,Op.TMooring,Op.TLander);
        fprintf('For the moorings/landers the time has been estimated using the actual depth and a descend/ascend velocity of %2d/%2d m/min and additional %3.2f/%3.2f hours. \n\n', ...
            Op.VelocityMooring,Op.VelocityLander,Op.TMooring,Op.TLander);
    end

end

if Op.MaxProfCTD>0
    fprintf(fid,  ' Maximum depth for CTD was %5.1f m. ',Op.MaxProfCTD);
    fprintf(      ' Maximum depth for CTD was %5.2f m. \n',Op.MaxProfCTD);
end

if (now-Op.DepartingDate)<0
    if Op.Idioma==1
        fprintf('Días para el comienzo de la singladura: %4.2f \n\n',abs((now-Op.DepartingDate)))
    elseif Op.Idioma==2
        fprintf('Days to departure: %4.2f \n\n',abs((now-Op.DepartingDate)))
    end
else
    if Op.Idioma==1
        fprintf('Días desde el comienzo de la singladura: %4.2f \n\n',(now-Op.DepartingDate))
    elseif Op.Idioma==2
        fprintf('Days since departure: %4.2f \n\n',(now-Op.DepartingDate))
    end
end

fprintf(fid,'------------------------------------------------------------------------------------\n');
if Op.Idioma==1
    fprintf(fid,'Estación     - Nombre de la estación.\n');
    fprintf(fid,'Operación    - Código de la operación.\n');
    fprintf(fid,'LatG         - Grados de latitud.\n');
    fprintf(fid,'LatM         - Minutos de latitud.\n');
    fprintf(fid,'LonG         - Grados de longitud.\n');
    fprintf(fid,'LonM         - Minutos de longitud.\n');
    fprintf(fid,'Pro-m        - Profundidad (metros) en la estación.\n');
    fprintf(fid,'Fecha llegada- Fecha llegada a la estación.\n');
    fprintf(fid,'Hora         - Hora llegada a la estación.\n');
    fprintf(fid,'horasT       - Horas de trabajo en la estación.\n');
    fprintf(fid,'Dia          - Dia de campaña (La campaña comienza el día 1).\n');
    fprintf(fid,'Naveg        - Navegación a la siguiente estación en millas nauticas.\n');
elseif Op.Idioma==2
    fprintf(fid,'Station     - Name of the station.\n');
    fprintf(fid,'Operation   - Operation code (depart port, waypoint, CTD, ,...) for the stations.\n');
    fprintf(fid,'LatG        - Degrees of latitude.\n');
    fprintf(fid,'LatM        - Minutes of latitude.\n');
    fprintf(fid,'LonG        - Degrees of longitude.\n');
    fprintf(fid,'LonM        - Minutes of longitude.\n');
    fprintf(fid,'Dep-m       - Depth (metres) at the station.\n');
    fprintf(fid,'Arriv. date - Arrival date to the station.\n');
    fprintf(fid,'Hour        - Hour of arrival to the station.\n');
    fprintf(fid,'WHours      - Hours working in the station.\n');
    fprintf(fid,'Day         - Cruise day (the cruise begins in day 1).\n');
    fprintf(fid,'Naveg       - Navegation to the next station in nautical miles.\n');
end

fclose(fid);

%% Output data
DataOut.PointID=PointID;
DataOut.TimeAtPoint=TimeAtPoint;
DataOut.Nombre=PointName;
DataOut.Lon=PointLon;
DataOut.Lat=PointLat;
DataOut.Codigo=PointID;
DataOut.Profundidad=PointDepth;
DataOut.hp=hp;
DataOut.DiaCampana=DiaCampana;
DataOut.DateAtPoint=DateAfterPoint-TimeAtPoint/24;


%% Formato Kml (Google earth)
if isfield(Op,'OutputKml')==1
    if Op.OutputKml==1
        imagesdir=which(mfilename);
        iconfilename=strcat(imagesdir(1:end-14),'Images/','circle','_','b','.png');
        if exist(iconfilename,'file')
            kmlwritepoint(strcat('PlanCampanha',Op.Cruise),PointLat,PointLon,'Name', ...
                KmlNombrePunto,'Description',KmlDescripcionPunto,'Icon',iconfilename,'IconScale',.5)
        else
            kmlwritepoint(strcat('PlanCampanha',Op.Cruise),PointLat,PointLon,'Name', ...
                KmlNombrePunto,'Description',KmlDescripcionPunto)
        end
    end
end

%% GPX
if isfield(Op,'OutputGPX')==1
    fid = fopen(strcat('PlanCampanha',Op.Cruise,'.gpx'),'w');
    fprintf(fid,'<?xml version="1.0"?>\n');
    fprintf(fid,'<gpx version="1.1">\n');
    for iest=1:length(PointLat)
        fprintf(fid, '<wpt lat="%12.9f" lon="%12.9f">\n',PointLat(iest),PointLon(iest));
        fprintf(fid, '    <name>%s</name>\n',KmlNombrePunto{iest});
        fprintf(fid, '    <desc>%s</desc> \n',KmlDescripcionPunto{iest});
        fprintf(fid, '    <sym>circle</sym>\n');
        fprintf(fid,'    <type>WPT</type>\n');
        fprintf(fid, '</wpt>\n');
    end
    fprintf(fid, '</gpx>\n');
end

if isfield(Op,'OutputMFP')==1
    fid = fopen(strcat('PlanCampanha',Op.Cruise,'.csv'),'w');
    fprintf(fid, 'Station Type;Name;Latitude;Longitude\n');
    for iest=1:length(PointLat)
        if PointID(iest)==1 | PointID(iest)==11 | PointID(iest)==12 | PointID(iest)==13| PointID(iest)==14| PointID(iest)<0
            fprintf(fid, 'Sampling Station;%s;%9.5f;%9.5f\n',PointName{iest},PointLat(iest),PointLon(iest));
        elseif PointID(iest)==7| PointID(iest)==8
            fprintf(fid, 'Mooring;%s;%9.5f;%9.5f\n',PointName{iest},PointLat(iest),PointLon(iest));
        elseif PointID(iest)==3 | PointID(iest)==4
            fprintf(fid, 'Lander;%s;%9.5f;%9.5f\n',PointName{iest},PointLat(iest),PointLon(iest));
        elseif PointID(iest)==2
            fprintf(fid, 'Waypoint;%s;%9.5f;%9.5f\n',PointName{iest},PointLat(iest),PointLon(iest));
        end
    end
end


%% Save mat file
if Op.Plot3d==1
    figure
    surf(BAT.batylon,BAT.batylat,BAT.elevations);hold on
    shading interp
    axis([Op.lon_min Op.lon_max Op.lat_min Op.lat_max]);
    for i1=1:length(PointLon)
        if PointID(i1) == 1
            plot3([PointLon(i1) PointLon(i1)],[PointLat(i1) PointLat(i1)],[-PointDepth(i1) 0],'-k')
            plot3([PointLon(i1) PointLon(i1)],[PointLat(i1) PointLat(i1)],[0 0],'ko','markerfacecolor','k')
            plot3([PointLon(i1) PointLon(i1)],[PointLat(i1) PointLat(i1)],[-PointDepth(i1) 0],'k.','markerfacecolor','k')
        end
    end
    clim([min(min(BAT.elevations)) 0])
    colorbar
    colormap(m_colmap('blues'));
    set(gcf,'color','w');

    if Op.Batimetry==1
        Op.BatimetryIso=sort(Op.BatimetryIso,'descend');
        cbiso=linspace(0.5,1,length(Op.BatimetryIso));
        for iiso=1:length(Op.BatimetryIso)

            [C,h]=contour3(BAT.batylon+Op.LonEConvMap,BAT.batylat,BAT.elevations,...
                [Op.BatimetryIso(iiso) Op.BatimetryIso(iiso)],'color',cbiso(iiso)*[1 1 1]);
            if Op.BatimetryIsoLabel(iiso)==1
                clabel(C,h,'FontSize',9,'LabelSpacing',500,'Color',cbiso(iiso)*[1 1 1])
            end
        end
    end
end

%% Save mat file
if isfield(Op,'OutputMat')==1
    if Op.OutputMat==1
        save(strcat('PlanCampanha',Op.Cruise))
    end
end

%% Create figures
if isfield(Op,'OutputFigures')==1
    orient(1,'landscape')
    set(1,'units','normalized','outerposition',[0.2 0.2 .75 .75])

    if Op.OutputFigures==1
        fprintf('     > Saving figure %s \n',strcat('PlanCampanha',Op.Cruise,'.png'));
        print(1, '-dpng',strcat('PlanCampanha',Op.Cruise,'.png'))
    elseif Op.OutputFigures==2
        fprintf('     > Saving figure %s \n',strcat('PlanCampanha',Op.Cruise,'.png'));
        print(1, '-dpng',strcat('PlanCampanha',Op.Cruise,'.png'))
        fprintf('     > Saving figure %s \n',strcat('PlanCampanha',Op.Cruise,'.pdf'));
        print(1,'-dpdf','-fillpage','-vector',strcat('PlanCampanha',Op.Cruise,'.pdf'))
    end
    if Op.Plot3d==1
        orient(2,'landscape')
        fprintf('     > Saving figure %s \n',strcat('PlanCampanha',Op.Cruise,'3D.png'));
        print(1, '-dpng',strcat('PlanCampanha',Op.Cruise,'3D.png'))

    end
    % Backward compatibility
    %if length(Op.OutputFigures)==2
    %    CreaFigura(1,strcat('PlanCampanha',Op.Cruise),Op.OutputFigures);
    %end
end


end


%% Funciones
%--------------------------------------------------------------------------

% AddImageSatelite
function D=AddImageSatelite(ImagenSateliteType,ImagenSateliteDayi,GlobalDS)
if contains(ImagenSateliteType,'A.L3m')
    D=ReadAquaL3m(ImagenSateliteType,ImagenSateliteDayi,GlobalDS);
elseif contains(ImagenSateliteType,'V.L3m')
    D=ReadVIIRSL3m(ImagenSateliteType,ImagenSateliteDayi,GlobalDS);
end
if isfield(D,'chlor')==1
    m_contourf(D.lon+360,D.lat,log10(D.chlor)',50,'edgecolor','none'); hold on
    m_contour(D.lon+360,D.lat,log10(D.chlor)',[0 .0],'k') %Line 1kg/m3
    hb=colorbar;
    colormap(parula)
    hb.Ticks=log10([0.01 0.02 0.05 0.1 0.2 0.5 1 2 5]);
    hb.TickLabels=['0.01';'0.02';'0.05';' 0.1';' 0.2';' 0.5';'   1';'   2';'   5'];
    clim([-1.5 log10(2.1)])
elseif isfield(D,'sst')==1
    m_contourf(D.lon+360,D.lat,D.sst',100,'edgecolor','none');hold on
    hb=colorbar;
    colormap(jet)
    clim([16 27])
end
end

% Locate
function j=Locate(xx,x)
% Givern an array XX, and given a value x, returns J such that x is between
% xx(j) and xx(j+1), xx must be monotic, either increasing or decresing order.
% J=0 is returned to indicate that x is out of range.
% The code is based in numerical recipes
%
% Pedro Velez (IEO), Agosto 1999
n=size(xx,1);
if n(1) == 1
    xx=xx';
    n=size(xx,1);
end
jl=0;
ju=n+1;
while (ju-jl) > 1
    jm=round((ju+jl)/2);
    if ((xx(n) > xx(1)) && (x > xx(jm))) ||(~((xx(n) > xx(1))||(x > xx(jm))))
        jl=jm;
    else
        ju=jm;
    end
end
j=jl;
end

% rgb
function rgb = rgb(s)
persistent num name
if isempty(num) % First time rgb is called
    [num,name] = getcolors();
    name = lower(name);
    num = reshape(hex2dec(num), [], 3);
    % Divide most numbers by 256 for "aesthetic" reasons (green=[0 0.5 0])
    I = num < 240;  % (interpolate F0--FF linearly from 240/256 to 1.0)
    num(I) = num(I)/256;
    num(~I) = ((num(~I) - 240)/15 + 15)/16; + 240;
end
if strcmpi(s,'chart')
    showcolors()
else
    k = find(strcmpi(s, name));
    if isempty(k)
        error(['Unknown color: ' s]);
    else
        rgb = num(k(1), :);
    end
end
end

% showcolors
function showcolors()
[~,name] = getcolors();
grp = {'White', 'Gray', 'Red', 'Pink', 'Orange', 'Yellow', 'Brown'...
    , 'Green', 'Blue', 'Purple', 'Grey'};
J = [1,3,6,8,9,10,11];
fl = lower(grp);
nl = lower(name);
for i=1:length(grp)
    n(i) = strmatch(fl{i}, nl, 'exact');
end
clf
p = get(0,'screensize');
wh = 0.6*p(3:4);
xy0 = p(1:2)+0.5*p(3:4) - wh/2;
set(gcf,'position', [xy0 wh]);
axes('position', [0 0 1 1], 'visible', 'off');
hold on
x = 0;
N = 0;
for i=1:length(J)-1
    N = max(N, n(J(i+1)) - n(J(i)) + (J(i+1) - J(i))*1.3);
end
h = 1/N;
w = 1/(length(J)-1);
d = w/30;
for col = 1:length(J)-1
    y = 1 - h;
    for i=J(col):J(col+1)-1
        t = text(x+w/2, y+h/10 , [grp{i} ' colors']);
        set(t, 'fontw', 'bold', 'vert','bot', 'horiz','cent', 'fontsize',10);
        y = y - h;
        for k = n(i):n(i+1)-1
            c = rgb(name{k});
            bright = (c(1)+2*c(2)+c(3))/4;
            if bright < 0.5
                txtcolor = 'w';
            else
                txtcolor = 'k';
            end
            rectangle('position',[x+d,y,w-2*d,h],'facecolor',c);
            t = text(x+w/2, y+h/2, name{k}, 'color', txtcolor);
            set(t, 'vert', 'mid', 'horiz', 'cent', 'fontsize', 9);
            y = y - h;
        end
        y = y - 0.3*h;
    end
    x = x + w;
end
end

% getcolors
function [hex,name] = getcolors()
css = {
    %White colors
    'FF','FF','FF', 'White'
    'FF','FA','FA', 'Snow'
    'F0','FF','F0', 'Honeydew'
    'F5','FF','FA', 'MintCream'
    'F0','FF','FF', 'Azure'
    'F0','F8','FF', 'AliceBlue'
    'F8','F8','FF', 'GhostWhite'
    'F5','F5','F5', 'WhiteSmoke'
    'FF','F5','EE', 'Seashell'
    'F5','F5','DC', 'Beige'
    'FD','F5','E6', 'OldLace'
    'FF','FA','F0', 'FloralWhite'
    'FF','FF','F0', 'Ivory'
    'FA','EB','D7', 'AntiqueWhite'
    'FA','F0','E6', 'Linen'
    'FF','F0','F5', 'LavenderBlush'
    'FF','E4','E1', 'MistyRose'
    %Grey colors'
    '80','80','80', 'Gray'
    'DC','DC','DC', 'Gainsboro'
    'D3','D3','D3', 'LightGray'
    'C0','C0','C0', 'Silver'
    'A9','A9','A9', 'DarkGray'
    '69','69','69', 'DimGray'
    '77','88','99', 'LightSlateGray'
    '70','80','90', 'SlateGray'
    '2F','4F','4F', 'DarkSlateGray'
    '00','00','00', 'Black'
    %Red colors
    'FF','00','00', 'Red'
    'FF','A0','7A', 'LightSalmon'
    'FA','80','72', 'Salmon'
    'E9','96','7A', 'DarkSalmon'
    'F0','80','80', 'LightCoral'
    'CD','5C','5C', 'IndianRed'
    'DC','14','3C', 'Crimson'
    'B2','22','22', 'FireBrick'
    '8B','00','00', 'DarkRed'
    %Pink colors
    'FF','C0','CB', 'Pink'
    'FF','B6','C1', 'LightPink'
    'FF','69','B4', 'HotPink'
    'FF','14','93', 'DeepPink'
    'DB','70','93', 'PaleVioletRed'
    'C7','15','85', 'MediumVioletRed'
    %Orange colors
    'FF','A5','00', 'Orange'
    'FF','8C','00', 'DarkOrange'
    'FF','7F','50', 'Coral'
    'FF','63','47', 'Tomato'
    'FF','45','00', 'OrangeRed'
    %Yellow colors
    'FF','FF','00', 'Yellow'
    'FF','FF','E0', 'LightYellow'
    'FF','FA','CD', 'LemonChiffon'
    'FA','FA','D2', 'LightGoldenrodYellow'
    'FF','EF','D5', 'PapayaWhip'
    'FF','E4','B5', 'Moccasin'
    'FF','DA','B9', 'PeachPuff'
    'EE','E8','AA', 'PaleGoldenrod'
    'F0','E6','8C', 'Khaki'
    'BD','B7','6B', 'DarkKhaki'
    'FF','D7','00', 'Gold'
    %Brown colors
    'A5','2A','2A', 'Brown'
    'FF','F8','DC', 'Cornsilk'
    'FF','EB','CD', 'BlanchedAlmond'
    'FF','E4','C4', 'Bisque'
    'FF','DE','AD', 'NavajoWhite'
    'F5','DE','B3', 'Wheat'
    'DE','B8','87', 'BurlyWood'
    'D2','B4','8C', 'Tan'
    'BC','8F','8F', 'RosyBrown'
    'F4','A4','60', 'SandyBrown'
    'DA','A5','20', 'Goldenrod'
    'B8','86','0B', 'DarkGoldenrod'
    'CD','85','3F', 'Peru'
    'D2','69','1E', 'Chocolate'
    '8B','45','13', 'SaddleBrown'
    'A0','52','2D', 'Sienna'
    '80','00','00', 'Maroon'
    %Green colors
    '00','80','00', 'Green'
    '98','FB','98', 'PaleGreen'
    '90','EE','90', 'LightGreen'
    '9A','CD','32', 'YellowGreen'
    'AD','FF','2F', 'GreenYellow'
    '7F','FF','00', 'Chartreuse'
    '7C','FC','00', 'LawnGreen'
    '00','FF','00', 'Lime'
    '32','CD','32', 'LimeGreen'
    '00','FA','9A', 'MediumSpringGreen'
    '00','FF','7F', 'SpringGreen'
    '66','CD','AA', 'MediumAquamarine'
    '7F','FF','D4', 'Aquamarine'
    '20','B2','AA', 'LightSeaGreen'
    '3C','B3','71', 'MediumSeaGreen'
    '2E','8B','57', 'SeaGreen'
    '8F','BC','8F', 'DarkSeaGreen'
    '22','8B','22', 'ForestGreen'
    '00','64','00', 'DarkGreen'
    '6B','8E','23', 'OliveDrab'
    '80','80','00', 'Olive'
    '55','6B','2F', 'DarkOliveGreen'
    '00','80','80', 'Teal'
    %Blue colors
    '00','00','FF', 'Blue'
    'AD','D8','E6', 'LightBlue'
    'B0','E0','E6', 'PowderBlue'
    'AF','EE','EE', 'PaleTurquoise'
    '40','E0','D0', 'Turquoise'
    '48','D1','CC', 'MediumTurquoise'
    '00','CE','D1', 'DarkTurquoise'
    'E0','FF','FF', 'LightCyan'
    '00','FF','FF', 'Cyan'
    '00','FF','FF', 'Aqua'
    '00','8B','8B', 'DarkCyan'
    '5F','9E','A0', 'CadetBlue'
    'B0','C4','DE', 'LightSteelBlue'
    '46','82','B4', 'SteelBlue'
    '87','CE','FA', 'LightSkyBlue'
    '87','CE','EB', 'SkyBlue'
    '00','BF','FF', 'DeepSkyBlue'
    '1E','90','FF', 'DodgerBlue'
    '64','95','ED', 'CornflowerBlue'
    '41','69','E1', 'RoyalBlue'
    '00','00','CD', 'MediumBlue'
    '00','00','8B', 'DarkBlue'
    '00','00','80', 'Navy'
    '19','19','70', 'MidnightBlue'
    %Purple colors
    '80','00','80', 'Purple'
    'E6','E6','FA', 'Lavender'
    'D8','BF','D8', 'Thistle'
    'DD','A0','DD', 'Plum'
    'EE','82','EE', 'Violet'
    'DA','70','D6', 'Orchid'
    'FF','00','FF', 'Fuchsia'
    'FF','00','FF', 'Magenta'
    'BA','55','D3', 'MediumOrchid'
    '93','70','DB', 'MediumPurple'
    '99','66','CC', 'Amethyst'
    '8A','2B','E2', 'BlueViolet'
    '94','00','D3', 'DarkViolet'
    '99','32','CC', 'DarkOrchid'
    '8B','00','8B', 'DarkMagenta'
    '6A','5A','CD', 'SlateBlue'
    '48','3D','8B', 'DarkSlateBlue'
    '7B','68','EE', 'MediumSlateBlue'
    '4B','00','82', 'Indigo'
    %Gray repeated with spelling grey
    '80','80','80', 'Grey'
    'D3','D3','D3', 'LightGrey'
    'A9','A9','A9', 'DarkGrey'
    '69','69','69', 'DimGrey'
    '77','88','99', 'LightSlateGrey'
    '70','80','90', 'SlateGrey'
    '2F','4F','4F', 'DarkSlateGrey'
    };
hex = css(:,1:3);
name = css(:,4);
end

% Logo

function haxesL=Logo(Type,Position)
if nargin==0
    Type=1;
    h=get(gca,'Position');
    Position=[h(1)+h(3)-0.14  h(2)+0.14   0.16 0.16];
elseif nargin==1
    switch Type
        case 1
            Position=[0.58 0.35 0.14 0.14];
        case 2
            Position=[0.58 0.35 0.20 0.20];
        case 3
            Position=[0.55 0.08 0.25 .14];
        case 4
            Position=[0.55 0.08 0.25 .14];
        case 5
            Position=[0.58 0.35 0.14 0.14];
    end
end
LogoFile=strcat('LogoIEO',num2str(Type),'.png');
if exist(LogoFile,'file') == 2
    [img, map, alphachannel]=imread(LogoFile);
    haxesL=axes;
    haxesL.PlotBoxAspectRatio=[1 1 1];
    himagL=image(img, 'AlphaData', alphachannel);
    haxesL.Position=Position;
    haxesL.Color='none';
    haxesL.XTickLabel='';
    haxesL.YTickLabel='';
    haxesL.Box='off';
    haxesL.DataAspectRatioMode='auto';
    haxesL.DataAspectRatio=[1 1 1];
    haxesL.XColor='none';
    haxesL.YColor='none';
else
    sprintf('WARNING There is not logo file %s',LogoFile)
end
end

