# Plan de Campaña

Usage: **DataOut=FPlanCampana(Op);**

This code helps to design a cruise planning, computing the arrival time to station, total time, ... 

The operations in the cruise plan should be in file named 'Estaciones'+CruiseName+.csv,for example: *EstacionesRaprocan2508.txt* This cruise is included as an example.

The file should contain a line for each operation, with the format  *Name of the station;longitude in decimal degrees;latitude in decimal degrees;type of operation*

For instance, a file with a cruise departing and arriving to Santa Cruz de Tenerife, with several CTD stations, Bongo, WP2 net and deploying a mooring will be:

```
Santa Cruz;-16.23;28.48;10

%Santa Cruz
Waypoint;-16.1191;28.4961;2
Waypoint;-16.01;28.57;2

%Seccion Raprocan

24-Pies433; -18.4863; 29.1667;-0.35
24-Zoo;-18.4963;29.1667;11
24;-18.4963;29.1667;1
24-Zoo;-18.4963;29.1667;11
24-Bongo;-18.4963;29.1667;12
24-Avani;-18.4963;29.1667;13

23;-18.2425;29.1667;1

22;-18.0025;29.1667;1
22-Zoo;-18.0025;29.1667;11
22-Bongo;-18.0025;29.1667;12
.
.
.
Santa Cruz;-16.2300;28.4800;9
```

