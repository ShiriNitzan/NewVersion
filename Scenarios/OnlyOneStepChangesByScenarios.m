function [OnlyOneStepScenariosTable, ConsumptionChanges] = OnlyOneStepChangesByScenarios(Data, ScenarioNumber, Years, S)
%% Prep

CurrentEnergyConsumptionFromRenewableEnergies = Data.InitialPercentage(3);
CurrentEnergyConsumptionFromNaturalGas = Data.InitialPercentage(2);

RowNames = {'Population Growth', 'Increased Electricity Per Capita', 'Increase in Desalinared Water', 'Reducing Beef Consumption', 'Preventing Food Loss', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving','Waste Minimization','Recycled Waste', 'Burning Waste', 'Reduction Of Mileage', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
ColumnNames = zeros(1, Years);
OnlyOneStepScenariosTable = array2table(zeros(19, Years), 'RowNames', RowNames);
ConsumptionChanges = array2table(zeros(sum(Type == "Consumption"), Years), 'RowNames', RowNames(Type == "Consumption"));

for i = 1:width(ColumnNames)
    ColumnNames(i) = 2016+i;
end
ColumnNames = string(ColumnNames);
OnlyOneStepScenariosTable.Properties.VariableNames = ColumnNames;
ConsumptionChanges.Properties.VariableNames = ColumnNames;

%% Create Defualt Table

OnlyOneStepScenariosTable{1,:} = 1;
OnlyOneStepScenariosTable{2,:} = 1;
OnlyOneStepScenariosTable{3,:} = 1;
OnlyOneStepScenariosTable{4,:} = 1;
OnlyOneStepScenariosTable{5,:} = 1;
OnlyOneStepScenariosTable{6,:} = CurrentEnergyConsumptionFromRenewableEnergies;
OnlyOneStepScenariosTable{7,:} = CurrentEnergyConsumptionFromNaturalGas;
OnlyOneStepScenariosTable{8,:} = 1;
OnlyOneStepScenariosTable{9,:} = 1;
OnlyOneStepScenariosTable{10,:} = 1;
OnlyOneStepScenariosTable{11,:} = 1;
OnlyOneStepScenariosTable{12,:} = 1;
OnlyOneStepScenariosTable{13,:} = 1;
OnlyOneStepScenariosTable{14,:} = 0;
OnlyOneStepScenariosTable{15,:} = 0;
OnlyOneStepScenariosTable{16,:} = 0;
OnlyOneStepScenariosTable{17,:} = 0;
OnlyOneStepScenariosTable{18,:} = 1;
OnlyOneStepScenariosTable{19,:} = 1;

%% Specific Changes
defvalues = cell(1, Years);
defvalues(:) = {'0'};
formatspec = 'Milestones in Scenario %s';
title = sprintf(formatspec, RowNames{1,ScenarioNumber});
dims = ones(Years, 2);
dims(:,2) = 10;
answer = inputdlg(ColumnNames,...
             title', dims, defvalues, 'on');
user_val = str2double(answer);

%% Bring to current situation - 2020
YearsAfterAnalysis = 4;
PopulationGrowth = 0.0484;
RenewableEnergies = 0.06;
NaturalGas = 0.68;

%%

switch ScenarioNumber
    case 1
        user_val(YearsAfterAnalysis) = PopulationGrowth;
        OnlyOneStepScenariosTable{ScenarioNumber,:} =  MileStonesGrowth(user_val, Years, S(ScenarioNumber));
    case 2
        OnlyOneStepScenariosTable{ScenarioNumber,:} =  MileStonesGrowth(user_val, Years, S(ScenarioNumber));
    case 3
        OnlyOneStepScenariosTable{ScenarioNumber,:} =  MileStonesGrowth(user_val, Years, S(ScenarioNumber));
    case 4
        OnlyOneStepScenariosTable{ScenarioNumber,:} =  MileStonesReduction(user_val, Years, S(ScenarioNumber));
    case 5
        FoodPercentageActuallyConsumed = S(ScenarioNumber) + (2/3);
        OnlyOneStepScenariosTable{ScenarioNumber,:} = MileStonesReduction(user_val, Years, 1-FoodPercentageActuallyConsumed);
    case 6
        OnlyOneStepScenariosTable{6, 1} = CurrentEnergyConsumptionFromRenewableEnergies;
        OnlyOneStepScenariosTable{6,Years} =  S(6);%According to S3
        OnlyOneStepScenariosTable{6,Years-5} = (OnlyOneStepScenariosTable{6,Years}-OnlyOneStepScenariosTable{6, 1})/2; %% according to iea - in 2025 we need to be halfway
        user_val(Years-5) = (OnlyOneStepScenariosTable{6,Years}-OnlyOneStepScenariosTable{6, 1})/2;
        user_val(Years) = S(6);
        user_val(YearsAfterAnalysis) = RenewableEnergies;
        StartYear = 1;
        for i = 1:Years
            if(user_val(i) ~= 0)
                OnlyOneStepScenariosTable{6,i} = user_val(i);
                EndYear = i;
                Period = EndYear-StartYear+1;
                Gap = (OnlyOneStepScenariosTable{6,EndYear}-OnlyOneStepScenariosTable{6, StartYear})/(Period-1);
                for j = StartYear+1:EndYear
                    OnlyOneStepScenariosTable{6, j} = OnlyOneStepScenariosTable{6, j-1}+Gap;
                end
                StartYear = i;
            end
        end
    case 7
        OnlyOneStepScenariosTable{7, 1} = CurrentEnergyConsumptionFromNaturalGas;
        OnlyOneStepScenariosTable{7,Years} =  S(7);%According to S3
        user_val(Years) = S(7);
        user_val(YearsAfterAnalysis) = NaturalGas;
        StartYear = 1;
        for i = 1:Years
            if(user_val(i) ~= 0)
                OnlyOneStepScenariosTable{7,i} = user_val(i);
                EndYear = i;
                Period = EndYear-StartYear+1;
                Gap = (OnlyOneStepScenariosTable{7,EndYear}-OnlyOneStepScenariosTable{7, StartYear})/(Period-1);
                for j = StartYear+1:EndYear
                    OnlyOneStepScenariosTable{7, j} = OnlyOneStepScenariosTable{7, j-1}+Gap;
                end
                StartYear = i;
            end
        end
    case 8
        OnlyOneStepScenariosTable{ScenarioNumber,:} =  MileStonesReduction(user_val, Years, S(ScenarioNumber));
    case 9
        OnlyOneStepScenariosTable{ScenarioNumber,:} =  MileStonesReduction(user_val, Years, S(ScenarioNumber));
    case 10
        OnlyOneStepScenariosTable{ScenarioNumber,:} =  MileStonesReduction(user_val, Years, S(ScenarioNumber));
    case 11
        OnlyOneStepScenariosTable{ScenarioNumber,:} =  MileStonesReduction(user_val, Years, S(ScenarioNumber));
    case 12
        OnlyOneStepScenariosTable{ScenarioNumber,:} =  MileStonesReduction(user_val, Years, S(ScenarioNumber));
    case 13
        OnlyOneStepScenariosTable{ScenarioNumber,:} =  MileStonesReduction(user_val, Years, S(ScenarioNumber));
    case 14
        OnlyOneStepScenariosTable{ScenarioNumber,:} = MileStonesGrowth(user_val, Years, S(ScenarioNumber));
        for i = 1:Years
            OnlyOneStepScenariosTable{14,i} = OnlyOneStepScenariosTable{14, i} - 1;
        end
    case 15
        OnlyOneStepScenariosTable{15,:} = GrowthVectorCalc(2017,2030,Years, S(15));
        for i = 1:Years
            OnlyOneStepScenariosTable{15,i} = OnlyOneStepScenariosTable{15, i} - 1;
        end
    case 16
        OnlyOneStepScenariosTable{16,:} = GrowthVectorCalc(2017,2030,Years, S(16));
        for i = 1:Years
            OnlyOneStepScenariosTable{16,i} = OnlyOneStepScenariosTable{16, i} - 1;
        end
    case 17
        OnlyOneStepScenariosTable{17,:} = GrowthVectorCalc(2017,2030,Years, S(17));
        for i = 1:Years
            OnlyOneStepScenariosTable{17,i} = OnlyOneStepScenariosTable{17, i} - 1;
        end
    case 19
        OnlyOneStepScenariosTable{19,:} =  ReductionVectorCalc(2017,2030,Years,S(19));
    otherwise
end
end

%% other functions

function [PercentVector] = MileStonesGrowth(MileStoneVector, Years, S)
PercentVector = ones(1,Years);
PercentVector(Years) = 1+S;
MileStoneVector(Years) = S;
StartYear = 1;
for i = 1:length(MileStoneVector)
    if(MileStoneVector(i) ~= 0)
        EndYear = i;
        GrowthVector = GrowthVectorCalc(StartYear, EndYear, MileStoneVector(i), MileStoneVector(StartYear));
        for j = 1:length(GrowthVector)
            PercentVector(StartYear+j-1) = GrowthVector(j);
        end    
        StartYear = i;
    end
end
end

function [PercentVector] = MileStonesReduction(MileStoneVector, Years, S)
PercentVector = ones(1,Years);
PercentVector(Years) = 1-S;
MileStoneVector(Years) = S;
StartYear = 1;
for i = 1:length(MileStoneVector)
    if(MileStoneVector(i) ~= 0)
        EndYear = i;
        GrowthVector = ReductionVectorCalc(StartYear, EndYear, MileStoneVector(i), MileStoneVector(StartYear));
        for j = 1:length(GrowthVector)
            PercentVector(StartYear+j-1) = GrowthVector(j);
        end    
        StartYear = i;
    end
end
end

function [PercentVector] = DescreteMileStonesReduction(MileStoneVector, Years, S)
PercentVector = ones(1,Years);
PercentVector(Years) = 1-S;
MileStoneVector(Years) = S;
StartYear = 1;
for i = 1:length(MileStoneVector)
    if(MileStoneVector(i) ~= 0)
        EndYear = i;
        GrowthVector = DisctreteMileStone(StartYear, EndYear, MileStoneVector(i));
        for j = 1:length(GrowthVector)
            PercentVector(StartYear+j-1) = GrowthVector(j);
        end    
        StartYear = i;
    end
end
end

function GrowthVector = GrowthVectorCalc(StartYear, EndYear, EndYearVal, StartYearVal)
Period = EndYear-StartYear+1;
GrowthVector = ones(1, Period);
GrowthVector(1) = 1 + StartYearVal;
GrowthVector(Period) = 1+EndYearVal; 
FutureValue = GrowthVector(Period);
Rate = nthroot(FutureValue/GrowthVector(1),Period-1);
    for i = 1:Period
        GrowthVector(i) = GrowthVector(1)*((Rate)^(i-1));
    end
end

function ReductionVector = ReductionVectorCalc(StartYear, EndYear, EndYearVal, StartYearVal)
Period = EndYear-StartYear+1;
ReductionVector = ones(1, Period);
ReductionVector(1) = 1-StartYearVal;
ReductionVector(Period) = 1-EndYearVal;
FutureValue = ReductionVector(Period);
Rate = nthroot(FutureValue/ReductionVector(1),Period-1);
    for i = 1:Period
        ReductionVector(i) = ReductionVector(1)*((Rate)^(i-1));
    end
end

function MileStoneVector = DisctreteMileStone(StartYear, EndYear, Val)
    Period = EndYear-StartYear+1;
    MileStoneVector = ones(1,Period)*Val;
end