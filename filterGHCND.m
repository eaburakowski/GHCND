% filterGHCND_SNWD.mat 
% 
% EA Burakowski
% 2017-09-11
% elizabeth.burakowski@gmail.com
%
% Screens and filters Global Historical Climatology Network Daily (GHCN-D)
% for station availability based on:
%   - start year of record
%   - end year of record
%   - location (US states)
%   - snow depth availability (var = SNWD)
%
% The list of potential GHCN-D stations available is exported as a .csv
% file, ghcndIDs_$startyear_$endyear_$var.csv.
%
%
% Requires:
%   ghcnd_inventory.mat (generated using mk_ghcnd_metadata_inv.m)
%   ghcnd_stations.mat (generated using mk_ghcnd_metadata.m)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd /Users/Antares/Documents/Data/GHCN_Daily/GHCND_2017/

load ghcnd_inventory.mat
load ghcnd_stations.mat

% define start year, end year, US states, and climate variable
yrsrt = 2000;
yrend = 2016;
states = ['AK';
          'AZ';
          'CA';
          'CO';
          'CT';
          'ID';
          'IL';
          'IN';
          'MA';
          'ME';
          'MI';
          'MN';
          'MT';
          'NC';
          'NE';
          'NH';
          'NJ';
          'NM';
          'NV';
          'NY';
          'OH';
          'OR';
          'PA';
          'RI';
          'SC';
          'SD';
          'UT';
          'VA';
          'VT';
          'WA';
          'WI';
          'WV';
          'WY'];
      
var = 'SNWD';

% assign .csv filename for output
ofile = strcat('ghcndIDs_',num2str(yrsrt),'_',num2str(yrend),'_',var,'.csv');

% Retrieve inventory stationIDs, lat, lon, 
InvID = cellstr(ghcnd_inventory.ID);
InvLat = ghcnd_inventory.lat;
InvLon = ghcnd_inventory.lon;
InvVar = ghcnd_inventory.variable;
InvYrStart = ghcnd_inventory.yearstart;
InvYrEnd = ghcnd_inventory.yearend;

% Retrieve metadata stationIDs, states, lat, lon, 
MetaID = cellstr(ghcnd_metadata.ID);
MetaLat = ghcnd_metadata.lat;
MetaLon = ghcnd_metadata.lon;
MetaState = cellstr(ghcnd_metadata.state);
MetaElev = ghcnd_metadata.elevation;
MetaName = cellstr(ghcnd_metadata.name);

% Filter Inventory by year start, year end, and variable 
% Indices of stations with yearstart > 2000, yearend < 2016, 
% and var ~= SNWD
remove1 = find(InvYrStart > 2000);
remove2 = find(InvYrEnd < 2016);
remove3 = find(strcmp(' SNWD',InvVar)==0); 
InvRemove = unique([remove1; remove2; remove3]);

% Remove the stations from Inventory not meeting criteria above
InvID(InvRemove,:)=[];
InvLat(InvRemove)=[];
InvLon(InvRemove)=[];
InvVar(InvRemove)=[];
InvYrStart(InvRemove)=[];
InvYrEnd(InvRemove)=[];

% Cleanup
clear InvRemove remove1 remove2 remove3

% Filter MetaID, removing stationIDs not present in InvID, 
% Then remove unwanted stations by state
% Create indices of MetadataID to be removed because not in screened
% inventory and not in list of desired states
[MetaIDs_removed,remove1] = setdiff(MetaID,InvID);
removeStates_logical = ismember(MetaState,states);
remove2 = find(removeStates_logical==0);
MetaRemove = unique([remove1; remove2]);

% Remove stations from Metadata not meeting criteria above
MetaID(MetaRemove)=[];
MetaLat(MetaRemove)=[];
MetaLon(MetaRemove)=[];
MetaState(MetaRemove)=[];
MetaElev(MetaRemove)=[];
MetaName(MetaRemove)=[];

% Cleanup
clear MetaIDs_removed remove1 removeStates_logical remove2 MetaRemove

% Create indices of InvID not in filtered MetaID to remove InventoryIDs
% that do not meet state criteria.  This would all be a lot easier if the
% ghcnd-inventory included states in the file.  I'm sure there's a more
% efficient way of doing this (assigning states based on ID probably)
[InvIDS_removed,InvRemove] = setdiff(InvID,MetaID);
InvID(InvRemove,:)=[];
InvLat(InvRemove)=[];
InvLon(InvRemove)=[];
InvVar(InvRemove)=[];
InvYrStart(InvRemove)=[];
InvYrEnd(InvRemove)=[];

% Cleanup
clear InvIDS_removed InvRemove

% Write csv file with GHCND stationID, lat, lon, elev, & station name











