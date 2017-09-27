%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% procSNWD.m
%
% 2017-09-22
% EA Burakowski
% elizabeth.burakowski@gmail.com
%
% procSNWD.m loads state-level .mat files created using "GHCND_SNWD.m",
% which contain GHCND daily snow depth data (in mm), 2000-2016. 
% The script does the following:
%   - calculates percent missing data per winter
%   - removes years missing >25% of daily records
%   - removes stations missing > 2 years of data
%   - sums the number of days per winter (December through March) with snow
%   depth greater than a user-defined threshold (>3" recommended).  
%   - calculates the state average # of snow days per winter
%   - ranks the winters from highest to lowest number of snow covered days
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd /Users/Antares/Documents/Data/GHCN_Daily/GHCND_2017/mat/

load stationIDs

% list all state.mat files in directory
fils = dir('*.mat');

% Some constants
years = (1850:2050)';
yrstart = find(years==2000);
yrend = find(years==2016);
yrs = years(yrstart:yrend)';
snwd_thresh = 76.2; % snow depth in mm
data_thresh = 0.25; % winter missing data threshold
yr_thresh = 2;      % time series missing years threshold 

% loop over states to processes station daily snow depth data
for istate = 1:length(fils)
    load(fils(istate).name);
    
    % list station IDs
    stations = who('U*');
    
    % loop over stations
    for istation = 1:length(stations)
        d = eval(stations{istation});
        SNWD = d.SNWD;
        SNWD_mm = SNWD.data;
        SNWD_2000_2016 = SNWD_mm(151:167,:);
        
        % calculate number of days per winter (Dec 1 through Apr 1) with 
        % snow depth > snwd_thresh, for years in which missing data 
        % is < data_thresh.
        for iyr = 1:length(yrs)-1
            onewinter = [SNWD_2000_2016(iyr,335:end)';SNWD_2000_2016(iyr+1,1:91)'];
            if (length(find(isnan(onewinter)))/length(onewinter))<data_thresh
                snwdays(iyr,istation)=length(find(onewinter>snwd_thresh));
            else
                snwdays(iyr,istation)=NaN;
            end
        end
        
    end
    
    % Eliminate stations for which missing years (NaN) is > yr_thresh
    remove = [];
    for istation = 1:length(stations)
        if length(find(isnan(snwdays(:,istation))))>yr_thresh
            remove = [remove;istation];
        else
            remove = remove;
        end
    end
    snwdays(:,remove)=[];
    
    % Calculate statewide average snowdays
    State_Snwdays(:,istate) = nanmean(snwdays,2);
    
    %Plot statewide average snowdays per winter, 2000-2016
        figure(istate); clf
        set(gcf,'Color','white')
        set(gca,'FontSize',20)
    
        % y-axis
        yrs2 = 2001:2016;
    
        % plot time series
        plot(yrs2,State_Snwdays(:,istate))
    
        % plot options
        xlabel('Year Dec-Mar')
        ylabel('Days with snow depth > 76.2 mm (3.0")')
        title(states(istate,:));
        text(2001,max(State_Snwdays(:,istate)),sprintf('n = %d ',length(snwdays(1,:))))
    
    % Rank statewide snow days, lowest to highest
    [rank, irank] = sort(State_Snwdays(:,istate));
    State_Rankings(:,istate) = yrs2(irank);
    
    % clean up
    clear stations d SNWD SNWD_mm SNWD_2000_2016 onewinter snwdays
    clear remove state_snwdays U*
    
end
    
       
            
            
            
    