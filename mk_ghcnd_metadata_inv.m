% Modified from the Matlab Spring Indices code provided by Ault et al. 2015
% https://www.mathworks.com/matlabcentral/fileexchange/54679-extended-spring-indices--si-x--code

ghcnd_metadata_filename='ghcnd_inventory';
ghcnd_metadata_dir='/Users/Antares/Documents/Data/GHCN_Daily/GHCND_2017/';
source_file='ghcnd-inventory.txt';


% IV. FORMAT OF "ghcnd-inventory.txt"
% 
% ------------------------------
% Variable   Columns   Type
% ------------------------------
% ID            1-11   Character
% LATITUDE     13-20   Real
% LONGITUDE    22-30   Real
% VARIABLE     31-35   Character
% YEAR START   36-40   Character
% YEAR END     41-45   Character
% ------------------------------
%( see readme.txt file)

nrows=595663;
IDq=1:11;
LATq=13:20;
LONq=22:30;
VARq=31:35;
YRSTARTq=36:40;
YRENDq=41:45;

fid=fopen(source_file);
k=1;
%ACW00011604  17.1167  -61.7833 TMAX 1949 1949
while k<=nrows
    aline=fgetl(fid);
    if ~ischar(aline)
        break
    end
    bline=char(aline);
    AllTXT{k,1}=bline;
    ID(k,:)=bline(IDq);
    LATITUDE(k,1)=str2num(bline(LATq));
    LONGITUDE(k,1)=str2num(bline(LONq));
    VARIABLE{k,1}=bline(VARq);
    YEARSTART(k,1)=str2num(bline(YRSTARTq));
    YEAREND(k,1)=str2num(bline(YRENDq));
    
    k=k+1;
    
end
fclose(fid);

ghcnd_inventory.source_file=source_file;
ghcnd_inventory.creation_date=date; 
ghcnd_inventory.creation_script=mfilename('fullpath');  
ghcnd_inventory.created_by=getenv('USER');     
ghcnd_inventory.ID=ID;
ghcnd_inventory.lon=LONGITUDE;
ghcnd_inventory.lat=LATITUDE;
ghcnd_inventory.variable=VARIABLE;
ghcnd_inventory.yearstart=YEARSTART;
ghcnd_inventory.yearend=YEAREND;

%
%save ../data/ghcnd_metadata ghcnd_metadata
save([ghcnd_metadata_dir ghcnd_metadata_filename],'ghcnd_inventory')
