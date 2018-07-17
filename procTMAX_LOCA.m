%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% procTMAX_LOCA.m
%
% 2018-07-16
% EA Burakowski
% elizabeth.burakowski@gmail.com
%
% procTMAX.m loads state-level .mat files created using "GHCND_TMAX.m",
% which contain GHCND daily maximum temperature (in degC), 1979-2005. 
% The script does the following:
%   - calculates percent missing data per year or season
%   - removes years missing >10% of daily records
%   - creates individual .csv files of station time series (1979-2005) 
%     for the following TMAX-related metrics:
%       (1) annual and seasonal (DJF, MAM, JJA, and SON) tmax
%       (2) days > 90F
%       (3) days < 95F
%       (4) hottest day
%       (5) coldest day
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load the filtered GHCN-Daily meta data file (filtered to region of
% interest and for 1979-2016).
cd '/Users/zubeneschamali/Documents/Spring2018/LOCA/matlab/GHNCD_metadata/';
load stationIDs_LOCA_TMAX.mat

% list all state.mat files in GHCND states directory
cd '/Users/zubeneschamali/Documents/Spring2018/LOCA/matlab/mat/'
fils = dir('*1979*TMAX_TMIN.mat');

% Some constants
years = (1850:2050)';   % full time series of ghcn daily files
yrstart = find(years==1979);
yrend = find(years==2005);  % can change to 2016 if desired. 
yrs = years(yrstart:yrend);
data_thresh = 0.10; % daily missing data threshold
yr_thresh = 2;      % time series missing years threshold 

% loop over states to processes station daily tmax data
for istate = 1:length(fils)
    
    % navigate to state-level directory
    cd '/Users/zubeneschamali/Documents/Spring2018/LOCA/matlab/mat/'
    
    load(fils(istate).name);
    
    % list station IDs
    stations = who('U*');
    
    % loop over stations
    for istation = 1:length(stations)
        d = eval(stations{istation});
        TMAX = d.TMAX;
        TMAX_C = TMAX.data;
        TMAXC_1979_2005 = TMAX_C(yrstart:yrend,:);
        
        % calculate annual and seasonal TMAX, extreme temp metrics
        for iyr = 2:length(yrs)
            
            % Annual
            oneyear = TMAXC_1979_2005(iyr,:);
            if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
                ann_tmax(iyr)=nanmean(oneyear);
            else
                ann_tmax(iyr)=NaN;
            end
            
            % Winter (Dec - Feb)
            onewinter = [TMAXC_1979_2005(iyr-1,335:end)';TMAXC_1979_2005(iyr,1:91)'];
            if (length(find(isnan(onewinter)))/length(onewinter))<data_thresh
                djf_tmax(iyr)=nanmean(onewinter);
            else
                djf_tmax(iyr)=NaN;
            end
            
            % Spring (Mar - May)
            onespring = TMAXC_1979_2005(iyr,60:151);
            if (length(find(isnan(onespring)))/length(onespring))<data_thresh
                mam_tmax(iyr)=nanmean(onespring);
            else
                mam_tmax(iyr)=NaN;
            end
            
            % Summer (June - August)
            onesummer = TMAXC_1979_2005(iyr,152:243);
            if (length(find(isnan(onesummer)))/length(onesummer))<data_thresh
                jja_tmax(iyr)=nanmean(onesummer);
            else
                jja_tmax(iyr)=NaN;
            end
            
            % Fall (Sept - Nov)
            onefall = TMAXC_1979_2005(iyr,244:334);
            if (length(find(isnan(onefall)))/length(onefall))<data_thresh
                son_tmax(iyr)=nanmean(onefall);
            else
                son_tmax(iyr)=NaN;
            end
            
            % days > 90F
            if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
                d90F_tmax(iyr)=length(find(oneyear>32.2));
            else
                d90F_tmax(iyr)=NaN;
            end
            
            % days > 95F
            if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
                d95F_tmax(iyr)=length(find(oneyear>35));
            else
                d95F_tmax(iyr)=NaN;
            end
            
            % hottest day
            if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
                hottestday_tmax(iyr)=nanmax(oneyear);
            else
                hottestday_tmax(iyr)=NaN;
            end
            
            % coldest day
            if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
                coldestday_tmax(iyr)=nanmin(oneyear);
            else
                coldestday_tmax(iyr)=NaN;
            end
            
        end     % years
        
        
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %
     % write station data to csv
     %
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % navigate to desired output directory
        cd /Users/zubeneschamali/Documents/Spring2018/LOCA/matlab/GHCND_csv/
        
        % Annual tmax
            % filename
            fn = char(strcat(stations(istation),'_ANN_TMAX_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','ANN_TMAX_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            ann_tmax = ann_tmax';
            dlmwrite(fn,[yrs(2:end),ann_tmax(2:end)],'-append');
            
        % Winter tmax
            % filename
            fn = char(strcat(stations(istation),'_Winter_TMAX_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','Winter_TMAX_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            djf_tmax = djf_tmax';
            dlmwrite(fn,[yrs(2:end),djf_tmax(2:end)],'-append');

        % Spring tmax
            % filename
            fn = char(strcat(stations(istation),'_Spring_TMAX_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','Spring_TMAX_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            mam_tmax = mam_tmax';
            dlmwrite(fn,[yrs(2:end),mam_tmax(2:end)],'-append');
            
        % Summer tmax
            % filename
            fn = char(strcat(stations(istation),'_Summer_TMAX_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','Summer_TMAX_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            jja_tmax = jja_tmax';
            dlmwrite(fn,[yrs(2:end),jja_tmax(2:end)],'-append');            
 
        % Fall tmax
            % filename
            fn = char(strcat(stations(istation),'_Fall_TMAX_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','Fall_TMAX_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            son_tmax = son_tmax';
            dlmwrite(fn,[yrs(2:end),son_tmax(2:end)],'-append');   
            
        % Days > 90F tmax
            % filename
            fn = char(strcat(stations(istation),'_ExtremeTemp_Days90F_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','d90F_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            d90F_tmax = d90F_tmax';
            dlmwrite(fn,[yrs(2:end),d90F_tmax(2:end)],'-append');     

       % Days > 90F tmax
            % filename
            fn = char(strcat(stations(istation),'_ExtremeTemp_Days95F_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','d95F_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            d95F_tmax = d95F_tmax';
            dlmwrite(fn,[yrs(2:end),d95F_tmax(2:end)],'-append');
        
       % Hottest Day tmax
            % filename
            fn = char(strcat(stations(istation),'_ExtremeTemp_HottestDay_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','HottestDay_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            hottestday_tmax = hottestday_tmax';
            dlmwrite(fn,[yrs(2:end),hottestday_tmax(2:end)],'-append');

       % Coldest Day tmax
            % filename
            fn = char(strcat(stations(istation),'_ExtremeTemp_ColdestDay_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','ColdestDay_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            coldestday_tmax = coldestday_tmax';
            dlmwrite(fn,[yrs(2:end),coldestday_tmax(2:end)],'-append');
            
        % clear temporary variables
        clear *_tmax
            
    end     % stations   
    
end  % states
    