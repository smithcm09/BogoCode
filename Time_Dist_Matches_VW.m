%% WWLLN and Vaisala Matching Code
tic
close all
clear all
load('Bogo_Struct_VandW.mat')

% using a buffer in time and space to account for errors

% Step one - for given event loop through events to find times matching within 0.5 seconds
% Timing is in Datenum so adding 1 sec = datenum+(1/86400)
% So adding 0.5 seconds = datenum+((1/86400)/2)

onesec = 1/86400;
halfsec = onesec/2;

% Latitude: 1 deg = 110.574 km
% so 5 km = 0.0452 degrees
fiveNS = 0.0452;
 
% Longitude: 1 deg = 111.320*cos(latitude) km %% in radians
% use overall latitude of 53
% deg2rad = (53 * pi) / (180)
% so at 53deg lat 1 deg longitude = 111.320*cos(0.9250)
% so 1 deg long = 66.9962km
% so 5 km = 0.0746 degrees
fiveEW = 0.0746;

%Using the smaller dataset (WWLLN) to compare to the larger dataset (Vaisala)
for i = 1:numel(WWLLN_Bogo.Date_Num)
    %Calulate the range of high and low times around the given timepoint
    %Calulate the bounding box lat/lon values around the given timepoint
    low = WWLLN_Bogo.Date_Num(i)-halfsec;
    high = WWLLN_Bogo.Date_Num(i)+halfsec;
    E = WWLLN_Bogo.lon(i) - fiveEW;
    W = WWLLN_Bogo.lon(i) + fiveEW;
    N = WWLLN_Bogo.lat(i) + fiveNS;
    S = WWLLN_Bogo.lat(i) - fiveNS;
    for j = 1:numel(Vais_Bogo.Date_Num)
        %check to see if any of the vaisala events fit in that window
        if Vais_Bogo.Date_Num(j) > low && Vais_Bogo.Date_Num(j) < high
            %fprintf('time match for WWLLN %d and Vaisala %d\n', i, j)
            if Vais_Bogo.lon(j) > E && Vais_Bogo.lon(j) < W && Vais_Bogo.lat(j) > S && Vais_Bogo.lat(j) < N
                %fprintf('time and distance match for WWLLN %d and Vaisla %d\n', i, j)
                TDM_W_DN(i,1) = WWLLN_Bogo.Date_Num(i);
                TDM_W_Lat(i,1) = WWLLN_Bogo.lat(i);
                TDM_W_Lon(i,1) = WWLLN_Bogo.lon(i);
                TDM_V_DN(i,1) = Vais_Bogo.Date_Num(j);
                TDM_V_Lat(i,1) = Vais_Bogo.lat(j);
                TDM_V_Lon(i,1) = Vais_Bogo.lon(j);
                TDM_V_PeakC(i,1) = Vais_Bogo.peak_current(j);
                TDM_W_VLF(i,1) = WWLLN_Bogo.VLF(i);
                TDM_W_index(i,1) = i;
                TDM_V_index(i,1) = j;
            else
            end
        else
        end
    end
end
fprintf('%d number of WWLLN and Vaisala events had matching times +/- 0.5s\n', numel(TDM_W_DN))

%change wonky W_VLF 0 to 0.01 so can still plot at end
TDM_W_VLF(327) = 0.01;

% Get rid of excess zeros
W_DN = TDM_W_DN(any(TDM_W_DN,2),:);
W_Lat = TDM_W_Lat(any(TDM_W_Lat,2),:);
W_Lon = TDM_W_Lon(any(TDM_W_Lon,2),:);
V_DN = TDM_V_DN(any(TDM_V_DN,2),:);
V_Lat = TDM_V_Lat(any(TDM_V_Lat,2),:);
V_Lon = TDM_V_Lon(any(TDM_V_Lon,2),:);
W_index = TDM_W_index(any(TDM_W_index,2),:);
V_index = TDM_V_index(any(TDM_V_index,2),:);
W_VLF = TDM_W_VLF(any(TDM_W_VLF,2),:);
V_PC = TDM_V_PeakC(and(TDM_V_PeakC,2),:);

fprintf('%d number of WWLLN and Vaisala events that had matching times +/- 0.5s \n and matching locations withing 5km \n', numel(W_DN))

TDM = v2struct(W_DN, W_Lat, W_Lon, V_DN, V_Lat, V_Lon, W_index, V_index, W_VLF, V_PC);

%Clear all other variables outside of the structure
clear('N','E','i','fiveEW','fiveNS','halfsec','high','j','low','onesec','S','TDM_V_DN','TDM_V_index','TDM_V_Lat','TDM_V_Lon','TDM_V_PeakC','TDM_W_DN','TDM_W_index','TDM_W_Lat','TDM_W_Lon','TDM_W_VLF','V_DN','V_index','V_Lat','V_Lon','V_PC','W','W_DN','W_index','W_Lat','W_Lon','W_VLF');

%% Plot matching locations
figure()
plot(TDM.V_Lon, TDM.V_Lat, 'ko')
hold on
plot(TDM.W_Lon, TDM.W_Lat, 'b*')
xlabel('Longitude')
ylabel('Latitude')
title('Location Plot of TDM Ltg - Vaisala = black, WWLLN = blue')
hold off

%% Plot matching peak current and VHF
figure()
plot(abs(TDM.V_PC),TDM.W_VLF, 'ko')
set(gca,'YScale','log')
set(gca,'XScale','log')
xlabel('Absolute Value Vaisala Peak Current (kA)')
ylabel('WWLLN VLF (J) [far-field 6-18kHz]')
title('Comparision of WWLLN and Vaisala Metrics')
grid on
hold off

%% Plot Temporal
figure()
stem(TDM.W_DN,TDM.W_VLF,'b')
hold on
stem(TDM.V_DN,abs(TDM.V_PC), 'k')
datetick 'x'
set(gca,'YScale','log')
toc