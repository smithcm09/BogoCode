%Calculating the gc distance of the WWLLN Data using the Cervelli gc.m code

origin = [-168.036306;53.931891];
llh = [WWLLN_Bogo.lon, WWLLN_Bogo.lat];

[GCD, az] = gc(llh',origin);
WWLLN_gcd = GCD';
%in km
WWLLN_gcd = WWLLN_gcd/1000
WWLLN_azi = az';
