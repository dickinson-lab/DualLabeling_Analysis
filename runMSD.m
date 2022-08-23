function ma = runMSD(dataset)

tracks_cell = prep_for_MSD(dataset);%change dataset here
ma = msdanalyzer(2, 'µm', 's');
ma = ma.addAll(tracks_cell);
disp(ma)
% figure('Name','tracks')
% ma.plotTracks;
% ma.labelPlotTracks;
ma = ma.computeMSD;
ma.msd;
figure('Name','MSD')
ma.plotMSD;

hold on;
%figure('Name','MSDaverage')
%cla;
ma.plotMeanMSD(gca, false);
set(gca,'XScale','log','YScale','log');
%[fo, gof] = ma.fitMeanMSD( 0.02 );
%plot(fo)


% %get coordinates for the meanMSD curve
% [varargout , msmsd]  = ma.plotMeanMSD(gca, true);
% coordinates = msmsd(:, 1:2)
% l = length(coordinates); 
% 
% figure
% plot(coordinates(:,1), coordinates(:,2))
% showfit('a*x^n')
% [fo, gof] = ma.fitMeanMSD;
% plot(fo)
% ma.labelPlotMSD;
% legend off