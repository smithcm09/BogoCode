% Exploratory Plots for comparison of Vaisala and WWLLN results for
% Bogoslof 2016/2017 eruptions
clear all
close all

load('Bogo_Struct_VandW.mat')
%% Number of Stations/Sensors Vs Energy/Peak Current

figure()
semilogy(WWLLN_Bogo.NumSta_energ, WWLLN_Bogo.VLF, 'ko')
ylabel('VLF Energy (J) [far-field 6-18kHz]')
xlabel('Number of Stations')
title('WWLLN - Entire Bogoslof Suite')


figure()
hold on
for i = 1:numel(Vais_Bogo.peak_current)
    if Vais_Bogo.peak_current(i) < 0
        plot(Vais_Bogo.NumSens(i), abs(Vais_Bogo.peak_current(i)), 'r*')
    else
        plot(Vais_Bogo.NumSens(i), Vais_Bogo.peak_current(i), 'ko')
    end
end
set(gca, 'YScale', 'log')
ylabel('Absolute Value of Peak Current (kA)')
xlabel('Number of Stations')
title('Vaisala - Entire Bogoslof Suite - red = negative polarity')
hold off

jitPeakCurrent = jitter(Vais_Bogo.peak_current);
jitNumSens = jitter(Vais_Bogo.NumSens);
figure()
hold on
for i = 1:numel(jitPeakCurrent)
    if jitPeakCurrent(i) < 0
        plot(jitNumSens(i), abs(jitPeakCurrent(i)), 'r*')
    else
        plot(jitNumSens(i), jitPeakCurrent(i), 'ko')
    end
end
set(gca, 'YScale', 'log')
ylabel('Absolute Value of Peak Current (kA)')
xlabel('Number of Stations')
title('Jittered Vaisala - Entire Bogoslof Suite - red = negative polarity')
hold off

x = Vais_Bogo.peak_current<0;
y = sum(x);
z = numel(Vais_Bogo.peak_current);
w = (y/z)*100;
fprintf('\n%d of the Vaisala peak currents (of a total of %d) are of negative polarity\n This is %d%% of all flashes\n', y,z,round(w))
%% Histograms of Vais and WWLLN data

figure()
histogram(Vais_Bogo.peak_current,739)
axis([-60 60 0 500])
ylabel('# of events')
xlabel('Peak Current (kA)')
title('Vaisala - Entire Bogoslof Suite - bin size 1kA, zoomed to +/-60 kA')

figure()
histogram(WWLLN_Bogo.VLF, 1000)
axis([0 10000 0 500])
ylabel('# of events')
xlabel('VLF Energy (J) [far-field 6-18kHz]')
title('WWLLN - Entire Bogoslof Suite - Zoomed to 0-10000 J ')

%% Comparison Plot of Vaisala and WWLLN location detections

figure()
plot(Vais_Bogo.lon,Vais_Bogo.lat, 'ko')
hold on
plot(WWLLN_Bogo.lon, WWLLN_Bogo.lat, 'b*')
grid on
xlabel('Longitude')
ylabel('Latitude')
title('Location Plot of detected Ltg - Vaisala = black, WWLLN = blue')
hold off

Vais_location = horzcat(Vais_Bogo.lat, Vais_Bogo.lon);
WWLLN_location = horzcat(WWLLN_Bogo.lat, WWLLN_Bogo.lon);
[E, ic, id] = intersect(Vais_location, WWLLN_location, 'rows');
fprintf('\nVaisala and WWLLN have %d matching events in space\n', numel(E)/2)


% %Plot Latitude and longitude for these times
% figure()
% hold on
% 
% for i = 1:(numel(E)/2)
%     plot(Vais_Bogo.lon(ic(i)),Vais_Bogo.lat(ic(i)),'ko')
% end
% xlabel('Longitude')
% ylabel('Latitude')
% title('Comparision of WWLLN and Vaisala Metrics')
% grid on
% hold off
%% %% Comparing Distance and peak current/energy

figure()
subplot(2,1,1)
semilogy(WWLLN_gcd,WWLLN_Bogo.VLF, 'o')
xlabel('Distance (km)')
ylabel('VLF (J) [far-field 6-18kHz]')
title('WWLLN - Bogoslof')

