%% Read Files
addpath("Scenarios");
addpath("CalcFunctions");
addpath("UI");
addpath("Data");

Data = "Data.xlsx";
TargetYear = 2050;
BaseYear = 2017;
Years = TargetYear-BaseYear+1;
ScenariosAndValues = readtable("The Three Scenarios.xlsx",'Sheet','Scenarios','Range','A1:I20','ReadRowNames',true,'ReadVariableNames',true);
ReadValues;
TechnologicalImprovements;
%% Preparations

RowNames = {'Population Growth', 'Increase In Electricity Per Capita', 'Increase in Desalinated Water', 'Reducing Beef Consumption', 'Preventing Food Loss', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', 'Reducing Mileage', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
AllButOneAnalysis = array2table(zeros(height(ScenariosAndValues),9));
AllButOneAnalysis.Properties.RowNames = RowNames;
AllButOneAnalysis.Properties.VariableNames = {'Emissions', 'Emissions - Global', 'Emissions - Local', 'Water', 'Water - Local', 'Water - Global', 'Area', 'Area - Global', 'Area - Local'};
OnlyOneAnalysis = array2table(zeros(height(ScenariosAndValues),9));
OnlyOneAnalysis.Properties.RowNames = RowNames;
OnlyOneAnalysis.Properties.VariableNames = {'Emissions', 'Emissions - Global', 'Emissions - Local', 'Water', 'Water - Local', 'Water - Global', 'Area', 'Area - Global', 'Area - Local'};
%-------------Sensitivity analysis
PopulationGrowth = {0, 0.45, 0.9};
ElectricityPerCapita = {0, 0.2, 0.41};
DesalinatedWater = {0,1.32,2.64};

%% Read Changes By Scenarios

ScenarioNumber = 19;
defvalues = {'1'};
prompt = "For Manual Input - 1 "+ newline + "For Only One Step - 2 " + newline + "For All But One - 3" + newline + "Activate Subsets with Milestones - 4" + newline +"For Renewable Energy Scenarios - 5" + newline + "For Business as Usual - 6" + newline + "Other - 7";
dims = [1 50];
answer = inputdlg(prompt,...
              'Choose an Option',dims, defvalues, 'on');
index = str2double(answer); 

switch index
    
    case 1 %% manual changes
    
        ManualScenariosTable = ManualChangesByScenarios(Data);
        [EmissionsByYearsCurrent, ConsumptionAmountsCurrent] = FullScenario(DataBase, ManualScenariosTable, Years);
        EmissionsSumCurrent = EmissionsSumCalc(EmissionsByYearsCurrent,Years);
        
    case 2 %% only one step
        for i = 1:ScenarioNumber
            OnlyOneStepScenariosTable = AllButOneChangesByScenarios(DataBase, i, Years, ScenariosAndValues{:,7}, 'OnlyOne', true);
            [EmissionsByYears, ConsumptionAmounts, Resources, WaterFromFood] = FullScenario(DataBase, OnlyOneStepScenariosTable, Years);   
            EmissionsSumCurrentBase = EmissionsSumCalcOnlyOneStep(EmissionsByYears,Years);
            GlobalLocalEmissions = CalcGlobalLocal(EmissionsByYears);
            GlobalDiff = sum(GlobalLocalEmissions{2,width(GlobalLocalEmissions)}{1,:}) - sum(GlobalLocalEmissions{2,1}{1,:});
            LocalDiff = sum(GlobalLocalEmissions{1,width(GlobalLocalEmissions)}{1,:}) - sum(GlobalLocalEmissions{1,1}{1,:});
            [WaterSumCurrent, GlobalWaterDiff, LocalWaterDiff] = WaterSumCalcOnlyOne(ConsumptionAmounts, WaterFromFood);
            [AreaSumCurrent, GlobalAreaDiff, LocalAreaDiff] = AreaSumCalcOnlyOne(Resources);
            OnlyOneAnalysis{i,1} = EmissionsSumCurrentBase(1);
            OnlyOneAnalysis{i,2} = GlobalDiff;
            OnlyOneAnalysis{i,3} = LocalDiff;
            OnlyOneAnalysis{i,4} = WaterSumCurrent;
            OnlyOneAnalysis{i,5} = GlobalWaterDiff;
            OnlyOneAnalysis{i,6} = LocalWaterDiff;
            OnlyOneAnalysis{i,7} = AreaSumCurrent;
            OnlyOneAnalysis{i,8} = GlobalAreaDiff;
            OnlyOneAnalysis{i,9} = LocalAreaDiff;
        end
        
    case 3 %% all steps but one
        AllButOneScenariosTable = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,7});
        [EmissionsByYearsFull, ConsumptionAmountsFull, ResourcesFull, WaterFromFoodFull] = FullScenario(DataBase, AllButOneScenariosTable, Years);
        GlobalLocalEmissionsFull = CalcGlobalLocal(EmissionsByYearsFull);
        for i = 1:ScenarioNumber  
            AllButOneScenariosTable = AllButOneChangesByScenarios(DataBase, i, Years, ScenariosAndValues{:,7});
            [EmissionsByYears, ConsumptionAmounts, Resources, WaterFromFood] = FullScenario(DataBase, AllButOneScenariosTable, Years);
            CurrentEmissions = EmissionsSumCalcAllButOne(EmissionsByYears, EmissionsByYearsFull,Years);
            GlobalLocalEmissions = CalcGlobalLocal(EmissionsByYears);
            GlobalDiff = sum(GlobalLocalEmissionsFull{2,width(GlobalLocalEmissionsFull)}{1,:}) - sum(GlobalLocalEmissions{2,width(GlobalLocalEmissions)}{1,:});
            LocalDiff = sum(GlobalLocalEmissionsFull{1,width(GlobalLocalEmissionsFull)}{1,:}) - sum(GlobalLocalEmissions{1,width(GlobalLocalEmissions)}{1,:});
            [CurrentWater, GlobalWaterDiff, LocalWaterDiff] = WaterSumCalcAllButOne(ConsumptionAmounts, ConsumptionAmountsFull, WaterFromFood, WaterFromFoodFull);
            [CurrentArea, GlobalAreaDiff, LocalAreaDiff] = AreaSumCalcAllButOne(Resources, ResourcesFull);
            AllButOneAnalysis{i,1} = CurrentEmissions;
            AllButOneAnalysis{i,2} = GlobalDiff;
            AllButOneAnalysis{i,3} = LocalDiff;
            AllButOneAnalysis{i,4} = CurrentWater;
            AllButOneAnalysis{i,5} = GlobalWaterDiff;
            AllButOneAnalysis{i,6} = LocalWaterDiff;
            AllButOneAnalysis{i,7} = CurrentArea;
            AllButOneAnalysis{i,8} = GlobalAreaDiff;
            AllButOneAnalysis{i,9} = LocalAreaDiff;
        end
      
    case 4 %% all the steps together

        [FullScenariosTable1] = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,7}, 'MileStones', true);
        [EmissionsByYearsTest1, ConsumptionAmounts1, Resources1] = FullScenario(DataBase, FullScenariosTable1,Years);
    
        [FullScenariosTable2] = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,7}, 'MileStones', true);
        [EmissionsByYearsTest2, ConsumptionAmounts2, Resources2] = FullScenario(DataBase, FullScenariosTable2,Years);

        [FullScenariosTable3] = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,7}, 'MileStones', true);
        [EmissionsByYearsTest3, ConsumptionAmounts3, Resources3] = FullScenario(DataBase, FullScenariosTable3,Years);
    case 5 %% renewable energies
       
    case 6 %% buisness as usual
        FullBAUScenariosTable = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,4});
        [EmissionsByYearsBAU, ConsumptionAmountsBAU] = FullScenario(DataBase, FullBAUScenariosTable, Years);
        YearlyEmissionsBAU = YearlySumCalc(EmissionsByYearsBAU);
    
    case 7 %% Sensitivity Analysis
        ScenariosAndValues{6,5} = 1;
        OtherScenarioTable = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,5});
        [EmissionsByYearsOther, ConsumptionAmountsOther] = FullScenario(DataBase, OtherScenarioTable, Years);
        YearlyEmissionsOther = YearlySumCalc(EmissionsByYearsOther);
        
        ScenariosAndValues{14,5} = 0;

        OtherScenarioTable = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,5});
        [EmissionsByYearsOtherNoElectric, ConsumptionAmountsOtherNoElectric] = FullScenario(DataBase, OtherScenarioTable, Years);
        YearlyEmissionsOtherNoElectric = YearlySumCalc(EmissionsByYearsOther);

    case 8
        SensitivityAnalysisCell = cell(1, 3*3);
        l = 1;
        for i = 1:3
            for j = 1:3
                  ScenariosAndValues{1,7} =  PopulationGrowth{1,i};
                  ScenariosAndValues{2,7} =  ElectricityPerCapita{1,j};
                  ScenariosAndValues{3,7} =  DesalinatedWater{1,i};
                  ScenariosTable = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,7}, 'MileStones', false);
                  [EmissionsTable, ConsumptioTable, Resources] = FullScenario(DataBase, ScenariosTable, Years);
                  SensitivityAnalysisCell{1, l} = EmissionsTable;
                  l = l+1;
            end
        end   
