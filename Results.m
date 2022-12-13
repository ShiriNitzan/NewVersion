ScenariosNames = {'Population Growth', 'Electricity Saving Scenario', 'Increase in Diselinated Water', 'Reducing Beef Consumption', 'Preventing Food Loss', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};

Co2eS3 = AllButOneAnalysis;

Co2eS3 = sortrows(Co2eS3,'Difference in Base and Target Year' ,'descend');
CO2EFor2014 = sum(EmissionsByYears{1,1}{1}{1,:}) + EmissionsByYears{2,1}{1}{7,9}+sum(EmissionsByYears{3,1}{1}{:,7})+sum(EmissionsByYears{4,1}{1}{:,16}) + sum(EmissionsByYears{5,1}{1}{:,12})  + sum(EmissionsByYears{6,1}{1}{:,7})+sum(EmissionsByYears{7,1}{1}{:,2})+EmissionsByYears{10,1}{1}{1,2};
CO2EFor2014 = CO2EFor2014/1000000;
Co2eS3('Electricity Saving', :) = [];
Co2eS3('Waste Minimization', :) = [];
Co2eS3('Recycle Waste', :) = [];
Co2eS3('11', :) = [];
Co2eS3('18', :) = [];
Co2eS3('Transition to Electric Van', :) = [];
Co2eS3('Water Saving', :) = [];
%% 
AllButOneBars = Co2eS3;
AllButOneBars('Transition To Public Transportation', :) = [];
AllButOneBars('Transition to Electric Truck', :) = [];
AllButOneBars('Reducing Beef Consumption', :) = [];
AllButOneBars('Transition to Electric Bus', :) = [];

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

x = categorical(AllButOneBars.Properties.RowNames).';
x = reordercats(x, AllButOneBars.Properties.RowNames);
y = (AllButOneBars{:, 1}).';
b = bar(x, y, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]);
title('Changes in CO2E Emissions - All But One Analysis',  'FontSize', 28);
xlabel('Scenarios', 'FontSize', 20);
ylabel('MtCO2Eq', 'FontSize', 20);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',16)

% hold on
% 
% y2 = sums;
% plot(x, y2, 'LineWidth', 4, 'Color', [0.123 0.104 0.238]);
% 
% yyaxis right
% ylabel('Percents')
% y3 = percentages;
% plot(x, y3, 'LineWidth', 4, 'Color', [0.255 0.127 0.80])
% 
% 
% legend('Emissions', 'Sum', 'Percentage')
% hold off
%%
ScenariosNames = {'Population Growth', 'Growth in Per Capita Electricity Consumption', 'Diselinated Water Use Growth', 'Reducing Beef Consumption', 'Preventing Food Loss', 'Electricity From Renewable Energies', 'Electricity From Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};

Co2eS3 = OnlyOneAnalysis;

Co2eS3 = sortrows(Co2eS3,'Difference in Base and Target Year' ,'descend');
CO2EFor2014 = sum(EmissionsByYears{1,1}{1}{1,:}) + EmissionsByYears{2,1}{1}{7,9}+sum(EmissionsByYears{3,1}{1}{:,7})+sum(EmissionsByYears{4,1}{1}{:,16}) + sum(EmissionsByYears{5,1}{1}{:,12})  + sum(EmissionsByYears{6,1}{1}{:,7})+sum(EmissionsByYears{7,1}{1}{:,2})+EmissionsByYears{10,1}{1}{1,2};
Co2eS3('Electricity Saving', :) = [];
Co2eS3('Waste Minimization', :) = [];
Co2eS3('Recycle Waste', :) = [];
Co2eS3('11', :) = [];
Co2eS3('18', :) = [];
Co2eS3('Transition to Electric Van', :) = [];
Co2eS3('Water Saving', :) = [];
%%

OnlyOneBars = Co2eS3;
OnlyOneBars('Transition To Public Transportation', :) = [];
OnlyOneBars('Transition to Electric Truck', :) = [];
OnlyOneBars('Reducing Beef Consumption', :) = [];
OnlyOneBars('Transition to Electric Bus', :) = [];
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

x = categorical(OnlyOneBars.Properties.RowNames).';
x = reordercats(x, OnlyOneBars.Properties.RowNames);
y = (OnlyOneBars{:, 1}).';
b = bar(x, y, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]);
title('Changes in CO2E Emissions - Only One Measure',  'FontSize', 28);
xlabel('Scenarios', 'FontSize', 20);
ylabel('MtCO2Eq', 'FontSize', 20);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',16)

