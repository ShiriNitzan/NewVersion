%% NOX all sectors
x = 1:1:3;
y = [sum(EmissionsBySectorsS1{2,:}); sum(EmissionsBySectorsS2{2,:});sum(EmissionsBySectorsS3{2,:})];
b = bar(x, y, 0.5);
set(gca,'xticklabel',{'S1','S2','S3'});
title('NOX For All Sectors - 2030',  'FontSize', 24);
xlabel('Scenarios', 'FontSize', 18) ;
ylabel('NOX (tons)', 'FontSize', 18);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^4),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%% PM10 all sectors
x = 1:1:3;
y = [sum(EmissionsBySectorsS1{3,:}); sum(EmissionsBySectorsS2{3,:});sum(EmissionsBySectorsS3{3,:})];
b = bar(x, y, 0.5);
set(gca,'xticklabel',{'S1','S2','S3'});
title('PM10 For All Sectors - 2030',  'FontSize', 24);
xlabel('Scenarios', 'FontSize', 18) ;
ylabel('PM10 (tons)', 'FontSize', 18);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^2),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%%  SO2 all sectors
x = 1:1:4;
y = [sum(EmissionsBySectorsS1{4,:}); sum(EmissionsBySectorsS2{4,:});sum(EmissionsBySectorsS3{4,:})];
b = bar(x, y, 0.5);
set(gca,'xticklabel',{'Current State','S1','S2','S3'});
title('SO2 For All Sectors - 2030',  'FontSize', 24);
xlabel('Scenarios', 'FontSize', 18) ;
ylabel('SO2 (tons)', 'FontSize', 18);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^2),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%% co2e calculations - population growth only

CO2eElectricityDownstream = zeros(1,Years);
CO2eElectricityUpstreamLocal = zeros(1,Years);
CO2eElectricityUpstreamGlobal = zeros(1, Years);
CO2eTranportationDownstream = zeros(1,Years);
CO2eTranportationUpstreamLocal = zeros(1,Years);
CO2eTranportationUpstreamGlobal = zeros(1,Years);
CO2eFoodLocal = zeros(1,Years);
CO2eFoodGlobal = zeros(1,Years);
CO2eFromConstruction = zeros(1, Years);
CO2eLocalConstruction = zeros(1,Years);
CO2eGlobalConstruction = zeros(1, Years);
TotalLocalCO2e = zeros(1,Years);
TotalGlobalCO2e = zeros(1,Years);
TotalNOX = zeros(1,Years);
for i = 1:Years
    CO2eFoodLocal(i) = sum(EmissionsByYearsPopulationGrowth{1,i}{1,1}{1,1:3});
    CO2eFoodGlobal(i) = sum(EmissionsByYearsPopulationGrowth{1,i}{1,1}{1,4:5});
    CO2eElectricityDownstream(i) = EmissionsByYearsPopulationGrowth{2,i}{1,1}{8,9};
    CO2eElectricityUpstreamLocal(i) = sum(EmissionsByYearsPopulationGrowth{3,i}{1,1}{2:4,7});
    CO2eElectricityUpstreamGlobal(i) = EmissionsByYearsPopulationGrowth{3,i}{1,1}{5,7}+EmissionsByYearsPopulationGrowth{3,i}{1,1}{1,7};
    CO2eTranportationDownstream(i) = sum(EmissionsByYearsPopulationGrowth{4,i}{1,1}{:,16});
    CO2eTranportationUpstreamLocal(i) = sum(EmissionsByYearsPopulationGrowth{5,i}{1,1}{1:4,7})+EmissionsByYearsPopulationGrowth{5,i}{1,1}{6,7}+EmissionsByYearsPopulationGrowth{6,i}{1,1}{11,2};
    CO2eTranportationUpstreamGlobal(i) = EmissionsByYearsPopulationGrowth{5,i}{1,1}{5,7};
    CO2eLocalConstruction(i) = EmissionsByYearsPopulationGrowth{6,i}{1,1}{11,2}+EmissionsByYearsPopulationGrowth{6,i}{1,1}{12,2};
    CO2eGlobalConstruction(i) = EmissionsByYearsPopulationGrowth{6,i}{1,1}{13,2};
    
    TotalLocalCO2e(i) = CO2eFoodLocal(i)+ CO2eElectricityDownstream(i)+CO2eElectricityUpstreamLocal(i)+CO2eTranportationDownstream(i)+ CO2eTranportationUpstreamLocal(i)+CO2eLocalConstruction(i);
    TotalGlobalCO2e(i) =   CO2eFoodGlobal(i) + CO2eElectricityUpstreamGlobal(i)+ CO2eTranportationUpstreamGlobal(i) + CO2eGlobalConstruction(i);