end

%% Only 2017
t = tiledlayout(1,3);
BySectors = CalcUpDownStream(EmissionsByYearsTest1);
[AreaSum1, CostsSum1, WaterSum1] = CalcTotalResources(Resources1, ConsumptionAmounts1);
AreaSum1 = sortrows(AreaSum1,1,'descend');
WaterSum1 = sortrows(WaterSum1,1,'descend');
AreaSum1(1, :) = [];
WaterSum1(1, :) = [];
AreaSum1(4, :) = [];

x1 = categorical({'All Sectors'});
y1 = zeros(1, 7); 
y1(1,:) = BySectors{1:7,1};
ax1 = nexttile;
b1 = bar(x1,y1,'Stacked');
ylim ([0 110])
ylabel('MtCO2Eq', 'FontSize', 20);
legend(ax1, flip(b1), flip(BySectors.Properties.RowNames(1:7,1)), 'FontSize',16,'Location','northeast')
a1 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a1,'fontsize',20)
title('Emissions',  'FontSize', 28);
ytips1 = zeros(1, length(b1));
for i = 1:length(b1)
    ytips1(i) = b1(i).YEndPoints;
end
ytxt1 = round(y1./repmat(sum(y1,2),1,size(y1,2))*100);
ytxt1 = num2cell(ytxt1);
ytxt1 = cellfun(@(x1) [sprintf('%0.0f',x1), '%'], ytxt1,'UniformOutput', false);
xtips1 = zeros(1, length(b1));
for i = 1:length(b1)
    xtips1(i) = b1(i).XEndPoints;
