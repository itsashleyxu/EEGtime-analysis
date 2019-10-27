function [chanlocs, captextfile] = paramloader(platform,nchans)
if strcmp(platform,'biosemi') == 1
    if nchans == 32
        load('chanlocs32.mat');
        chanlocs = chanlocs;
        captextfile = 'chanlocs32.txt';
    elseif nchans == 64
        load('chanlocs64.mat');
        chanlocs = chanlocs;
        captextfile = 'biosemi64.txt';
    elseif nchans == 128
        load('chanlocs128.mat');
        chanlocs = chanlocs;
        captextfile = 'chanlocs128.txt';
    elseif nchans == 256
        load('chanlocs256.mat');
        chanlocs = chanlocs;
        captextfile = 'chanlocs256.txt';
    elseif strcmp(platform,'ANTeego') == 1
        disp(['While this was coded as an acceptable input, the script cant'...
            'actually handle this data yet. Yell at Eric to continue developing this script!']);
    end
end