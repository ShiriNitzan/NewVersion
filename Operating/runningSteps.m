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

        for i = 1:ScenarioNumber
            OnlyOneStepScenariosTable = AllButOneChangesByScenarios(DataBase, i, Years, ScenariosAndValues{:,scenarioIndex}, 'OnlyOne', true);
            [EmissionsByYears, ConsumptionAmounts, Resources, WaterFromFood] = FullScenario(DataBase, OnlyOneStepScenariosTable, Years,population);   
            EmissionsSumCurrentBase = EmissionsSumCalcOnlyOneStep(EmissionsByYears,Years);
        
            GlobalLocalEmissions = CalcGlobalLocal(EmissionsByYears);
            GlobalDiff = sum(GlobalLocalEmissions{2,width(GlobalLocalEmissions)}{1,:}) - sum(GlobalLocalEmissions{2,1}{1,:});
            LocalDiff = sum(GlobalLocalEmissions{1,width(GlobalLocalEmissions)}{1,:}) - sum(GlobalLocalEmissions{1,1}{1,:});
            
             if i == 1
              localWaterForFood = sum(WaterFromFood{1,width(WaterFromFood)}{1,1:2})/1000000;
             end
   
            [WaterSumCurrent, GlobalWaterDiff, LocalWaterDiff] = WaterSumCalcOnlyOne(ConsumptionAmounts, WaterFromFood,localWaterForFood);
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
        disp('Only one step');
        
    case 3 %% All steps but one
        
        AllButOneScenariosTable = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,scenarioIndex});
        [EmissionsByYearsFull, ConsumptionAmountsFull, ResourcesFull, WaterFromFoodFull] = FullScenario(DataBase, AllButOneScenariosTable, Years, population);
        GlobalLocalEmissionsFull = CalcGlobalLocal(EmissionsByYearsFull);
        for i = 1:ScenarioNumber  
            AllButOneScenariosTable = AllButOneChangesByScenarios(DataBase, i, Years, ScenariosAndValues{:,scenarioIndex});
            [EmissionsByYears, ConsumptionAmounts, Resources, WaterFromFood] = FullScenario(DataBase, AllButOneScenariosTable, Years, pop);
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
        disp('All steps but one');
      
    case 4 %% All the steps together
        [FullScenariosTable1] = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,4}, 'MileStones', false);
        [EmissionsByYearsTest1, ConsumptionAmounts1, Resources1] = FullScenario(DataBase, FullScenariosTable1,Years,population);
    
        [FullScenariosTable2] = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,7}, 'MileStones', false);
        [EmissionsByYearsTest2, ConsumptionAmounts2, Resources2] = FullScenarioCompare(DataBase, FullScenariosTable2,Years,population,EmissionsByYearsTest1);

        [FullScenariosTable3] = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,8}, 'MileStones', false);
        [EmissionsByYearsTest3, ConsumptionAmounts3, Resources3] = FullScenarioCompare(DataBase, FullScenariosTable3,Years,population,EmissionsByYearsTest1);
        


        disp('All the steps together');

      
    case 5 %% Buisness as usual
        FullBAUScenariosTable = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,4});
        [EmissionsByYearsBAU, ConsumptionAmountsBAU] = FullScenario(DataBase, FullBAUScenariosTable, Years);
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
                  [EmissionsTable, ConsumptioTable, Resources] = FullScenario(DataBase, ScenariosTable, Years,population);
                  SensitivityAnalysisCell{1, l} = EmissionsTable;
                  SensitivityAnalysisCell{2, l} = ConsumptioTable;
                  SensitivityAnalysisCell{3, l} = Resources;
                  l = l+1;
            end
        end   
        disp('SensitivityAnalysis');
end

beep;