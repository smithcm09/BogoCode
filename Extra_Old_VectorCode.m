%% OLD AZIMUTH CODE

%% calculate average azimuth from one flash to the next
% %Can only do for averaging 2 azimuths togeather
% %Check to see if angles are >180 apart from each other by taking difference
% for i = 1:numel(azi)
%     if i+1 > numel(azi)
%         break
%     end
%     diff = abs(azi(i)-azi(i+1))
%     if diff < 180
%         %if no add togeather and divide by 2
%         avg_azi(i,1) = (azi(i) + azi(i+1))/2
%     else
%         %if yes add togeather divide by 2 add 180
%         avg_azi(i,1) = ((azi(i) + azi(i+1))/2)+180
%         %if answer is >360 subtract 360
%         if avg_azi(i,1) > 360
%             avg_azi(i,1) = avg_azi(i,1) - 360
%         else
%         end
%     end
% end
% %% plot the one by one averaged data
% subset_Date = WWLLN.Date_Num(1:(numel(avg_azi)));
% figure();
% plot(subset_Date,avg_azi, 'ko');
% grid on;
% datetick('x');

%% calculate the unit vector average direction - Non Temporal (http://www.ndbc.noaa.gov/wndav.shtml)
%This is the NOAA accepted way of averaging azimuths
clear x xbar y ybar i
% unity is length of vector
% azimuth is angle
% find x and y 
x = cosd(azi);
y = sind(azi);
% average x an y
xbar = mean(x);
ybar = mean(y);
% find angle of y/x
% add 360 at the end to correct for mapping to the -180/180  range and
    % instead map to the 0-360 range (https://www.mathworks.com/matlabcentral/answers/202915-converting-atan2-output-to-360-deg)
Ltg_Avg_Dir = atan2d(ybar,xbar) + 360*(ybar<0)

%% plot subplots of lat and lon vs time
% figure ()
% subplot(2,1,1)
% hold on
% plot(WWLLN.Date_Num,WWLLN.lon,'ko');
% myfit = polyfit(WWLLN.Date_Num,WWLLN.lon,1);
% X = linspace(min(WWLLN.Date_Num),max(WWLLN.Date_Num))';
% Y = polyval(myfit,X);
% plot(X,Y);
% datetick('x');
% % set(gca,'ydir','reverse')
% % view(-90,90)
% p = plot(mintime,bogo_lon,'r^');
% p.MarkerSize = 10;
% p.MarkerFaceColor = 'r';
% grid on
% title('Longitude through time')
% hold off
% 
% subplot(2,1,2)
% hold on
% plot(WWLLN.Date_Num,WWLLN.lat,'ko');
% myfit_1 = polyfit(WWLLN.Date_Num,WWLLN.lat,1);
% X = linspace(min(WWLLN.Date_Num),max(WWLLN.Date_Num))';
% Y = polyval(myfit_1,X);
% plot(X,Y);
% datetick('x');
% p = plot(mintime,bogo_lat,'r^');
% p.MarkerSize = 10;
% p.MarkerFaceColor = 'r';
% grid on
% title('Latitude through time')
% hold off
% 
% 
% fprintf('slope of longitude fit is %1.5f\n', myfit(1))
% fprintf('slope of latitude fit is %1.5f\n', myfit_1(1))
% 
% if myfit(1) > 0 && myfit_1(1) > 0
%     fprintf('Ltg is travelling North-East\n')
% elseif myfit(1) > 0 && myfit_1(1) < 0
%     fprintf('Ltg is travelling South-East\n')
% elseif myfit(1) < 0 && myfit_1(1) < 0
%     fprintf('Ltg is travelling South-West\n')
% elseif myfit(1) < 0 && myfit_1(1) > 0
%     fprintf('Ltg is travelling North-West\n')
% elseif myfit == 0 && myfit_1(1) > 0 
%     fprintf('Ltg is travelling North\n')
% elseif myfit == 0 && myfit_1(1) < 0 
%     fprintf('Ltg is travelling South\n') 
% elseif myfit < 0 && myfit_1(1) == 0 
%     fprintf('Ltg is travelling West\n')
% elseif myfit > 0 && myfit_1(1) == 0 
%     fprintf('Ltg is travelling East\n')
% else
%     fprintf('Ltg is stationary\n')
% end
    
%% plot latitude and longitude and find NON-Temporal TrendLine slope
% bogo_lat = 53.9272;
% bogo_lon = -168.0344;
% 
% figure()
% hold on
% plot(WWLLN.lon,WWLLN.lat,'ko');
% myfit_2 = polyfit(WWLLN.lon,WWLLN.lat,1);
% X = linspace(min(WWLLN.lon),max(WWLLN.lon))';
% Y = polyval(myfit_2,X);
% plot(X,Y);
% 
% p = plot(bogo_lon,bogo_lat,'r^');
% p.MarkerSize = 10;
% p.MarkerFaceColor = 'r';
% grid on
% hold off
% 
% fprintf('Non-Temporal lat/lon slope of fit is %1.2f\n', myfit_2(1))


