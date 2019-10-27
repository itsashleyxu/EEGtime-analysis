function [trig_idxs, epoch2] = logicalTrigs(eegstruct,operation,TrigsIn)


evtlist = zeros(1,length(eegstruct.urevent));
for i = 1:length(eegstruct.urevent)
    if ischar(eegstruct.urevent(i).type) == 1
        evtlist(i) = NaN;
        disp(i);
        disp('Event List Contained Character Elements');
    else
        evtlist(i) = eegstruct.urevent(i).type;
    end
end

if strcmp(operation,'pairs_epoch2first')
    trigsat = find(evtlist==str2double(TrigsIn{1}));
    comp2 = 1;
    test = str2double(TrigsIn{2});
    epoch2 = TrigsIn(1);
    loopstart = 1;
    loopend = -1;
elseif strcmp(operation,'bridgepairs_epoch2first')
    trigsat = find(evtlist==str2double(TrigsIn{1}));
    comp2 = 2;
    test = nan;
    test2 = str2double(TrigsIn{3});
    epoch2 = TrigsIn(1);
    loopstart = 1;
    loopend = -2;
elseif strcmp(operation,'pairs_epoch2second')
    trigsat = find(evtlist==str2double(TrigsIn{2}));
    comp2 = -1;
    test = str2double(TrigsIn{1});
    epoch2 = TrigsIn(2);
    loopstart = 2;
    loopend = 0;
elseif strcmp(operation,'deafvisioncustom')
    trigsat = find(evtlist==str2double(TrigsIn{1}));
    comp2 = 2;
    test = str2double(TrigsIn{2});
    test2 = str2double(TrigsIn{3});
    epoch2 = TrigsIn(1);
    loopstart = 1;
    loopend = -2;
else
    disp('Invalid logical operation provided');
end

trig_idxs = [];
for i = loopstart:length(trigsat)+loopend
    if evtlist(trigsat(i)+comp2) == test || evtlist(trigsat(i)+comp2) == test2
        trig_idxs = [trig_idxs trigsat(i)];
    end
end