% Script to filter and epoch EEG data

function preprocess(datadir,chanlocs,nChans,captextfile,trigs,logicalepochs,virtual_trigs,des_trigs,logictype,preserve_data,pristine_chans,epoch_window,baseline_period,thresh,fs)

% Define ERP parameters %THESE SHOULD BE DETERMINED FROM DATA STRUCT OR
% USER SHOULD BE PROMPTED
thrMin = -100;
thrMax = 500;

%Define filter parameters
%TSE 4th order parameter
% FstopH = 2;
% FpassH = 8;
% AstopH = 50;
% FpassL = 14;
% FstopL = 24;
% AstopL = 25; 
% Apass = 1;

% TSE Original parameter
% FstopH = 2;
% FpassH = 8;
% AstopH = 65;
% FpassL = 14;
% FstopL = 24;
% AstopL = 65; 
% Apass = 1;

% ERP parameter 0.1hz
FstopH = 0.025;
FpassH = 0.1;
AstopH = 65;
FpassL = 45;
FstopL = 60;
AstopL = 65; 
Apass = 1;

% ERP parameter for ICA 1hz
% FstopH = 0.25;
% FpassH = 1;
% AstopH = 65;
% FpassL = 45;
% FstopL = 60;
% AstopL = 65; 
% Apass = 1;

% Generate high/low-pass filters
h = fdesign.highpass(FstopH,FpassH,AstopH,Apass,fs);
hpf = design(h,'cheby2','MatchExactly','stopband'); clear h
h = fdesign.lowpass(FpassL,FstopL,Apass,AstopL,fs);
lpf = design(h,'cheby2','MatchExactly','stopband'); clear h

%Give filter responses so we can see performance

% Find 6 nearest channels to each channel
[~,nearMat] = getnearest(captextfile,nChans,6);
nearCell = cell(1,nChans);
for i = 1:nChans
    nearCell{i} = nearMat(i,:);
end

blmin = baseline_period(1);
blmax = baseline_period(2);

% Get all subject IDs
folders = dir(datadir);
subjects = {folders([folders(:).isdir]).name};
subjects(ismember(subjects,{'.','..'})) = [];

for i = 1:length(subjects)
    if exist(fullfile(datadir,subjects{i},[subjects{i},'_mat']),'dir')
        if exist(fullfile(datadir,subjects{i},[subjects{i},'_erp']),'dir') == 0
            disp(['Now Preprocessing dataset contained in ' subjects{i} '_mat'])
            %if isempty(ls(fullfile(datadir,subjects{i},[subjects{i},'_erp'],'*mat')));
            
            % Create new subject folder
            mkdir(fullfile(datadir,subjects{i},[subjects{i},'_erp']));
            
            % Load MAT files
            load(fullfile(datadir,subjects{i},[subjects{i},'_mat'],[subjects{i},'.mat']));
            
            alloriginaldata = EEG.data;
            EEG.data = double(EEG.data); 
            
            % Filter EEG
            disp('Filtering EEG...');
            EEG.data = filtfilthd(hpf,EEG.data');
            disp('Filtering halfway complete');
            EEG.data = filtfilthd(lpf,EEG.data)';
            disp('Done Filtering...');
            % Remove external channels
            
            EEG.data = EEG.data(1:nChans,:);
            EEG.nbchan = nChans;
            disp('Finding bad channels...');
            % Find bad channels based on XCORR and SD
            badChans = findBadChans(EEG.data',nearCell,3,3);
            
            % Spline interpolate bad channels
            if ~isempty(badChans)
                EEG = pop_interp(EEG,badChans,'spherical');
            end
            % Re-refernece to average of all channels
            EEG = pop_reref(EEG,[],'exclude',nChans+1:size(EEG.data,1));
            
            if preserve_data == 1
                for k = 1:length(pristine_chans)
                    EEG.data(nChans+k,:) = alloriginaldata(pristine_chans(k),:);
                end
                EEG.nbchan = EEG.nbchan+length(pristine_chans);
            end
            
            
            % Apply ICA here
            
            
            EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString' ,{ 'boundary' } );
            maxVals = [];
            ERPs = cell(numel(trigs),1);
            for j = 1:numel(trigs)
                try
                    % Extract epochs for each condition
                    [ERPs{j}, Iepochs{j}] = pop_epoch(EEG,trigs(j),[epoch_window(1)/1e3,epoch_window(2)/1e3]);
                    % Calculate max/min values of epochs
                    maxVals = [maxVals;squeeze(max(max(abs(ERPs{j}.data(1:nChans,1:308,:)))))];
                catch
                    disp(['Error in pop_epoch. Likely that no triggers were found for trigger ' trigs(j) '. Creating empty cell in ERPs array']);
                    ERPs{j} = {};
                end
            end
            
            if logicalepochs == 1
                nvtrigs = numel(virtual_trigs);
                p = 1;
                for j = numel(trigs)+1:numel(trigs)+nvtrigs
                    [trig_idxs, epoch2] = logicalTrigs(EEG,logictype,des_trigs{p});
                    if isempty(trig_idxs)
                        fprintf('No epochs found for trigger pair %s %s \n',des_trigs{p}{1},des_trigs{p}{2});
                        ERPs{j} = {};
                    else
                        [ERPs{j}, Iepochs{j}] = pop_epoch(EEG,epoch2,[epoch_window(1)/1e3,epoch_window(2)/1e3],'eventindices',trig_idxs);
                        ERPs{j}.condition = virtual_trigs{p};
                    end
                    p = p + 1;
                end
            else
                nvtrigs = 0;
            end
            
            % Get rid of outliers above threshold 1 (150 uV)
            maxVals(maxVals>thresh) = [];
            
            % Set threshold 2 based on normal distribution of max/min values
            thr2 = mean(maxVals) + 2*std(maxVals);
        
            
            % Rejection epochs above threshold
            for j = 1:numel(trigs)+nvtrigs
                if ~isempty(ERPs{j})
%                     [ERPs{j}, Ireject{j}] = pop_artmwppth(ERPs{j},'Channel',  1:128, 'Flag',  1, 'Threshold',...
%                         150, 'Twindow', [ -200 1200], 'Windowsize',  200, 'Windowstep',100 );
                     [ERPs{j}, Ireject{j}] = pop_eegthresh(ERPs{j},1,1:nChans,-thr2,thr2,thrMin/1e3,thrMax/1e3,0,1);
                    ERPs{j} = pop_rmbase(ERPs{j},[blmin,blmax]);
                    percentRej(j) = length(Ireject{j})/length(Iepochs{j});
                    % Taking the absolute value to rectify data
                    ERPs{j}.rectifieddata = abs(ERPs{j}.data);
                end
            end
            
            fail = 1;
            k = 1;
            while fail
                try
                    t = ERPs{k}.times;
                    fs = ERPs{k}.srate;
                    fail = 0;
                catch
                    fail = 1;
                    k = k + 1;
                end
            end
            
            % Save in MAT files
            disp('Saving data to mat file...');)
            save(fullfile(datadir,subjects{i},[subjects{i},'_erp'],[subjects{i},'.mat']),'ERPs','Iepochs','badChans','Ireject','t','fs','alloriginaldata','-mat');
            clear files EEG ERPs maxVals thr2 RTs ERPavg t alloriginaldata fs
            disp('Processing completed!')
        else 
            disp(['Folder ' subjects{i} '_erp' ' already exists. Delete this folder to re-preprocess']);',
        end
    else
        disp(['Folder with mat file for ' subjects{i} ' does not exist']);
    end
end
