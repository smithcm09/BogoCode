%% Import all .loc files

A = simplified_WWLLN_import('AE20161205.bogoslov.loc');
B = simplified_WWLLN_import('AE20161216.bogoslov.loc');
C = simplified_WWLLN_import('AE20161217.bogoslov.loc');
D = simplified_WWLLN_import('AE20161219.bogoslov.loc');
E = simplified_WWLLN_import('AE20161222.bogoslov.loc');
F = simplified_WWLLN_import('AE20161223.bogoslov.loc');
G = simplified_WWLLN_import('AE20161226.bogoslov.loc');
H = simplified_WWLLN_import('AE20161227.bogoslov.loc');
I = simplified_WWLLN_import('AE20161231.bogoslov.loc');
J = simplified_WWLLN_import('AE20170104.bogoslov.loc');
K = simplified_WWLLN_import('AE20170105.bogoslov.loc');
L = simplified_WWLLN_import('AE20170109.bogoslov.loc');
M = simplified_WWLLN_import('AE20170115.bogoslov.loc');
N = simplified_WWLLN_import('AE20170118.bogoslov.loc');
O = simplified_WWLLN_import('AE20170120.bogoslov.loc');
P = simplified_WWLLN_import('AE20170122.bogoslov.loc');
Q = simplified_WWLLN_import('AE20170124.bogoslov.loc');
R = simplified_WWLLN_import('AE20170126.bogoslov.loc');
S = simplified_WWLLN_import('AE20170127.bogoslov.loc');
T = simplified_WWLLN_import('AE20170128.bogoslov.loc');
U = simplified_WWLLN_import('AE20170131.bogoslov.loc');
V = simplified_WWLLN_import('AE20170217.bogoslov.loc');
W = simplified_WWLLN_import('AE20170218.bogoslov.loc');
X = simplified_WWLLN_import('AE20170220.bogoslov.loc');
Y = simplified_WWLLN_import('AE20170308.bogoslov.loc');
Z = simplified_WWLLN_import('AE20170402.bogoslov.loc');
AA = simplified_WWLLN_import('AE20170502.bogoslov.loc');
BB = simplified_WWLLN_import('AE20170517.bogoslov.loc');
CC = simplified_WWLLN_import('AE20170528.bogoslov.loc');
DD = simplified_WWLLN_import('AE20170610.bogoslov.loc');
EE = simplified_WWLLN_import('AE20170616.bogoslov.loc');

%% Concatenate Variables into single variables

Date_Num = vertcat(A.Date_Num, B.Date_Num, C.Date_Num, D.Date_Num, E.Date_Num, F.Date_Num, G.Date_Num, H.Date_Num, I.Date_Num, J.Date_Num, K.Date_Num, L.Date_Num, M.Date_Num, N.Date_Num, O.Date_Num, P.Date_Num, Q.Date_Num, R.Date_Num, S.Date_Num, T.Date_Num, U.Date_Num, V.Date_Num, W.Date_Num, X.Date_Num, Y.Date_Num, Z.Date_Num, AA.Date_Num, BB.Date_Num, CC.Date_Num, DD.Date_Num, EE.Date_Num);
lat = vertcat(A.lat, B.lat, C.lat, D.lat, E.lat, F.lat, G.lat, H.lat, I.lat, J.lat, K.lat, L.lat, M.lat, N.lat, O.lat, P.lat, Q.lat, R.lat, S.lat, T.lat, U.lat, V.lat, W.lat, X.lat, Y.lat, Z.lat, AA.lat, BB.lat, CC.lat, DD.lat, EE.lat);
lon = vertcat(A.lon, B.lon, C.lon, D.lon, E.lon, F.lon, G.lon, H.lon, I.lon, J.lon, K.lon, L.lon, M.lon, N.lon, O.lon, P.lon, Q.lon, R.lon, S.lon, T.lon, U.lon, V.lon, W.lon, X.lon, Y.lon, Z.lon, AA.lon, BB.lon, CC.lon, DD.lon, EE.lon);
res_fit = vertcat(A.res_fit, B.res_fit, C.res_fit, D.res_fit, E.res_fit, F.res_fit, G.res_fit, H.res_fit, I.res_fit, J.res_fit, K.res_fit, L.res_fit, M.res_fit, N.res_fit, O.res_fit, P.res_fit, Q.res_fit, R.res_fit, S.res_fit, T.res_fit, U.res_fit, V.res_fit, W.res_fit, X.res_fit, Y.res_fit, Z.res_fit, AA.res_fit, BB.res_fit, CC.res_fit, DD.res_fit, EE.res_fit);
NumSta_loc = vertcat(A.NumSta_loc, B.NumSta_loc, C.NumSta_loc, D.NumSta_loc, E.NumSta_loc, F.NumSta_loc, G.NumSta_loc, H.NumSta_loc, I.NumSta_loc, J.NumSta_loc, K.NumSta_loc, L.NumSta_loc, M.NumSta_loc, N.NumSta_loc, O.NumSta_loc, P.NumSta_loc, Q.NumSta_loc, R.NumSta_loc, S.NumSta_loc, T.NumSta_loc, U.NumSta_loc, V.NumSta_loc, W.NumSta_loc, X.NumSta_loc, Y.NumSta_loc, Z.NumSta_loc, AA.NumSta_loc, BB.NumSta_loc, CC.NumSta_loc, DD.NumSta_loc, EE.NumSta_loc);
VLF = vertcat(A.VLF, B.VLF, C.VLF, D.VLF, E.VLF, F.VLF, G.VLF, H.VLF, I.VLF, J.VLF, K.VLF, L.VLF, M.VLF, N.VLF, O.VLF, P.VLF, Q.VLF, R.VLF, S.VLF, T.VLF, U.VLF, V.VLF, W.VLF, X.VLF, Y.VLF, Z.VLF, AA.VLF, BB.VLF, CC.VLF, DD.VLF, EE.VLF);
VLF_error = vertcat(A.VLF_error, B.VLF_error, C.VLF_error, D.VLF_error, E.VLF_error, F.VLF_error, G.VLF_error, H.VLF_error, I.VLF_error, J.VLF_error, K.VLF_error, L.VLF_error, M.VLF_error, N.VLF_error, O.VLF_error, P.VLF_error, Q.VLF_error, R.VLF_error, S.VLF_error, T.VLF_error, U.VLF_error, V.VLF_error, W.VLF_error, X.VLF_error, Y.VLF_error, Z.VLF_error, AA.VLF_error, BB.VLF_error, CC.VLF_error, DD.VLF_error, EE.VLF_error);
NumSta_energ = vertcat(A.NumSta_energ, B.NumSta_energ, C.NumSta_energ, D.NumSta_energ, E.NumSta_energ, F.NumSta_energ, G.NumSta_energ, H.NumSta_energ, I.NumSta_energ, J.NumSta_energ, K.NumSta_energ, L.NumSta_energ, M.NumSta_energ, N.NumSta_energ, O.NumSta_energ, P.NumSta_energ, Q.NumSta_energ, R.NumSta_energ, S.NumSta_energ, T.NumSta_energ, U.NumSta_energ, V.NumSta_energ, W.NumSta_energ, X.NumSta_energ, Y.NumSta_energ, Z.NumSta_energ, AA.NumSta_energ, BB.NumSta_energ, CC.NumSta_energ, DD.NumSta_energ, EE.NumSta_energ);

%% create a structure from the single variables
WWLLN_Bogo = v2struct(Date_Num, lat, lon, res_fit, NumSta_loc, VLF, VLF_error, NumSta_energ);