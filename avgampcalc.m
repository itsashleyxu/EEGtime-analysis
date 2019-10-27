% Not finished yet
% Do not use this script

disp('Where are the ERPs you want to open?')
datadir = uigetdir;

folders = dir(datadir);
subjects = {folders.name};
subjects(ismember(subjects,{'.','..'})) = [];

erpfiles = ls(fullfile(datadir,'*mat'));
erpname = {subjects};


for i = 1:length(subjects)
    load(fullfile(datadir,erpfiles(i,:)),'ERPs');
    load(fullfile(datadir,erpfiles(i,:)),'t');
    for j = 1:length(ERPs)
        ERPavg(i,j,:,:) = mean(ERPs{j}.data,3);
        TSEavg(i,j,:,:) = mean(ERPs{j}.rectifieddata,3);
        t = t;
            
    end
    clear ERPs
end

for k = 1:length(subjects)
    
    temp_A10_left = squeeze(TSEavg(k,3,10,:));
    temp_A10_right = squeeze(TSEavg(k,4,10,:));
    temp_A9_left = squeeze(TSEavg(k,3,9,:));
    temp_A9_right = squeeze(TSEavg(k,4,9,:));
    temp_B7_left = squeeze(TSEavg(k,3,39,:));
    temp_B7_right = squeeze(TSEavg(k,4,39,:));
    temp_B6_left = squeeze(TSEavg(k,3,38,:));
    temp_B6_right = squeeze(TSEavg(k,4,38,:));
    temp_A9_10_left = (squeeze(TSEavg(k,3,10,:)) + squeeze(TSEavg(k,3,9,:)))/2;
    temp_A9_10_right = (squeeze(TSEavg(k,4,10,:)) + squeeze(TSEavg(k,4,9,:)))/2;
    temp_B6_7_left = (squeeze(TSEavg(k,3,39,:)) + squeeze(TSEavg(k,3,38,:)))/2;
    temp_B6_7_right = (squeeze(TSEavg(k,4,39,:)) + squeeze(TSEavg(k,4,38,:)))/2;
    A9_10_diff = temp_A9_10_left - temp_A9_10_right;
    B6_7_diff = temp_B6_7_right - temp_B6_7_left;
    A9_10_diff_400_500ms = mean(A9_10_diff(308:359));
    B6_7_diff_400_500ms = mean(B6_7_diff(308:359));
    A9_10_diff_500_600ms = mean(A9_10_diff(359:411));
    B6_7_diff_500_600ms = mean(B6_7_diff(359:411));
    A9_10_diff_600_700ms = mean(A9_10_diff(411:462));
    B6_7_diff_600_700ms = mean(B6_7_diff(411:462));
    A9_10_diff_700_800ms = mean(A9_10_diff(462:513));
    B6_7_diff_700_800ms = mean(B6_7_diff(462:513));
    A9_10_diff_800_900ms = mean(A9_10_diff(513:564));
    B6_7_diff_800_900ms = mean(B6_7_diff(513:564));
    A9_10_diff_900_1000ms = mean(A9_10_diff(564:615));
    B6_7_diff_900_1000ms = mean(B6_7_diff(564:615));
    temp_name = char(erpname{1}(k));
    
    assignin('base', [temp_name(1:end-4),'_A9_10_diff'],A9_10_diff);
    assignin('base', [temp_name(1:end-4),'_B6_7_diff'],B6_7_diff);
    assignin('base', [temp_name(1:end-4),'A9_10_diff_600_800ms'],A9_10_diff_600_800ms);
    assignin('base', [temp_name(1:end-4),'B6_7_diff_600_800ms'],B6_7_diff_600_800ms);
    
    clear temp_A9_left
    clear temp_A9_right
    clear temp_A10_left
    clear temp_A10_right
    clear temp_B6_left
    clear temp_B6_right
    clear temp_B7_left
    clear temp_B7_right
    clear temp_A9_10_left
    clear temp_A9_10_right
    clear temp_B6_7_left
    clear temp_B6_7_right
    clear A9_10_diff
    clear B6_7_diff
    clear A9_10_diff_600_800ms
    clear B6_7_diff_600_800ms
    clear temp_name
end
clear i
clear j
clear k
disp('Completed!')