%% emissions - all scenrios
BAU = CalcUpDownStream(EmissionsByYearsTest1);
BAU(8,:) = [];
Scenario1 = CalcUpDownStream(EmissionsByYearsTest2);
Scenario1(8,:) = [];
Scenario2 = CalcUpDownStream(EmissionsByYearsTest3);
Scenario2(8,:) = [];
Order = {'Base Year','BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'};
y = [BAU{1:7,1}, BAU{1:7,34}, Scenario1{1:7,34}, Scenario2{1:7,34}];
y = y';
x = categorical({'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');
title('Emissions From Different Scenarios', 'FontSize', 28);
xlabel('Scenarios', 'FontSize', 20);
ylabel('MtCO2Eq', 'FontSize', 20);
legend(flip(b), flip(BAU.Properties.RowNames(1:7)), 'FontSize',12,'Location','northwest')
%% emissions - all scenrios try
t = tiledlayout(1,3);

BAU = CalcUpDownStream(EmissionsByYearsTest1);
%%BAU(8,:) = [];
%%Scenario1 = CalcUpDownStream(EmissionsByYearsTest2);
%%Scenario1(11,:) = [];
%%Scenario2 = CalcUpDownStream(EmissionsByYearsTest3);
%%Senario2(11,:) = [];
Order = {'Base Year'};%,'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'};
y = [BAU{1:10,1}];%, BAU{1:7,34}, Scenario1{1:7,34}, Scenario2{1:7,34}];
y = y';
x = categorical({'Base Year'});%, 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');
title('Emissions From Different Scenarios', 'FontSize', 28);
xlabel('Scenarios', 'FontSize', 20);
ylabel('MtCO2Eq', 'FontSize', 20);
legend(flip(b), flip(BAU.Properties.RowNames(1:10)), 'FontSize',12,'Location','northwest')
precents = y(1,:)./sum(y(1,:));
ytips = zeros(1, length(b));
for i = 1:length(b)
    ytips(i) = b(i).YEndPoints;
end
ytxt = round(y./repmat(sum(y,2),1,size(y,2))*100);
ytxt = num2cell(ytxt);
ytxt = cellfun(@(x) [sprintf('%0.0f',x), '%'], ytxt,'UniformOutput', false);
xtips = zeros(1, length(b));
for i = 1:length(b)
    xtips(i) = b(i).XEndPoints;
end
text(xtips,ytips,ytxt,'HorizontalAlignment','left','VerticalAlignment','top', 'FontSize', 6);

[AreaSum1, WaterSum1] = CalcTotalResources(Resources1, ConsumptionAmounts1);

