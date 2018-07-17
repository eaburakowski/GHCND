%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% procPRCP_LOCA.m
%
% 2018-07-16
% EA Burakowski
% elizabeth.burakowski@gmail.com
%
% procPRCP.m loads state-level .mat files created using "GHCND_PRCP.m",
% which contain GHCND daily precipitation (in degC), 1979-2005. 
% The script does the following:
%   - calculates percent missing data per year or season
%   - removes years missing >10% of daily records
%   - creates individual .csv files of station time series (1979-2005) 
%     for the following PRCP-related metrics:
%       (1) annual and seasonal (DJF, MAM, JJA, and SON) prcp
%       (2) days > 1in
%       (3) days > 2in
%       (4) wetest day
%       (5) 2-day events > 4"
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load the filtered GHCN-Daily meta data file (filtered to region of
% interest and for 1979-2016).
cd '/Users/zubeneschamali/Documents/Spring2018/LOCA/matlab/GHNCD_metadata';
load stationIDs_LOCA_PRCP.mat

% list all state.mat files in GHCND states directory
cd /Users/zubeneschamali/Documents/Spring2018/LOCA/matlab/mat/
fils = dir('*1979*PRCP.mat');

% Some constants
years = (1850:2050)';   % full time series of ghcn daily files
yrstart = find(years==1979);
yrend = find(years==2005);  % can change to 2016 if desired. 
yrs = years(yrstart:yrend);
data_thresh = 0.10; % daily missing data threshold
yr_thresh = 2;      % time series missing years threshold 

% loop over states to processes station daily prcp data
for istate = 1:length(fils)
    
    % navigate to state-level directory
    cd /Users/zubeneschamali/Documents/Spring2018/LOCA/matlab/mat/
    
    load(fils(istate).name);
    
    % list station IDs
    stations = who('U*');
    
    % loop over stations
    for istation = 1:length(stations)
        d = eval(stations{istation});
        PRCP = d.PRCP;
        PRCP_C = PRCP.data;
        PRCPC_1979_2005 = PRCP_C(yrstart:yrend,:);
        
        % calculate annual and seasonal PRCP, extreme temp metrics
        for iyr = 2:length(yrs)
            
            % Annual
            oneyear = PRCPC_1979_2005(iyr,:);
            if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
                ann_prcp(iyr)=nansum(oneyear);
            else
                ann_prcp(iyr)=NaN;
            end
            
            % Winter (Dec - Feb)
            onewinter = [PRCPC_1979_2005(iyr-1,335:end)';PRCPC_1979_2005(iyr,1:91)'];
            if (length(find(isnan(onewinter)))/length(onewinter))<data_thresh
                djf_prcp(iyr)=nansum(onewinter);
            else
                djf_prcp(iyr)=NaN;
            end
            
            % Spring (Mar - May)
            onespring = PRCPC_1979_2005(iyr,60:151);
            if (length(find(isnan(onespring)))/length(onespring))<data_thresh
                mam_prcp(iyr)=nansum(onespring);
            else
                mam_prcp(iyr)=NaN;
            end
            
            % Summer (June - August)
            onesummer = PRCPC_1979_2005(iyr,152:243);
            if (length(find(isnan(onesummer)))/length(onesummer))<data_thresh
                jja_prcp(iyr)=nansum(onesummer);
            else
                jja_prcp(iyr)=NaN;
            end
            
            % Fall (Sept - Nov)
            onefall = PRCPC_1979_2005(iyr,244:334);
            if (length(find(isnan(onefall)))/length(onefall))<data_thresh
                son_prcp(iyr)=nansum(onefall);
            else
                son_prcp(iyr)=NaN;
            end
            
            % days > 1in
            if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
                d1in_prcp(iyr)=length(find(oneyear>25.4));
            else
                d1in_prcp(iyr)=NaN;
            end
            
            % days > 2in
            if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
                d2in_prcp(iyr)=length(find(oneyear>50.8));
            else
                d2in_prcp(iyr)=NaN;
            end
            
            % wettest day
            if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
                wettestday_prcp(iyr)=nanmax(oneyear);
            else
                wettestday_prcp(iyr)=NaN;
            end
            
