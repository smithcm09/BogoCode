%% Determining the Vector Direction the Ltg is moving in

%load data for the specific days event that you are looking at

close all
clear all
% WWLLN = simplified_WWLLN_import('AE20161216.bogoslov.loc');
% WWLLN = simplified_WWLLN_import('AE20161222.bogoslov.loc');
% WWLLN = simplified_WWLLN_import('AE20170131.bogoslov.loc');
% WWLLN = simplified_WWLLN_import('AE20170218.bogoslov.loc');
% WWLLN = simplified_WWLLN_import('AE20170308.bogoslov.loc');
% WWLLN = simplified_WWLLN_import('AE20170517.bogoslov.loc');
WWLLN = simplified_WWLLN_import('AE20170610.bogoslov.loc');

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

%% Calculate Azimuths
azi = azimuth(bogo_lat,bogo_lon,WWLLN.lat,WWLLN.lon);


%% Calculate the temporal average in unit vector azimuth average through time (http://www.ndbc.noaa.gov/wndav.shtml)
% ie avg of 1+2, avg of 1+2+3, avg of 1+2+3+4+....+n
clear x xbar y ybar i
for i = 1:numel(azi);
    x(i) = cosd(azi(i));
    y(i) = sind(azi(i));
    xbar = mean(x);
    ybar = mean(y);
    % add 360 at the end to correct for mapping to the -180/180  range and
    % instead map to the 0-360 range (https://www.mathworks.com/matlabcentral/answers/202915-converting-atan2-output-to-360-deg)
    Temporal_Average(i,1) = atan2d(ybar,xbar) + 360*(ybar<0);
end
figure()
% subplot(2,2,3)
% subplot(2,3,4)
%don't plot first point bc not a change in azimuth bc nothing to change in
%comparision to
yyaxis left
plot(WWLLN.Date_Num(2:end),Temporal_Average(2:end), 'ko-')
hold on
%plot first azimuth point as a visual of when and where the first azimuth
%occured
plot(WWLLN.Date_Num(1),Temporal_Average(1), 'b*')
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

title('temporal average in unit vector azimuth')
hold off

%% Calculate the temporal change in unit vector azimuth average through 3 most recent flashes
% But ONLY USING the 3 most recent flashes
% ie avg of 1+2, avg of 1+2+3, avg of 1+2+3+4+....+n
clear x xbar y ybar i
for i = 1:numel(azi);
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
figure()
% subplot(2,2,4)
% subplot(2,3,5)
%don't start plotting until the 3rd value as the previous two are not fully
%averaged of three points
yyaxis left
plot(WWLLN.Date_Num(3:end),Temporal_Average3(3:end), 'ko-')
hold on
plot(WWLLN.Date_Num(1:2),Temporal_Average3(1:2), 'b*')
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

title('temporal average in unit vector azimuth - For the 3 most recent flashes')

%% Plot Raw Azimuths/Distances through time
figure()
% subplot(2,2,2)
% subplot(2,3,3)
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


%% Plot the event in question's lat/lon pairs color coded to time
figure()
% subplot(2,2,1)
% subplot(2,3,2)
hold on
scatter(WWLLN.lon, WWLLN.lat, d1km*10, WWLLN.Date_Num, 'filled')
colorbar
p = plot(bogo_lon,bogo_lat,'r^');
p.MarkerSize = 10;
p.MarkerFaceColor = 'r';
grid on
cbdate('hh:mm:ss')
hold off
title('lat/lon pairs color coded to time')


%% Plot Wind Data
load('Jun10_noon_Wind.mat')

Wind_Height_Ft = Wind_Height*3.28084;
figure()
% subplot(2,3,1)
hold on
plot(Wind_Dir,Wind_Height_Ft, 'b')
plot(Wind_Speed,Wind_Height_Ft, 'r')

xlim([0 360])
xticks([0 90 180 270 360])
xlabel('Azimuth Direction')
label = ['N'; 'E'; 'S'; 'W'; 'N'];
set (gca,'XTickLabel',label);

title('Red is speed increasing with increasing x, Blue is direction wind is COMING from')
grid on
hold off
