function tracks = get_Intensities_Trackmate(varargin)
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

% Get data from Trackmate
[csvfile csvpath] = uigetfile('*.csv','Choose CSV file containing tracks from TrackMate');
T = readtable([csvpath filesep csvfile]);
T(1,:)=[]; %Eliminate an empty row from the Trackmate data

%Reorganize the data
nTracks = T{end,'TRACK_ID'}+1;
tracks(nTracks) = struct('x',[],'y',[],'t',[],'redInt',[],'redAvgInt',[],'FRInt',[],'FRAvgInt',[]);
for a = 1:height(T)
    id = T{a,'TRACK_ID'};
    tracks(id+1).x(end+1) = T{a,'POSITION_X'};
    tracks(id+1).y(end+1) = T{a,'POSITION_Y'};
    tracks(id+1).t(end+1) = T{a,'POSITION_T'};
    tracks(id+1).redInt(end+1) = T{a,'MEAN_INTENSITY_CH1'};
    tracks(id+1).FRInt(end+1) = T{a,'MEAN_INTENSITY_CH2'};
end

%Eliminate tracks that are too short
trackLengths = cellfun(@length, {tracks.x});
tracks = tracks(trackLengths>nFrames);
nTracks = length(tracks);

%Calculate Mean initial particle intensities
for c = 1:nTracks
    tracks(c).redAvgInt = mean(tracks(c).redInt(1:nFrames));
    tracks(c).FRAvgInt = mean(tracks(c).FRInt(1:nFrames));
end

%Perform normalization - red channel
logRedInt = cellfun(@log,{tracks.redAvgInt});
meanLogRedInt = mean(logRedInt);
normLogRedInt = logRedInt - meanLogRedInt;
logRedInt = num2cell(logRedInt);
[tracks.logInt_Red] = logRedInt{:};
normLogRedInt = num2cell(normLogRedInt);
[tracks.normLogInt_Red] = normLogRedInt{:};
% Far Red Channel
logFRInt = cellfun(@log,{tracks.FRAvgInt});
normLogFRInt = logFRInt - meanLogRedInt; % Note that here we divide by the red intensity, since it's the internal standard
logFRInt = num2cell(logFRInt);
[tracks.logInt_FR] = logFRInt{:};
normLogFRInt = num2cell(normLogFRInt);
[tracks.normLogInt_FR] = normLogFRInt{:};