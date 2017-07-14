function L = simplified_vaisala_import(filename)
% Reads data from a Vaisala UALF0 format data files, which contain 25
% columns of tab-delimited ASCII text
%
% For the file purchased from Vaisala on 2017-01-30:
%     report5530083384_gld_strokes_ualf0.txt
% 9 columns were invariant (see below) and thus omitted from the
% function output.
%
% -----------------------------------------------------------------------------------------------------------------------
% Col #     MIN         MAX   status     Definition
% -----------------------------------------------------------------------------------------------------------------------
%  1.         0          0   (omitted)   Version number
%  2.      2016       2017               Year
%  3.         1         12               Month
%  4.         4         31               Day
%  5.         0         23               Hour
%  6.         0         59               Minute
%  7.         0         59               Second
%  8.    836121  999939695               Nanosecond
%  9.   53.1624    54.3576               Latitude (decimal degrees)
% 10. -169.0744  -166.7547               Longitude (decimal degrees)
% 11.      -678         61               Estimated peak current in kiloamps, -9999 to 9999
% 12.         0          0   (omitted)   Multiplicity for flash data (1 to 99) or 0 for strokes.
% 13.         3         17               Number of sensors participating in the solution, 2 to 99
% 14.         3         31               Degrees of freedom when optimizing location, 0 to 99
% 15.       0.7        180               Ellipse angle as a clockwise bearing from 0 degrees North, 0 to 180.0 degrees
% 16.       1.6       23.1               Ellipse semi-major axis length in kilometers, 0 to 50.0km.
% 17.       1.2          4               Ellipse semi-minor axis length in kilometers, 0 to 50.0km.
% 18.         0        9.7               Chi-squared value from location optimization, 0 to 999.99
% 19.         0          0   (omitted)   Risetime of the waveform in microseconds, 0 to 99.9
% 20.         0          0   (omitted)   Peak-to-zero time of the waveform in microseconds, 0 to 999.9
% 21.         0          0   (omitted)   Maximum rate-of-rise of the waveform in kA/usec, 0 to 999.9
% 22.         0          0   (omitted)   Cloud indicator, 1 if Cloud-to-cloud discharge, 0 for Cloud-to-ground
% 23.         1          1   (omitted)   Angle indicator, 1 if sensor angle data used to compute position, 0 otherwise
% 24.         0          0   (omitted)   Signal indicator, 1 if sensor signal data used to compute position, 0 otherwise
% 25.         1          1   (omitted)   Timing indicator, 1 if sensor timing data used to compute position, 0 otherwise
% -----------------------------------------------------------------------------------------------------------------------

%filename = 'merged_vaisala.txt';
data_format = '%n%s%s%s%s%s%s%s%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n';
fid = fopen(filename,'r');
C = textscan(fid,data_format);
lat = C{9};
lon = C{10};
peak_current = C{11};
NumSens = C{13};

for k = 1:length(C{1})
    str = sprintf('%s-%s-%s %s:%s:%s.%s', C{2}{k},C{3}{k},C{4}{k},C{5}{k},C{6}{k},C{7}{k},C{8}{k});
    Date_Num(k,1) =  datenum(str, 'yyyy-mm-dd HH:MM:SS.FFF');
end


%create a structure from the variables
L = v2struct(Date_Num, lat, lon, peak_current, NumSens)

end




