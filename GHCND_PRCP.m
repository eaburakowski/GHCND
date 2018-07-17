%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% GHCND_PRCP.m
%
% 2018-07-17
% EA Burakowski
% elizabeth.burakowski@gmail.com
%
% GHCND_PRCP.m loads Global Historical Climatology Network Daily files
% using the function "read_ghcnd_dly_file.m".  Script requires
% "ghcnd_metadata" generated with "mk_ghcnd_metadata.m" and "stationIDs"
% generated using "mk_ghcnd_metadata_inv.m" and filterGHCND.m.  
%
% Output is a separate .mat file for each selected US state with station
% data meeting criteria defined in filterGHCND.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd /Users/zubeneschamali/Documents/Data/GHCN_Daily/GHCND_2017/

load ghcnd_metadata
load stationIDs_LOCA_PRCP

% convert states to string
states = cellstr(states); 

% Loop over states, load stations from each state and create a .mat file
% Loop over states
for istate = 1:length(unique(MetaState)) 
    
    % Create index of stations in given state
    state_ind = find(strcmp(MetaState,states(istate))==1);
    
    % change dir to where .dly files are stored
    cd /Users/zubeneschamali/Documents/Data/GHCN_Daily/GHCND_2017/dly/ghcnd_all/

    % Loop over stations in given state
    for istation = 1:length(state_ind)
        station = char(InvID(state_ind(istation)))
        disp(station)
        filename = strcat(char(InvID(state_ind(istation))),'.dly');
        filename = string(filename);
        variable = char('PRCP');
        
        % load station
        eval([station '= read_ghcnd_dly_file(filename,ghcnd_metadata,variable);'])
    end
    
    % change dir to where .mat files are stored
    cd /Users/zubeneschamali/Documents/Spring2018/LOCA/matlab/mat/

    % save all stations in state in single .mat file
    fn_state = char(strcat(states(istate),'_1979_2016_PRCP.mat'))
    save(fn_state,'U*')
    
    % clean up
    clear U* state_ind station filename fn_state
    
end