%             % 2-day events > 4"
%             if (length(find(isnan(oneyear)))/length(oneyear))<data_thresh
%                 events4in_prcp(iyr)=nanmin(oneyear);
%             else
%                 events4in_prcp(iyr)=NaN;
%             end
            
        end     % years
        
        
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %
     % write station data to csv
     %
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % navigate to desired output directory
        cd /Users/zubeneschamali/Documents/Spring2018/LOCA/matlab/GHCND_csv/
        
        % Annual prcp
            % filename
            fn = char(strcat(stations(istation),'_ANN_PRCP_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','ANN_PRCP_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            ann_prcp = ann_prcp';
            dlmwrite(fn,[yrs(2:end),ann_prcp(2:end)],'-append');
            
        % Winter prcp
            % filename
            fn = char(strcat(stations(istation),'_Winter_PRCP_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','Winter_PRCP_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            djf_prcp = djf_prcp';
            dlmwrite(fn,[yrs(2:end),djf_prcp(2:end)],'-append');

        % Spring prcp
            % filename
            fn = char(strcat(stations(istation),'_Spring_PRCP_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','Spring_PRCP_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            mam_prcp = mam_prcp';
            dlmwrite(fn,[yrs(2:end),mam_prcp(2:end)],'-append');
            
        % Summer prcp
            % filename
            fn = char(strcat(stations(istation),'_Summer_PRCP_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','Summer_PRCP_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            jja_prcp = jja_prcp';
            dlmwrite(fn,[yrs(2:end),jja_prcp(2:end)],'-append');            
 
        % Fall prcp
            % filename
            fn = char(strcat(stations(istation),'_Fall_PRCP_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','Fall_PRCP_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            son_prcp = son_prcp';
            dlmwrite(fn,[yrs(2:end),son_prcp(2:end)],'-append');   
            
        % Days > 92in prcp
            % filename
            fn = char(strcat(stations(istation),'_ExtremePrecip_Days1in_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','d1in_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            d1in_prcp = d1in_prcp';
            dlmwrite(fn,[yrs(2:end),d1in_prcp(2:end)],'-append');     

       % Days > 92in prcp
            % filename
            fn = char(strcat(stations(istation),'_ExtremePrecip_Days2in_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','d2in_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            d2in_prcp = d2in_prcp';
            dlmwrite(fn,[yrs(2:end),d2in_prcp(2:end)],'-append');
        
       % Hottest Day prcp
            % filename
            fn = char(strcat(stations(istation),'_ExtremePrecip_WettestDay_1979-2005_timeseries.csv'));
            
            % header information
            Header = {'Year','WettestDay_ghcnd'};
            tHeader = strjoin(Header,',');
        
            % write header to .csv
            fid = fopen(fn,'w');
            fprintf(fid,'%s\n',tHeader);
            fclose(fid);
            
            % write data to end of file
            wettestday_prcp = wettestday_prcp';
            dlmwrite(fn,[yrs(2:end),wettestday_prcp(2:end)],'-append');

%        % 2-day events > 4"
%             % filename
%             fn = char(strcat(stations(istation),'_ExtremePrecip_Events4in_1979-2005_timeseries.csv'));
%             
%             % header information
%             Header = {'Year','Events4in_ghcnd'};
%             tHeader = strjoin(Header,',');
%         
%             % write header to .csv
%             fid = fopen(fn,'w');
%             fprintf(fid,'%s\n',tHeader);
%             fclose(fid);
%             
%             % write data to end of file
%             events4in_prcp = events4in_prcp';
%             dlmwrite(fn,[yrs(2:end),events4in_prcp(2:end)],'-append');
            
        % clear temporary variables
        clear *_prcp
            
    end     % stations   
    
end  % states
    