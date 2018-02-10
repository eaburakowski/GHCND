# GHCND
Scripts used to process Global Historical Climatology Network Daily (GHCND) data. 
GHCND data available at: 
https://www.ncdc.noaa.gov/data-access/land-based-station-data/land-based-datasets/global-historical-climatology-network-ghcn

Matlab scripts used for processing GHCND data. Code requires customization and will not run 'as-is'. Always happy to answer questions and I welcome helpful suggestions to improve the efficiency of the code. This code was written for a specific project (TBA at a later date) and is adaptable for multiple uses. elizabeth.burakowski@unh.edu.

NOTE: Several of the matlab scripts are dervied directly from, or modified from, the Matlab Spring Indices code package:
https://www.mathworks.com/matlabcentral/fileexchange/54679-extended-spring-indices--si-x--code
Ault et al. 2015


Files listed in order of use in my processeing & analysis.

(1a) mk_ghcnd.m
- processes metadata file from GHCND (ghcnd-stations.txt)

(1b) mk_ghcnd_inv.m
- processes inventory file from GHCND (ghcnd-inventory.txt)

(2) filterGHCND.m
- Screens and filters Global Historical Climatology Network Daily (GHCN-D)
- for station availability based on:
  - start year of record
  - end year of record
  - location (US states)
  - snow depth availability (var = SNWD)
  
(3) read_ghcnd_dly_file.m
- loads ghcnd station data
- used in GHCND_SNWD.m, below. Not meant to run as stand-alone
- from Matlab Spring Indices code package (Ault et al. 2015)

(4) GHCND_SNWD.m
- loads Global Historical Climatology Network Daily files using the function "read_ghcnd_dly_file.m"
- Output is a state-level .mat file of daily station data meeting criteria defined in filterGHCND.m

(5) procSNWD.m
- loads state-level .mat files created using "GHCND_SNWD.m", which contain GHCND daily snow depth data (in mm), 2000-2016. 
- The script then does the following:
  - calculates percent missing data per winter
  - removes years missing >25% of daily records
  - removes stations missing > 2 years of data
  - sums the number of days per winter (December through March) with snow
    depth greater than a user-defined threshold (>4" recommended).  
  - calculates the state average # of snow days per winter
  - ranks the winters from highest to lowest number of snow covered days
