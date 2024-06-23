%% emissions-area-water-base year only
% To be used after selecting "all steps together"

%preparations
[AreaSum1, CostsSum1, WaterSum1] = CalcTotalResources(Resources1, ConsumptionAmounts1, WaterFromFood1);

% Arranging the data and building the graph
t = tiledlayout(1,3);
nexttile
NoPolicy = CalcUpDownStream(EmissionsByYearsTest1);
%NoPolicy(11,:) = [];

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
    0, 1, 0.74;
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
    0.72, 0.27, 1.0;
];

colors4Cost = [
    0.1, 0.31, 0.5;  
    0, 0.45, 0.74;  
    0.85, 0.33, 0.1; 
    0.72, 0.27, 1.0;
];

Order = {'All Sectors'};
y = [NoPolicy{1:11,1}];
y = y';
x = categorical({'All Sectors'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors1Em(i, :));
end

ylim([0 120])
title('Emissions', 'FontSize', 14,'Position', [1, 123, 0]);
ylabel('MtCO2Eq', 'FontSize', 20);
legend(flip(b), flip(NoPolicy.Properties.RowNames(1:11)), 'FontSize',8,'Location','northwest')

AreaSum1 = sortrows(AreaSum1,1,'descend');
WaterSum1 = sortrows(WaterSum1,1,'descend');
CostsSum1 = sortrows(CostsSum1,1,'descend');
AreaSum1(1, :) = [];
WaterSum1(1, :) = [];
CostsSum1(1, :) = [];

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
title('Area', 'FontSize',14,'Position', [1, 35875, 0]);
ylabel('km^2', 'FontSize', 20);
legend(flip(b), flip(AreaSum1.Properties.RowNames(1:4)), 'FontSize',10,'Location','northwest')

Order = {'All Sectors'};
y = [WaterSum1{1:5,1}];
y = y';
x = categorical({'All Sectors'});
x = reordercats(x, Order);
nexttile
b = bar(x, y, 'stacked');

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors3Water(i, :));
end

ylim([0 3500]) 
title('Water', 'FontSize', 14,'Position', [1, 3580, 0]);
ylabel('Million m^3', 'FontSize', 20);
legend(flip(b), flip(WaterSum1.Properties.RowNames(1:5)), 'FontSize',10,'Location','northwest')
%% Costs
Order = {'All Sectors'};
y = [CostsSum1{1:4,1}];
y = y';
x = categorical({'All Sectors'});
x = reordercats(x, Order);

b = bar(x, y, 'stacked');

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors4Cost(i, :));
end

ylim([0 150]) 
title('Cost', 'FontSize', 14,'Position', [1, 123, 0]);
ylabel('Billion ILS', 'FontSize', 20);
legend(flip(b), flip(CostsSum1.Properties.RowNames(1:4)), 'FontSize',10,'Location','northwest')

%% emissions-area-water-base year to last year *****
% To be used after selecting "all steps together" 

%preparations
[AreaSum1, CostsSum1, WaterSum1] = CalcTotalResources(Resources1, ConsumptionAmounts1,WaterFromFood1);
[AreaSum2, CostsSum2, WaterSum2] = CalcTotalResources(Resources2, ConsumptionAmounts2, WaterFromFood2);
[AreaSum3, CostsSum3, WaterSum3] = CalcTotalResources(Resources3, ConsumptionAmounts3,WaterFromFood3);

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
    0, 1, 0.74;
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
    0.72, 0.27, 1.0;
];

colors4Cost = [
    0.1, 0.31, 0.5;  
    0, 0.45, 0.74;  
    0.85, 0.33, 0.1; 
    0.72, 0.27, 1.0;
];
 
t = tiledlayout(1,3);
nexttile
NoPolicy = CalcUpDownStream(EmissionsByYearsTest1);
%NoPolicy(11,:) = [];
Scenario1 = CalcUpDownStream(EmissionsByYearsTest2);
% Scenario1(11,:) = [];
Scenario2 = CalcUpDownStream(EmissionsByYearsTest3);
%Scenario2(11,:) = [];
Order = {'Base Year','No Policy - 2050', 'Moderate - 2050', 'Advanced - 2050'};

