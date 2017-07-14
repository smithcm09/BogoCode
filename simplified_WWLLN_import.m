function Q = simplified_WWLLN_import(filename)
% Reads data from a WWLLN loc file located in
% /Documents/MATLAB/Bogoslof_lightning/WWLLN_data/WWLLNbogoslovAE
% filenames are of the form AE20161205.bogoslov.loc
% -----------------------------------------------------------------------------------------------------------------------
%  This is just from WWLLN-only files (only WWLLN data with energy info at the moment).
%  Same column structure as before:
%  1-6   Date,time to microsecond  in UTC
%  7,8   Lat,Lon in fractional degrees
%  9 residual fit error in microseconds 10 Nsta=number of WWLLN stations participating in fit
%  11 Far field radiated VLF energy/stroke between 6 and 18 kHz in Joules
%  12 Energy error of the fit (in joules)
%  13 number of wwlln station with good energy data used for the energy fit
% 
%  Note that if energy is zero - no data
%  If the energy error is more than half of the energy - then be careful in using the energy
%  If only 1 station has good energy data, then no error, does not mean necessarily good energy value
% 
%  You should find some correlation between energy and Nsta because for stronger strokes they are more 
% likely to be detected by more WWLLN stations (one way to check really large energy values are valid)
% -----------------------------------------------------------------------------------------------------------------------

%filename = 'merged_vaisala.txt';
data_format = '%s%s%f%f%f%f%f%f%f';
fid = fopen(filename,'r');
C = textscan(fid,data_format, 'Delimiter', ',');
lat = C{3};
lon = C{4};
res_fit = C{5};
NumSta_loc = C{6};
VLF = C{7};
VLF_error = C{8};
NumSta_energ = C{9};


for k = 1:length(C{1})
    str = sprintf('%s %s', C{1}{k},C{2}{k});
    Date_Num(k,1) =  datenum(str, 'yyyy/mm/dd HH:MM:SS.FFF');
end
 
Q = v2struct(Date_Num, lat, lon, res_fit, NumSta_loc, VLF, VLF_error, NumSta_energ);

end




