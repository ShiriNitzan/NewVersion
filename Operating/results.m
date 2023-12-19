%% emissions-area-water-base year only
% To be used after selecting "all steps together"

%preparations
[AreaSum1, CostsSum1, WaterSum1] = CalcTotalResources(Resources1, ConsumptionAmounts1);
[AreaSum2, CostsSum2, WaterSum2] = CalcTotalResources(Resources2, ConsumptionAmounts2);
[AreaSum3, CostsSum3, WaterSum3] = CalcTotalResources(Resources3, ConsumptionAmounts3);

% Arranging the data and building the graph
t = tiledlayout(1,3);
nexttile
BAU = CalcUpDownStream(EmissionsByYearsTest1);
BAU(11,:) = [];

colors1Em = [
   0.72, 0.27, 1.0; 
    0.49, 0.18, 0.56; 
    0.93, 0.69, 0.13;  
    0.51, 0.37, 0.01; 
    0.29, 0.89, 0.69;  
    0.47, 0.67, 0.19;  
    0.85, 0.33, 0.1;  
    0.64, 0.08, 0.18;  
    0.3, 0.75, 0.93;  
    0, 0.45, 0.74;
];

colors2Area = [
    0.47, 0.67, 0.19;
    0.29, 0.89, 0.69; 
    0.85, 0.33, 0.1; 
    0.72, 0.27, 1.0;
];

colors3Water = [
    0.1, 0.31, 0.5;  
    0, 0.45, 0.74;  
    0.46, 0.72, 0.89;  
    0.92, 0.93, 0.93;  
];

Order = {'All Sectors'};
y = [BAU{1:10,1}];
y = y';
x = categorical({'All Sectors'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors1Em(i, :));
end

ylim([0 120])
title('Emissions', 'FontSize', 14);
ylabel('MtCO2Eq', 'FontSize', 20);
legend(flip(b), flip(BAU.Properties.RowNames(1:10)), 'FontSize',8,'Location','northwest')

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

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors2Area(i, :));
end

ylim([0 35000])
title('Area', 'FontSize',14);
ylabel('Km^2', 'FontSize', 20);
legend(flip(b), flip(AreaSum1.Properties.RowNames(1:4)), 'FontSize',10,'Location','northwest')

Order = {'All Sectors'};
y = [WaterSum1{1:4,1}];
y = y';
x = categorical({'All Sectors'});
x = reordercats(x, Order);
nexttile
b = bar(x, y, 'stacked');

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors3Water(i, :));
end

ylim([0 3500]) 
title('Water', 'FontSize', 14);
ylabel('Million M^3', 'FontSize', 20);
legend(flip(b), flip(WaterSum1.Properties.RowNames(1:4)), 'FontSize',10,'Location','northwest')

%% emissions-area-water-base year to last year
% To be used after selecting "all steps together"

%preparations
[AreaSum1, CostsSum1, WaterSum1] = CalcTotalResources(Resources1, ConsumptionAmounts1);
[AreaSum2, CostsSum2, WaterSum2] = CalcTotalResources(Resources2, ConsumptionAmounts2);
[AreaSum3, CostsSum3, WaterSum3] = CalcTotalResources(Resources3, ConsumptionAmounts3);

% Arranging the data and building the graph

colors1Em = [
   0.72, 0.27, 1.0; 
    0.49, 0.18, 0.56;  
    0.93, 0.69, 0.13;  
    0.51, 0.37, 0.01;  
    0.29, 0.89, 0.69;  
    0.47, 0.67, 0.19;  
    0.85, 0.33, 0.1;  
    0.64, 0.08, 0.18;  
    0.3, 0.75, 0.93;  
    0, 0.45, 0.74;
];

colors2Area = [
    0.47, 0.67, 0.19;
    0.29, 0.89, 0.69; 
    0.85, 0.33, 0.1; 
    0.72, 0.27, 1.0;
];

colors3Water = [
    0.1, 0.31, 0.5;  
    0, 0.45, 0.74;  
    0.46, 0.72, 0.89;    
    0.92, 0.93, 0.93;  
];


