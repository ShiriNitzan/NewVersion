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


