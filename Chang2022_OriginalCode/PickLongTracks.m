function LongTracks  = PickLongTracks(MinLength,tracking_dataset);
dataLength = length(tracking_dataset);
for i = 1:dataLength
    Track_length(i) = length(tracking_dataset(i).x);
end
Index100 = [Track_length] >MinLength;
LongTracks = tracking_dataset(Index100);