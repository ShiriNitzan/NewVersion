addpath("Scenarios");
addpath("CalcFunctions");
addpath("UI");
addpath("Data");

ImprovementValues = readtable("The Three Scenarios.xlsx",'Sheet','Improvements','Range','B2:B5','ReadVariableNames',false);

ColumnNames = ones(1, Years);
for i = 1:width(ColumnNames)
    ColumnNames(i) = 2016+i;
end
ColumnNames = string(ColumnNames);
%% Electric Vehicles Improvements
ElectricityConsumptionEmissionsInTransportationTable = array2table(zeros(height(DataBase.ElectricityConsumptionEmissionsInTransportation),Years));
ElectricVehicleImprovements = ReductionVectorCalc(BaseYear,TargetYear, ImprovementValues{2,1});
ElectricityConsumptionEmissionsInTransportationTable{:,1} = DataBase.ElectricityConsumptionEmissionsInTransportation;
for i = 1:Years
    ElectricityConsumptionEmissionsInTransportationTable{1,i} = ElectricityConsumptionEmissionsInTransportationTable{1,1}*ElectricVehicleImprovements(i);
    ElectricityConsumptionEmissionsInTransportationTable{2,i} = ElectricityConsumptionEmissionsInTransportationTable{2,1}*ElectricVehicleImprovements(i);
    ElectricityConsumptionEmissionsInTransportationTable{3,i} = ElectricityConsumptionEmissionsInTransportationTable{3,1}*ElectricVehicleImprovements(i);
    ElectricityConsumptionEmissionsInTransportationTable{4,i} = ElectricityConsumptionEmissionsInTransportationTable{4,1}*ElectricVehicleImprovements(i);
end
ElectricityConsumptionEmissionsInTransportationTable.Properties.VariableNames = ColumnNames;
ElectricityConsumptionEmissionsInTransportationTable.Properties.RowNames = {'Electric Car', 'Electric Van', 'Electric Truck', 'Electric Bus'};

DataBase.ElectricityConsumptionEmissionsInTransportation = ElectricityConsumptionEmissionsInTransportationTable;

%% Water Desalination Improvements

ElectricityFromWaterCoefficientsTable = array2table(zeros(height(DataBase.ElectricityConsumptionCoefficients),Years));
ElectricityFromWaterCoefficientsTable{:,1} = DataBase.ElectricityConsumptionCoefficients;
WaterDesalinationImprovements = ReductionVectorCalc(BaseYear,TargetYear, ImprovementValues{1,1});
for i = 1:Years
    ElectricityFromWaterCoefficientsTable{1,i} = ElectricityFromWaterCoefficientsTable{1,1}.*WaterDesalinationImprovements(i);
    ElectricityFromWaterCoefficientsTable{2,i} = ElectricityFromWaterCoefficientsTable{2,1};
    ElectricityFromWaterCoefficientsTable{3,i} = ElectricityFromWaterCoefficientsTable{3,1};
    ElectricityFromWaterCoefficientsTable{4,i} = ElectricityFromWaterCoefficientsTable{4,1};
    ElectricityFromWaterCoefficientsTable{5,i} = ElectricityFromWaterCoefficientsTable{5,1};
    ElectricityFromWaterCoefficientsTable{6,i} = ElectricityFromWaterCoefficientsTable{6,1};
end
ElectricityFromWaterCoefficientsTable.Properties.VariableNames = ColumnNames;
ElectricityFromWaterCoefficientsTable.Properties.RowNames = {'Desalination', 'Moving', 'Urban Water Moving', 'Treated Waste Water Moving', 'Sewege Treatment', 'Water Production'};
DataBase.ElectricityConsumptionCoefficients = ElectricityFromWaterCoefficientsTable;

%% Natural Gas Improvements
NaturalGasImprovements = GrowthVectorCalc(BaseYear,TargetYear, ImprovementValues{3,1})-1;
DataBase.NaturalGasImprovements = NaturalGasImprovements;

%% Area For solar Energy Improvement - Given from cost efficiency file
% AreaForSolarImprovement = ReductionVectorCalc(BaseYear,TargetYear, ImprovementValues{4,1});
% for i = 1:Years
%     CurrentArea = DataBase.AreaForSolarEnergyCoefficients(i)*AreaForSolarImprovement(i);
%     if(CurrentArea >= DataBase.LowerBoundForArea)
%         DataBase.AreaForSolarEnergyCoefficients(i) = CurrentArea;
%     else
%         DataBase.AreaForSolarEnergyCoefficients(i) = DataBase.LowerBoundForArea;
%     end    
% end    

%% Other functions
function ReductionVector = ReductionVectorCalc(StartYear, EndYear, EndYearVal)
Period = EndYear-StartYear+1;
ReductionVector = ones(1, Period);
ReductionVector(Period) = 1-EndYearVal;
FutureValue = ReductionVector(Period);
Rate = nthroot(FutureValue/ReductionVector(1),Period-1);
    for i = 1:Period
        ReductionVector(i) = ReductionVector(1)*((Rate)^(i-1));
    end
end

function GrowthVector = GrowthVectorCalc(StartYear, EndYear, EndYearVal)
Period = EndYear-StartYear+1;
GrowthVector = ones(1, Period);
GrowthVector(Period) = 1+EndYearVal;
FutureValue = GrowthVector(Period);
Rate = nthroot(FutureValue/GrowthVector(1),Period-1);
    for i = 1:Period
        GrowthVector(i) = GrowthVector(1)*((Rate)^(i-1));
    end
end