end
%% All But One vs. Full S3 - co2e
ScenariosNames = {'Growth in Population', 'Electricity Saving Scenario', 'Increase in Diselinated Water', 'Reducing Beef Consumption', '5', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
temp = string(ScenariosNames);
AllButOneS2co2e = SensitivityAnalysisTableAllButOneS2{:,1}';
AllButOneS3co2e = SensitivityAnalysisTableAllButOneS3{:,1}';

PositiveTableS2 = table(temp.', AllButOneS2co2e.');
PositiveTableS2 = sortrows(PositiveTableS2, 2, 'descend');

PositiveTableS3 = table(temp.', AllButOneS3co2e.');
PositiveTableS3 = sortrows(PositiveTableS3, 2, 'descend');

NegativeTableS2 = sortrows(PositiveTableS2, 2);
NegativeTableS3 = sortrows(PositiveTableS3, 2);

t = tiledlayout(2,2);
% top left corner - positive values S2
title(t, 'Sensitivity Analysis - All But One - CO2E', 'FontSize', 20, 'fontweight','bold');
xlabel(t,'Scenarios', 'FontSize', 16);
ylabel(t,'CO2E - Million Tons', 'FontSize', 16)
ax1 = nexttile;
x = categorical(PositiveTableS2{1:3, 1}).';
x = reordercats(x, PositiveTableS2{1:3, 1});
y = (PositiveTableS2{1:3, 2}).';
b = bar(x, y, 0.4);
ylim([0,0.1*10^9])
title(ax1, 'Scenarios with Positive Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^6),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%top right corner - positive values S3
nexttile
x = categorical(PositiveTableS3{1:3, 1}).';
x = reordercats(x, PositiveTableS3{1:3, 1});
y = (PositiveTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [.42 .37 .73]);
ylim([0,0.1*10^9]);
title('Scenarios with Positive Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^6),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%bottom right corner - negative values S2
nexttile
x = categorical(NegativeTableS2{1:3, 1}).';
x = reordercats(x, NegativeTableS2{1:3, 1});
y = (NegativeTableS2{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [0.9290, 0.6940, 0.1250]);
ylim([-0.3*10^8, 0]);
title('Scenarios with Negative Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^6),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%bottom left corner - negative values S3
nexttile
x = categorical(NegativeTableS3{1:3, 1}).';
x = reordercats(x, NegativeTableS3{1:3, 1});
y = (NegativeTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]	);
ylim([-0.3*10^8, 0]);
title('Scenarios with Negative Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^6),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');


%% %% All But One vs. Full S3 - nox

ScenariosNames = {'Growth in Population', 'Electricity Saving Scenario', 'Increase in Diselinated Water', 'Reducing Beef Consumption', '5', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
temp = string(ScenariosNames);
AllButOneS2nox = SensitivityAnalysisTableAllButOneS2{:,2}';
AllButOneS3nox = SensitivityAnalysisTableAllButOneS3{:,2}';

PositiveTableS2 = table(temp.', AllButOneS2nox.');
PositiveTableS2 = sortrows(PositiveTableS2, 2, 'descend');

PositiveTableS3 = table(temp.', AllButOneS3nox.');
PositiveTableS3 = sortrows(PositiveTableS3, 2, 'descend');

NegativeTableS2 = sortrows(PositiveTableS2, 2);
NegativeTableS3 = sortrows(PositiveTableS3, 2);

t = tiledlayout(2,2);
% top left corner - positive values S2
title(t, 'Sensitivity Analysis - All But One - NOX', 'FontSize', 20, 'fontweight','bold');
xlabel(t,'Scenarios', 'FontSize', 16);
ylabel(t,'Nox - Thousand Tons', 'FontSize', 16)
ax1 = nexttile;
x = categorical(PositiveTableS2{1:3, 1}).';
x = reordercats(x, PositiveTableS2{1:3, 1});
y = (PositiveTableS2{1:3, 2}).';
b = bar(x, y, 0.4);
ylim([0, 2*10^4])
title(ax1, 'Scenarios with Positive Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%top right corner - positive values S3
nexttile
x = categorical(PositiveTableS3{1:3, 1}).';
x = reordercats(x, PositiveTableS3{1:3, 1});
y = (PositiveTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [.42 .37 .73]);
ylim([0, 2*10^4])
title('Scenarios with Positive Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%bottom right corner - negative values S2
nexttile
x = categorical(NegativeTableS2{1:3, 1}).';
x = reordercats(x, NegativeTableS2{1:3, 1});
y = (NegativeTableS2{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [0.9290, 0.6940, 0.1250]);
ylim([-4.5*10^4, 0])
title('Scenarios with Negative Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%bottom left corner - negative values S3
nexttile
x = categorical(NegativeTableS3{1:3, 1}).';
x = reordercats(x, NegativeTableS3{1:3, 1});
y = (NegativeTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]	);
ylim([-4.56*10^4, 0])
title('Scenarios with Negative Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

 %% All But One vs. Full S3 - pm10
ScenariosNames = {'Growth in Population', 'Electricity Saving Scenario', 'Increase in Diselinated Water', 'Reducing Beef Consumption', '5', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
temp = string(ScenariosNames);
AllButOneS2pm10 = SensitivityAnalysisTableAllButOneS2{:,3}';
AllButOneS3pm10 = SensitivityAnalysisTableAllButOneS3{:,3}';

PositiveTableS2 = table(temp.', AllButOneS2pm10.');
PositiveTableS2 = sortrows(PositiveTableS2, 2, 'descend');

PositiveTableS3 = table(temp.', AllButOneS3pm10.');
PositiveTableS3 = sortrows(PositiveTableS3, 2, 'descend');

NegativeTableS2 = sortrows(PositiveTableS2, 2);
NegativeTableS3 = sortrows(PositiveTableS3, 2);

t = tiledlayout(2,2);
% top left corner - positive values S2
title(t, 'Sensitivity Analysis - All But One - PM10', 'FontSize', 20, 'fontweight','bold');
xlabel(t,'Scenarios', 'FontSize', 16);
ylabel(t,'PM10 - Tons', 'FontSize', 16)
ax1 = nexttile;
x = categorical(PositiveTableS2{1:3, 1}).';
x = reordercats(x, PositiveTableS2{1:3, 1});
y = (PositiveTableS2{1:3, 2}).';
b = bar(x, y, 0.4);
ylim([0, 1200])
title(ax1, 'Scenarios with Positive Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^0),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

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
%% All But One vs. Full S3 - SO2
ScenariosNames = {'Growth in Population', 'Electricity Saving Scenario', 'Increase in Diselinated Water', 'Reducing Beef Consumption', '5', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
temp = string(ScenariosNames);
AllButOneS2so2= SensitivityAnalysisTableAllButOneS2{:,4}';
AllButOneS3so2 = SensitivityAnalysisTableAllButOneS3{:,4}';

PositiveTableS2 = table(temp.', AllButOneS2so2.');
PositiveTableS2 = sortrows(PositiveTableS2, 2, 'descend');

PositiveTableS3 = table(temp.', AllButOneS3so2');
PositiveTableS3 = sortrows(PositiveTableS3, 2, 'descend');

NegativeTableS2 = sortrows(PositiveTableS2, 2);
NegativeTableS3 = sortrows(PositiveTableS3, 2);

t = tiledlayout(2,2);
% top left corner - positive values S2
title(t, 'Sensitivity Analysis - All But One - SO2', 'FontSize', 20, 'fontweight','bold');
xlabel(t,'Scenarios', 'FontSize', 16);
ylabel(t,'SO2 - Tons', 'FontSize', 16)
ax1 = nexttile;
x = categorical(PositiveTableS2{1:3, 1}).';
x = reordercats(x, PositiveTableS2{1:3, 1});
y = (PositiveTableS2{1:3, 2}).';
b = bar(x, y, 0.4);
ylim([0, 10500])
title(ax1, 'Scenarios with Positive Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^0),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%top right corner - positive values S3
nexttile
x = categorical(PositiveTableS3{1:3, 1}).';
x = reordercats(x, PositiveTableS3{1:3, 1});
y = (PositiveTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [.42 .37 .73]);
ylim([0, 10500])
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
ylim([-41500, 0])
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
ylim([-41500, 0])
title('Scenarios with Negative Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^0),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');



%%  Only one S2 vs. S3 - co2e
ScenariosNames = {'Growth in Population', 'Electricity Saving Scenario', 'Increase in Diselinated Water', 'Reducing Beef Consumption', '5', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
temp = string(ScenariosNames);
OnlyOneS2CO2E= SensitivityAnalysisTableOnlyOneStepS2{:,1}';
OnlyOneS3CO2E = SensitivityAnalysisTableOnlyOneStepS3{:,1}';

PositiveTableS2 = table(temp.', OnlyOneS2CO2E.');
PositiveTableS2 = sortrows(PositiveTableS2, 2, 'descend');

PositiveTableS3 = table(temp.', OnlyOneS3CO2E');
PositiveTableS3 = sortrows(PositiveTableS3, 2, 'descend');

NegativeTableS2 = sortrows(PositiveTableS2, 2);
NegativeTableS3 = sortrows(PositiveTableS3, 2);

t = tiledlayout(2,2);
% top left corner - positive values S2
title(t, 'Sensitivity Analysis - Only One - CO2E', 'FontSize', 20, 'fontweight','bold');
xlabel(t,'Scenarios', 'FontSize', 16);
ylabel(t,'CO2E - Million Tons', 'FontSize', 16)
ax1 = nexttile;
x = categorical(PositiveTableS2{1:3, 1}).';
x = reordercats(x, PositiveTableS2{1:3, 1});
y = (PositiveTableS2{1:3, 2}).';
b = bar(x, y, 0.4);
title(ax1, 'Scenarios with Positive Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^6),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%top right corner - positive values S3
nexttile
x = categorical(PositiveTableS3{1:3, 1}).';
x = reordercats(x, PositiveTableS3{1:3, 1});
y = (PositiveTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [.42 .37 .73]);
title('Scenarios with Positive Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^6),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%bottom right corner - negative values S2
nexttile
x = categorical(NegativeTableS2{1:3, 1}).';
x = reordercats(x, NegativeTableS2{1:3, 1});
y = (NegativeTableS2{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [0.9290, 0.6940, 0.1250]);
title('Scenarios with Negative Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^6),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%bottom left corner - negative values S3
nexttile
x = categorical(NegativeTableS3{1:3, 1}).';
x = reordercats(x, NegativeTableS3{1:3, 1});
y = (NegativeTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]);
title('Scenarios with Negative Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^6),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');



%% Only one Step S2 vs. S3 NOX
ScenariosNames = {'Growth in Population', 'Electricity Saving Scenario', 'Increase in Diselinated Water', 'Reducing Beef Consumption', '5', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
temp = string(ScenariosNames);
OnlyOneS2NOX= SensitivityAnalysisTableOnlyOneStepS2{:,2}';
OnlyOneS3NOX = SensitivityAnalysisTableOnlyOneStepS3{:,2}';

PositiveTableS2 = table(temp.', OnlyOneS2NOX.');
PositiveTableS2 = sortrows(PositiveTableS2, 2, 'descend');

PositiveTableS3 = table(temp.', OnlyOneS3NOX');
PositiveTableS3 = sortrows(PositiveTableS3, 2, 'descend');

NegativeTableS2 = sortrows(PositiveTableS2, 2);
NegativeTableS3 = sortrows(PositiveTableS3, 2);

t = tiledlayout(2,2);
% top left corner - positive values S2
title(t, 'Sensitivity Analysis - Only One - NOX', 'FontSize', 20, 'fontweight','bold');
xlabel(t,'Scenarios', 'FontSize', 16);
ylabel(t,'NOX - Thousand Tons', 'FontSize', 16)
ax1 = nexttile;
x = categorical(PositiveTableS2{1:3, 1}).';
x = reordercats(x, PositiveTableS2{1:3, 1});
y = (PositiveTableS2{1:3, 2}).';
b = bar(x, y, 0.4);
title(ax1, 'Scenarios with Positive Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%top right corner - positive values S3
nexttile
x = categorical(PositiveTableS3{1:3, 1}).';
x = reordercats(x, PositiveTableS3{1:3, 1});
y = (PositiveTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [.42 .37 .73]);
title('Scenarios with Positive Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%bottom right corner - negative values S2
nexttile
x = categorical(NegativeTableS2{1:3, 1}).';
x = reordercats(x, NegativeTableS2{1:3, 1});
y = (NegativeTableS2{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [0.9290, 0.6940, 0.1250]);
title('Scenarios with Negative Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%bottom left corner - negative values S3
nexttile
x = categorical(NegativeTableS3{1:3, 1}).';
x = reordercats(x, NegativeTableS3{1:3, 1});
y = (NegativeTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]);
title('Scenarios with Negative Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%% %% Only one Step S2 vs. S3 PM10
ScenariosNames = {'Growth in Population', 'Electricity Saving Scenario', 'Increase in Diselinated Water', 'Reducing Beef Consumption', '5', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
temp = string(ScenariosNames);
OnlyOneS2PM10= SensitivityAnalysisTableOnlyOneStepS2{:,3}';
OnlyOneS3PM10 = SensitivityAnalysisTableOnlyOneStepS3{:,3}';

PositiveTableS2 = table(temp.', OnlyOneS2PM10.');
PositiveTableS2 = sortrows(PositiveTableS2, 2, 'descend');

PositiveTableS3 = table(temp.', OnlyOneS3PM10');
PositiveTableS3 = sortrows(PositiveTableS3, 2, 'descend');

NegativeTableS2 = sortrows(PositiveTableS2, 2);
NegativeTableS3 = sortrows(PositiveTableS3, 2);

t = tiledlayout(2,2);
% top left corner - positive values S2
title(t, 'Sensitivity Analysis - Only One - PM10', 'FontSize', 20, 'fontweight','bold');
xlabel(t,'Scenarios', 'FontSize', 16);
ylabel(t,'PM10 - Thousand Tons', 'FontSize', 16)
ax1 = nexttile;
x = categorical(PositiveTableS2{1:3, 1}).';
x = reordercats(x, PositiveTableS2{1:3, 1});
y = (PositiveTableS2{1:3, 2}).';
b = bar(x, y, 0.4);
title(ax1, 'Scenarios with Positive Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%top right corner - positive values S3
nexttile
x = categorical(PositiveTableS3{1:3, 1}).';
x = reordercats(x, PositiveTableS3{1:3, 1});
y = (PositiveTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [.42 .37 .73]);
title('Scenarios with Positive Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%bottom right corner - negative values S2
nexttile
x = categorical(NegativeTableS2{1:3, 1}).';
x = reordercats(x, NegativeTableS2{1:3, 1});
y = (NegativeTableS2{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [0.9290, 0.6940, 0.1250]);
ylim([-2500, 0])
title('Scenarios with Negative Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%bottom left corner - negative values S3
nexttile
x = categorical(NegativeTableS3{1:3, 1}).';
x = reordercats(x, NegativeTableS3{1:3, 1});
y = (NegativeTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]);
ylim([-2500, 0])
title('Scenarios with Negative Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');
%% Only one Step S2 vs. S3 so2
ScenariosNames = {'Growth in Population', 'Electricity Saving Scenario', 'Increase in Diselinated Water', 'Reducing Beef Consumption', '5', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
temp = string(ScenariosNames);
OnlyOneS2SO2= SensitivityAnalysisTableOnlyOneStepS2{:,4}';
OnlyOneS3SO2 = SensitivityAnalysisTableOnlyOneStepS3{:,4}';

PositiveTableS2 = table(temp.', OnlyOneS2SO2.');
PositiveTableS2 = sortrows(PositiveTableS2, 2, 'descend');

PositiveTableS3 = table(temp.', OnlyOneS3SO2');
PositiveTableS3 = sortrows(PositiveTableS3, 2, 'descend');

NegativeTableS2 = sortrows(PositiveTableS2, 2);
NegativeTableS3 = sortrows(PositiveTableS3, 2);

t = tiledlayout(2,2);
% top left corner - positive values S2
title(t, 'Sensitivity Analysis - Only One - SO2', 'FontSize', 20, 'fontweight','bold');
xlabel(t,'Scenarios', 'FontSize', 16);
ylabel(t,'SO2 - Thousand Tons', 'FontSize', 16)
ax1 = nexttile;
x = categorical(PositiveTableS2{1:3, 1}).';
x = reordercats(x, PositiveTableS2{1:3, 1});
y = (PositiveTableS2{1:3, 2}).';
b = bar(x, y, 0.4);
title(ax1, 'Scenarios with Positive Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%top right corner - positive values S3
nexttile
x = categorical(PositiveTableS3{1:3, 1}).';
x = reordercats(x, PositiveTableS3{1:3, 1});
y = (PositiveTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [.42 .37 .73]);
title('Scenarios with Positive Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%bottom right corner - negative values S2
nexttile
x = categorical(NegativeTableS2{1:3, 1}).';
x = reordercats(x, NegativeTableS2{1:3, 1});
y = (NegativeTableS2{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [0.9290, 0.6940, 0.1250]);
ylim([-3.5*10^4, 0])
title('Scenarios with Negative Changes S2',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

%bottom left corner - negative values S3
nexttile
x = categorical(NegativeTableS3{1:3, 1}).';
x = reordercats(x, NegativeTableS3{1:3, 1});
y = (NegativeTableS3{1:3, 2}).';
b = bar(x, y, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]);
ylim([-3.5*10^4, 0])
title('Scenarios with Negative Changes S3',  'FontSize', 16);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');


%% CO2E
x = 1:1:4;
y = [EmissionsSumS1(1), EmissionsSumS2(1),EmissionsSumS3(1),EmissionsSumCurrent(1)];
b = bar(x, y, 0.4);
set(gca,'xticklabel',{'S1','S2','S3','Current State'});
title('CO2E',  'FontSize', 24);
xlabel('Scenarios', 'FontSize', 18) ;
ylabel('CO2E (tons)', 'FontSize', 18);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^9),2));
text(xtips1,ytips1,labels1,'HorizontalAlignment','left','VerticalAlignment','bottom');

%% NOX
x = 1:1:4;
y = [EmissionsSumS1(2), EmissionsSumS2(2),EmissionsSumS3(2),EmissionsSumCurrent(2)];
b = bar(x, y, 0.4);
set(gca,'xticklabel',{'S1','S2','S3','Current State'});
title('NOX',  'FontSize', 24);
xlabel('Scenarios', 'FontSize', 18) ;
ylabel('NOX (tons)', 'FontSize', 18);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^4),2));
text(xtips1,ytips1,labels1,'HorizontalAlignment','left','VerticalAlignment','bottom');
%% PM10
x = 1:1:4;
y = [EmissionsSumS1(3), EmissionsSumS2(3),EmissionsSumS3(3),EmissionsSumCurrent(3)];
b = bar(x, y, 0.4);
set(gca,'xticklabel',{'S1','S2','S3','Current State'});
title('PM10',  'FontSize', 24);
xlabel('Scenarios', 'FontSize', 18) ;
ylabel('PM10 (tons)', 'FontSize', 18);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),2));
text(xtips1,ytips1,labels1,'HorizontalAlignment','left','VerticalAlignment','bottom');
%% SO2
x = 1:1:4;
y = [EmissionsSumS1(4), EmissionsSumS2(4),EmissionsSumS3(4),EmissionsSumCurrent(4)];
b = bar(x, y, 0.4);
set(gca,'xticklabel',{'S1','S2','S3','Current State'});
title('SO2',  'FontSize', 24);
xlabel('Scenarios', 'FontSize', 18) ;
ylabel('SO2 (tons)', 'FontSize', 18);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),2));
text(xtips1,ytips1,labels1,'HorizontalAlignment','left','VerticalAlignment','bottom');

%% delta 2017-2030 - only S1
ScenariosNames = {'Growth in Population', 'Electricity Saving Scenario', 'Increase in Diselinated Water', 'Reducing Beef Consumption', '5', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};



Co2eS1 = SensitivityAnalysisTableOnlyOneStepS2;
Co2eS1([1,2,3], :) = [];
Co2eS1(ismember(Co2eS1.('CO2Equivalent'),0),:)=[];

Co2eS1 = sortrows(Co2eS1,'CO2Equivalent', 'descend');
s = sum(EmissionsByYears{1,1}{1}{1,:});
CO2EFor2014 = sum(EmissionsByYears{1,1}{1}{1,:}) + EmissionsByYears{2,1}{1}{8,9}+sum(EmissionsByYears{3,1}{1}{:,7})+sum(EmissionsByYears{4,1}{1}{:,16}) + sum(EmissionsByYears{5,1}{1}{:,12})  + sum(EmissionsByYears{6,1}{1}{:,7})+sum(EmissionsByYears{7,1}{1}{:,2}) + sum(EmissionsByYears{8,1}{1}{:,3}) + sum(EmissionsByYears{9,1}{1}{2,:}) + sum(EmissionsByYears{9,1}{1}{6,:}) + sum(EmissionsByYears{9,1}{1}{10,:});

sums = zeros(1, height(Co2eS1));
temp = 0;
for i = 1:height(Co2eS1)
    temp = temp + Co2eS1{i, 1};
    sums(i) = temp;
end

percentages =  zeros(1, height(Co2eS1));
percent = 0;
temp = 0;
for i = 1:height(Co2eS1)
    percent = (Co2eS1{i,1}/CO2EFor2014)*100;
    temp = temp + percent;
    percentages(i) = temp;
end    

fig = figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);

x = categorical(Co2eS1.Properties.RowNames).';
x = reordercats(x, Co2eS1.Properties.RowNames);
y = (Co2eS1{:, 1}).';
b = bar(x, y, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]);
title('Changes in CO2E Emissions',  'FontSize', 28);
xlabel('Scenarios', 'FontSize', 20);
ylabel('CO2E -Kilotons', 'FontSize', 20);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',16)
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = append(string(round(b(1).YData/(10^3),0)), " kt");
text(xtips1,ytips1,labels1,'HorizontalAlignment','left','VerticalAlignment','bottom', 'FontSize', 14);
ax = gca;
ax.YAxis.Exponent = 3;

hold on

y2 = sums;
plot(x, y2, 'LineWidth', 4, 'Color', [0.123 0.104 0.238]);
yyaxis right
y3 = percentages;
ylabel('Percents')
plot(x, y3, 'LineWidth', 4, 'Color', [0.255 0.127 0.80])

legend('Emissions', 'Kilotons', 'Percentage')


hold off

%% delta 2017-2030 - only S2
ScenariosNames = {'Growth in Population', 'Electricity Saving Scenario', 'Increase in Diselinated Water', 'Reducing Beef Consumption', '5', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};

Co2eS2 = SensitivityAnalysisTableOnlyOneStepS2;
Co2eS2(ismember(Co2eS2.('CO2Equivalent'),0),:)=[];

Co2eS2 = sortrows(Co2eS2,'CO2Equivalent', 'descend');
CO2EFor2014 = sum(EmissionsByYears{1,1}{1}{1,:}) + EmissionsByYears{2,1}{1}{8,9}+sum(EmissionsByYears{3,1}{1}{:,7})+sum(EmissionsByYears{4,1}{1}{:,16}) + sum(EmissionsByYears{5,1}{1}{:,12})  + sum(EmissionsByYears{6,1}{1}{:,7})+sum(EmissionsByYears{7,1}{1}{:,2}) + sum(EmissionsByYears{8,1}{1}{:,3}) + sum(EmissionsByYears{9,1}{1}{2,:}) + sum(EmissionsByYears{9,1}{1}{6,:}) + sum(EmissionsByYears{9,1}{1}{10,:});

sums = zeros(1, height(Co2eS2));
temp = 0;
for i = 1:height(Co2eS2)
    temp = temp + Co2eS2{i, 1};
    sums(i) = temp;
end

percentages =  zeros(1, height(Co2eS2));
percent = 0;
temp = 0;
for i = 1:height(Co2eS2)
    percent = (Co2eS2{i,1}/CO2EFor2014)*100;
    temp = temp + percent;
    percentages(i) = temp;
end    

fig = figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);

x = categorical(Co2eS2.Properties.RowNames).';
x = reordercats(x, Co2eS2.Properties.RowNames);
y = (Co2eS2{:, 1}).';
b = bar(x, y, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]);
title('Changes in CO2E Emissions - After Considering Population Growth and Chnages in Consumption Habits',  'FontSize', 28);
xlabel('Scenarios', 'FontSize', 20);
ylabel('CO2E -Kilotons', 'FontSize', 20);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',16)
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = append(string(round(b(1).YData/(10^3),0)), " kt");
text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','top', 'FontSize', 14);
ax = gca;
ax.YAxis.Exponent = 3;
hold on

y2 = sums;
plot(x, y2, 'LineWidth', 4, 'Color', [0.123 0.104 0.238]);

yyaxis right
ylabel('Percents')
y3 = percentages;
plot(x, y3, 'LineWidth', 4, 'Color', [0.255 0.127 0.80])


legend('Emissions', 'Sum', 'Percentage')
hold off

%% %% delta 2017-2030 - only S3
ScenariosNames = {'Growth in Population', 'Electricity Saving Scenario', 'Increase in Diselinated Water', 'Reducing Beef Consumption', '5', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};

Co2eS3 = SensitivityAnalysisTableOnlyOneStepS3;
Co2eS3(ismember(Co2eS3.('CO2Equivalent'),0),:)=[];

Co2eS3 = sortrows(Co2eS3,'CO2Equivalent', 'descend');
CO2EFor2014 = sum(EmissionsByYears{1,1}{1}{1,:}) + EmissionsByYears{2,1}{1}{8,9}+sum(EmissionsByYears{3,1}{1}{:,7})+sum(EmissionsByYears{4,1}{1}{:,16}) + sum(EmissionsByYears{5,1}{1}{:,12})  + sum(EmissionsByYears{6,1}{1}{:,7})+sum(EmissionsByYears{7,1}{1}{:,2}) + sum(EmissionsByYears{8,1}{1}{:,3}) + sum(EmissionsByYears{9,1}{1}{2,:}) + sum(EmissionsByYears{9,1}{1}{6,:}) + sum(EmissionsByYears{9,1}{1}{10,:});

sums = zeros(1, height(Co2eS3));
temp = 0;
for i = 1:height(Co2eS3)
    temp = temp + Co2eS3{i, 1};
    sums(i) = temp;
end

percentages =  zeros(1, height(Co2eS3));
percent = 0;
temp = 0;
for i = 1:height(Co2eS3)
    percent = (Co2eS3{i,1}/CO2EFor2014)*100;
    temp = temp + percent;
    percentages(i) = temp;
end    

fig = figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);

x = categorical(Co2eS3.Properties.RowNames).';
x = reordercats(x, Co2eS3.Properties.RowNames);
y = (Co2eS3{:, 1}).';
b = bar(x, y, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]);
title('Changes in CO2E Emissions - Considering More Drastic Steps',  'FontSize', 28);
xlabel('Scenarios', 'FontSize', 20);
ylabel('CO2E -Thousands Tons', 'FontSize', 20);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',16)
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData/(10^3),3));
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');

hold on

y2 = sums;
plot(x, y2, 'LineWidth', 4, 'Color', [0.123 0.104 0.238]);

yyaxis right
ylabel('Percents')
y3 = percentages;
plot(x, y3, 'LineWidth', 4, 'Color', [0.255 0.127 0.80])


legend('Emissions', 'Sum', 'Percentage')
hold off




%% 
ScenariosNames = {'Population Growth', 'Chnage in Electricity Per Capita', 'Increase in Diselinated Water', 'Reducing Beef Consumption', '5', 'Energy Consumption From Renewable Energies', 'Electricity by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
y = [ScenariosAndValues{:,1}.'; ScenariosAndValues{:,2}.'; ScenariosAndValues{:,3}.'];
x = categorical(ScenariosNames);
x =  reordercats(x, ScenariosNames);
b = bar(x, y);
title('Chnages in Prcentages',  'FontSize', 24);
xlabel('Scenarios', 'FontSize', 16);
ylabel('Percents', 'FontSize', 16);
legend({'S1','S2','S3'},'Location','northwest');
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = append(string(b(1).YData*10), "%");
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom');
