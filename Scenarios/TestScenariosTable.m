function [AllButOneScenariosTable] = TestScenariosTable(Data, ScenarioNumber, Years, S)
%% Prep

%%CurrentEnergyConsumptionFromRenewableEnergies = readtable(Data,'Sheet','ElectricityConsumption','Range','D14:D14','ReadVariableNames',false);
CurrentEnergyConsumptionFromRenewableEnergies = Data.InitialPercentage(3);
CurrentEnergyConsumptionFromNaturalGas = Data.InitialPercentage(2);

RowNames = {'Population Growth', 'Increased Electricity Per Capita', 'Increase in Desalinared Water', 'Reducing Beef Consumption', 'Preventing Food Loss', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving','Waste Minimization','Recycled Waste', '11', 'Reduction Of Mileage', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
ColumnNames = ones(1, Years);
AllButOneScenariosTable = array2table(zeros(19, Years), 'RowNames', RowNames);

for i = 1:width(ColumnNames)
    ColumnNames(i) = 2016+i;
end
ColumnNames = string(ColumnNames);
AllButOneScenariosTable.Properties.VariableNames = ColumnNames;
%%

% Specific Changes
MilesTonesTable = array2table(zeros(19, Years));
for i = 1:height(AllButOneScenariosTable)
    defvalues = cell(1, Years);
    defvalues(:) = {'0'};
    formatspec = 'Milestones in Scenario %s';
    title = sprintf(formatspec, RowNames{1,i});
    dims = ones(Years, 2);
    dims(:,2) = 10;
    answer = inputdlg(ColumnNames,...
        title', dims, defvalues, 'on');
    user_val = str2double(answer);
    MilesTonesTable{i,:} = user_val';
end


%% 

AllButOneScenariosTable{1,:} = MileStonesGrowth(MilesTonesTable{1,:}, Years, S(1));

AllButOneScenariosTable{2,:} = MileStonesGrowth(MilesTonesTable{2,:}, Years, S(2));

AllButOneScenariosTable{3,:} = MileStonesGrowth(MilesTonesTable{3,:}, Years, S(3));

AllButOneScenariosTable{4,:} = MileStonesReduction(MilesTonesTable{4,:}, Years, S(4));

FoodPercentageActuallyConsumed = S(5) + (2/3);
AllButOneScenariosTable{5,:} = MileStonesReduction(MilesTonesTable{5,:}, Years, 1-FoodPercentageActuallyConsumed);

AllButOneScenariosTable{6, 1} = CurrentEnergyConsumptionFromRenewableEnergies;
MilesTonesTable{6,Years} = S(6);
MilesTonesTable{6, 1}  = CurrentEnergyConsumptionFromRenewableEnergies;
StartYear = 1;
for i = 1:Years
    if(MilesTonesTable{6,i} ~= 0)
        AllButOneScenariosTable{6,i} = MilesTonesTable{6,i};
        EndYear = i;
        Period = EndYear-StartYear+1;
        Gap = (AllButOneScenariosTable{6,EndYear}-AllButOneScenariosTable{6, StartYear})/(Period-1);
        for j = StartYear+1:EndYear
            AllButOneScenariosTable{6, j} = AllButOneScenariosTable{6, j-1}+Gap;
        end
        StartYear = i;
    end
end

AllButOneScenariosTable{6,:} = MileStonesGrowth(MilesTonesTable{6,:}, Years, S(6));
for i = 1:Years
    AllButOneScenariosTable{6, i} = AllButOneScenariosTable{6, i} - 1;
end

AllButOneScenariosTable{7, 1} = CurrentEnergyConsumptionFromNaturalGas;
AllButOneScenariosTable{7,Years} =  S(7);%According to S3
MilesTonesTable{7,Years} = S(7);
StartYear = 1;
for i = 1:Years
    if(MilesTonesTable{7,i} ~= 0)
        AllButOneScenariosTable{7,i} = MilesTonesTable{7,i};
        EndYear = i;
        Period = EndYear-StartYear+1;
        Gap = (AllButOneScenariosTable{7,EndYear}-AllButOneScenariosTable{7, StartYear})/(Period-1);
        for j = StartYear+1:EndYear
            AllButOneScenariosTable{7, j} = AllButOneScenariosTable{7, j-1}+Gap;
        end
        StartYear = i;
    end
end

AllButOneScenariosTable{8,:} =  MileStonesReduction(MilesTonesTable{8,:}, Years, S(8));

AllButOneScenariosTable{9,:} =  MileStonesReduction(MilesTonesTable{9,:}, Years, S(9));

AllButOneScenariosTable{10,:} =  MileStonesReduction(MilesTonesTable{10,:}, Years, S(10));

AllButOneScenariosTable{11,:} = 1;

AllButOneScenariosTable{12,:} = MileStonesReduction(MilesTonesTable{12,:}, Years, S(12));

AllButOneScenariosTable{13,:} = MileStonesReduction(MilesTonesTable{13,:}, Years, S(13));

AllButOneScenariosTable{14,:} = MileStonesGrowth(MilesTonesTable{14,:}, Years, S(14));
for i = 1:Years
    AllButOneScenariosTable{14, i} = AllButOneScenariosTable{14, i} - 1;
end

AllButOneScenariosTable{15,:} = MileStonesGrowth(MilesTonesTable{15,:}, Years, S(15));
for i = 1:Years
    AllButOneScenariosTable{15, i} = AllButOneScenariosTable{15, i} - 1;
end

AllButOneScenariosTable{16,:} = MileStonesGrowth(MilesTonesTable{16,:}, Years, S(16));
for i = 1:Years
    AllButOneScenariosTable{16, i} = AllButOneScenariosTable{16, i} - 1;
end

AllButOneScenariosTable{17,:} = MileStonesGrowth(MilesTonesTable{17,:}, Years, S(17));
for i = 1:Years
    AllButOneScenariosTable{17, i} = AllButOneScenariosTable{17, i} - 1;
end

AllButOneScenariosTable{18,:} = 1;

AllButOneScenariosTable{19,:} = MileStonesGrowth(MilesTonesTable{19,:}, Years, S(19));

%% Specific Changes

switch ScenarioNumber
    case 1
        AllButOneScenariosTable{1,:} = 1;
    case 2
        AllButOneScenariosTable{2,:} = 1;
    case 3
        AllButOneScenariosTable{3,:} = 1;
    case 4
        AllButOneScenariosTable{4,:} = 1;
    case 5
        AllButOneScenariosTable{5,:} = 1;
    case 6
        AllButOneScenariosTable{6,:} = CurrentEnergyConsumptionFromRenewableEnergies;
    case 7
        AllButOneScenariosTable{7,:} = CurrentEnergyConsumptionFromNaturalGas;
    case 8
        AllButOneScenariosTable{8,:} = 1;
    case 9
        AllButOneScenariosTable{9,:} = 1;
    case 10
        AllButOneScenariosTable{10,:} = 1;
    case 12
        AllButOneScenariosTable{12,:} = 1;
    case 13
        AllButOneScenariosTable{13,:} = 1;
    case 14
        AllButOneScenariosTable{14,:} = 0;
    case 15
        AllButOneScenariosTable{15,:} = 0;
    case 16
        AllButOneScenariosTable{16,:} = 0;
    case 17
        AllButOneScenariosTable{17,:} = 0;
    case 19
        AllButOneScenariosTable{19,:} = 1;
    otherwise
end
end

%% %% other functions

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