subplot(2,1,2)
semilogy([Cervelli_Vais_Bogo.distance], abs(Vais_Bogo.peak_current), 'o')
xlabel('Distance(km)')
ylabel('Absolute Value Peak Current (kA)')
title('Vaisala - Bogoslof')

%% Comparing Peak Current (Vaisala) with Peak VLF energy (WWLLN)

%only want to compare the same events - vaisala has extra events
%need to determine if the timing of each event to determine an appropriate
%timewindow to bin things into for comparision

% figure()
% hold on
% plot(Vais_Bogo.Date_Num,'r*')
% plot(WWLLN_Bogo.Date_Num,'ko')
% grid on
% hold off

%Compared datenum arrival times for WWLLN n=108 with Vaisala n=200 --> same
%timing, compared Vaisala n=200 with n=201 timing diff of 0.0000001

%Create a list of all of the times that Vais and WLLN have the same
%date_nums
[C,ia,ib] = intersect(Vais_Bogo.Date_Num,WWLLN_Bogo.Date_Num);
fprintf('\nVaisala and WWLLN have %d matching events in time\n', numel(C))

%Plot peak current and VLF for these times
figure()
hold on

for i = 1:numel(C)
    plot(abs(Vais_Bogo.peak_current(ia(i))),WWLLN_Bogo.VLF(ib(i)),'ko')
end
set(gca,'YScale','log')
set(gca,'XScale','log')
xlabel('Absolute Value Vaisala Peak Current (kA)')
ylabel('WWLLN VLF (J) [far-field 6-18kHz]')
title('Comparision of WWLLN and Vaisala Metrics')
grid on
hold off

%% Determine what the distance differences are for the events matching in time (above section)

for i = 1:numel(C)
    Vais_lat_a(i,1) = Vais_Bogo.lat(ia(i));
    Vais_lon_a(i,1) = Vais_Bogo.lon(ia(i));
    WWLLN_lat_b(i,1) = WWLLN_Bogo.lat(ib(i));
    WWLLN_lon_b(i,1) = WWLLN_Bogo.lon(ib(i));
end

% use downloaded function in file lldistkm that calculates the distance in km using the
% Haversine Distance
for i = 1:numel(C)
    Vais_point = [Vais_lat_a(i) Vais_lon_a(i)];
    WWLLN_point = [WWLLN_lat_b(i) WWLLN_lon_b(i)];
    d1km(i,1) = lldistkm(Vais_point, WWLLN_point);
end

figure()
histogram(d1km)
xlabel('difference in location (km)')
ylabel('number of events from time matched list')

mdkm = mean(d1km);

fprintf('\nOf these %d matching events in time, the mean difference in distance \n for each matching event is %3.1d km\n', numel(C), mdkm)

%% Plot WWLLN Data with energy error 

%if error is >1/2 the energy value plot in red
figure()
hold on
for k = 1:numel(WWLLN_Bogo.Date_Num)
    if WWLLN_Bogo.VLF_error(k,1) > (WWLLN_Bogo.VLF(k,1)*0.5)
        plot(WWLLN_Bogo.Date_Num(k,1), WWLLN_Bogo.VLF(k,1), 'r*')
        WWLLN_error_Datenum(k,1) = WWLLN_Bogo.Date_Num(k,1);
    else
        plot(WWLLN_Bogo.Date_Num(k,1), WWLLN_Bogo.VLF(k,1), 'ko')
    end
end
datetick('x')
xlabel('Date 2016/2017')
ylabel('WWLLN VLF (J) [far-field 6-18kHz]')
title('VLF error analysis - red points indicate error > 1/2 VLF value')
hold off

Aa = WWLLN_Bogo.VLF_error > (WWLLN_Bogo.VLF*0.5);
A = sum(Aa);
B = numel(WWLLN_Bogo.Date_Num);

fprintf('\nWWLLN has %d of events out of (%d total events) where \n the VLF error is >1/2 the total VLF. \n These %d events should only be used with caution \n', A,B,A)

%% 

