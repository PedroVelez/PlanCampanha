
load Globales
load(strcat(GlobalSU.LibPath,'/Settings/DS',Op.Region)); %Cargo Data Settings
BAT=load(GlobalDS.filebat);
if isfield(BAT,'batylon')==0;BAT.batylon=BAT.bathylon;end
if isfield(BAT,'batylat')==0;BAT.batylat=BAT.bathylat;end

[file,pathfile]=uigetfile ( '*.gpx', 'Escoge el fichero a procesar' ); %Escoge fichero

P=gpxread(strcat(pathfile,file));
lon=P.Longitude;
lat=P.Latitude;


figure
m_proj('mercator','long',[GlobalDS.lon_min GlobalDS.lon_max],'lat',[GlobalDS.lat_min GlobalDS.lat_max]);hold on
m_contour(BAT.batylon,BAT.batylat,BAT.elevations,[-3000 -3000],'color',[0.45 0.45 0.45]);
m_contour(BAT.batylon,BAT.batylat,BAT.elevations,[-2000 -2000],'color',[0.55 0.55 0.45]);
m_contour(BAT.batylon,BAT.batylat,BAT.elevations,[-1000 -1000],'color',[0.65 0.65 0.65]);
m_contour(BAT.batylon,BAT.batylat,BAT.elevations,[ -500  -500],'color',[0.75 0.75 0.75]);
m_contour(BAT.batylon,BAT.batylat,BAT.elevations,[ -250  -250],'color',[0.85 0.85 0.85]);
m_usercoast(GlobalDS.filecoast,'patch',[.7 .6 .4,],'edgecolor',[.7 .6 .4,]);
m_grid

m_plot(360+lon,lat,'ob-','markersize',6);hold on



for ii=1:length(lat)
    %if isfield('P','Name')
    disp(sprintf('%s;%7.4f;%7.4f;1',deblank(P.Name{ii}),lon(ii),lat(ii)))
    %else
    %    disp(sprintf('%s;%7.4f;%7.4f;1',deblank(''),lon(ii),lat(ii)))
    %end
end
