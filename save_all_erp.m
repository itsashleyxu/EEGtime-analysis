% This script is for saving all erp files in individual folders to one
% folder
% For the first pop-up window you should choose the folder that 
% contains all individual folders for each participant
% e.g. PilotAnalysis > TSE DATA > adult > DA
% For the second pop-up window you should choose the innermost folder that
% contains all matlab format processed ERP(TSE) files
% e.g. PilotAnalysis > TSE DATA > adult > All DA erp > DA1-5 ori_filt (you 
% should create this folder beforehand)
disp('Where are the files you want to copy?')
datadir = uigetdir;
disp('Where do you want them to be saved?')
savedestin = uigetdir;

folders = dir(datadir);
subjects = {folders([folders(:).isdir]).name};
subjects(ismember(subjects,{'.','..'})) = [];
disp('Save all ERPs to one folder...');

for i = 1:length(subjects)
    
    erpfiles = ls(fullfile(datadir,subjects{i},[subjects{i},'_1hz'],'*mat'));
    
     if ~isempty(erpfiles)
         if exist(fullfile(savedestin,[subjects{i},'.mat']),'file') == 0
             disp(['Copying ' subjects{i}]);
             copyfile(fullfile(datadir,subjects{i},[subjects{i},'_1hz'],'*mat'), savedestin, 'f');
             disp(['Complete copying ' subjects{i} 'erp file']);    
   
         else 
             disp(['Participant ' subjects{i} ' already copied!']);
         end 
     end
end 
disp('Saving completed!')