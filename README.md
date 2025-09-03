# PlanCampanha

## Usage

DataOut=FPlanCampana(Op); 

Help to design a cruise planning, computing the arrival time to station, total time,...

The cruise plan is in a file named strcat('Estaciones',Op.Cruise,'.csv') for example: 'EstacionesRaprocan1810.csv'.

It will have a line for operation, with the following format:

Name of the station;longitude in decimal degrees;latitude in decimal degrees;type of operation
for example:
  24;-18.4963;29.1667;1

Always the first line would be the departure port: 
Santa Cruz;-16.2300;28.4800;10

and the last line the arrival port: 
Santa Cruz;-16.2300;28.4800; 9

## Types of operations (fourth field in the station file) are:

 10 - Departure port
  1 - CTD station       - Compute the time in station using the depth and Op.VelocityCTD
 11 - WP2 Zoo           - Compute the time in station using the depth and Op.TWP2
 12 - Bongo Ictio       - Compute the time in station using the depth and Op.TBongo
 13 - Manta microplasticos - Compute the time in station using the depth and Op.TAvani
 14 - Box Core          -
 15 - Gravity Core      -
 16 - ROV station       -
  2 - Waypoint
  3 - Deploy lander     - Compute the time in station using the depth and Op.VelocityLander
  4 - Recovery lander   - Compute the time in station using the depth and Op.VelocityLander
  7 - Deploy mooring    - Compute the time in station using the depth and Op.VelocityCTD
  8 - Recovery mooring  - Compute the time in station using the depth and Op.VelocityCTD
  9 - Arrival port
 <0 - Waiting time in days

## Options
%
Op.Cruise='Raprocan1810';
Op.DepartingDate=datenum(2018,10,20,23,00,00); %Fecha salida

%Geographic limits
Op.Region='CanaryIslands';
Op.lat_min=24.25;
Op.lat_max=29.50;
Op.lon_min=340;
Op.lon_max=352;
Op.LonEConvMap=-360;        %For the case of map in 0-360 coodinates Elon 360
Op.Proj=1;                  %1 'mercator', 2'Mollweide'

Op.TStation=0.50;         % Time [h] for operation right after CTD station
Op.TWP2=0.5;              % Time [h] for WP2 operation.
Op.TBongo=0.5;            % Time [h] for Bongo operation.
Op.TAvani=0.5;            % Time [h] for Avani operation.
Op.TLander=1.0;           % Time [h] for operation righ after recover/deploy mooring.
Op.TMooring=0.5;          % Time [h] for operation righ after recover/deploy mooring.
Op.Delay=0.0/24;          % [days]
Op.DepthROV=1500;         % Maximum depth of ROV[m]
Op.DailyAOperation=0.0;   % Daily time [h] for additional operations

Op.VelocityVessel=9.5;    % [knots]
Op.VelocityCTD=60;        % [m/min]
Op.VelocityBC=55;         % [m/min]
Op.VelocityGC=55;         % [m/min]
Op.VelocityROV=40;        % [m/min]
Op.VelocityLander=30;     % [m/min]
Op.VelocityMooring=55;    % [m/min]

Op.Batimetry=1;           % [1/0] to add batythemtry
Op.BatimetryIso=[-1000 -2000 -3000 -4000];%Isobaths to contour
Op.BatimetryIsoLabel=[0 1 0 1];%Isobaths to label
Op.BatimetryColor=0;      % [1/0] to add color batythemtry
Op.ZEE=0;                 % [1/0] to add ZEE lines
Op.VesselTrack=1;         % [1/0] to add vessel track. 2 for track with time

Op.StaTicks=2;            % Cada cuanto se etiquetan las stations
Op.StaSpecMarks1=[24, 15, 11, 10 , 7 ];    % Stations especiales a marcar
Op.StaSpecMarks1Color='r';
Op.StaSpecMarks1Ticks=0;  % Flag para etiquetar stations especiales
Op.StaSpecMarks1Legend='PIES'; % Flag para etiquetar stations especiales

Op.StaSpecMarks2=[24,21,18,15,12,9,6,51,48,45,42,36,33,30,28,26];  
Op.StaSpecMarks2Color='g';
Op.StaSpecMarks2Ticks=0;
Op.StaSpecMarks2Legend='Microplastico';


Op.Subtitle=2;        %[0/1/2]for subtitle
Op.Legend=1;          %[0/1/2]for subtitle
Op.Idioma=1;          %[1/2] Español/Ingles

Op.MoorTick=1;            %Añade nombre de fondeo

Op.OutputKml=1;
Op.OutputMat=1;
Op.OutputGPX=1;
Op.OutputFigures=[4 7];

OP.Logo=1;          %Add IEO's log



Created by Pedro Velez Belchi (IEO) in 2002 ... 