% hold on
% 
% y2 = sums;
% plot(x, y2, 'LineWidth', 4, 'Color', [0.123 0.104 0.238]);
% 
% yyaxis right
% ylabel('Percents')
% y3 = percentages;
% plot(x, y3, 'LineWidth', 4, 'Color', [0.255 0.127 0.80])
% 
% 
% legend('Emissions', 'Sum', 'Percentage')
% hold off
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
x = categorical({'Base Year', 'BAU - 2030', 'Moderate - 2030', 'Advanced - 2030', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');
title('Emissions From Different Scenarios', 'FontSize', 28);
xlabel('Scenarios', 'FontSize', 20);
ylabel('MtCO2Eq', 'FontSize', 20);
legend(flip(b), flip(BAU.Properties.RowNames(1:7)), 'FontSize',12,'Location','northwest')

%% 
[AreaSum1, CostsSum1, WaterSum1] = CalcTotalResources(Resources1, ConsumptionAmounts1);
[AreaSum2, CostsSum2, WaterSum2] = CalcTotalResources(Resources2, ConsumptionAmounts2);
[AreaSum3, CostsSum3, WaterSum3] = CalcTotalResources(Resources3, ConsumptionAmounts3);

%% emissions - all scenrios
t = tiledlayout(1,3);
nexttile
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
ylim([0 250])
title('Emissions From Different Scenarios', 'FontSize', 24);
xlabel('Scenarios', 'FontSize', 20);
ylabel('MtCO2Eq', 'FontSize', 20);
legend(flip(b), flip(BAU.Properties.RowNames(1:7)), 'FontSize',16,'Location','northeast')
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
Order = {'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'};
y = [AreaSum1{1:4,1}, AreaSum1{1:4,34}, AreaSum2{1:4,34}, AreaSum3{1:4,34}];
y = y';
x = categorical({'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');
ylim([0 70000])
title('Area From Different Scenarios', 'FontSize', 24);
xlabel('Scenarios', 'FontSize', 20);
ylabel('Km^2', 'FontSize', 20);
legend(flip(b), flip(AreaSum3.Properties.RowNames(1:4)), 'FontSize',16,'Location','north')
Order = {'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'};
y = [WaterSum1{1:4,1}, WaterSum1{1:4,34}, WaterSum2{1:4,34}, WaterSum3{1:4,34}];
y = y';
x = categorical({'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'});
x = reordercats(x, Order);
nexttile
b = bar(x, y, 'stacked');
ylim([0 7000]) 
title('Water From Different Scenarios', 'FontSize', 24);
xlabel('Scenarios', 'FontSize', 20);
ylabel('Million M^3', 'FontSize', 20);
legend(flip(b), flip(WaterSum3.Properties.RowNames(1:4)), 'FontSize',16,'Location','northwest')
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

%% Discussion
BySectors = cell(1,10);
for i = 2:10
    BySectors{i} = CalcUpDownStream(SensitivityAnalysisCell{i-1});
    BySectors{i}(8,:) = [];
end    

x = categorical(0:1:9);
y = zeros(7,10);
for i = 2:10
    y(:,i) = BySectors{i}{1:7,Years};
end

y(:, 1) = BySectors{2}{1:7,1};

b = bar(x,y,'stacked');
title('Emissions By Sectors - 2050',  'FontSize', 28);
ylabel('MtCO2Eq', 'FontSize', 20);
xlabel('State', 'FontSize', 20);
legend(flip(b), flip(BySectors{2}.Properties.RowNames(1:7,1)), 'FontSize',12,'Location','northwest')
%% 

temp = CalcGlobalLocal(EmissionsByYears);
