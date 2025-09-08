# Plan de Campaña

Usage:

**DataOut=FPlanCampana(Op);**

This code helps to design a cruise planning, computing the arrival time to station, total time, ... 

The operations in the cruise plan should be in file named 'Estaciones'+CruiseName+.csv,for example: *EstacionesRaprocan2508.txt* This cruise is included as an example.
The file should contain a linea for each operation, with the format  *Name of the station;longitude in decimal degrees;latitude in decimal degrees;type of operation*

For instance, a file Departing and arriving to Santa Cruz de Tenerife, with 3 CTD stations, Bongo, WP2 net and deploying a mooring will be:

```
Santa Cruz;-16.23;28.48;10
Waypoint  ;-16.1191;28.4961;2
Waypoint  ;-16.01  ;28.57  ;2
24        ;-18.4963;29.1667;1
24-WP2    ;-18.4963;29.1667;11
24-Bongo  ;-18.4963;29.1667;12
24-Avani  ;-18.4963;29.1667;13
15        ;-15.5007;29.1667;1
15-WP2    ;-15.5007;29.1667;11
15-Avani  ;-15.5007;29.1667;13
07        ;-13.1614;28.6955;1
EBC7      ;-13.0862;28.6789;7
Santa Cruz;-16.2300;28.4800;9
```