AreaSum1 = sortrows(AreaSum1,1,'descend');
WaterSum1 = sortrows(WaterSum1,1,'descend');
AreaSum1(1, :) = [];
WaterSum1(1, :) = [];
%nexttile
%%Order = {'Base Year', 'BAU - 2030', 'Moderate - 2030', 'Advanced - 2030'};
Order = {'Base Year'};
y = [AreaSum1{1:4,1}];
%%y = [AreaSum1{1:4,1}, AreaSum1{1:4,14}, AreaSum2{1:4,14}, AreaSum3{1:4,14}];
y = y';
%%x = categorical({'Base Year', 'BAU - 2030', 'Moderate - 2030', 'Advanced - 2030'});
x = categorical({'Base Year'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');
ylim([0 70000])
title('Area From Different Scenarios', 'FontSize',12);
xlabel('Scenarios', 'FontSize', 20);
ylabel('Km^2', 'FontSize', 20);
legend(flip(b), flip(AreaSum1.Properties.RowNames(1:4)), 'FontSize',16,'Location','north')
Order = {'Base Year'};
y = [WaterSum1{1:4,2}];
y = y';
x = categorical({'Base Year'});
x = reordercats(x, Order);
nexttile
b = bar(x, y, 'stacked');
ylim([0 7500]) 
title('Water From Different Scenarios', 'FontSize', 12);
xlabel('Scenarios', 'FontSize', 20);
ylabel('Million M^3', 'FontSize', 20);
legend(flip(b), flip(WaterSum1.Properties.RowNames(1:4)), 'FontSize',16,'Location','northwest')

%% emissions-area-water-base year to end year - pre
[AreaSum1, CostsSum1, WaterSum1] = CalcTotalResources(Resources1, ConsumptionAmounts1);
[AreaSum2, CostsSum2, WaterSum2] = CalcTotalResources(Resources2, ConsumptionAmounts2);
[AreaSum3, CostsSum3, WaterSum3] = CalcTotalResources(Resources3, ConsumptionAmounts3);

%% emissions-area-water-base year only
t = tiledlayout(1,3);
nexttile
BAU = CalcUpDownStream(EmissionsByYearsTest3);
BAU(11,:) = [];

Order = {'All Sectors'};
y = [BAU{1:10,1}];
y = y';
x = categorical({'All Sectors'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');
ylim([0 120])
title('Emissions From Different Scenarios', 'FontSize', 12);
xlabel('Scenarios', 'FontSize', 20);
ylabel('MtCO2Eq', 'FontSize', 20);
legend(flip(b), flip(BAU.Properties.RowNames(1:10)), 'FontSize',16,'Location','northeast')


% Define the data for the new row
 for i = 1:width(WaterSum1)
    newData{1,i} = (EmissionsByYearsTest3{11,i}{1,1}{1,3}+ EmissionsByYearsTest3{11,i}{1,1}{1,4})/1000000;
 end
% Add the new row using addvars


% Create a new table with the new row
newRow = table(newData{:}, 'VariableNames', WaterSum1.Properties.VariableNames);

% Concatenate the new row to the existing table
WaterSum1 = [WaterSum1; newRow];
WaterSum1.Properties.RowNames{7} = 'Water for food - Global';

AreaSum1 = sortrows(AreaSum1,1,'descend');
WaterSum1 = sortrows(WaterSum1,1,'descend');
AreaSum1(1, :) = [];
WaterSum1(1, :) = [];

nexttile
Order = {'All Sectors'};
y = [AreaSum1{1:4,1}];
y = y';
x = categorical({'All Sectors'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');
ylim([0 35000])
title('Area From Different Scenarios', 'FontSize',12);
xlabel('Scenarios', 'FontSize', 20);
ylabel('Km^2', 'FontSize', 20);
legend(flip(b), flip(AreaSum1.Properties.RowNames(1:4)), 'FontSize',16,'Location','north')
Order = {'All Sectors'};
y = [WaterSum1{1:5,1}];
y = y';
x = categorical({'All Sectors'});
x = reordercats(x, Order);
nexttile
b = bar(x, y, 'stacked');
ylim([0 3000]) 
title('Water From Different Scenarios', 'FontSize', 12);
xlabel('Scenarios', 'FontSize', 20);
ylabel('Million M^3', 'FontSize', 20);
legend(flip(b), flip(WaterSum1.Properties.RowNames(1:5)), 'FontSize',16,'Location','northwest')
%% emissions-area-water-base year to end year
t = tiledlayout(1,3);
nexttile
BAU = CalcUpDownStream(EmissionsByYearsTest1);
BAU(11,:) = [];
Scenario1 = CalcUpDownStream(EmissionsByYearsTest2);
Scenario1(11,:) = [];
Scenario2 = CalcUpDownStream(EmissionsByYearsTest3);
Scenario2(11,:) = [];
Order = {'Base Year','BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'};
%%Order = {'Base Year','BAU - 2030', 'Moderate - 2030', 'Advanced - 2030'};
y = [BAU{1:10,1}, BAU{1:10,34}, Scenario1{1:10,34}, Scenario2{1:10,34}];
%%y = [BAU{1:7,1}, BAU{1:7,14}, Scenario1{1:7,14}, Scenario2{1:7,14}];
y = y';
%%x = categorical({'Base Year', 'BAU - 2030', 'Moderate - 2030', 'Advanced - 2030'});
x = categorical({'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');
ylim([0 260])
title('Emissions From Different Scenarios', 'FontSize', 12);
xlabel('Scenarios', 'FontSize', 20);
ylabel('MtCO2Eq', 'FontSize', 20);
legend(flip(b), flip(BAU.Properties.RowNames(1:10)), 'FontSize',16,'Location','northeast')


% Define the data for the new row
 for i = 1:width(WaterSum1)
    newData1{1,i} = (EmissionsByYearsTest1{11,i}{1,1}{1,3}+ EmissionsByYearsTest1{11,i}{1,1}{1,4})/1000000;        newData1{1,i} = (EmissionsByYearsTest3{11,i}{1,1}{1,3}+ EmissionsByYearsTest3{11,i}{1,1}{1,4})/1000000;
    newData2{1,i} = (EmissionsByYearsTest2{11,i}{1,1}{1,3}+ EmissionsByYearsTest2{11,i}{1,1}{1,4})/1000000;
    newData3{1,i} = (EmissionsByYearsTest3{11,i}{1,1}{1,3}+ EmissionsByYearsTest3{11,i}{1,1}{1,4})/1000000;
 end
% Add the new row using addvars


% Create a new table with the new row
newRow1 = table(newData1{:}, 'VariableNames', WaterSum1.Properties.VariableNames);
newRow2 = table(newData2{:}, 'VariableNames', WaterSum2.Properties.VariableNames);
newRow3 = table(newData3{:}, 'VariableNames', WaterSum3.Properties.VariableNames);



% Concatenate the new row to the existing table
WaterSum1 = [WaterSum1; newRow];
WaterSum1.Properties.RowNames{7} = 'Water for food - Global';
WaterSum2 = [WaterSum2; newRow];
WaterSum2.Properties.RowNames{7} = 'Water for food - Global';
WaterSum3 = [WaterSum3; newRow];
WaterSum3.Properties.RowNames{7} = 'Water for food - Global';

% Display the updated table
disp(WaterSum1);




AreaSum1 = sortrows(AreaSum1,1,'descend');
WaterSum1 = sortrows(WaterSum1,1,'descend');
AreaSum1(1, :) = [];
WaterSum1(1, :) = [];
AreaSum2 = sortrows(AreaSum2,1,'descend');
WaterSum2 = sortrows(WaterSum2,1,'descend');
AreaSum2(1, :) = [];
WaterSum2(1, :) = [];
AreaSum3 = sortrows(AreaSum3,1,'descend');
WaterSum3 = sortrows(WaterSum3,1,'descend');
AreaSum3(1, :) = [];
WaterSum3(1, :) = [];
nexttile


%%Order = {'Base Year', 'BAU - 2030', 'Moderate - 2030', 'Advanced - 2030'};
Order = {'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'};
y = [AreaSum1{1:4,1}, AreaSum1{1:4,34}, AreaSum2{1:4,34}, AreaSum3{1:4,34}];
%%y = [AreaSum1{1:4,1}, AreaSum1{1:4,14}, AreaSum2{1:4,14}, AreaSum3{1:4,14}];
y = y';
%%x = categorical({'Base Year', 'BAU - 2030', 'Moderate - 2030', 'Advanced - 2030'});
x = categorical({'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');
ylim([0 70000])
title('Area From Different Scenarios', 'FontSize',12);
xlabel('Scenarios', 'FontSize', 20);
ylabel('Km^2', 'FontSize', 20);
legend(flip(b), flip(AreaSum3.Properties.RowNames(1:4)), 'FontSize',16,'Location','north')
Order = {'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'};
%%Order = {'Base Year', 'BAU - 2030', 'Moderate - 2030', 'Advanced - 2030'};
%%y = [WaterSum1{1:4,1}, WaterSum1{1:4,14}, WaterSum2{1:4,14}, WaterSum3{1:4,14}];
y = [WaterSum1{1:5,1}, WaterSum1{1:5,34}, WaterSum2{1:5,34}, WaterSum3{1:5,34}];
y = y';
%%x = categorical({'Base Year', 'BAU - 2030', 'Moderate - 2030', 'Advanced - 2030'});
x = categorical({'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'});
x = reordercats(x, Order);
nexttile
b = bar(x, y, 'stacked');
ylim([0 7500]) 
title('Water From Different Scenarios', 'FontSize', 12);
xlabel('Scenarios', 'FontSize', 20);
ylabel('Million M^3', 'FontSize', 20);
legend(flip(b), flip(WaterSum3.Properties.RowNames(1:5)), 'FontSize',16,'Location','northwest')
%%
Order = {'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'};
BY = [WaterSum1{1,1}*0.51, WaterSum1{2,1}*3.50, WaterSum1{4,1}*0.50];
BAU = [WaterSum1{1,34}*0.51, WaterSum1{2,34}*3.50, WaterSum1{4,34}*0.50];
MOD = [WaterSum2{1,34}*0.51, WaterSum2{2,34}*3.50, WaterSum2{4,34}*0.50];
ADV = [WaterSum3{1,34}*0.51, WaterSum3{2,34}*3.50, WaterSum3{4,34}*0.50];
y = [BY,BAU,MOD,ADV];
%y = [WaterSum1{1:4,1}, WaterSum1{1:4,34}, WaterSum2{1:4,34}, WaterSum3{1:4,34}];

%y = y';
x = categorical({'Base Year'});
z = categorical({'BAU - 2050'});
%x = categorical({'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'});
%x = reordercats(x, Order);
nexttile
b = bar(x, BY ,'stacked');
c = bar(z, BAU ,'stacked');
ylim([0 15000]) 
title('KWH of Water From Different Scenarios', 'FontSize', 24);
xlabel('Scenarios', 'FontSize', 20);
ylabel('KWH', 'FontSize', 20);
%legend(flip(b), flip(WaterSum1.Properties.RowNames(1:4)), 'FontSize',16,'Location','northwest')

%%
MileStonesResults = zeros(3,Years);

Electricity30 = TotalEmissionsBySectors(EmissionsByYearsTest1);
ElectricityFoNoga(1,:) = Electricity30{1,:};
Electricity40 = TotalEmissionsBySectors(EmissionsByYearsTest2);
ElectricityFoNoga(2,:) = Electricity40{1,:};
Electricity50 = TotalEmissionsBySectors(EmissionsByYearsTest3);
ElectricityFoNoga(3,:) = Electricity50{1,:};

x = categorical(EmissionsByYearsTest1.Properties.VariableNames);
x = reordercats(x,EmissionsByYearsTest1.Properties.VariableNames);
bar(x, ElectricityFoNoga);
title('Emissions From Electrcity',  'FontSize', 28);
xlabel('Years', 'FontSize', 20);
ylabel('MtCO2eqs', 'FontSize', 20);
legend({'30%', '50%', '60%'}, 'FontSize',12,'Location','northwest')
%% sum of emissions
SumOfEmissions = zeros(1,3);
for i = 1:3
    SumOfEmissions(i) = sum(ElectricityFoNoga(i,:));
end

x = categorical({'30%', '40%', '50%'});
bar(x, SumOfEmissions);
title('Emissions From Electrcity - Sum of All Years',  'FontSize', 28);
xlabel('Scenarios', 'FontSize', 20);
ylabel('MtCO2eqs', 'FontSize', 20);

%% Yearly Emissions sum - Scenarios with milestones
YearlyEmissionsTest1 = YearlySumCalc(EmissionsByYearsTest1);
YearlyEmissionsTest1{2,:} = zeros(1,width(YearlyEmissionsTest1));
YearlyEmissionsTest1{2,1} = YearlyEmissionsTest1{1,1};
for i = 2:width(YearlyEmissionsTest1)
    YearlyEmissionsTest1{2,i} = YearlyEmissionsTest1{2,i-1} +  YearlyEmissionsTest1{1,i};
end    
YearlyEmissionsTest1{2,:} = YearlyEmissionsTest1{2,:};
YearlyEmissionsTest1{1,:} = YearlyEmissionsTest1{1,:};

YearlyEmissionsTest2 = YearlySumCalc(EmissionsByYearsTest2);
YearlyEmissionsTest2{2,:} = zeros(1,width(YearlyEmissionsTest2));
YearlyEmissionsTest2{2,1} = YearlyEmissionsTest2{1,1};
for i = 2:width(YearlyEmissionsTest2)
    YearlyEmissionsTest2{2,i} = YearlyEmissionsTest2{2,i-1} +  YearlyEmissionsTest2{1,i};
end
YearlyEmissionsTest2{2,:} = YearlyEmissionsTest2{2,:};
YearlyEmissionsTest2{1,:} = YearlyEmissionsTest2{1,:};

YearlyEmissionsTest3 = YearlySumCalc(EmissionsByYearsTest3);
YearlyEmissionsTest3{2,:} = zeros(1,width(YearlyEmissionsTest3));
YearlyEmissionsTest3{2,1} = YearlyEmissionsTest3{1,1};
for i = 2:width(YearlyEmissionsTest3)
    YearlyEmissionsTest3{2,i} = YearlyEmissionsTest3{2,i-1} +  YearlyEmissionsTest3{1,i};
end    
YearlyEmissionsTest3{2,:} = YearlyEmissionsTest3{2,:};
YearlyEmissionsTest3{1,:} = YearlyEmissionsTest3{1,:};

x = categorical(YearlyEmissionsTest1.Properties.VariableNames);
y1 = YearlyEmissionsTest1{1,:};
y2 = YearlyEmissionsTest2{1,:};
y3 = YearlyEmissionsTest3{1,:};
t = tiledlayout(1,3);
nexttile
b = bar(x, y1, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]);
title('No Milestones',  'FontSize', 16);
xlabel('Years', 'FontSize', 20);
ylabel('Mt Co2Eq', 'FontSize', 20);
nexttile
b = bar(x, y2, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]);
title('25% Milestone',  'FontSize', 16);
xlabel('Years', 'FontSize', 20);
ylabel('Mt Co2Eq', 'FontSize', 20);
nexttile
b = bar(x, y3, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]);
title('20% Milestone',  'FontSize', 16);
xlabel('Years', 'FontSize', 20);
ylabel('Mt Co2Eq', 'FontSize', 20);

title(t, 'Yearly CO2E Emissions - Scenarios Implemenataion',  'FontSize', 28);

figure
t = tiledlayout(1,2)
nexttile
x = 2017:1:2050;
y1 = FullScenariosTable1{6,:};
y2 = FullScenariosTable2{6,:};
y3 = FullScenariosTable3{6,:};
plot(x, y1, x, y2, x, y3, 'LineWidth', 2)
title('Change of Factor over Time',  'FontSize', 24);
xlabel('Years', 'FontSize', 20);
ylabel('Precents', 'FontSize', 20);
legend({'30%', '50%', '60%'}, 'FontSize',12,'Location','northwest')

nexttile
x1 = categorical({'30% Milestone', '50% Milestone', '60% Milestone'});
y4 = [sum(YearlyEmissionsTest1{1,:}) sum(YearlyEmissionsTest2{1,:}) sum(YearlyEmissionsTest3{1,:})];
b1 = bar(x1, y4, 0.4);
title('Sum Of All Years - Scenarios Implemenataion',  'FontSize', 24);
xlabel('Total', 'FontSize', 20);
ylabel('Mt Co2Eq', 'FontSize', 20);
set(gca,'XTick', x);

%% Discussion - 2050 sceario 2 analysis

Scenario2Analysis = TotalEmissionsBySectors(EmissionsByYearsTest3);

Scenario2Analysis(5,:) = [];
x = categorical({'All Sectors'});
y = zeros(1, 5); 
y(1,:) = Scenario2Analysis{1:5,width(Scenario2Analysis)};
b = bar(x,y,'Stacked');
title('Emissions By Sectors - Scenario 2, 2050',  'FontSize', 28);
ylabel('MtCO2Eq', 'FontSize', 20);
legend(flip(b), flip(Scenario2Analysis.Properties.RowNames), 'FontSize',12,'Location','northwest')
precents = y(1,:)./sum(y(1,:));
ytips = zeros(1, length(b));
for i = 1:length(b)
    ytips(i) = b(i).YEndPoints;
end
ytxt = round(y./repmat(sum(y,2),1,size(y,2))*100);
ytxt = num2cell(ytxt);
ytxt = cellfun(@(x) [sprintf('%0.0f',x), '%'], ytxt,'UniformOutput', false);
xtips = zeros(1, length(b));
for i = 1:length(b)
    xtips(i) = b(i).XEndPoints;
end
text(xtips,ytips,ytxt,'HorizontalAlignment','left','VerticalAlignment','top', 'FontSize', 14);

%% Discussion - emissions
BySectors = cell(1,10);
for i = 2:10
    BySectors{i} = CalcUpDownStream(SensitivityAnalysisCell{1,i-1});
    BySectors{i}(12,:) = [];
end    

Order = {'Base Year','Pop 0% Elec 0%', 'Pop 0% Elec 20%', 'Pop 0% Elec 41%','Pop 45% Elec 0%','Pop 45% Elec 20%','Pop 45% Elec 41%','Pop 90% Elec 0%','Pop 90% Elec 20%','Pop 90% Elec 41%'};
h = categorical({'Base\nYear','1\nPop 0%\nElec 0%', '2\n', '3\n','4\n','5\n','6\n','7\n','8\n','9\n'});
%h = reordercats(h, Order);

x = categorical(0:1:9);
y = zeros(11,10);
for i = 2:10
    y(:,i) = BySectors{1,i}{1:11,Years};
end

y(:, 1) = BySectors{2}{1:11,1};


%yael methood
t = zeros (10,10);
for i  =2:10
t(i,:)=sum(y(1:i,:));
end

t(1,:)=y(1,:);
for i = 10:-1:1
    bar(t(i,:),'stacked');
    hold on
end
legend( flip(BySectors{3}.Properties.RowNames(1:10,1)), 'FontSize',12,'Location','northwest')
title('Emissions By Sectors - 2050',  'FontSize', 28);
ylabel('MtCO2Eq', 'FontSize', 20);
xticklabels(Order);
xtickangle(45);
xlabel('State', 'FontSize', 20);
1%%
%yael methood
t = zeros (10,10);
for i  =2:10
t(i,:)=sum(y(1:i,:));
end

t(1,:)=y(1,:);
for i = 10:-1:1
    bar(t(i,:),'stacked');
    hold on
end
legend(flip(h), flip(BySectors{3}.Properties.RowNames(1:10,1)), 'FontSize',12,'Location','northwest')
title('Emissions By Sectors - 2050',  'FontSize', 28);
ylabel('MtCO2Eq', 'FontSize', 20);
xlabel('State', 'FontSize', 20);
%%

b = bar(x,y,'stacked');
title('Emissions By Sectors - 2050',  'FontSize', 28);
ylabel('MtCO2Eq', 'FontSize', 20);
xlabel('State', 'FontSize', 20);
legend(flip(b), flip(BySectors{3}.Properties.RowNames(1:11,1)), 'FontSize',12,'Location','northwest')

%% Discussion - Area
BySectorsWater = cell(1,10);
BySectorsArea = cell(1,10);
for i = 2:10
    [BySectorsArea{i}, CostsSum1, BySectorsWater{i}] = CalcTotalResources(SensitivityAnalysisCell{3,i-1}, SensitivityAnalysisCell{2,i-1});
end    

x = categorical(0:1:9);
y = zeros(4,10);
for i = 2:10
    y(:,i) = BySectorsWater{i}{1:4,Years};
end

y(:, 1) = BySectorsWater{2}{1:4,1};

b = bar(x,y,'stacked');
title('Water By Sectors - 2050',  'FontSize', 28);
ylabel('Million M^3', 'FontSize', 20);
xlabel('State', 'FontSize', 20);
legend(flip(b), flip(BySectorsWater{2}.Properties.RowNames(1:4,1)), 'FontSize',12,'Location','northwest')
%%
x = categorical(0:1:9);
y = zeros(4,10);
for i = 2:10
    y(:,i) = BySectorsArea{i}{1:4,Years};
end

y(:, 1) = BySectorsArea{2}{1:4,1};

b = bar(x,y,'stacked');
title('Area By Sectors - 2050',  'FontSize', 28);
ylabel('KM^2', 'FontSize', 20);
xlabel('State', 'FontSize', 20);
legend(flip(b), flip(BySectorsArea{2}.Properties.RowNames(1:4,1)), 'FontSize',12,'Location','northwest')