function [tracks, regData] = getClustersize_10frames(tracks,varargin)
tracks  = PickLongTracks(10,tracks);
%Input: convert tracking result as tracks = convert_Utrack(tracksFinal)
%       A second optional argument is the name of the channel being
%       analyzed (usually something like 'green', 'mNG' or 'farred')
%Input: when dialog bix pop up, choose folder containing frames as image sequence
%tracks = convert_Utrack(tracksFinal);
%output: new field (size) added to tracks

if nargin == 2 
    channel = varargin{1};
else
    channel = 'ch2';
end

%get folder name using GUI
folder = uigetdir();

%creat file list of farred with full file name
fileList = dir(fullfile(folder,'*.tif'));

% Ask the user whether to perform image registration
doReg = questdlg('Perform image registration?');

if strcmp(doReg,'Yes')
    %Options dialog box
    [Answer,Cancelled] = registrationDlg(folder);
    if Cancelled
        doReg = false;
    else
        v2struct(Answer);
    end
    warning("off") %Suppress unnecessary warnings from libTiff
    regImg = TIFFStack(regFile,[],nChannels);
    regData = registerImages( regImg(:,:,targetChNum), regImg(:,:,baitChNum) );
else
    regData = [];
end

%Throw out peaks that are too close to the edge
F = fullfile(folder,fileList(1).name);
farredframe_getsize = imread(F);%get a farred frame to calculate img size
[ymax, xmax] = size(farredframe_getsize); 
[ntracks, ~] = size(tracks);
index = true(ntracks,1);
for c = 1:ntracks
    mincoord = [min(tracks(c).x(1:10)) min(tracks(c).y(1:10))];
    maxcoord = [max(tracks(c).x(1:10)) max(tracks(c).y(1:10))];
    if  any(mincoord<6) || any(maxcoord > [xmax-5 ymax-5]) 
        index(c) = false;
    end
end
tracks = tracks(index);
[ntracks, ~] = size(tracks);
    

for n = 1:ntracks

    %get frame number cluster first appear
    firstappear_frame = tracks(n).seqOfEvents(1);
   
    %read corresponding frame in farred channel
    sum10 = 0;
    k = 0;
    NF = 10;
    for i = firstappear_frame : firstappear_frame +9 %taking average from first 10 frames
        %skip any NaN in the first 10 frames
        k = k+1; 
        if isnan(tracks(n).x(k)) == 1 || isnan(tracks(n).y(k))== 1
              NF = NF-1;
            continue
        end
        F = fullfile(folder,fileList(i).name);
        farredframe = imread(F);
        
        %box sizes for background and signal
        smBoxRad = 2; %This will result in a 5x5 box for large-pixel cameras (EMCCD) and a 7x7 box for small-pixel cameras (sCMOS)
        smBoxArea = (2*smBoxRad + 1)^2; 
        lgBoxRad = smBoxRad + 2;
        lgBoxArea = (2*lgBoxRad + 1)^2;
        areaDiff =  lgBoxArea - smBoxArea;
        
        %Get coordinates
        xcoord = tracks(n).x(k);
        ycoord = tracks(n).y(k);   
        %Registration correction
        if (strcmp(doReg,'Yes'))
            [xcoord,ycoord] = transformPointsInverse(regData.Transformation, xcoord, ycoord) ;
            xcoord = round(xcoord);
            ycoord = round(ycoord);
        end

        %Skip this peak if it's too close to the edge
        if xcoord < 6 || ycoord < 6 || xcoord > (xmax-5) || ycoord > (ymax-5)
            tracks(n).(['size_' channel]) = NaN;
            continue
        end

        %Calculate the background and perform the subtraction
        spotMat = farredframe((ycoord-smBoxRad):(ycoord+smBoxRad),(xcoord-smBoxRad):(xcoord+smBoxRad),:);
        traceSmall = squeeze(sum(sum(spotMat,1),2));
        BGMat = farredframe(ycoord-lgBoxRad:ycoord+lgBoxRad,xcoord-lgBoxRad:xcoord+lgBoxRad,:);
        traceLarge = squeeze(sum(sum(BGMat,1),2));
        traceAvgBG = (traceLarge - traceSmall)/areaDiff;
        traceSmallMBG_single = traceSmall-traceAvgBG*smBoxArea;
        sum10 = sum10 + traceSmallMBG_single;
    end
    traceSmallMBG = sum10 ./ NF;
    %write result into existing 'tracks' cell array
    tracks(n).(['size_' channel]) = traceSmallMBG;
end
%end

