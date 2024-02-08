function tracks = calc_Absolute_Sizes(tracks, FR_red_logRatio)
%Calculate
normLogFRInt = cell2mat({tracks.normLogInt_FR});
corrLogFRInt = normLogFRInt - FR_red_logRatio;
estN_FR = round(exp(corrLogFRInt));
estN_FR(estN_FR<0) = 0;
estN_tot = estN_FR + 1; %Add 1 to get the total number because one molecule should have the red dye
estN_FR_cell = num2cell(estN_FR);
[tracks.estN_FR] = estN_FR_cell{:};
estN_tot_cell = num2cell(estN_tot);
[tracks.estN_tot] = estN_tot_cell{:};

%Plot
maxSize = max(estN_FR);
nObs = zeros(maxSize,1);
for a = 1:maxSize
    nObs(a) = sum(estN_FR == a);
end
figure
scatter(1:maxSize,nObs)