end
text(xtips1,ytips1,ytxt1,'HorizontalAlignment','left','VerticalAlignment','top', 'FontSize', 14);


x2 = categorical({'All Sectors'});
y2 = zeros(1, 3);
y2(1,:) = AreaSum1{1:3,1};
nexttile
b2 = bar(x2,y2,'Stacked');
ylim([0 35000])
ylabel('Km^2', 'FontSize', 20);
legend(flip(b2), flip(AreaSum1.Properties.RowNames(1:3,1)), 'FontSize',16,'Location','northwest')
a2 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a2,'fontsize',20)
title('Area',  'FontSize', 28);
ytips2 = zeros(1, length(b2));
for i = 1:length(b2)
    ytips2(i) = b2(i).YEndPoints;
end
ytxt2 = round(y2./repmat(sum(y2,2),1,size(y2,2))*100);
ytxt2 = num2cell(ytxt2);
ytxt2 = cellfun(@(x) [sprintf('%0.0f',x), '%'], ytxt2,'UniformOutput', false);
xtips2 = zeros(1, length(b2));
for i = 1:length(b2)
    xtips2(i) = b2(i).XEndPoints;
end
text(xtips2,ytips2,ytxt2, 'HorizontalAlignment','left','VerticalAlignment','top', 'FontSize', 14);

nexttile
x3 = categorical({'All Sectors'});
y3 = zeros(1, 4); 
y3(1,:) = WaterSum1{1:4,1};
b3 = bar(x3,y3,'Stacked');
ylim([0 2700])
ylabel('Million M^3', 'FontSize', 20);
legend(flip(b3), flip(WaterSum1.Properties.RowNames(1:4,1)), 'FontSize',16,'Location','north')
a3 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a3,'fontsize',20)
title('Water',  'FontSize', 28);
precents = y3(1,:)./sum(y3(1,:));
ytips3 = zeros(1, length(b3));
for i = 1:length(b3)
    ytips3(i) = b3(i).YEndPoints;
end
ytxt3 = round(y3./repmat(sum(y3,2),1,size(y3,2))*100);
ytxt3 = num2cell(ytxt3);
ytxt3 = cellfun(@(x) [sprintf('%0.0f',x), '%'], ytxt3,'UniformOutput', false);
xtips3 = zeros(1, length(b3));
for i = 1:length(b3)
    xtips3(i) = b3(i).XEndPoints;
end
text(xtips3,ytips3,ytxt3,'HorizontalAlignment','left','VerticalAlignment','top', 'FontSize', 14);