The full list of stations could be found in the folder *./Example* : [*EstacionesRaprocan2508.txt*](https://raw.githubusercontent.com/PedroVelez/PlanCampanha/3d4846d31262263790f7a7bfde542e2ac2a0a3c9/Example/EstacionesRaprocan2508.txt). 

In the same folder the script *PlanCampanha* creates the cruise plan:

<img src="https://github.com/PedroVelez/PlanCampanha/blob/3d4846d31262263790f7a7bfde542e2ac2a0a3c9/Example/PlanCampanhaRaprocan2508.png?raw=true" alt="cruisePlan" width="800"/>

With the information of the timing for each station in the cruise plan file: [PlanCampanhaRaprocan2508.txt](https://raw.githubusercontent.com/PedroVelez/PlanCampanha/87d9ae4790524e675614d63a903a97659b04e84e/Example/PlanCampanhaRaprocan2508.txt)

```
Estación           ;Operación   ;LonG;LonM  ;LatG;LatM  ;Pro-m;Fecha llegada  ;Hora ;horasT;Dia ;Naveg
Santa Cruz         ;P. Salida   ; -16;13.800;  28;28.800;-----;Sat 09 Aug 2025;19:00; -----; 1.0;  5.9
Waypoint           ;Waypoint    ; -16; 7.146;  28;29.766;-----;Sat 09 Aug 2025;20:09; -----; 1.0;  7.3
Waypoint           ;Waypoint    ; -16; 0.600;  28;34.200;-----;Sat 09 Aug 2025;20:51; -----; 1.1;135.0
24-Pies433         ;Operaciones ; -18;29.178;  29;10.002; 4227;Sun 10 Aug 2025;09:42;   8.4; 1.6;  0.5
24-Zoo             ;Red WP2     ; -18;29.778;  29;10.002; 4245;Sun 10 Aug 2025;18:09;   0.5; 2.0;  0.0
24                 ;EstacionCTD ; -18;29.778;  29;10.002; 4245;Sun 10 Aug 2025;18:39;   2.9; 2.0;  0.0
24-Zoo             ;Red WP2     ; -18;29.778;  29;10.002; 4245;Sun 10 Aug 2025;21:31;   0.5; 2.1;  0.0
24-Bongo           ;Red Bongo 90; -18;29.778;  29;10.002; 4245;Sun 10 Aug 2025;22:01;   0.5; 2.1;  0.0
24-Avani           ;Red Avani   ; -18;29.778;  29;10.002; 4245;Sun 10 Aug 2025;22:31;   0.5; 2.1; 13.3
23                 ;EstacionCTD ; -18;14.550;  29;10.002; 3989;Mon 11 Aug 2025;00:16;   2.7; 2.2; 12.6
22                 ;EstacionCTD ; -18; 0.150;  29;10.002; 3662;Mon 11 Aug 2025;04:11;   2.5; 2.4;  0.0
22-Zoo             ;Red WP2     ; -18; 0.150;  29;10.002; 3662;Mon 11 Aug 2025;06:43;   0.5; 2.5;  0.0
22-Bongo           ;Red Bongo 90; -18; 0.150;  29;10.002; 3662;Mon 11 Aug 2025;07:13;   0.5; 2.5; 18.2
.
.
.
Santa Cruz         ;P. llegada  ; -16;13.800;  28;28.800;-----;Thu 21 Aug 2025;09:47; -----;12.6;-----

------------------------------------------------------------------------------------------------------
SUMMARY ----------------------------------------------------------------------------------------------

Raprocan2508: Santa Cruz [09-Aug-2025 19:00:00] - Santa Cruz [21-Aug-2025 09:47:32],  120 stations, 1038.5 miles, 11.62 days at 10.5 knots

Station CTD:  50 [24, 23, 22,  ... ] 
Net WP2     :  27 [24-Zoo, 24-Zoo, 22-Zoo, ... ] 
Net Bongo 90:  23 [24-Bongo, 22-Bongo,  ...] 
Net Avani   :  15 [24-Avani, ... ] 
Depl.Mooring:   1 [EBC7] 
Operations:   5 [24-Pies433, ...] 

Time delay used for adjustment: 0.02 

Time in each stations has been estimated using the actual depth and a descend/ascend velocity of 60/50/50/40 (CTD/BC/GC/ROV) m/min. In each CTD station 0.50 h has been added for positioning.
For the moorings/landers the time has been estimated using the actual depth and a descend/ascend velocity of 55/30 m/min and additional 0.50/1.00 hours. 

------------------------------------------------------------------------------------
Station     - Name of the station.
Operation   - Operation code (depart port, waypoint, CTD, ,...) for the stations.
LatG        - Degrees of latitude.
LatM        - Minutes of latitude.
LonG        - Degrees of longitude.
LonM        - Minutes of longitude.
Dep-m       - Depth (metres) at the station.
Arriv. date - Arrival date to the station.
Hour        - Hour of arrival to the station.
WHours      - Hours working in the station.
Day         - Cruise day (the cruise begins in day 1).
Naveg       - Navegation to the next station in nautical miles.
```

All the output files are also in the folder:

* PlanCampanhaRaprocan2508.csv

* PlanCampanhaRaprocan2508.gpx

* PlanCampanhaRaprocan2508.kml

* PlanCampanhaRaprocan2508.mat

* PlanCampanhaRaprocan2508.pdf

* PlanCampanhaRaprocan2508.png

* PlanCampanhaRaprocan2508.txt


## Configuration

### Types of operations 
The type of operations are definined in the fourth field of the station file list, and are:

```
 10 - Departure port  
  1 - CTD station       - CTD cast, compute the time in station using the depth and Op.VelocityCTD  
 11 - WP2 Zoo           - WP2 net deployment, compute the time in station using the depth and Op.TWP2  
 12 - Bongo Ictio       - Bongo net deployment, compute the time in station using the depth and Op.TBongo  
 13 - Avani             - Avani net - microplastics - deployment, compute the time in station using the depth and Op.TAvani  
 14 - Box Core          -  
 15 - Gravity Core      -  
 16 - ROV station       -  
  2 - Waypoint  
  3 - Deploy lander     - Compute the time in station using the depth and Op.VelocityLander  
  4 - Recovery lander   - Compute the time in station using the depth and Op.VelocityLander  
  7 - Deploy mooring    - Compute the time in station using the depth and Op.VelocityCTD  
  8 - Recovery mooring  - Compute the time in station using the depth and Op.VelocityCTD  
  9 - Arrival port  
 <0 - Waiting time in days  - Add the time for any operations when the vessel is not moving. 

```

### Options

The  options are included in an structure that as argument to the main function, this is **DataOut=FPlanCampana(Op);**:

#### General settings

Op.Cruise='Raprocan1810'; 
Op.DepartingDate=datenum(2018,10,20,23,00,00); %Fecha salida

#### Geographic limits 

Op.Region='CanaryIslands'; 
Op.lat_min=24.25;  
Op.lat_max=29.50;  
Op.lon_min=340;  
Op.lon_max=352;  
Op.LonEConvMap=-360;      % For the case of map in 0-360 coordinates Elon 360  
Op.Proj=1;                % 1 'mercator', 2'Mollweide'  

#### Operating options

Op.TStation=0.50;         % Time [h] for operation right after CTD station  
Op.TWP2=0.5;              % Time [h] for WP2 operation.  
Op.TBongo=0.5;            % Time [h] for Bongo operation.  
Op.TAvani=0.5;            % Time [h] for Avani operation.  
Op.TLander=1.0;           % Time [h] for operation right after recover/deploy Lander.  
Op.TMooring=0.5;          % Time [h] for operation right after recover/deploy mooring.  
Op.DepthROV=1500;         % Maximum depth for ROV[m]  
Op.DailyAOperation=0.0;   % Daily time [h] for additional operations  
Op.Delay=0.0/24;          % [days]  
Op.VelocityVessel=9.5;    % [knots]  
Op.VelocityCTD=60;        % [m/min]  
Op.VelocityBC=55;         % [m/min]  
Op.VelocityGC=55;         % [m/min]  
Op.VelocityROV=40;        % [m/min]  
Op.VelocityLander=30;     % [m/min]  
Op.VelocityMooring=55;    % [m/min]  
OP.Logo=1;                % Add IEO's log

#### Visualization options

Op.Batimetry=1;           % [1/0] to add bathymetry  
Op.BatimetryIso=[-1000 -2000 -3000 -4000];% Isobaths to contour  
Op.BatimetryIsoLabel=[0 1 0 1];% Isobaths to label  
Op.BatimetryColor=0;      % [1/0] to add color bathymetry
Op.VesselTrack=1;         % [1/0] to add vessel track. 2 for track with time  
Op.Subtitle=2;            % [0/1/2]for subtitle  
Op.Legend=1;              % [0/1/2]for subtitle  
Op.Idioma=1;              % [1/2] Español/Ingles  
Op.MoorTick=1;            % Add mooring names 

Op.StaTicks=2;            % Cada cuanto se etiquetan las stations  
Op.StaSpecMarks1=[24, 15, 11, 10 , 7 ];    % Stations especiales a marcar  
Op.StaSpecMarks1Color='r';  
Op.StaSpecMarks1Ticks=0;  % Flag para etiquetar stations especiales  
Op.StaSpecMarks1Legend='PIES'; % Flag para etiquetar stations especiales  

Op.StaSpecMarks2=[24,21,18,15,12,9,6,51,48,45,42,36,33,30,28,26];  
Op.StaSpecMarks2Color='g';  
Op.StaSpecMarks2Ticks=0;  
Op.StaSpecMarks2Legend='Microplastico';  
Op.ZEE=0;                 % [1/0] to add ZEE lines

#### Outputs options

Op.OutputCsv=1;   %Output in csv format compatible with https://www.marinefacilitiesplanning.com/
Op.OutputKml=1;   %Output in .kml, compatible with Google Earth
Op.OutputMat=1;   %Output in .mat matlab format
Op.OutputGPX=1;   %Output in .gpx format, compatible with OpenCPN

Op.OutputFigures=1; %Create figures in 1 .png 2 .png and .pdf formats

### Additional tools

In this folder there are also some additional tools that may help to design a cruise plan:

* *ginput2PlanCampana* - Call m_ginput that allows to select points in a mat and output the chosen values in the .csv format read by PlanCampanha 

* *gpx2PlanCampana.m* - Read a .gpx files and output in the .csv format read by PlanCampanha 

* *CalculaRadialZonal.m* - 

* *CalculaRadialMeridional.m* - 

* *CalculaRadial.m* - 


### Embebed functions

Within FPlanCampana there are some functions include:

* function D=AddImageSatelite(ImagenSateliteType,ImagenSateliteDayi,GlobalDS) % AddImageSatelite

* function j=Locate(xx,x) % Locate

* function rgb = rgb(s) % rgb

* function showcolors() % showcolors

* function [hex,name] = getcolors() % getcolors

* function haxesL=Logo(Type,Position) % Logo


--------- Created by Pedro Vélez Belchí (IEO) in 2002 ... 