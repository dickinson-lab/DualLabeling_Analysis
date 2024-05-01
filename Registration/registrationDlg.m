% Dialog box for image registration and channel localization in dynamic analysis.  
% This dialog box allows user to specify which channel is which and gets an image 
% to use for dual-view registration.

function [Answer, Cancelled] = dynamicChannelInfoDlg(expDir)
    Title = 'Channel Info and Registration';
    Options.Resize = 'off';
    Options.Interpreter = 'tex';
    Options.CancelButton = 'on';
    Options.ApplyButton = 'off';
    Options.ButtonNames = {'Continue','Cancel'}; 
    Prompt = {};
    Formats = {};
    DefAns = struct([]);
    
    Prompt(1,:) = {'\fontsize{12}Number of Channels in Composite Image:',[],[]};
    Formats(1,1).type = 'text';
    Formats(1,1).span = [1 2];
    
    Prompt(2,:) = {[],'nChannels',[]};
    Formats(1,3).type = 'edit';
    Formats(1,3).format = 'integer';
    Formats(1,3).limits = [1 4];
    Formats(1,3).size = [25 25];
    Formats(1,3).unitsloc = 'bottomleft';
    Formats(1,3).span = [1 1];
    DefAns(1).nChannels = 2;

    Prompt(3,:) = {' ','',[]};
    Formats(1,4).type = 'text';
    Formats(1,4).span = [1 1];
    
    Prompt(4,:) = {'\fontsize{12}Channel to be measured:',[],[]};
    Formats(2,1).type = 'text';
    Formats(2,1).span = [1 2];
    
    Prompt(5,:) = {[],'targetChNum',[]};
    Formats(2,3).type = 'edit';
    Formats(2,3).format = 'integer';
    Formats(2,3).limits = [1 4];
    Formats(2,3).size = [25 25];
    Formats(2,3).unitsloc = 'bottomleft';
    Formats(2,3).span = [1 2];
    %DefAns.targetChNum = 1;
    
    Prompt(6,:) = {' ',[],[]};
    Formats(3,1).type = 'text';
    Formats(3,1).span = [1 4];

    Prompt(7,:) = {'\fontsize{12}Sparse / Reference Channel:',[],[]};
    Formats(4,1).type = 'text';
    Formats(4,1).span = [1 2];
    
    Prompt(8,:) = {[],'baitChNum',[]};
    Formats(4,3).type = 'edit';
    Formats(4,3).format = 'integer';
    Formats(4,3).limits = [1 4];
    Formats(4,3).size = [25 25];
    Formats(4,3).unitsloc = 'bottomleft';
    Formats(4,3).span = [1 2];
    %DefAns.baitChNum = 2;
    
    Prompt(9,:) = {' ',[],[]};
    Formats(5,1).type = 'text';
    Formats(5,1).span = [1 4];

    Prompt(10,:) = {'\fontsize{12}Choose a representative image to perform registration. This registration will then be applied across all of your images.',[],[]};
    Formats(6,1).type = 'text';
    Formats(6,1).span = [1 4];

    Prompt(11,:) = {'\fontsize{12}You should choose an image that has distinct spots (not too dense) and a lot of colocalized signal. Bead images work best.',[],[]};
    Formats(7,1).type = 'text';
    Formats(7,1).span = [1 4];
    
    Prompt(12,:) = {'\fontsize{12}Image File:','regFile',[]};
    Formats(8,1).type = 'edit';
    Formats(8,1).format = 'file';
    Formats(8,1).items = [expDir filesep '*.tif'];
    Formats(8,1).limits = [0 1];
    Formats(8,1).required = 'on';
    Formats(8,1).size = [0 25];
    Formats(8,1).span = [1 4];
    %DefAns.regFile = expDir;

    [Answer,Cancelled] = inputsdlg(Prompt,Title,Formats,DefAns,Options);
end
