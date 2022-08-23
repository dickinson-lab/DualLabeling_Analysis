function tracks = getClustersize_SiMpull_10frames(tracks)
tracks  = PickLongTracks(10,tracks);
%Input: convert tracking result as tracks = convert_Utrack(tracksFinal)
%Input: when dialog bix pop up, choose folder contains farred frames as
%image sequence
%tracks = convert_Utrack(tracksFinal);
%output: new field (size) added to tracks

%function [F] = getClusterSizebyI(tracks,folder)
%get folder name using GUI
folder = uigetdir();

%creat file list of farred with full file name
fileList = dir(fullfile(folder,'*.tif'));

tracksize = size(tracks);
ntracks = tracksize(1);
trackswithsize = tracks;

%Throw out peaks that are too close to the edge
F = fullfile(folder,fileList(1).name);
farredframe_getsize = imread(F);%get a farred frame to calculate img size
[ymax, xmax] = size(farredframe_getsize); 
    [ntracks, ~] = size(tracks);
    for c = 1:ntracks;
        for d = 1 : 10;
        if  (min(tracks(c).x(d),tracks(c).y(d))<6 || tracks(c).x(d)>xmax-5 || tracks(c).y(d)>ymax-5)
            tracks(c,:) = [];
        end
        end
    end
    [ntracks, ~] = size(tracks);
    

for n = 1:ntracks
%coordiantes when red first appear
%tracks(n).x(1)
%tracks(n).y(1)

%get frame number cluster first appear
firstappear_frame = tracks(n).seqOfEvents(1);
%read corresponding frame in farred channel
%j = firstappear_frame +9;
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

%Calculate the background and perform the subtraction
xcoord = tracks(n).x(k);
ycoord = tracks(n).y(k);   
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
if traceSmallMBG <= 0
    tracks(n).size_farred = 0;
else
tracks(n).size_farred = traceSmallMBG;
end
end
%end

