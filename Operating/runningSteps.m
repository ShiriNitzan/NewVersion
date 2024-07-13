%% running steps

orderIndex = choiceList('Select a scenario','Choose one of the scenarios and follow the instructions.',{'Manual Input','Only One Step','All But One','All the steps together','Business as Usual', 'Sensitivity Analysis', 'All the steps together - new scenario table', 'Sensitivity Analysis +- 10%'});
if (orderIndex ~= 1 && orderIndex ~= 4 && orderIndex ~= 5  && orderIndex ~= 7 &&  orderIndex ~= 8)
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
            % returns a table where only the i row changes

            [population] = populationCal(OnlyOneStepScenariosTable);
            [EmissionsByYears, ConsumptionAmounts, Resources, WaterFromFood] = FullScenario(DataBase, OnlyOneStepScenariosTable, Years,population,orderIndex,i);
            EmissionsSumCurrentBase = EmissionsSumCalcOnlyOneStep(EmissionsByYears,Years);
            GlobalLocalEmissions = CalcGlobalLocal(EmissionsByYears);
            GlobalDiff = sum(GlobalLocalEmissions{2,width(GlobalLocalEmissions)}{1,:}) - sum(GlobalLocalEmissions{2,1}{1,:});
            % total emissions of 2050 minus total of 2017 - GLOBAL
            LocalDiff = sum(GlobalLocalEmissions{1,width(GlobalLocalEmissions)}{1,:}) - sum(GlobalLocalEmissions{1,1}{1,:});
            % total emissions of 2050 minus total of 2017 - LOCAL

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

    case 4  %% All the steps together
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
        l = 1; %index that marks in which combination we are (for 3 options of 2 categories)
        for i = 1:3
            for j = 1:3
                % in each iteration: changing the pop-growth to 0/45%/90%
                ScenariosAndValues{1,scenarioIndex} =  PopulationGrowth{1,i};
                % in each iteration: changing the electricity consumption to 0/20%/41%
                ScenariosAndValues{2,scenarioIndex} =  ElectricityPerCapita{1,j};
                % in each iteration: changing the desalination to 0/132%/264%, matching the population growth.
                ScenariosAndValues{3,scenarioIndex} =  DesalinatedWater{1,i};
                ScenariosTable = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,scenarioIndex}, 'MileStones', false);
                % ScenariosTable will be the same as the THREE SCENARIOS
                % table, except rows 1-3 (poplation, electricity, desalination)
                [population] = populationCal(ScenariosTable);
                [EmissionsTable, ConsumptioTable, Resources] = FullScenario(DataBase, ScenariosTable, Years,population,orderIndex,0);
                SensitivityAnalysisCell{1, l} = EmissionsTable;
                SensitivityAnalysisCell{2, l} = ConsumptioTable;
                SensitivityAnalysisCell{3, l} = Resources;
                l = l+1;
            end
        end
        disp('SensitivityAnalysis');

    case 7  % All the steps together - WITH NEW SCENARIO VALUES

        % NOTE: MUST RE-RUN THE WHOLE MainSystem FOR THIS PART!

        % NO POLICY
        [FullScenariosTable1] = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,4}, 'MileStones', false);
        [population] = populationCal(FullScenariosTable1);
        [EmissionsByYearsTest1, ConsumptionAmounts1, Resources1, WaterFromFood1] = FullScenario(DataBase, FullScenariosTable1,Years,population,orderIndex,0);
        Years = 19; % for 2035
        EmissionsByYearsTest1 = EmissionsByYearsTest1(:,1:Years);
        ConsumptionAmounts1 = ConsumptionAmounts1(:,1:Years);
        Resources1 = Resources1(:,1:Years);
        WaterFromFood1 = WaterFromFood1(:,1:Years);

        % NEW POLICY
        [FullScenariosTable3] = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,9}, 'MileStones', false);
        [population] = populationCal(FullScenariosTable3);
        [EmissionsByYearsTest3, ConsumptionAmounts3, Resources3, WaterFromFood3] = FullScenarioCompare(DataBase, FullScenariosTable3,Years,population,WaterFromFood1,orderIndex);

    case 8 % Sensitivity Analysis - +- 10%

        % preperations: define the new scenario precentages and the year.
        Years = 19; % for 2035
        RelevantScenarios = [1, 2, 4, 5, 6, 7, 8, 12, 13, 14, 15, 16, 17, 19, 20];  % only choosing interesting scenarios
        rowNames = ScenariosAndValues.Properties.RowNames;
        RelevantScenarioNames = rowNames(RelevantScenarios);

        SensitivityAnalysisCell = cell(2, height(ScenariosAndValues));
        TotalEmissionByScenarioChanged = array2table(zeros(3, length(RelevantScenarios)), 'VariableNames', RelevantScenarioNames, 'RowNames', {'as is', '+0.1', '-0.1'});
        TotalAreaByScenarioChanged = array2table(zeros(3, length(RelevantScenarios)), 'VariableNames', RelevantScenarioNames, 'RowNames', {'as is', '+0.1', '-0.1'});
        TotalWaterByScenarioChanged = array2table(zeros(3, length(RelevantScenarios)), 'VariableNames', RelevantScenarioNames, 'RowNames', {'as is', '+0.1', '-0.1'});

        renewable_original = ScenariosAndValues{6,9};
        gas_original = ScenariosAndValues{7,9};
        % SensitivityAnalysisCell has 12 columns, each of them represent a different scenario.
        % the upper row is Original_Precentage - 10%_Bigger,  the lower row is Original_Precentage - 10%_Smaller

        for i = 1:length(RelevantScenarios)

            ScenarioIndex = RelevantScenarios(i); % iterarting through all the relevant scenarios
            OriginalPrecentage = ScenariosAndValues{ScenarioIndex, 9}; % saving the original value

            % running FULL SCENARIO 3 times: as is, +10%, -10%.
            [FullScenariosTable1] = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,9}, 'MileStones', false);
            [population] = populationCal(FullScenariosTable1);
            [EmissionsByYearsTest1, ConsumptionAmounts1, Resources1, WaterFromFood1] = FullScenario(DataBase, FullScenariosTable1,Years,population,orderIndex,0);
            TotalEmission1 = CalcUpDownStream(EmissionsByYearsTest1);
            Emission1_Sum = sum(TotalEmission1{1:11, 19});
            [AreaSum1, CostsSum1, WaterSum1] = CalcTotalResources(Resources1, ConsumptionAmounts1, WaterFromFood1);
            Area1_Sum = sum(AreaSum1{1:4, 19});
            Water1_Sum = sum(WaterSum1{1:5, 19});

            % new calculation for +10%
            ScenariosAndValues{ScenarioIndex, 9} = OriginalPrecentage + 0.1;
            if ScenarioIndex==6
               ScenariosAndValues{7,9} = gas_original - 0.1; % if renewable is 10% higher, we substract it from gas
            end
            if ScenarioIndex==7
               ScenariosAndValues{6,9} = renewable_original - 0.1; % if gas is 10% higher, we substract it from renewable
            end
            [FullScenariosTable2] = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,9}, 'MileStones', false);
            [population] = populationCal(FullScenariosTable2);
            [EmissionsByYearsTest2, ConsumptionAmounts2, Resources2, WaterFromFood2] = FullScenario(DataBase, FullScenariosTable2,Years,population,orderIndex,0);
            TotalEmission2 = CalcUpDownStream(EmissionsByYearsTest2);
            Emission2_Sum = sum(TotalEmission2{1:11, 19});
            [AreaSum2, CostsSum2, WaterSum2] = CalcTotalResources(Resources2, ConsumptionAmounts2, WaterFromFood2);
            Area2_Sum = sum(AreaSum2{1:4, 19});
            Water2_Sum = sum(WaterSum2{1:5, 19});

            ScenariosAndValues{6,9} = renewable_original; %restart
            ScenariosAndValues{7,9} = gas_original;

            % new calculation for -10%
            ScenariosAndValues{ScenarioIndex, 9} = OriginalPrecentage - 0.1 ; % new calculation for -10%
            if ScenarioIndex==6
               ScenariosAndValues{7,9} = gas_original + 0.1; % if renewable is 10% lower, we add it to gas
            end
            if ScenarioIndex==7
               ScenariosAndValues{6,9} = renewable_original + 0.1; % if gas is 10% lower, we add it to renewable
            end
            [FullScenariosTable3] = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,9}, 'MileStones', false);
            [population] = populationCal(FullScenariosTable3);
            [EmissionsByYearsTest3, ConsumptionAmounts3, Resources3, WaterFromFood3] = FullScenario(DataBase, FullScenariosTable3,Years,population,orderIndex,0);
            TotalEmission3 = CalcUpDownStream(EmissionsByYearsTest3);
            Emission3_Sum = sum(TotalEmission3{1:11, 19});
            [AreaSum3, CostsSum3, WaterSum3] = CalcTotalResources(Resources3, ConsumptionAmounts3, WaterFromFood3);
            Area3_Sum = sum(AreaSum3{1:4, 19});
            Water3_Sum = sum(WaterSum3{1:5, 19});

            ScenariosAndValues{6,9} = renewable_original; %restart
            ScenariosAndValues{7,9} = gas_original;

            BiggerMinusOriginal = TotalEmission2 - TotalEmission1;
            OriginalMinusSmaller = TotalEmission1 - TotalEmission3;

            % delta tables:
            ScenariosAndValues{ScenarioIndex, 9} = OriginalPrecentage ; % RESET
            SensitivityAnalysisCell{1, ScenarioIndex} = BiggerMinusOriginal;
            SensitivityAnalysisCell{2, ScenarioIndex} = OriginalMinusSmaller;

            % summarized emission table:
            TotalEmissionByScenarioChanged{1, i} = Emission1_Sum;
            TotalEmissionByScenarioChanged{2, i} = Emission2_Sum;
            TotalEmissionByScenarioChanged{3, i} = Emission3_Sum;

            % summarized area table:
            TotalAreaByScenarioChanged{1, i} = Area1_Sum;
            TotalAreaByScenarioChanged{2, i} = Area2_Sum;
            TotalAreaByScenarioChanged{3, i} = Area3_Sum;

            % summarized water table:
            TotalWaterByScenarioChanged{1, i} = Water1_Sum;
            TotalWaterByScenarioChanged{2, i} = Water2_Sum;
            TotalWaterByScenarioChanged{3, i} = Water3_Sum;

            disp('SensitivityAnalysis');

        end

        SensitivityAnalysisTable = cell2table(SensitivityAnalysisCell);
        SensitivityAnalysisTable.Properties.VariableNames = rowNames;
        SensitivityAnalysisTable.Properties.RowNames = {'BiggerMinusOriginal', 'OriginalMinusSmaller'};
        SensitivityAnalysisCell = table2cell(SensitivityAnalysisTable);


end

beep;




