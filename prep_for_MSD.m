function tracks_cell = prep_for_MSD(tracks)

%Takes particle tracking data from U-Track and formats it for MSDanalyzer. 

dT = 0.05; %seconds between frames in my movies; could modify this to an input later if needed.
scale = 0.06875; %microns per pixel for images acquired on our CSU-X1 system with the 100X objective and 1.5X tube lens.

% If needed, convert data to a more usable format
if ~isfield(tracks, 'x')
    tracks = convert_Utrack(tracks);
end
ntracks = length(tracks);

% Reshape data for MSDanalyzer
tracks_cell = cell(ntracks,1);
for a=1:ntracks
    tracks_cell{a} = zeros(length(tracks(a).x),3);
    tracks_cell{a}(:,1) = 0:dT:dT*(length(tracks(a).x)-1);
    tracks_cell{a}(:,2) = tracks(a).x * scale;
    tracks_cell{a}(:,3) = tracks(a).y * scale;
    %Remove gaps in the tracks
    index = isnan(tracks(a).x);
    tracks_cell{a}(index,:) = [];
end

