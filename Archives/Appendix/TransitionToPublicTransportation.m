function [EmissionsByYears, ConsumptionAmounts] = TransitionToPublicTransportation (Data, ChangeByYears, Years)
%% Preparations

    EmissionsByYears=cell(6,Years);
    ConsumptionAmounts=cell(5,Years);
    addpath("CalcFunctions");
    PercentageByTheYears = ones(1,14);
    PercentageOfBusTransportation = CalculateBusPercentages(ChangeByYears);
    [ElectricityConsumptionTable, TransportationConsumptionTable, VehicleAmountsCell, FoodConsumptionCell, FoodProductionTable, WaterConsumptionFromSheetTable, WaterConsumptionCell] = CreatTablesForScenariosWithGrowthPercentage(Data, PercentageByTheYears, Years);
    
 
%% Food Emissions & Food Resource Consumption
    
    WaterFromFoodCell = cell(1,Years);
    AreaForFoodCell = cell(1,Years);
    for i=1:Years
        CurrentFoodConsumption = FoodConsumptionCell{i};
        CurrentFoodProduction = FoodProductionTable{:,i};
        CurrentWaterConsumptionFromSheet = WaterConsumptionFromSheetTable{1,i};
        WaterFromFoodCell{i} = CalcWaterForFoodConsumption(Data, CurrentFoodConsumption,CurrentFoodProduction, CurrentWaterConsumptionFromSheet);
        AreaForFoodCell{i} = CalcAreaForFoodConsumption(Data, CurrentFoodConsumption,CurrentFoodProduction);
        EmissionsFromFood = CalcCo2eFromFoodConsumption(Data, CurrentFoodConsumption,CurrentFoodProduction);
        EmissionsByYears{1,i} = EmissionsFromFood;
        ConsumptionAmounts{1,i} = AreaForFoodCell{i};
    end
%% Water Emissions

    WaterForFoodPercentages = table2array(readtable(Data,'Sheet','Food','Range','T6:T9','ReadVariableNames',false))';
    for i=1:Years
        WaterFromAgriculture = WaterForFoodPercentages*sum(WaterFromFoodCell{i}{1,1:3});
        WaterConsumptionCell{i}{1,1:4} = WaterFromAgriculture;
        ConsumptionAmounts{2,i} = WaterConsumptionCell{i};
    end 
    
%% Electricity - Consumption

    ElectricityFromWaterCell = CalculateElectricityFromWaterAllYears(Data, WaterConsumptionCell,Years);
    ElectricityPercentages = table2array(readtable(Data,'Sheet','ElectricityConsumption','Range','B14:F14','ReadVariableNames',false))';
    for i=1:Years
        ElectricityConsumptionTable{6,i} = ElectricityFromWaterCell{i}{6,2};
        EmissionsByYears{2,i}=CalcElectricityConsumption(Data, ElectricityConsumptionTable{:,i},ElectricityPercentages);
        [EmissionsByYears{3,i}, ConsumptionAmounts{3,i}] = CalcElectricityManufacturing(Data, ElectricityConsumptionTable{:,i},ElectricityPercentages);
    end
%% Transportation - Downstream
    
    %KM from car to bus (percentages)
    
    for i = 1:Years
        TransportationConsumptionTable{2,i} = TransportationConsumptionTable{2,i}*ChangeByYears(i);
        TransportationConsumptionTable{1,i} = TransportationConsumptionTable{1,i}*PercentageOfBusTransportation(i);
    end
    
    %%change in vehicle amounts
    VehicleAmountsCell = CalulateChangeInVehicleAmounts(TransportationConsumptionTable, VehicleAmountsCell);
    for i = 1:Years
        CurrentTransportatiionConsumtpion = TransportationConsumptionTable{:,i};
        CurrentVehicleAmount = table2array(VehicleAmountsCell{i});
        EmissionsByYears{4,i} = CalcTransportationConsumption(Data, CurrentTransportatiionConsumtpion,CurrentVehicleAmount);
        [EmissionsByYears{5,i}, ConsumptionAmounts{4,i}]  = CalcTransportationManufacturing(Data, CurrentTransportatiionConsumtpion,CurrentVehicleAmount);
    end
