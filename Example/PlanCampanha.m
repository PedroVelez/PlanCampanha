clearvars ;close all;clc

Op.Cruise='Raprocan2508';
Op.DepartingDate=datenum(2025,08,09,19,00,00); %Fecha salida

%Geographic l5imits
Op.Region='CanaryIslands';

Op.lat_min=26.25;
Op.lat_max=29.75;
Op.lon_min=-19;
Op.lon_max=-11;
Op.LonEConvMap=0;      % For the case of map in 0-360 coodinates Elon 360
Op.Proj='mercator';    % 1:'mercator',2:'Mollweide'


Op.Delay=.6/24;        % [days]
Op.VelocityVessel=10.5;% [knots]
Op.TStation=0.50;      % Time [h] for operation righ after station, excluding CTD, BC, and GC time
Op.TBongo=0.5;         % Time [h] for WP2 operation.
Op.TWP2=0.5;           % Time [h] for WP2 operation.
Op.TAvani=0.5;         % Time [h] for Avani operation.

Op.Batimetry=1;        %[1/0] to add batythemtry
Op.BatimetryIso=[-1000 -2000 -3000 -4000];%Isobaths to contour
Op.BatimetryIsoLabel=[0 1 0 1];%Isobaths to label
Op.BatimetryColor=0;   %[1/0] to add color batythemtry
Op.ZEE=0;              %[1/0] to add ZEE lines

Op.VesselTrack=1;       %[1/0] to add vessel track. 2 for track with time
Op.VelocityCTD=60;

Op.StaTicks=2;         %Cada cuanto se etiquetan las stations
Op.StaSpecMarks1=[24, 15, 11, 10 , 7 ];    %Stationes especiales a marcar
Op.StaSpecMarks1Color='r';
Op.StaSpecMarks1Ticks=0;%Flag para etiquetar stations especiales
Op.StaSpecMarks1Legend='PIES';%Flag para etiquetar stations especiales

Op.StaSpecMarks2=[24,21,18,15,12,9,6,51,48,45,42,36,33,30,28,26];  
Op.StaSpecMarks2Color='g';
Op.StaSpecMarks2Ticks=0;
Op.StaSpecMarks2Legend='Microplastico';%Flag para etiquetar stations especiales

Op.Subtitle=2;        %[0/1/2]for subtitle

Op.Legend=1;          %[0/1/2]for subtitle

Op.Idioma=1;          %[1/2] Español/Ingles

Op.MoorTick=1;  

Op.OutputGEarth=1;
Op.OutputMat=1;
Op.OutputGPX=1;
Op.OutputMFP=1;
Op.OutputFigures=[4 7];

OP.Logo=1;
DataOut=FPlanCampana(Op);

% Estaciones=find(DataOut.PointID==1);
% for i1=1:length(Estaciones)
%     Estacion{i1}=DataOut.Nombre{Estaciones(i1)};
%     DateASt(i1)=DataOut.DateAtPoint(Estaciones(i1));
%     ctd=load(strcat('/Users/pvb/Dropbox/Oceanografia/Proyectos/Raprocan/Campanhas/2025_Raprocan2508/CTD/mat/ra2508_0', ... 
%         DataOut.Nombre{Estaciones(i1)},'.mat'));
%     DateSt(i1)=datenum(ctd.gtime);
%     Diferencia(i1)=DateASt(i1)-datenum(ctd.gtime);
% end

