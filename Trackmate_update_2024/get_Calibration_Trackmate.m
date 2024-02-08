function [FR_red_logRatio, redTracks, FRTracks] = get_Calibration_Trackmate(varargin)
% Loads a .csv file from Trackmate, extracts the tracks, and calculates
% particle intensities. 

% An optional argument specifies the number of single-frame intensity
% measurements that are averaged to get the particle brightness.  It is
% also the minimum track length considered. Default = 10

% Check for input
if nargin > 0
    nFrames = varargin{1};
else
    nFrames = 10;
end

% Get red data from Trackmate
[csvfile csvpath] = uigetfile('*.csv','Choose CSV file containing red tracks from TrackMate');
T = readtable([csvpath filesep csvfile]);
T(1,:)=[]; %Eliminate an empty row from the Trackmate data

%Reorganize the data
nTracks = T{end,'TRACK_ID'}+1;
redTracks(nTracks) = struct('x',[],'y',[],'t',[],'redInt',[],'redAvgInt',[]);
for a = 1:height(T)
    id = T{a,'TRACK_ID'};
    redTracks(id+1).x(end+1) = T{a,'POSITION_X'};
    redTracks(id+1).y(end+1) = T{a,'POSITION_Y'};
    redTracks(id+1).t(end+1) = T{a,'POSITION_T'};
    redTracks(id+1).redInt(end+1) = T{a,'MEAN_INTENSITY_CH1'};
end

%Eliminate tracks that are too short
trackLengths = cellfun(@length, {redTracks.x});
redTracks = redTracks(trackLengths>nFrames);
nRedTracks = length(redTracks);

%Calculate Mean initial particle intensities
for c = 1:nRedTracks
    redTracks(c).redAvgInt = mean(redTracks(c).redInt(1:nFrames));
end

% Get far red data from Trackmate
[csvfile csvpath] = uigetfile('*.csv','Choose CSV file containing far red tracks from TrackMate');
T = readtable([csvpath filesep csvfile]);
T(1,:)=[]; %Eliminate an empty row from the Trackmate data

%Reorganize the data
nTracks = T{end,'TRACK_ID'}+1;
FRTracks(nTracks) = struct('x',[],'y',[],'t',[],'FRInt',[],'FRAvgInt',[]);
for b = 1:height(T)
    id = T{b,'TRACK_ID'};
    FRTracks(id+1).x(end+1) = T{b,'POSITION_X'};
    FRTracks(id+1).y(end+1) = T{b,'POSITION_Y'};
    FRTracks(id+1).t(end+1) = T{b,'POSITION_T'};
    FRTracks(id+1).FRInt(end+1) = T{b,'MEAN_INTENSITY_CH2'};
end

%Eliminate tracks that are too short
trackLengths = cellfun(@length, {FRTracks.x});
FRTracks = FRTracks(trackLengths>nFrames);
nFRTracks = length(FRTracks);

%Calculate Mean initial particle intensities
for c = 1:nFRTracks
    FRTracks(c).FRAvgInt = mean(FRTracks(c).FRInt(1:nFrames));
end

%Perform normalization - red channel
logRedInt = cellfun(@log,{redTracks.redAvgInt});
meanLogRedInt = mean(logRedInt);
normLogRedInt = logRedInt - meanLogRedInt;
logRedInt = num2cell(logRedInt);
[redTracks.logInt_Red] = logRedInt{:};
normLogRedInt = num2cell(normLogRedInt);
[redTracks.normLogInt_Red] = normLogRedInt{:};
% Far Red Channel
logFRInt = cellfun(@log,{FRTracks.FRAvgInt});
normLogFRInt = logFRInt - meanLogRedInt; % Note that here we divide by the red intensity, since it's the internal standard
FR_red_logRatio = mean(normLogFRInt); % Calibration ratio - this is what's returned to use for calibrating experimental datasets
logFRInt = num2cell(logFRInt);
[FRTracks.logInt_FR] = logFRInt{:};
normLogFRInt = num2cell(normLogFRInt);
[FRTracks.normLogInt_FR] = normLogFRInt{:};