y = [NoPolicy{1:11,1}, NoPolicy{1:11,34}, Scenario1{1:11,34}, Scenario2{1:11,34}];
y = y';
x = categorical({'Base Year', 'No Policy - 2050', 'Moderate - 2050', 'Advanced - 2050'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors1Em(i, :));
end

ylim([0 270])
title('Emissions', 'FontSize', 14,'Position', [2.5, 275, 0]);
xticklabels(Order);
xtickangle(20);
xlabel('Scenarios', 'FontSize', 20);

ylabel('MtCO2Eq', 'FontSize', 20);
legend(flip(b), flip(NoPolicy.Properties.RowNames(1:11)), 'FontSize',8,'Location','northwest')


AreaSum1 = sortrows(AreaSum1,1,'descend'); 
WaterSum1 = sortrows(WaterSum1,1,'descend');
CostsSum1 = sortrows(CostsSum1,1,'descend');
AreaSum1(1, :) = [];
WaterSum1(1, :) = [];
CostsSum1(1, :) = [];
AreaSum2 = sortrows(AreaSum2,1,'descend');
WaterSum2 = sortrows(WaterSum2,1,'descend');
CostsSum2 = sortrows(CostsSum2,1,'descend');
AreaSum2(1, :) = [];
WaterSum2(1, :) = [];
CostsSum2(1, :) = [];
AreaSum3 = sortrows(AreaSum3,1,'descend');
WaterSum3 = sortrows(WaterSum3,1,'descend');
CostsSum3 = sortrows(CostsSum3,1,'descend');
AreaSum3(1, :) = [];
WaterSum3(1, :) = [];
CostsSum3(1, :) = [];

nexttile


%%Order = {'Base Year', 'NoPolicy - 2030', 'Moderate - 2030', 'Advanced - 2030'};
Order = {'Base Year', 'No Policy - 2050', 'Moderate - 2050', 'Advanced - 2050'};
y = [AreaSum1{1:4,1}, AreaSum1{1:4,34}, AreaSum2{1:4,34}, AreaSum3{1:4,34}];
%%y = [AreaSum1{1:4,1}, AreaSum1{1:4,14}, AreaSum2{1:4,14}, AreaSum3{1:4,14}];
y = y';
%%x = categorical({'Base Year', 'NoPolicy - 2030', 'Moderate - 2030', 'Advanced - 2030'});
x = categorical({'Base Year', 'No Policy - 2050', 'Moderate - 2050', 'Advanced - 2050'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');
for i = 1:numel(b)
    set(b(i), 'FaceColor', colors2Area(i, :));
end
% ** CHANGED **
ylim([0 85000])
title('Area', 'FontSize',14,'Position', [2.5, 86296, 0]);
xticklabels(Order);
xtickangle(20);
xlabel('Scenarios', 'FontSize', 20);
ylabel('km^2', 'FontSize', 20);
legend(flip(b), flip(AreaSum3.Properties.RowNames(1:4)), 'FontSize',10,'Location','northwest')

Order = {'Base Year', 'No Policy - 2050', 'Moderate - 2050', 'Advanced - 2050'};
y = [WaterSum1{1:5,1}, WaterSum1{1:5,34}, WaterSum2{1:5,34}, WaterSum3{1:5,34}];
y = y';
x = categorical({'Base Year', 'No Policy - 2050', 'Moderate - 2050', 'Advanced - 2050'});
x = reordercats(x, Order);
nexttile
b = bar(x, y, 'stacked');

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors3Water(i, :));
end

ylim([0 7500]) 
title('Water', 'FontSize', 14,'Position', [2.5, 7638, 0]);
xlabel('Scenarios', 'FontSize', 20);
xticklabels(Order);
xtickangle(20);
ylabel('Million m^3', 'FontSize', 20);
legend(flip(b), flip(WaterSum3.Properties.RowNames(1:5)), 'FontSize',10,'Location','northwest')

%% COST
Order = {'Base Year', 'NoPolicy - 2050', 'Moderate - 2050', 'Advanced - 2050'};
y = [CostsSum1{1:4,1}, CostsSum1{1:4,34}, CostsSum2{1:4,34}, CostsSum3{1:4,34}];
y = y';
x = categorical({'Base Year', 'NoPolicy - 2050', 'Moderate - 2050', 'Advanced - 2050'});
x = reordercats(x, Order);
nexttile
b = bar(x, y, 'stacked');

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors3Water(i, :));
end

ylim([0 400]) 
title('Costs', 'FontSize', 14);
xlabel('Scenarios', 'FontSize', 20);
ylabel('Billion ILS', 'FontSize', 20);
legend(flip(b), flip(CostsSum3.Properties.RowNames(1:4)), 'FontSize',10,'Location','northwest')
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
    0, 1, 0.74;
];

