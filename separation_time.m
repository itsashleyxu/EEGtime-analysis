% This script is for calculating the separation time for each participant
% The first folder you should open is the innermost folder that contains all
% matlab format processed ERP(TSE) files
% e.g. PilotAnalysis > TSE DATA > adult > All DA erp > DA1-5 ori_filt
% The second folder you should open is just wherever you want to save those
% numbers, you can just create a new folder wherever you like
% % When there is no separation in the data, no value will be returned
% % not sure what to do with the results yet so better figure it out soon

clear;
disp('Where are the data?')
datadir = uigetdir;

disp('Where do you want ot save the processed data?')
datasave = uigetdir;

folders = dir(datadir);
subjects = {folders.name};
subjects(ismember(subjects,{'.','..'})) = [];
erpfiles = ls(fullfile(datadir,'*mat'));

for i = 1:length(subjects)
    load(fullfile(datadir,erpfiles(i,:)),'ERPs');
    load(fullfile(datadir,erpfiles(i,:)),'t');
    temp_name = char(subjects{i});
    for j = 1:length(ERPs)
        TSEavg(i,j,:,:) = mean(ERPs{j}.rectifieddata,3);
    end
    
    A10_diff = TSEavg(i,3,10,:) - TSEavg(i,4,10,:);
    
    k = 103;
    while k <= 616
        l = 1;
        if A10_diff(k) >= 0.2
            for l = 1:100
                test_Adiff = A10_diff(k+l);
                if test_Adiff <= 0
                    break
                else continue
                end
            end
            if l == 100
                time_sep_A10 = t(k);
                assignin('base', [temp_name(1:end-4),'_time_A10'],time_sep_A10);
                clear time_sep_A10
                break
            else
                k = k + l; continue
            end
        end
        k = k + l;
    end
end 

for i = 1:length(subjects)
    load(fullfile(datadir,erpfiles(i,:)),'ERPs');
    load(fullfile(datadir,erpfiles(i,:)),'t');
    temp_name = char(subjects{i});
    for j = 1:length(ERPs)
        TSEavg(i,j,:,:) = mean(ERPs{j}.rectifieddata,3);
    end
    
    B7_diff = TSEavg(i,4,39,:) - TSEavg(i,3,39,:);
    
    k = 103;
    while k <= 616
        l = 1;
        if B7_diff(k) >= 0.2
            for l = 1:100
                test_Bdiff = B7_diff(k+l);
                if test_Bdiff <= 0
                    break
                else continue
                end
            end
            if l == 100
                time_sep_B7 = t(k);
                assignin('base', [temp_name(1:end-4),'_time_B7'],time_sep_B7);
                clear time_sep_B7
                break
            else
                k = k + l; continue
            end
        end
        k = k + l;
    end
end 

clear datadir
clear erpfiles
clear ERPs
clear folders
clear i
clear j
clear k
clear l
clear temp_name
clear A10_diff
clear B7_diff
clear test_Adiff
clear test_Bdiff
clear TSEavg
save(fullfile(datasave,'time_diff.mat'),'','-mat');