% This script is for opening up all the individual data in the workspace at
% once
% Workspace variables will have all participants' A9,10,B6,7 and their
% differences, and also the average of A9,10 and B6,7
% I've written this before, not much of a use now
% The folder you should open is the innermost folder that contains all
% matlab format processed ERP(TSE) files
% e.g. PilotAnalysis > TSE DATA > adult > All DA erp > DA1-5 ori_filt

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
    temp_name = char(erpname{1}(k));
    assignin('base', [temp_name(1:end-4),'_A10_left'],temp_A10_left);
    assignin('base', [temp_name(1:end-4),'_A10_right'],temp_A10_right);
    assignin('base', [temp_name(1:end-4),'_A9_left'],temp_A9_left);
    assignin('base', [temp_name(1:end-4),'_A9_right'],temp_A9_right);
    assignin('base', [temp_name(1:end-4),'_B7_left'],temp_B7_left);
    assignin('base',[temp_name(1:end-4),'_B7_right'],temp_B7_right);
    assignin('base', [temp_name(1:end-4),'_B6_left'],temp_B6_left);
    assignin('base',[temp_name(1:end-4),'_B6_right'],temp_B6_right);
    assignin('base', [temp_name(1:end-4),'_A10_diff'],temp_A10_left-temp_A10_right);
    assignin('base',[temp_name(1:end-4),'_B7_diff'],temp_B7_right-temp_B7_left);
    assignin('base', [temp_name(1:end-4),'_A9_diff'],temp_A9_left-temp_A9_right);
    assignin('base',[temp_name(1:end-4),'_B6_diff'],temp_B6_right-temp_B6_left);
    assignin('base',['avg',temp_name(1:end-4),'_A9_10_left'],temp_A9_10_left);
    assignin('base',['avg',temp_name(1:end-4),'_A9_10_right'],temp_A9_10_right);
    assignin('base',['avg',temp_name(1:end-4),'_B6_7_left'],temp_B6_7_left);
    assignin('base',['avg',temp_name(1:end-4),'_B6_7_right'],temp_B6_7_right);
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
    clear temp_name
end
clear i
clear j
clear k
disp('Completed!')