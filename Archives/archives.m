%% main
% -------------Sensitivity analysis/preparitons
PopulationGrowth = {0, 0.45, 0.9};
ElectricityPerCapita = {0, 0.2, 0.41};
DesalinatedWater = {0,1.32,2.64};
%   case 5 %% renewable energies
%   case 7 %% Sensitivity Analysis
        ScenariosAndValues{6,5} = 1;
        OtherScenarioTable = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,5});
        [EmissionsByYearsOther, ConsumptionAmountsOther] = FullScenario(DataBase, OtherScenarioTable, Years);
        YearlyEmissionsOther = YearlySumCalc(EmissionsByYearsOther);
        
        ScenariosAndValues{14,5} = 0;

        OtherScenarioTable = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,5});
        [EmissionsByYearsOtherNoElectric, ConsumptionAmountsOtherNoElectric] = FullScenario(DataBase, OtherScenarioTable, Years);
        YearlyEmissionsOtherNoElectric = YearlySumCalc(EmissionsByYearsOther);
       
%% test runs
[ValidaionLocalGlobal, ValidationTotalGlobalLocal] = CalcGlobalLocal(EmissionsByYearsTest);
ValidationUpDownStream = CalcUpDownStream(EmissionsByYearsTest);
ValidationEmissionsBySectors = TotalEmissionsBySectors(EmissionsByYearsTest);


function [a] = choiceList()
list = {'Manual Input','Only One Step','All But One',...                   
'All the steps together','Business as Usual', 'Sensitivity Analysis'};
a = listdlg('PromptString',{'Choose one of the scenarios and follow the instructions.',''},...
    'Name','Select a scenario',...
    'SelectionMode','single','ListString',list);
%% 

for i =2:Years 
    CurrentConsumption = array2table(zeros(1,8), 'VariableNames', ColNames);
    CurrentConsumption{1,1} = pop{3,i}*110.452; % Water for Domestic & Industrial
    CurrentConsumption{1,2} = pop{3,i}*waterData{1,i}; % for agriculture
    CurrentConsumption{1,3} = pop{4,i}*20.31282+90; % Water for Neighbors
    CurrentConsumption{1,4} = waterData{2,i}; %% for Nature
    CurrentConsumption{1,5} = waterData{3,i}; %% natural from
    CurrentConsumption{1,6} = 0.66*CurrentConsumption{1,1}; %% WasteWater from
    CurrentConsumption{1,7} = 250; %% Brackish water, fresh and non-fresh reservoir water
    CurrentConsumption{1,8} = CurrentConsumption{1,1}*0.898904 + CurrentConsumption{1,2}*0.35 + CurrentConsumption{1,3} - CurrentConsumption{1,5}; %% desalinated from
    if i == 6 % Adjustment to the water model data for 2022, until all the data in the software is updated
        CurrentConsumption{1,1} = 1070;
        CurrentConsumption{1,2} = 1300;
        CurrentConsumption{1,3} = 190;
        CurrentConsumption{1,4} = 25;
        CurrentConsumption{1,5} = 1080;
        CurrentConsumption{1,6} = 636;
        CurrentConsumption{1,7} = 250;
        CurrentConsumption{1,8} = 524;  
    end
   
    WaterConsumptionCell{i} =  CurrentConsumption;
end


%% results
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
%% from consumption changes
%%Water Consumption
WaterConsumptionCell = Data.WaterConsumptionCell;

RowNames = {'Agriculture', 'Marginal Water Percentage', 'Home Consumption(Urban)', 'Industry', 'Water for Nature', 'Water for Neighbors'};
    ColNames = {'for home', 'for agriculture', 'for Neighbors', 'for Nature', 'natural from', 'clear from', 'other from', 'desalit from'};
Initialization = WaterConsumptionCell{1}{:,1:5};

for i =1:Years 
    %%CurrentConsumption = array2table(zeros(6,5), 'RowNames', RowNames);
    CurrentConsumption = array2table(zeros(1,8), 'VariableNames', ColNames);
  %%CurrentConsumption{:,1} = Initialization(:,1)*1; %% from nature
 CurrentConsumption{1,1} = Initialization(:,1)*(PrecentegeByTheYears(i)); %% from nature
    CurrentConsumption{:,2} = Initialization(:,2); %% deslinated - only from scenario
    CurrentConsumption{:,3} = Initialization(:,3)*(PrecentegeByTheYears(i)); %% all but desalinated
    CurrentConsumption{:,4} = Initialization(:,4)*(PrecentegeByTheYears(i)); %% all but desalinated
    CurrentConsumption{:,5} = Initialization(:,5)*(PrecentegeByTheYears(i)); %% all but desalinated
    ColNames = {'Water From Nature','Diselinated Water','Brackish Water','Treated WasteWater','Flood Water'};
    CurrentConsumption.Properties.VariableNames = ColNames;
    WaterConsumptionCell{i} =  CurrentConsumption;
end
%% { change in diselinated water consumption - scenario 3  - not useful 
    for i =1:Years
        DiselinatedWaterConsumption = WaterConsumptionCell{i}{:,2};
        DiselinatedWaterConsumption = DiselinatedWaterConsumption*IncreaseInDiselinatedWater(i);
        WaterConsumptionCell{i}{:,2} = DiselinatedWaterConsumption;
    end
  %%
  function [WaterSum, GlobalWaterDiff, LocalWaterDiff] = WaterSumCalcAllButOne(AllButOneScenario,FullScenario, WaterFromFood, WaterFromFoodFull)
   WaterForAllButOneScenario = sum(AllButOneScenario{1,width(AllButOneScenario)}{1,1}{1,:});
   WaterForFullScenario = sum(FullScenario{1,width( )}{1,1}{1,:});
   WaterSum = WaterForFullScenario - WaterForAllButOneScenario; %% m^3*10^6

    GlobalWaterDiff = sum(WaterFromFoodFull{1,width(WaterFromFoodFull)}{1,3:4})/1000000 - sum(WaterFromFood{1,width(WaterFromFood)}{1,3:4})/1000000;
    LocalWaterDiff = (WaterForFullScenario - sum(WaterFromFoodFull{1,width(WaterFromFoodFull)}{1,3:4})/1000000)...
    -(WaterForAllButOneScenario - sum(WaterFromFood{1, width(WaterFromFood)}{1,3:4})/1000000);
end
%% Water Emissions
% from full scenrio
 WaterForFoodPercentages = Data.WaterForFoodPercentages;
    for i=1:Years
        WaterFromAgriculture = WaterForFoodPercentages*sum(WaterFromFoodCell{i}{1,1:2});
        WaterFromAgriculture = WaterForFoodPercentages*sum(WaterFromFoodCell{i}{1,1:4});probebly mistake that sum also global water to local water 
        WaterConsumptionCell{i}{1,1:5} = WaterFromAgriculture;
     WaterConsumptionCell{i}{1,2:5} = WaterFromAgriculture(1,2:5);
    end

for i=1:Years
    EmissionsByYears{11,i} = WaterFromFoodCell{i} ;
end
%% ConsumptionChanges
% function GrowthVector = GrowthVectorCalc(StartYear, EndYear, EndYearVal, StartYearVal)
% Period = EndYear-StartYear+1;
% GrowthVector = ones(1, Period);
% GrowthVector(1) = 1 + StartYearVal;
% GrowthVector(Period) = 1+EndYearVal; 
% FutureValue = GrowthVector(Period);
% Rate = nthroot(FutureValue/GrowthVector(1),Period-1);
%     for i = 1:Period
%         GrowthVector(i) = GrowthVector(1)*((Rate)^(i-1));
%     end
% end
