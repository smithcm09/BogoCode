function Ltg_Vector(ltgfile, windfile, windstructure)
%% Determining the Vector Direction the Ltg is moving in and how it compares to model NCEP/NCAR reanalysis wind models
% Plots the wind and lighting trajectory on a 6 pannel subplot
% Ltgfile is WWLLN data and must be in format of 'AEyyyymmdd.bogoslov.loc'
% Windfile must be a .mat file containing the windstructure containing the following parts: Height, WindSpeed, WindDir labeled as such
% example of command to run the code: Ltg_Vector('AE20170610.bogoslov.loc', 'Wind_Strucs.mat', 'wd06_10_17_12')
%     Subplot 1 = wind rose of all altitudes
%     Subplot 2 = wind azimuth with altitude
%     Subplot 3 = lat/lon location of ltg color coded to time
%     Subplot 4 = raw azimuths with time and distance overlay
%     Subplot 5 = total average of azimuths through time with dotted distance overlay
%     Subplot 6 = most recent 3 flash average through time with dotted distance overlay


%% Load Ltg Data

WWLLN = simplified_WWLLN_import(ltgfile);

filename = ltgfile(3:end-13);

%set up basic parameters
bogo_lat = 53.9272;
bogo_lon = -168.0344;
mintime = min(WWLLN.Date_Num);

%% calculate dsitances - only use d1km (Haversine)
for i = 1:numel(WWLLN.lat)
    bogo_loc = [bogo_lat(1) bogo_lon(1)];
    WWLLN_loc = [WWLLN.lat(i) WWLLN.lon(i)];
    d1km(i,1) = lldistkm(bogo_loc, WWLLN_loc); 
end

%% Calculate LTG Azimuths
azi = azimuth(bogo_lat,bogo_lon,WWLLN.lat,WWLLN.lon);

%% Load Wind Data

load(windfile, windstructure)
% load('Wind_Strucs.mat', 'wd06_10_17_12')

x = eval(windstructure);

    Wind_Height = [x.Height]';
    Wind_Speed = [x.WindSpeed]';      
    Wind_Dir = [x.WindDir]';

%% Plot Wind Rose

figure()
axes1 = subplot(2,3,1);
WindRose(Wind_Dir,Wind_Speed,'anglenorth', 0, 'angleeast', 90, 'FreqLabelAngle', 45, 'axes', axes1, 'legendtype', 1)

%% Plot Wind Profile

Wind_Height_Ft = Wind_Height*3.28084;

subplot(2,3,2)
hold on
plot(Wind_Dir,Wind_Height_Ft, 'k')
plot(Wind_Speed,Wind_Height_Ft, 'b')

xlim([0 360])
xticks([0 10 30 50 70 90 180 270 360])
xlabel('Azimuth Direction(black)/Wind Speed m/s (blue)')
label = ['N'; ' '; ' '; ' '; ' '; 'E'; 'S'; 'W'; 'N'];
set (gca,'XTickLabel',label);
ylabel('Altitude (ft)')

title('Wind Profile')
grid on
hold off

%% Plot the event in question's lat/lon pairs color coded to time

subplot(2,3,3)
hold on
scatter(WWLLN.lon, WWLLN.lat, WWLLN.VLF, WWLLN.Date_Num, 'filled')
colorbar
p = plot(bogo_lon,bogo_lat,'r^');
p.MarkerSize = 10;
p.MarkerFaceColor = 'r';
grid on
cbdate('hh:MM:ss')
hold off
title('WWLLN Lightning locations')
xlabel('symbol size is proportional to VLF energy')

%% Plot Raw Azimuths/Distances through time

subplot(2,3,4)
hold on
yyaxis left
scatter(WWLLN.Date_Num,azi, 'bo')
grid on
datetick('x')
ylim([0 360])
yticks([0 90 180 270 360])
ylabel('Azimuth Direction')
label = ['N'; 'E'; 'S'; 'W'; 'N'];
set (gca,'YTickLabel',label);
yyaxis right
plot(WWLLN.Date_Num,d1km,'r.-')
ylabel('Distance from Bogoslof (km)')
grid on
grid minor
datetick('x')
title('Raw Azimuths/Distances through time')

%% Calculate the temporal average in unit vector azimuth average through time (http://www.ndbc.noaa.gov/wndav.shtml)
% ie avg of 1+2, avg of 1+2+3, avg of 1+2+3+4+....+n
clear x xbar y ybar i
for i = 1:numel(azi)
    x(i) = cosd(azi(i));
    y(i) = sind(azi(i));
    xbar = mean(x);
    ybar = mean(y);
    % add 360 at the end to correct for mapping to the -180/180  range and
    % instead map to the 0-360 range (https://www.mathworks.com/matlabcentral/answers/202915-converting-atan2-output-to-360-deg)
    Temporal_Average(i,1) = atan2d(ybar,xbar) + 360*(ybar<0);
end
subplot(2,3,5)
%don't plot first point bc not a change in azimuth bc nothing to change in
%comparision to
yyaxis left
plot(WWLLN.Date_Num(2:end),Temporal_Average(2:end), 'bo-')
hold on
%plot first azimuth point as a visual of when and where the first azimuth
%occured
plot(WWLLN.Date_Num(1),Temporal_Average(1), 'c*')
datetick('x')
grid on
ylim([0 360])
yticks([0 90 180 270 360])
label = ['N'; 'E'; 'S'; 'W'; 'N'];
set (gca,'YTickLabel',label);
ylabel('Azimuth Direction')

yyaxis right
yyaxis right
plot(WWLLN.Date_Num,d1km,'r:')
ylabel('Distance from Bogoslof (km)')

title('temporal average, u-v azimuth')
hold off

%% Calculate the temporal change in unit vector azimuth average through 3 most recent flashes
% But ONLY USING the 3 most recent flashes
% ie avg of 1+2, avg of 1+2+3, avg of 2+3+4, avg of 3+4+5 etc...
clear x xbar y ybar i
for i = 1:numel(azi)
    x(i) = cosd(azi(i));
    y(i) = sind(azi(i));
    if i > 3
        xbar = mean(x(end-2:end));
        ybar = mean(y(end-2:end));
    else
        xbar = mean(x);
        ybar = mean(y);
    end
    Temporal_Average3(i,1) = atan2d(ybar,xbar)+ 360*(ybar<0);
end

subplot(2,3,6)
%don't start plotting until the 3rd value as the previous two are not fully
%averaged of three points
yyaxis left
plot(WWLLN.Date_Num(3:end),Temporal_Average3(3:end), 'bo-')
hold on
plot(WWLLN.Date_Num(1:2),Temporal_Average3(1:2), 'c*')
datetick('x')
grid on
ylim([0 360])
yticks([0 90 180 270 360])
ylabel('Azimuth Direction')
label = ['N'; 'E'; 'S'; 'W'; 'N'];
set (gca,'YTickLabel',label);
ylabel('Azimuth Direction')

yyaxis right
yyaxis right
plot(WWLLN.Date_Num,d1km,'r:')
ylabel('Distance from Bogoslof (km)')

title('3 most recent flash average, u-v azimuth')

%% make figure fullsize and save
fullfig(1);
saveas(gcf,filename,'jpeg');
close all
end
