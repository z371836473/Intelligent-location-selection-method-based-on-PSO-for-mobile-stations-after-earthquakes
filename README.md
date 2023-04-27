# Intelligent-location-selection-method-based-on-MOPSO-for-mobile-stations-after-earthquakes
Requirements: PlatEMO 4.0

The main function is site_selection.m, where two input parameters (parameter_str,file_dir) are required.
1. parameter_str refers to the site selection information, which is encoded as:

The data is presented in the following form in a string:
Coordinate x (double) of the main shock projection point, y (double) of the main shock projection point; Number of divided grid rows (int, starting from 1); Number of divided grid columns (int, starting from 1); Grid 1 row number (int), Grid 1 column number (int), Grid 1 attribute value (int); Grid 2 row number (int), Grid 2 column number (int), Grid 2 attribute value (int);...; Number of fixed stations nearby (int); Fixed station 1 coordinate x (double) Fixed station 1 coordinate y (double); Fixed station 2 coordinate x (double), fixed station 2 coordinate y (double); Number of mobile platforms to be deployed (int)“

Example:

"1.2,1.5,7.0;3;2;1,1,1111;1,2,1101;2,1,1001;2,2,1000;3,1,0110;3,2,1101;2;1.11,1.25;2.03,4.60;3"

Among them:

1.2 is the coordinate of the main shock projection point x

1.5 is the coordinate y of the main shock projection point

7.0 is the main earthquake magnitude

3 is the number of rows in the divided grid
2 is the number of divided grid columns
The row coordinate of grid 1 is 1, the column coordinate is 1, and the attribute value is 1111
The row coordinate of grid 2 is 1, the column coordinate is 2, and the attribute value is 1101
The row coordinate of grid 3 is 2, the column coordinate is 1, and the attribute value is 1001
The row coordinate of grid 4 is 2, the column coordinate is 2, and the attribute value is 1000
The row coordinate of grid 5 is 3, the column coordinate is 1, and the attribute value is 0110
The row coordinate of grid 6 is 3, the column coordinate is 2, and the attribute value is 1101
2 is the number of fixed stations nearby
The coordinates of fixed platform 1 are 1.11,1.25
The coordinates of fixed platform 2 are 2.03,4.60
3 is the number of mobile platforms to be deployed
Grid attribute score:
Bedrock: 1
Noise area: 10
Infeasible area: 100
Fault zone: 1000
The grid length is 100m * 100m
Plane coordinates
Spherical coordinates
Row number

2. file_dir refers to the local path to save the results.
