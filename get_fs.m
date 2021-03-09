files = dir('data\*.csv');
files = {files.name};

all_fs = NaN(1,length(files));
all_yrsmusic = NaN(1,length(files));
for f=1:length(files)
    f
    
    [tmp,~,~] = xlsread(['data\' files{f}],'E2:F2');
    all_yrsmusic(f) = tmp(1);
    all_fs(f) = tmp(2);
end