t = tiledlayout(1,3);
nexttile
BAU = CalcUpDownStream(EmissionsByYearsTest1);
BAU(11,:) = [];
Scenario1 = CalcUpDownStream(EmissionsByYearsTest2);
 Scenario1(11,:) = [];
Scenario2 = CalcUpDownStream(EmissionsByYearsTest3);
Scenario2(11,:) = [];
Order = {'Base Year','BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'};

y = [BAU{1:10,1}, BAU{1:10,34}, Scenario1{1:10,34}, Scenario2{1:10,34}];
y = y';
x = categorical({'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors1Em(i, :));
end

ylim([0 260])
title('Emissions From Different Scenarios', 'FontSize', 14);
xlabel('Scenarios', 'FontSize', 20);
ylabel('MtCO2Eq', 'FontSize', 20);
legend(flip(b), flip(BAU.Properties.RowNames(1:10)), 'FontSize',8,'Location','northwest')

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

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors2Area(i, :));
end

ylim([0 70000])
title('Area From Different Scenarios', 'FontSize',14);
xlabel('Scenarios', 'FontSize', 20);
ylabel('Km^2', 'FontSize', 20);
legend(flip(b), flip(AreaSum3.Properties.RowNames(1:4)), 'FontSize',10,'Location','northwest')
Order = {'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'};
y = [WaterSum1{1:4,1}, WaterSum1{1:4,34}, WaterSum2{1:4,34}, WaterSum3{1:4,34}];
y = y';
x = categorical({'Base Year', 'BAU - 2050', 'Moderate - 2050', 'Advanced - 2050'});
x = reordercats(x, Order);
nexttile
b = bar(x, y, 'stacked');

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors3Water(i, :));
end

ylim([0 7500]) 
title('Water From Different Scenarios', 'FontSize', 14);
xlabel('Scenarios', 'FontSize', 20);
ylabel('Million M^3', 'FontSize', 20);
legend(flip(b), flip(WaterSum3.Properties.RowNames(1:4)), 'FontSize',10,'Location','northwest')


%% Discussion - emissions
% To be used after selecting "sensitivity analysis"

colors1Em = [
    0.72, 0.27, 1.0; 
    0.49, 0.18, 0.56; 
    0.93, 0.69, 0.13; 
    0.51, 0.37, 0.01;  
    0.29, 0.89, 0.69;  
    0.47, 0.67, 0.19; 
    0.85, 0.33, 0.1;  
    0.64, 0.08, 0.18;  
    0.3, 0.75, 0.93;  
    0, 0.45, 0.74;
];

BySectors = cell(1,10);
for i = 2:10
    BySectors{i} = CalcUpDownStream(SensitivityAnalysisCell{1,i-1});
    BySectors{i}(12,:) = [];
end    

Order = {'Base Year','Pop 0%\newlineElec 0%', 'Pop 0%\newlineElec 20%', 'Pop 0%\newlineElec 41%','Pop 45%\newlineElec 0%','Pop 45%\newlineElec 20%','Pop 45%\newlineElec 41%','Pop 90%\newlineElec 0%','Pop 90%\newlineElec 20%','Pop 90%\newlineElec 41%'};
h = categorical({'Base\nYear','1\nPop 0%\nElec 0%', '2\n', '3\n','4\n','5\n','6\n','7\n','8\n','9\n'});

x = categorical(0:1:9);
y = zeros(11,10);
for i = 2:10
    y(:,i) = BySectors{1,i}{1:11,Years};
end

y(:, 1) = BySectors{2}{1:11,1};

b = bar(x,y,'stacked');

for i = 1:10
    set(b(i), 'FaceColor', colors1Em(i, :));
end

legend(flip(b(1:10)), flip(BySectors{3}.Properties.RowNames(1:10,1)), 'FontSize',12,'Location','north')
title('Emissions By Sectors - 2050',  'FontSize', 28);
ylabel('MtCO2Eq', 'FontSize', 20);
xticklabels(Order);
xtickangle(0);
xlabel('State', 'FontSize', 20);
