function [EmissionsByYears,ConsumptionAmounts] = TransportationScenariosCombination(ScenariosTable,Years)
%% Data file

    Data = "Data.xlsx";
   
%% Preparations

    EmissionsByYears=cell(6,Years);
    ConsumptionAmounts=cell(5,Years);
    addpath("CalcFunctions");
    PercentageByTheYears = ScenariosTable{1,:};
    TransitionToPublicTrasportationForCalcs = zeros(1,Years);
    for i = 1:Years
        TransitionToPublicTrasportationForCalcs(i) = 1-ScenariosTable{5,i};
    end    
    PercentageOfBusTransportation = CalculateBusPercentages(TransitionToPublicTrasportationForCalcs);
    [ElectricityConsumptionTable, TransportationConsumptionTable, VehicleAmountsCell, FoodConsumptionCell, FoodProductionTable, WaterConsumptionFromSheetTable, WaterConsumptionCell, ConstructionTable] = CreatTablesForScenariosWithGrowthPercentage(PercentageByTheYears, Years);
    
 
%% Food Emissions & Food Resource Consumption
    
    WaterFromFoodCell = cell(1,Years);
    AreaForFoodCell = cell(1,Years);
    for i=1:Years
        CurrentFoodConsumption = FoodConsumptionCell{i};
        CurrentFoodProduction = FoodProductionTable{:,i};
        CurrentWaterConsumptionFromSheet = WaterConsumptionFromSheetTable{1,i};
        WaterFromFoodCell{i} = CalcWaterForFoodConsumption(CurrentFoodConsumption,CurrentFoodProduction, CurrentWaterConsumptionFromSheet);
        AreaForFoodCell{i} = CalcAreaForFoodConsumption(CurrentFoodConsumption,CurrentFoodProduction);
        EmissionsFromFood = CalcCo2eFromFoodConsumption(CurrentFoodConsumption,CurrentFoodProduction);
        EmissionsByYears{1,i} = EmissionsFromFood;
        ConsumptionAmounts{1,i} = AreaForFoodCell{i};
    end
    
%% Water Emissions

    WaterForFoodPercentages = table2array(readtable(Data,'Sheet','Food','Range','T6:T9','ReadVariableNames',false))';
    DiselinatedWaterPercentage = readtable(Data,'Sheet','Water','Range','N44:N44','ReadVariableNames',false);
    DiselinatedWaterPercentage = DiselinatedWaterPercentage{1,1};
    ColNames = {'Fresh Water','Diselinated Water','Brackish Water','Treated WasteWater','Flood Water'};
    RowNames = {'Agriculture', 'Home and Other Consumption', 'Marginal Water Percentage', 'Home Consumption(Urban)', 'Industry', 'Water for Nature', 'Water for Neighbors', 'Total'};
    for i=1:Years
        CurrentWaterConsumption = array2table(zeros(8,5), 'RowNames', RowNames);
        WaterFromAgriculture = WaterForFoodPercentages*sum(WaterFromFoodCell{i}{1,1:3});
        WaterConsumptionCell{i}{1,1:4} = WaterFromAgriculture;
        CurrentWaterConsumption{1:7,1} =   WaterConsumptionCell{i}{:,1};
        CurrentWaterConsumption{: , 2} = CurrentWaterConsumption{:,1}*DiselinatedWaterPercentage;
        CurrentWaterConsumption{:,1} = CurrentWaterConsumption{:,1}*(1-DiselinatedWaterPercentage);
        CurrentWaterConsumption{1:7,3:5} = WaterConsumptionCell{i}{:,2:4};
        CurrentWaterConsumption(4,:) = [];
        for j =1:width(CurrentWaterConsumption)
            CurrentWaterConsumption{7,j} = sum(CurrentWaterConsumption{1:6, j});
        end    
        CurrentWaterConsumption.Properties.VariableNames = ColNames;
        ConsumptionAmounts{2,i} = CurrentWaterConsumption;
    end 
    
%% Electricity - Consumption

    ElectricityFromWaterCell = CalculateElectricityFromWaterAllYears(WaterConsumptionCell,Years);
    ElectricityPercentages = table2array(readtable(Data,'Sheet','ElectricityConsumption','Range','B14:F14','ReadVariableNames',false))';
    for i=1:Years
        ElectricityConsumptionTable{6,i} = ElectricityFromWaterCell{i}{6,2};
        EmissionsByYears{2,i}=CalcElectricityConsumption(ElectricityConsumptionTable{:,i},ElectricityPercentages);
        [EmissionsByYears{3,i}, ConsumptionAmounts{3,i}] = CalcElectricityManufacturing(ElectricityConsumptionTable{:,i},ElectricityPercentages);
    end
%% Transportation - Downstream

    for i = 1:Years
        TransportationConsumptionTable{:,i} = TransportationConsumptionTable{:,i}*ScenariosTable{3,i};
    end  

     for i = 1:Years
        TransportationConsumptionTable{2,i} = TransportationConsumptionTable{2,i}*TransitionToPublicTrasportationForCalcs(i);
        TransportationConsumptionTable{1,i} = TransportationConsumptionTable{1,i}*PercentageOfBusTransportation(i);
     end
    
    VehicleAmountsCell = CalulateChangeInVehicleAmounts(TransportationConsumptionTable, VehicleAmountsCell);
    for i = 1:Years
        CurrentTransportatiionConsumtpion = TransportationConsumptionTable{:,i};
        CurrentVehicleAmount = table2array(VehicleAmountsCell{i});
        EmissionsByYears{4,i} = CalcTransportationConsumption(CurrentTransportatiionConsumtpion,CurrentVehicleAmount);
        [EmissionsByYears{5,i}, ConsumptionAmounts{4,i}]  = CalcTransportationManufacturing(CurrentTransportatiionConsumtpion,CurrentVehicleAmount);
    end
    
    ShipAndPlaneFuelCell = ShipAndPlaneFuelConsumption(PercentageByTheYears, Years);
    for i=1:Years
        ConsumptionAmounts{4,i}{1,1} = ShipAndPlaneFuelCell{i}{1,1};
        ConsumptionAmounts{4,i}{1,2} = ConsumptionAmounts{4,i}{1,2}+ShipAndPlaneFuelCell{i}{1,2};
         ConsumptionAmounts{4,i}{1,3} = ShipAndPlaneFuelCell{i}{2,3} + ShipAndPlaneFuelCell{i}{3,3};
    end   
    
    %% Constuction
    for i = 1:Years
        CurrentConstruction = ConstructionTable{:,i};
        [ConsumptionAmounts{5,i},EmissionsByYears{6,i}] = CalcConstruction(CurrentConstruction);
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

    function ElectricityFromWater = CalculateElectricityFromWaterAllYears(WaterConsumptionCell, Years)
        ElectricityFromWater = cell(1,Years);
        for i=1:Years
            ElectricityFromWater{i} = CalcElectricityForWater(WaterConsumptionCell{i});
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


