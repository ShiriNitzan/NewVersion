FilePath = "C:\Users\talco\Desktop\System-1\Solar Radiation Data.xlsx";
RadiationArad = readtable(FilePath,'Sheet','Arad','Range','A1:W14','ReadVariableNames',true, 'ReadRowNames', true);
RadiationBeerSheba = readtable(FilePath,'Sheet','BeerSheba','Range','A1:W14','ReadVariableNames',true, 'ReadRowNames', true);
RadiationBesorFarm = readtable(FilePath,'Sheet','BesorFarm','Range','A1:W14','ReadVariableNames',true, 'ReadRowNames', true);
RadiationEilat = readtable(FilePath,'Sheet','Eilat','Range','A1:W14','ReadVariableNames',true, 'ReadRowNames', true);
RadiationHaifa = readtable(FilePath,'Sheet','Haifa','Range','A1:W14','ReadVariableNames',true, 'ReadRowNames', true);
RadiationHatzeva = readtable(FilePath,'Sheet','Hatzeva','Range','A1:W14','ReadVariableNames',true, 'ReadRowNames', true);
RadiationJerusalem = readtable(FilePath,'Sheet','Jerusalem','Range','A1:W14','ReadVariableNames',true, 'ReadRowNames', true);
RadiationMitzpeRamon = readtable(FilePath,'Sheet','MitzpeRamon','Range','A1:W14','ReadVariableNames',true, 'ReadRowNames', true);
RadiationSedeBoqer = readtable(FilePath,'Sheet','SedeBoqer','Range','A1:W14','ReadVariableNames',true, 'ReadRowNames', true);
RadiationSedom = readtable(FilePath,'Sheet','Sedom','Range','A1:W14','ReadVariableNames',true, 'ReadRowNames', true);
RadiationTelAviv = readtable(FilePath,'Sheet','TelAviv','Range','A1:W14','ReadVariableNames',true, 'ReadRowNames', true);
RadiationYotvata = readtable(FilePath,'Sheet','Yotvata','Range','A1:W14','ReadVariableNames',true, 'ReadRowNames', true);

 %% All But One vs. Full S3 - pm10
xLabels = RadiationArad.Properties.RowNames';
yLabels = RadiationArad.Properties.VariableNames;

t = tiledlayout(2,2);
% top left corner - Beersheba
title(t, 'Solar Radiation', 'FontSize', 20, 'fontweight','bold');
xlabel(t,'Time', 'FontSize', 16);
ylabel(t,'Radiation (kWH m^-2 day^-1)', 'FontSize', 16)
ax1 = nexttile;
x = string(RadiationArad.Properties.RowNames');
x = x(1:12);
y = RadiationBeerSheba{1:12,21}';
plot(x,y);
title(ax1, 'Beer-Sheba',  'FontSize', 16);

%top right corner - positive values S3
nexttile
x = categorical(PositiveTableS3{1:3, 1}).';
x = reordercats(x, PositiveTableS3{1:3, 1});
y = (PositiveTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [.42 .37 .73]);
ylim([0, 1200])
title('Scenarios with Positive Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^0),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%bottom right corner - negative values S2
nexttile
x = categorical(NegativeTableS2{1:3, 1}).';
x = reordercats(x, NegativeTableS2{1:3, 1});
y = (NegativeTableS2{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [0.9290, 0.6940, 0.1250]);
ylim([-2600, 0])
title('Scenarios with Negative Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^0),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%bottom left corner - negative values S3
nexttile
x = categorical(NegativeTableS3{1:3, 1}).';
x = reordercats(x, NegativeTableS3{1:3, 1});
y = (NegativeTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]);
ylim([-2600, 0])
title('Scenarios with Negative Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^0),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');