BySectors = cell(1,11);
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

for i = 1:11
    set(b(i), 'FaceColor', colors1Em(i, :));
end
ylim([0 110]) 
legend(flip(b(1:11)), flip(BySectors{3}.Properties.RowNames(1:11,1)), 'FontSize',12,'Location','north')
title('Emissions By Sectors - 2050',  'FontSize', 28);
ylabel('MtCO2Eq', 'FontSize', 20);
xticklabels(Order);
xtickangle(0);
xlabel('State', 'FontSize', 20);


















%% NEW NEW NEW - Sensitivity analysis for DOMESTIC ONLY
% To be used after selecting "sensitivity analysis"

colors1Em = [
    0.902, 0.373, 0.145; % electricity 
    0.949, 0.737, 0.239;  % transportaion - L
    0.784, 0.910, 0.690; % food - L 
    0.871, 0.761, 0.941; % construction - L 
    0.302, 0.749, 0.929; % water - L
    0.361, 0.325, 0.325; % fuels - L
];

BySectors = cell(1,11);
for i = 2:10
    BySectors{i} = CalcUpDownStream(SensitivityAnalysisCell{1,i-1});
    BySectors{i}(12,:) = [];
end    

Order = {'Base Year','Pop 0%\newlineElec 0%', 'Pop 0%\newlineElec 20%', 'Pop 0%\newlineElec 41%','Pop 45%\newlineElec 0%','Pop 45%\newlineElec 20%','Pop 45%\newlineElec 41%','Pop 90%\newlineElec 0%','Pop 90%\newlineElec 20%','Pop 90%\newlineElec 41%'};
h = categorical({'Base\nYear','1\nPop 0%\nElec 0%', '2\n', '3\n','4\n','5\n','6\n','7\n','8\n','9\n'});

x = categorical(0:1:9);
y = zeros(6,10);
for i = 2:10
    y(:,i) = BySectors{1,i}{1:2:11,Years};
end

y(:, 1) = BySectors{2}{1:2:11,1};

b = bar(x,y,'stacked');

for i = 1:6
    set(b(i), 'FaceColor', colors1Em(i, :));
end
ylim([0 110]) 
legend(flip(b(1:6)), flip(BySectors{3}.Properties.RowNames(1:2:11)),  'FontSize',12,'Location','northeast') 
title('Emissions By Sectors - 2050',  'FontSize', 28);
ylabel('MtCO2Eq', 'FontSize', 20);
xticklabels(Order);
xtickangle(0);
xlabel('State', 'FontSize', 20);

%% emissions-area-water: base year to 2035 with specific scenario
% To be used after selecting "all steps together" (FOR 2035!)

%preparations
[AreaSum1, CostsSum1, WaterSum1] = CalcTotalResources(Resources1, ConsumptionAmounts1,WaterFromFood1);
[AreaSum3, CostsSum3, WaterSum3] = CalcTotalResources(Resources3, ConsumptionAmounts3,WaterFromFood3);

% Arranging the data and building the graph

colors1Em = [
    0.902, 0.373, 0.145; % electricity - L
    0.6353, 0.0824, 0.1843
    0.949, 0.737, 0.239;  % transportaion - L
    0.7098, 0.5333, 0.1765
    0.784, 0.910, 0.690; % food - L 
    0.4314, 0.6196, 0.4627
    0.871, 0.761, 0.941; % construction - L 
    0.4941, 0.3490, 0.6039
    0.302, 0.749, 0.929; % water - L
    0.0039, 0.4471, 0.7451
    0.361, 0.325, 0.325; % fuels - L
];



