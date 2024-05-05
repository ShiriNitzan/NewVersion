%% running steps
 
orderIndex = choiceList('Select a scenario','Choose one of the scenarios and follow the instructions.',{'Manual Input','Only One Step','All But One','All the steps together','Business as Usual', 'Sensitivity Analysis'}); 
if (orderIndex ~= 1 && orderIndex ~= 4 && orderIndex ~= 5)
        scenarioIndex = choiceList('Select a scenario','Choose one of the scenarios',{'S1','S2','S3','Busnness as Usual','Othen_OnlyOne','Othen_AllButOne','Moderate','Advanced'});
end
switch orderIndex
    
    case 1 %% Manual changes
        ManualScenariosTable = ManualChangesByScenarios(DataBase);
        [EmissionsByYearsCurrent, ConsumptionAmountsCurrent] = FullScenario(DataBase, ManualScenariosTable, Years);
        EmissionsSumCurrent = EmissionsSumCalcOnlyOneStep(EmissionsByYearsCurrent,Years);
        disp('Manual changes');

    case 2 %% Only one step
   % each iteration calculates scenario i.
        for i = 1:ScenarioNumber
            OnlyOneStepScenariosTable = AllButOneChangesByScenarios(DataBase, i, Years, ScenariosAndValues{:,scenarioIndex}, 'OnlyOne', true);
            [population] = populationCal(OnlyOneStepScenariosTable);
            [EmissionsByYears, ConsumptionAmounts, Resources, WaterFromFood] = FullScenario(DataBase, OnlyOneStepScenariosTable, Years,population,orderIndex,i);   
            EmissionsSumCurrentBase = EmissionsSumCalcOnlyOneStep(EmissionsByYears,Years);
            GlobalLocalEmissions = CalcGlobalLocal(EmissionsByYears);
            GlobalDiff = sum(GlobalLocalEmissions{2,width(GlobalLocalEmissions)}{1,:}) - sum(GlobalLocalEmissions{2,1}{1,:});
            LocalDiff = sum(GlobalLocalEmissions{1,width(GlobalLocalEmissions)}{1,:}) - sum(GlobalLocalEmissions{1,1}{1,:});           
            [WaterSumCurrent, GlobalWaterDiff, LocalWaterDiff] = WaterSumCalcOnlyOne(ConsumptionAmounts, WaterFromFood,i);
            [AreaSumCurrent, GlobalAreaDiff, LocalAreaDiff] = AreaSumCalcOnlyOne(Resources); 
         
            %OnlyOneAnalysis{i,1} = EmissionsSumCurrentBase(1);
            OnlyOneAnalysis{i,1} = GlobalDiff+LocalDiff;
            OnlyOneAnalysis{i,2} = GlobalDiff;
            OnlyOneAnalysis{i,3} = LocalDiff;
            OnlyOneAnalysis{i,4} = WaterSumCurrent;
            OnlyOneAnalysis{i,5} = GlobalWaterDiff;
            OnlyOneAnalysis{i,6} = LocalWaterDiff;
            OnlyOneAnalysis{i,7} = AreaSumCurrent;
            OnlyOneAnalysis{i,8} = GlobalAreaDiff;
            OnlyOneAnalysis{i,9} = LocalAreaDiff;
        end
        disp('Only one step');
        
    case 3 %% All steps but one
        AllButOneScenariosTable = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,scenarioIndex});
        % will return 19X34 table, each cell is the change of this factor
        % for that year, when 2050 is dictated by "the three scenarios".
        [population] = populationCal(AllButOneScenariosTable);
        [EmissionsByYearsFull, ConsumptionAmountsFull, ResourcesFull, WaterFromFoodFull] = FullScenario(DataBase, AllButOneScenariosTable, Years, population,orderIndex,0);
        GlobalLocalEmissionsFull = CalcGlobalLocal(EmissionsByYearsFull);
        for i = 1:ScenarioNumber  
            AllButOneScenariosTable = AllButOneChangesByScenarios(DataBase, i, Years, ScenariosAndValues{:,scenarioIndex});
            [population] = populationCal(AllButOneScenariosTable);       
            [EmissionsByYears, ConsumptionAmounts, Resources, WaterFromFood] = FullScenario(DataBase, AllButOneScenariosTable, Years, population,orderIndex,0);
            CurrentEmissions = EmissionsSumCalcAllButOne(EmissionsByYears, EmissionsByYearsFull,Years);
            GlobalLocalEmissions = CalcGlobalLocal(EmissionsByYears);
            GlobalDiff = sum(GlobalLocalEmissionsFull{2,width(GlobalLocalEmissionsFull)}{1,:}) - sum(GlobalLocalEmissions{2,width(GlobalLocalEmissions)}{1,:});
            LocalDiff = sum(GlobalLocalEmissionsFull{1,width(GlobalLocalEmissionsFull)}{1,:}) - sum(GlobalLocalEmissions{1,width(GlobalLocalEmissions)}{1,:});
            [CurrentWater, GlobalWaterDiff, LocalWaterDiff] = WaterSumCalcAllButOne(ConsumptionAmounts, ConsumptionAmountsFull, WaterFromFood, WaterFromFoodFull);
            [CurrentArea, GlobalAreaDiff, LocalAreaDiff] = AreaSumCalcAllButOne(Resources, ResourcesFull);
       
            %AllButOneAnalysis{i,1} = CurrentEmissions;
            AllButOneAnalysis{i,1} = GlobalDiff+LocalDiff;
            AllButOneAnalysis{i,2} = GlobalDiff;
            AllButOneAnalysis{i,3} = LocalDiff;
            AllButOneAnalysis{i,4} = CurrentWater;
            AllButOneAnalysis{i,5} = GlobalWaterDiff;
            AllButOneAnalysis{i,6} = LocalWaterDiff;
            AllButOneAnalysis{i,7} = CurrentArea;
            AllButOneAnalysis{i,8} = GlobalAreaDiff;
            AllButOneAnalysis{i,9} = LocalAreaDiff;
        end
        disp('All steps but one');
      
    case 4 %% All the steps together
  % calculates 3 times: for BAU, MODERATE, ADVANCED
  % first table: change in precentage for each parameter by the years.
  % second table: population size per year, seperationg israel and the palestinians.
  % returns: total Co2 by category, amounts of water/fuels/construction materials, all other resources by category, water for food.

        [FullScenariosTable1] = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,4}, 'MileStones', false);
        [population] = populationCal(FullScenariosTable1);
        [EmissionsByYearsTest1, ConsumptionAmounts1, Resources1, WaterFromFood1] = FullScenario(DataBase, FullScenariosTable1,Years,population,orderIndex,0);
    
        [FullScenariosTable2] = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,7}, 'MileStones', false);
        [population] = populationCal(FullScenariosTable2);
        [EmissionsByYearsTest2, ConsumptionAmounts2, Resources2, WaterFromFood2] = FullScenarioCompare(DataBase, FullScenariosTable2,Years,population,WaterFromFood1,orderIndex);

        [FullScenariosTable3] = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,8}, 'MileStones', false);
        [population] = populationCal(FullScenariosTable3);
        [EmissionsByYearsTest3, ConsumptionAmounts3, Resources3, WaterFromFood3] = FullScenarioCompare(DataBase, FullScenariosTable3,Years,population,WaterFromFood1,orderIndex);
        


        disp('All the steps together');

      
    case 5 %% Buisness as usual
        FullBAUScenariosTable = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,4});
        [EmissionsByYearsBAU, ConsumptionAmountsBAU,ResourcesBAU, WaterFromFoodBAU] = FullScenario(DataBase, FullBAUScenariosTable, Years,population,orderIndex,0);
     
        YearlyEmissionsBAU = YearlySumCalc(EmissionsByYearsBAU);
        disp('Buisness as usual');
            

    case 6 %% SensitivityAnalysis
        SensitivityAnalysisCell = cell(3, 3*3);
        l = 1;
        for i = 1:3
            for j = 1:3
                  ScenariosAndValues{1,scenarioIndex} =  PopulationGrowth{1,i};
                  ScenariosAndValues{2,scenarioIndex} =  ElectricityPerCapita{1,j};
                  ScenariosAndValues{3,scenarioIndex} =  DesalinatedWater{1,i};
                  ScenariosTable = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,scenarioIndex}, 'MileStones', false);
                  [population] = populationCal(ScenariosTable);
                  [EmissionsTable, ConsumptioTable, Resources] = FullScenario(DataBase, ScenariosTable, Years,population,orderIndex,0);
                  SensitivityAnalysisCell{1, l} = EmissionsTable;
                  SensitivityAnalysisCell{2, l} = ConsumptioTable;
                  SensitivityAnalysisCell{3, l} = Resources;
                  l = l+1;
            end
        end   
        disp('SensitivityAnalysis');
end

beep;