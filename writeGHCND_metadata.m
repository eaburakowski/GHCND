%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% writeGHCND_metadata.m
%
% 2018-07-17
% EA Burakowski
% elizabeth.burakowski@gmail.com
%
% writeGHCND_metadata.m writes Global Historical Climatology Network Daily
%   (GHCND) metadata from .mat file to .csv. 
%
% The script does the following:
%   - loads a .mat file with GHCND metadata created using filterGHCND.m
%   - writes the following metadata to a comma-separated values (.csv):
%       - station ID
%       - station name (ie: city or town)
%       - state
%       - lat (deg N)
%       - lon (deg W)
%       - elev (m)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% navigate to where .mat files are stored and load metadata .mat file
cd '/Users/zubeneschamali/Documents/Spring2018/LOCA/matlab/GHNCD_metadata'
load stationIDs_LOCA_PRCP.mat

% designate a filename
fn = 'GHCNDstations_PRCP.csv';

% generate header information
Header = {'StationID','StationName','State','Lat','Lon','Elevation'};
tHeader = strjoin(Header,',');

% open file and write header
fid = fopen(fn,'w');
fprintf(fid,'%s\n',tHeader);

% append metadata under header
for i = 1:length(MetaLat)
    fprintf(fid,'%s,%s,%s,%f,%f,%f\n',MetaID{i},MetaName{i},MetaState{i},MetaLat(i),MetaLon(i),MetaElev(i));
end

% close the file
fclose(fid);



