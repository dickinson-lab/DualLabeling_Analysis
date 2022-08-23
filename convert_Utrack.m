function tracks = convert_Utrack(tracks)

% Convert track data from U-Track to a more usable format
ntracks = length(tracks);
if ~isfield(tracks, 'x')
    [tracks(:).amp] = deal([]); %struct('amp',zeros(ntracks,1),'x',zeros(ntracks,1),'y',zeros(ntracks,1));
    [tracks(:).x] = deal([]);
    [tracks(:).y] = deal([]);
    for a = 1:ntracks
        dataLength = length(tracks(a).tracksCoordAmpCG);
        amp = tracks(a).tracksCoordAmpCG(4:8:dataLength-4);
        indexa = ~isnan(amp);
        tracks(a).amp = mean(amp(indexa));
        tracks(a).x = tracks(a).tracksCoordAmpCG(1:8:dataLength-7);
        tracks(a).y = tracks(a).tracksCoordAmpCG(2:8:dataLength-6);
    end
end
