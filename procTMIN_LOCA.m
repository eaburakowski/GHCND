%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% procTMIN_LOCA.m
%
% 2018-07-16
% EA Burakowski
% elizabeth.burakowski@gmail.com
%
% procTMIN.m loads state-level .mat files created using "GHCND_TMIN.m",
% which contain GHCND daily maximum temperature (in degC), 1979-2005. 
% The script does the following:
%   - calculates percent missing data per year or season
%   - removes years missing >10% of daily records
%   - creates individual .csv files of station time series (1979-2005) 
%     for the following TMIN-related metrics:
%       (1) annual and seasonal (DJF, MAM, JJA, and SON) tmin
%       (2) days < 32F
%       (3) days < 0F
%       (4) hottest night
%       (5) coldest night
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load the filtered GHCN-Daily meta data file (filtered to region of
% interest and for 1979-2016).
cd '/Users/zubeneschamali/Documents/Spring2018/LOCA/matlab/GHNCD_metadata';
load stationIDs_LOCA_TMIN.mat

% list all state.mat files in GHCND states directory
cd '/Users/zubeneschamali/Documents/Spring2018/LOCA/matlab/mat'
fils = dir('*1979*TMIN.mat');

% Some constants
years = (1850:2050)';   % full time series of ghcn daily files
yrstart = find(years==1979);
yrend = find(years==2005);  % can change to 2016 if desired. 
yrs = years(yrstart:yrend);
data_thresh = 0.10; % daily missing data threshold
yr_thresh = 2;      % time series missing years threshold 

% loop over states to processes station daily tmin data
for istate = 1:length(fils)
    
    % navigate to state-level directory
    cd '/Users/zubeneschamali/Documents/Spring2018/LOCA/matlab/mat/'
    
    load(fils(istate).name);
    
    % list station IDs
    stations = who('U*');
    
    % loop over stations
    for istation = 1:length(stations)
        d = eval(stations{istation});
        TMIN = d.TMIN;
        TMIN_C = TMIN.data;
        TMINC_1979_2005 = TMIN_C(yrstart:yrend,:);
        
        % calculate annual and seasonal TMIN, extreme temp metrics
        for iyr = 2:length(yrs)
            
            % Annual
            oneyear = TMINC_1979_2005(iyr,:);
            if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
                ann_tmin(iyr)=nanmean(oneyear);
            else
                ann_tmin(iyr)=NaN;
            end
            
            % Winter (Dec - Feb)
            onewinter = [TMINC_1979_2005(iyr-1,335:end)';TMINC_1979_2005(iyr,1:91)'];
            if (length(find(isnan(onewinter)))/length(onewinter))<data_thresh
                djf_tmin(iyr)=nanmean(onewinter);
            else
                djf_tmin(iyr)=NaN;
            end
            
            % Spring (Mar - May)
            onespring = TMINC_1979_2005(iyr,60:151);
            if (length(find(isnan(onespring)))/length(onespring))<data_thresh
                mam_tmin(iyr)=nanmean(onespring);
            else
                mam_tmin(iyr)=NaN;
            end
            
            % Summer (June - August)
            onesummer = TMINC_1979_2005(iyr,152:243);
            if (length(find(isnan(onesummer)))/length(onesummer))<data_thresh
                jja_tmin(iyr)=nanmean(onesummer);
            else
                jja_tmin(iyr)=NaN;
            end
            
            % Fall (Sept - Nov)
            onefall = TMINC_1979_2005(iyr,244:334);
            if (length(find(isnan(onefall)))/length(onefall))<data_thresh
                son_tmin(iyr)=nanmean(onefall);
            else
                son_tmin(iyr)=NaN;
            end
            
            % days > 90F
            if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
                d32F_tmin(iyr)=length(find(oneyear<0));
            else
                d32F_tmin(iyr)=NaN;
            end
            
            % days > 95F
            if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
                d0F_tmin(iyr)=length(find(oneyear<-17.8));
            else
                d0F_tmin(iyr)=NaN;
            end
            
            % hottest day
            if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
                hottestnight_tmin(iyr)=nanmax(oneyear);
            else
                hottestnight_tmin(iyr)=NaN;
            end
            
            % coldest day
            if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
                coldestnight_tmin(iyr)=nanmin(oneyear);
            else
                coldestnight_tmin(iyr)=NaN;
            end
            
        end     % years
        
        
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %
     % write station data to csv
     %
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % navigate to desired output directory
        cd /Users/zubeneschamali/Documents/Spring2018/LOCA/matlab/GHCND_csv/
        
        % Annual tmin
            % filename
            fn = char(strcat(stations(istation),'_ANN_TMIN_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','ANN_TMIN_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            ann_tmin = ann_tmin';
            dlmwrite(fn,[yrs(2:end),ann_tmin(2:end)],'-append');
            
        % Winter tmin
            % filename
            fn = char(strcat(stations(istation),'_Winter_TMIN_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','Winter_TMIN_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            djf_tmin = djf_tmin';
            dlmwrite(fn,[yrs(2:end),djf_tmin(2:end)],'-append');

        % Spring tmin
            % filename
            fn = char(strcat(stations(istation),'_Spring_TMIN_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','Spring_TMIN_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            mam_tmin = mam_tmin';
            dlmwrite(fn,[yrs(2:end),mam_tmin(2:end)],'-append');
            
        % Summer tmin
            % filename
            fn = char(strcat(stations(istation),'_Summer_TMIN_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','Summer_TMIN_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            jja_tmin = jja_tmin';
            dlmwrite(fn,[yrs(2:end),jja_tmin(2:end)],'-append');            
 
        % Fall tmin
            % filename
            fn = char(strcat(stations(istation),'_Fall_TMIN_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','Fall_TMIN_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            son_tmin = son_tmin';
            dlmwrite(fn,[yrs(2:end),son_tmin(2:end)],'-append');   
            
        % Days > 90F tmin
            % filename
            fn = char(strcat(stations(istation),'_ExtremeTemp_Days32F_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','d32F_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            d32F_tmin = d32F_tmin';
            dlmwrite(fn,[yrs(2:end),d32F_tmin(2:end)],'-append');     

       % Days > 90F tmin
            % filename
            fn = char(strcat(stations(istation),'_ExtremeTemp_Days0F_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','d0F_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            d0F_tmin = d0F_tmin';
            dlmwrite(fn,[yrs(2:end),d0F_tmin(2:end)],'-append');
        
       % Hottest Day tmin
            % filename
            fn = char(strcat(stations(istation),'_ExtremeTemp_HottestNight_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','HottestNight_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            hottestnight_tmin = hottestnight_tmin';
            dlmwrite(fn,[yrs(2:end),hottestnight_tmin(2:end)],'-append');

       % Coldest Day tmin
            % filename
            fn = char(strcat(stations(istation),'_ExtremeTemp_ColdestNight_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','ColdestNight_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            coldestnight_tmin = coldestnight_tmin';
            dlmwrite(fn,[yrs(2:end),coldestnight_tmin(2:end)],'-append');
            
        % clear temporary variables
        clear *_tmin
            
    end     % stations   
    
end  % states
    