In the folder *./Example* the script *PlanCampanha* creates the cruise plan for [*EstacionesRaprocan2508.txt*](https://raw.githubusercontent.com/PedroVelez/PlanCampanha/3d4846d31262263790f7a7bfde542e2ac2a0a3c9/Example/EstacionesRaprocan2508.txt) all the output files are also in the folder.

<img src="https://github.com/PedroVelez/PlanCampanha/blob/3d4846d31262263790f7a7bfde542e2ac2a0a3c9/Example/PlanCampanhaRaprocan2508.png?raw=true" alt="cruisePlan" width="800"/>

the information provide looks like:

```
Estación           ;Operación   ;LonG;LonM  ;LatG;LatM  ;Pro-m;Fecha llegada  ;Hora ;horasT;Dia ;Naveg
Santa Cruz         ;P. Salida   ; -16;13.800;  28;28.800;-----;Sat 09 Aug 2025;19:00; -----; 1.0;  5.9
Waypoint           ;Waypoint    ; -16; 7.146;  28;29.766;-----;Sat 09 Aug 2025;20:09; -----; 1.0;  7.3
Waypoint           ;Waypoint    ; -16; 0.600;  28;34.200;-----;Sat 09 Aug 2025;20:51; -----; 1.1;135.0
24                 ;EstacionCTD ; -18;29.778;  29;10.002; 4245;Sun 10 Aug 2025;18:39;   2.9; 2.0;  0.0
24-Zoo             ;Red WP2     ; -18;29.778;  29;10.002; 4245;Sun 10 Aug 2025;21:31;   0.5; 2.1;  0.0
24-Bongo           ;Red Bongo 90; -18;29.778;  29;10.002; 4245;Sun 10 Aug 2025;22:01;   0.5; 2.1;  0.0
24-Avani           ;Red Avani   ; -18;29.778;  29;10.002; 4245;Sun 10 Aug 2025;22:31;   0.5; 2.1; 13.3
15                 ;EstacionCTD ; -15;30.042;  29;10.002; 3604;Wed 13 Aug 2025;00:35;   2.5; 4.2;  0.0
15-WP2             ;Red WP2     ; -15;30.042;  29;10.002; 3604;Wed 13 Aug 2025;03:05;   0.5; 4.3;  0.0
07                 ;EstacionCTD ; -13;12.372;  28;42.528; 1071;Fri 15 Aug 2025;04:49;   1.1; 6.4;  6.6
EBC7               ;Despl.fondeo; -13; 5.172;  28;40.734;  760;Fri 15 Aug 2025;16:47;   0.9; 6.9;  4.3
Santa Cruz         ;P. llegada  ; -16;13.800;  28;28.800;-----;Thu 21 Aug 2025;09:47; -----;12.6;-----

------------------------------------------------------------------------------------------------------
RESUMEN ----------------------------------------------------------------------------------------------

Raprocan2508: Santa Cruz [09-Aug-2025 19:00:00] - Santa Cruz [21-Aug-2025 09:47:32],  120 estaciones, 1038.5 miles, 11.62 days at 10.5 knots

EstacionCTD :  3 [24, 15, 7] 

Red WP2     :  2 [24-WP2, 15-WP2] 

Red Bongo 90:  1 [24-Bongo] 

Red Avani   :  15 [24-Avani, 21-Avani, 18-Avani, 15-Avani, 12-Avani, 09-Avani, 06-Avani, 51-Avani, 48-Avani, 45-Avani, 42-Avani, 36-Avani, 33-Avani, 30-Avani, 26-Avani] 

Despl.fondeo:   1 [EBC7] 

Time delay used for adjustment: 0.02 

El tiempo en cada estación se ha estimado usando la profundidad y una velocidad de descenso/ascenso de 60/50/50/40 (CTD/BC/GC/ROV) m/min. En cada estación CTD se han añadido 0.50 h para posicionamiento.
Para los fondeos/landers el tiempo se ha estimado usando la profundidad, con una velocidad de largado de  55/30 m/min, y 0.50/1.00 h adicionales. 

------------------------------------------------------------------------------------
Estación     - Nombre de la estación.
Operación    - Código de la operación.
LatG         - Grados de latitud.
LatM         - Minutos de latitud.
LonG         - Grados de longitud.
LonM         - Minutos de longitud.
Pro-m        - Profundidad (metros) en la estación.
Fecha llegada- Fecha llegada a la estación.
Hora         - Hora llegada a la estación.
horasT       - Horas de trabajo en la estación.
Dia          - Dia de campaña (La campaña comienza el día 1).
Naveg        - Navegación a la siguiente estación en millas nauticas.
```

## Types of operations (fourth field in the station file) are:

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

## Options

Op.Cruise='Raprocan1810'; 
Op.DepartingDate=datenum(2018,10,20,23,00,00); %Fecha salida

### Geographic limits 

Op.Region='CanaryIslands'; 
Op.lat_min=24.25;  
Op.lat_max=29.50;  
Op.lon_min=340;  
Op.lon_max=352;  
Op.LonEConvMap=-360;      % For the case of map in 0-360 coordinates Elon 360  
Op.Proj=1;                % 1 'mercator', 2'Mollweide'  

### Operating options

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

### Visualization options

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

### Outputs options

Op.OutputCsv=1;   %Output in csv format compatible with https://www.marinefacilitiesplanning.com/
Op.OutputKml=1;   %Output in .kml, compatible with Google Earth
Op.OutputMat=1;   %Output in .mat matlab format
Op.OutputGPX=1;   %Output in .gpx format, compatible with OpenCPN

Op.OutputFigures=1; %Create figures in 1 .png 2 .png and .pdf formats

## Additional tools

*ginput2PlanCampana* - Call m_ginput that allows to select points in a mat and output the chosen values in the .csv format read by PlanCampanha 
*gpx2PlanCampana* - Read a .gpx files and output in the .csv format read by PlanCampanha 

*CalculaRadialZonal* - 

*CalculaRadialMeridional* - 

*CalculaRadial* - 


### embeded functions

With in FPlanCampana there are some functions inclued:

* function D=AddImageSatelite(ImagenSateliteType,ImagenSateliteDayi,GlobalDS) % AddImageSatelite

* function j=Locate(xx,x) % Locate

* function rgb = rgb(s) % rgb

* function showcolors() % showcolors

* function [hex,name] = getcolors() % getcolors

* function haxesL=LogoIEO(Type,Position) % LogoIEO

--------- Created by Pedro Velez Belchi (IEO) in 2002 ... 