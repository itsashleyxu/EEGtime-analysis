% This script is for calculating the grand average for all participants 
% The folder you should open is the innermost folder that contains all
% matlab format processed ERP(TSE) files
% e.g. PilotAnalysis > TSE DATA > adult > All DA erp > DA1-5 ori_filt
% Returns the grand average for both ERP and TSE data

disp('Where are the ERP files you want to average?')
datadir = uigetdir;

folders = dir(datadir);
subjects = {folders.name};
subjects(ismember(subjects,{'.','..'})) = [];

erpfiles = ls(fullfile(datadir,'*mat'));

ERPavg = [];
TSEavg = [];
for i = 1:length(subjects)
    load(fullfile(datadir,erpfiles(i,:)),'ERPs');
    load(fullfile(datadir,erpfiles(i,:)),'t');
    for j = 1:length(ERPs)
        ERPavg(i,j,:,:) = mean(ERPs{j}.data,3);
%         TSEavg(i,j,:,:) = mean(ERPs{j}.rectifieddata,3);
        t = t;
    end
    clear ERPs
end 
GrandAvgERP = squeeze(mean(ERPavg,1));
% GrandAvgTSE = squeeze(mean(TSEavg,1));
Stderror = squeeze(std(ERPavg,1))/sqrt(length(subjects));

disp('Averaging completed!')