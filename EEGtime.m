% Hello. This is the master of a set of scripts to allow for a relatively
% rapid analysis of EEG data using a combination of EEGlab and custom
% scripts
% The foler you should open up is the one that contains all individual
% folders for each participant
% e.g. PilotAnalysis > TSE DATA > adult > DA
clear;
clc;
% Which recording system was used?
platform = 'biosemi'; %Acceptable inputs are ('biosemi','ANTeego')
% How many channels???
nchans = 128;
% What was your sampling rate??
fs = 512;
% Shall we filter? (The answer should be yes)
tofilter = 1; %1 is yes, 0 is no
% Use standard filter settings? Or Make your own?
customfilter = 0; % 1 is yes, 0 is no

% Do you want epochs?
toepoch = 1;
% Which trigger values would you like epochs for?
trigs = {'21' '22' };
%trigs = {'3' '5' '7' '9' '11' '13'};
% How long do you want your epochs to be?
epoch_window = [-200 1200];
% What period would you like to use to baseline your epochs?
baseline_period = [-150 0];

% Do you want to epoch around triggers with LOGIC???
logicalepochs = 1;
% Go ahead and create some trigger values to represent your desired events
%virtual_trigs = {'61','62','63','64'};
virtual_trigs = {'61','62'};
% Which trigger pairs do you want to epoch around?
    %des_trigs = {{'21' '50' '10'},{'21' '50' '11'},{'22','50','10'},{'22','50','11'}};
des_trigs = {{'21' '11' '10'},{'22' '11' '10'}};
% Which logical operation would you like to use for logical trigs? 
%Current acceptable values are; 'pairs_epoch2second', 'pairs_epoch2first'
%logictype = 'bridgepairs_epoch2first';
logictype = 'deafvisioncustom'; 

% Would you like to preserve specific channels from being filtered and rejected?
preserve_data = 0;
% Which channels would you like to keep in a "RAW" state? (Based on
% location in original data structure).
pristine_chans = [73, 74, 75];

% Artifact rejection parameters
% Trial rejection, max value threshold
thresh = 150;

rootdir = uigetdir;

[chanlocs, captextfile] = paramloader(platform,nchans);
bdf2mat(rootdir,chanlocs);

preprocess(rootdir,chanlocs,nchans,captextfile,trigs,logicalepochs,virtual_trigs,des_trigs,logictype,preserve_data,pristine_chans,epoch_window,baseline_period,thresh,fs);


