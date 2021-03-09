% reads the csv files and saves each one as a mat file

files = dir('data\last several subjects\*.csv');
files = {files.name};

dest = 'C:\Users\Joselyn\Documents\pitchdiffrove data\DataMatFiles\';

for f=1:length(files)
    data = xlsread(['data\last several subjects\' files{f}],'H2:S551');
    fname = files{f}(1:10);
    if(~exist([dest fname '.mat'],'file'))
        save([dest fname '.mat'],'data');
    end
end

%% columns
% 1: task
% 2: trial num
% 3: trial type
% 4-5: frequencies of the tones
% 6: response
% 7: whether correct
% 8-11: staircase stuff
% 12: pitch difference in semitones, but it is safer to calculate based off
% col 4-5 because there are some errors

%% task
% 1: tone scramble task
% 2: PD Gap 0.5
% 3: PD Gap 1
% 4: PD Fixed
% 5: PD Same-Different