%% Create Final Table
    
    RowNames = {'Food', 'Electricity-DownStream', 'Electricity - UpStream', 'Transportation-DownStream', 'Transportation-UpStream', 'Construction'};
    EmissionsByYears = cell2table(EmissionsByYears, 'RowNames', RowNames);
    ColumnNames = cell(1,Years);
    for i=1:Years
        s1 = num2str(i+2016);
        ColumnNames{i} = s1;
    end
    EmissionsByYears.Properties.VariableNames = ColumnNames;
    
    RowNames = {'Area', 'Water', 'Fuels For Electriciy Manufacturing', 'Fuels For Transportation Amounts', 'Materials For Construction'};
    ConsumptionAmounts = cell2table(ConsumptionAmounts, 'RowNames', RowNames);
    ColumnNames = cell(1,Years);
    for i=1:Years
        s1 = num2str(i+2016);
        ColumnNames{i} = s1;
    end
    ConsumptionAmounts.Properties.VariableNames = ColumnNames;
    

end
%% Other Functions

    function ElectricityFromWater = CalculateElectricityFromWaterAllYears(Data, WaterConsumptionCell, Years)
        ElectricityFromWater = cell(1,Years);
        for i=1:Years
            ElectricityFromWater{i} = CalcElectricityForWater(Data, WaterConsumptionCell{i});
        end
    end
    
function PercentageByYears = CalculateBusPercentages(ChangeByYears)
        Years = width(ChangeByYears);
        PercentageByYears = zeros(1,width(ChangeByYears));
        PercentageByYears(1) = 1;
        for i = 1:Years-1
            CurrentChange = (ChangeByYears(i)-ChangeByYears(i+1))*(1.5/20);
            PercentageByYears(i+1) = PercentageByYears(i) + CurrentChange;
        end    
end

function NewVehicleAmountCell = CalulateChangeInVehicleAmounts(TrasnportationConsumptionTable, VehicleAmountCell)
    NewVehicleAmountCell = cell(1,width(TrasnportationConsumptionTable));
    NewVehicleAmountCell{1} = VehicleAmountCell{1};
    RidesPerDay = 4;
    KMPerCar = TrasnportationConsumptionTable{2,1}/VehicleAmountCell{1}{1,2};
    KMPerBus = TrasnportationConsumptionTable{1,1}/VehicleAmountCell{1}{1,1};
    RowNames = {'Quantity', 'Gasoline', 'Diesel', 'Drive Per Day', 'Drive Per Year', 'Cars Per Year'};
    NewVehicleAmountCell{1} = array2table(zeros(6,6), 'RowNames', RowNames);
    NewVehicleAmountCell{1}{:,:} = VehicleAmountCell{1}{:,:};
    ColNames = {'Bus','Car','Minibus','Motorcycle', 'Truck', 'LCV'};
    NewVehicleAmountCell{1}.Properties.VariableNames = ColNames;

    for i=2:width(TrasnportationConsumptionTable)
        NewVehicleAmountCell{i} = array2table(zeros(6,6), 'RowNames', RowNames);
        NewVehicleAmountCell{i}{:,:} = VehicleAmountCell{i}{:,:};
        NewVehicleAmountCell{i}{1,1} = ceil((TrasnportationConsumptionTable{1,i}-TrasnportationConsumptionTable{1,i-1})/KMPerBus) + NewVehicleAmountCell{i-1}{1,1};
        NewVehicleAmountCell{i}{4,1} = NewVehicleAmountCell{i}{1,1}*RidesPerDay;
        NewVehicleAmountCell{i}{5,1} = NewVehicleAmountCell{i}{4,1}*365;
        NewVehicleAmountCell{i}{6,1} = NewVehicleAmountCell{i}{1,1}*365;
        
        NewVehicleAmountCell{i}{1,2} = NewVehicleAmountCell{i-1}{1,2} - floor((TrasnportationConsumptionTable{2,i-1}-TrasnportationConsumptionTable{2,i})/KMPerCar);
        NewVehicleAmountCell{i}{4,2} = NewVehicleAmountCell{i}{1,2}*RidesPerDay;
        NewVehicleAmountCell{i}{5,2} = NewVehicleAmountCell{i}{4,2}*365;
        NewVehicleAmountCell{i}{6,2} = NewVehicleAmountCell{i}{1,2}*365;
        
        NewVehicleAmountCell{i}.Properties.VariableNames = ColNames;
    end    
end