colors2Area = [
    0.4314, 0.6196, 0.4627;
    0.7961, 0.8863, 0.6667; 
    0.7843, 0.5961, 0.6824; 
    0.8510, 0.3216, 0.0941;
];

colors3Water = [
    24/255, 80/255, 129/255; 
    0.0039, 0.4471, 0.7451;
    0.4627, 0.7216, 0.8902;    
    0.9176, 0.9255, 0.9216;        
    0.3608, 0.4667, 0.5098;   
    ];


t = tiledlayout(1,3);
nexttile
NoPolicy = CalcUpDownStream(EmissionsByYearsTest1);
Scenario2 = CalcUpDownStream(EmissionsByYearsTest3);
Order = {'Base Year','No Policy - 2035', 'Chosen Scenario - 2035'};

y = [NoPolicy{1:11,1}, NoPolicy{1:11,19}, Scenario2{1:11,19}];
y = y';
x = categorical({'Base Year','No Policy - 2035', 'Chosen Scenario - 2035'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors1Em(i, :));
end

ylim([0 270])
title('Emissions', 'FontSize', 14,'Position', [2.5, 275, 0]);
xticklabels(Order);
xtickangle(20);
xlabel('Scenarios', 'FontSize', 20);

ylabel('MtCO2Eq', 'FontSize', 20);
legend(flip(b), flip(NoPolicy.Properties.RowNames(1:11)), 'FontSize',8,'Location','northwest')


AreaSum1 = sortrows(AreaSum1,1,'descend'); 
WaterSum1 = sortrows(WaterSum1,1,'descend');
CostsSum1 = sortrows(CostsSum1,1,'descend');
AreaSum1(1, :) = [];
WaterSum1(1, :) = [];
CostsSum1(1, :) = [];
AreaSum3 = sortrows(AreaSum3,1,'descend');
WaterSum3 = sortrows(WaterSum3,1,'descend');
CostsSum3 = sortrows(CostsSum3,1,'descend');
AreaSum3(1, :) = [];
WaterSum3(1, :) = [];
CostsSum3(1, :) = [];

nexttile

Order = {'Base Year','No Policy - 2035', 'Chosen Scenario - 2035'};
y = [AreaSum1{1:4,1}, AreaSum1{1:4,19}, AreaSum3{1:4,19}];
y = y';
x = categorical({'Base Year','No Policy - 2035', 'Chosen Scenario - 2035'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');
for i = 1:numel(b)
    set(b(i), 'FaceColor', colors2Area(i, :));
end
 
ylim([0 85000])
title('Area', 'FontSize',14,'Position', [2.5, 86296, 0]);
xticklabels(Order);
xtickangle(20);
xlabel('Scenarios', 'FontSize', 20);
ylabel('km^2', 'FontSize', 20);
legend(flip(b), flip(AreaSum3.Properties.RowNames(1:4)), 'FontSize',10,'Location','northwest')

Order = {'Base Year','No Policy - 2035', 'Chosen Scenario - 2035'};
y = [WaterSum1{1:5,1}, WaterSum1{1:5,19}, WaterSum3{1:5, 19}];
y = y';
x = categorical({'Base Year','No Policy - 2035', 'Chosen Scenario - 2035'});
x = reordercats(x, Order);
nexttile
b = bar(x, y, 'stacked');

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors3Water(i, :));
end

ylim([0 7500]) 
title('Water', 'FontSize', 14,'Position', [2.5, 7638, 0]);
xlabel('Scenarios', 'FontSize', 20);
xticklabels(Order);
xtickangle(20);
ylabel('Million m^3', 'FontSize', 20);
legend(flip(b), flip(WaterSum3.Properties.RowNames(1:5)), 'FontSize',10,'Location','northwest')


%% NEW NEW NEW - LOCAL 2035
% only local emissions, base year and 2035 by chosen scenario.

% Arranging the data and building the graph

colors1Em = [
    0.902, 0.373, 0.145; % electricity 
    0.949, 0.737, 0.239;  % transportaion - L
    0.784, 0.910, 0.690; % food - L 
    0.871, 0.761, 0.941; % construction - L 
    0.302, 0.749, 0.929; % water - L
    0.361, 0.325, 0.325; % fuels - L
];
 
 
NoPolicy = CalcUpDownStream(EmissionsByYearsTest1);
Scenario2 = CalcUpDownStream(EmissionsByYearsTest3); 
Order = {'Base Year - 2017', 'No Policy - 2035', 'Chosen Scenario - 2035'};

%y = [NoPolicy{1:11,1}, NoPolicy{1:11,34}, Scenario1{1:11,34}, Scenario2{1:11,34}];
y = [NoPolicy{1:2:11,1}, NoPolicy{1:2:11,19}, Scenario2{1:2:11,19}];

y = y';
x = categorical({'Base Year - 2017', 'No Policy - 2035', 'Chosen Scenario - 2035'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors1Em(i, :));
end

ylim([0 140])
title('Emissions - Local', 'FontSize', 14,'Position', [2, 145, 0]);
xticklabels(Order);
xtickangle(20);
xlabel('Scenarios', 'FontSize', 20);

ylabel('MtCO2Eq', 'FontSize', 20);
legend(flip(b), flip(NoPolicy.Properties.RowNames(1:2:11)), 'FontSize',8,'Location','northwest')



%% NEW NEW NEW - GLOBAL 2035
% only global emissions, base year and 2035 by chosen scenario.

% Arranging the data and building the graph

colors1Em = [
    0.6353, 0.0824, 0.1843
    0.7098, 0.5333, 0.1765
    0.4314, 0.6196, 0.4627
    0.4941, 0.3490, 0.6039
    0.0039, 0.4471, 0.7451
];
 
 
NoPolicy = CalcUpDownStream(EmissionsByYearsTest1);
Scenario2 = CalcUpDownStream(EmissionsByYearsTest3); 
Order = {'Base Year - 2017', 'No Policy - 2035', 'Chosen Scenario - 2035'};

%y = [NoPolicy{1:11,1}, NoPolicy{1:11,34}, Scenario1{1:11,34}, Scenario2{1:11,34}];
y = [NoPolicy{2:2:11,1}, NoPolicy{2:2:11,19}, Scenario2{2:2:11,19}];

y = y';
x = categorical({'Base Year - 2017', 'No Policy - 2035', 'Chosen Scenario - 2035'});
x = reordercats(x, Order);
b = bar(x, y, 'stacked');

for i = 1:numel(b)
    set(b(i), 'FaceColor', colors1Em(i, :));
end

ylim([0 140])
title('Emissions - Global', 'FontSize', 14,'Position', [2, 145, 0]);
xticklabels(Order);
xtickangle(20);
xlabel('Scenarios', 'FontSize', 20);

ylabel('MtCO2Eq', 'FontSize', 20);
legend(flip(b), flip(NoPolicy.Properties.RowNames(2:2:11)), 'FontSize',8,'Location','northwest')

%% %% NEW NEW NEW - Sensitivity +-10%
DeltaCell = cell(2, 19); % Initialize DeltaCell as a 2x19 cell array

for i = 1:2
    for j = RelevantScenarios 
        currentTable = SensitivityAnalysisCell{i, j}; % Extract the table from the current cell - each table is for a specific factor
        sumValue = sum(currentTable(1:11, 19)); % total emissions
        
        DeltaCell{i, j} = sumValue;
    end
end

rowNames = SensitivityAnalysisTable.Properties.RowNames;
colNames = SensitivityAnalysisTable.Properties.VariableNames;
DeltaTable = cell2table(DeltaCell, 'VariableNames', colNames);


% Presenting te data as numbers:
UpdatedData = cell(size(DeltaTable));

for row = 1:size(DeltaTable, 1)
    for col = 1:size(DeltaTable, 2)
        % Check if the cell is not empty and is a table
        if ~isempty(DeltaTable{row, col}) && istable(DeltaTable{row, col})
            number = DeltaTable{row, col}.Variables;
            UpdatedData{row, col} = number;
        end
    end
end

% Convert the cell array to a table
UpdatedDeltaTable = cell2table(UpdatedData);
UpdatedDeltaTable.Properties.RowNames = rowNames;
UpdatedDeltaTable.Properties.VariableNames = DeltaTable.Properties.VariableNames;
disp(UpdatedDeltaTable);
