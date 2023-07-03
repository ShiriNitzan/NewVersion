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

