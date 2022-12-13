function [EmissionsByYears, ConsumptionAmounts] = IncreaseInEnergyConsumptionFromRenewableEnergies (Data, ChangeByYears, Years)
%% Preparations
    
    EmissionsByYears=cell(6,Years);
    ConsumptionAmounts=cell(5,Years);
    addpath("CalcFunctions");
    PercentageByTheYears = ones(1,14);
    InitialPercentage = table2array(readtable(Data,'Sheet','ElectricityConsumption','Range','B14:F14','ReadVariableNames',false));
    PercentageOfElectricitySourcesByYears = CalculatePercentageOfElectricitySourcesByYears(ChangeByYears, InitialPercentage);
    [ElectricityConsumptionTable, TransportationConsumptionTable, VehicleAmountsCell, FoodConsumptionCell, FoodProductionTable, WaterConsumptionFromSheetTable, WaterConsumptionCell, ConstructionTable] = CreatTablesForScenariosWithGrowthPercentage(Data, PercentageByTheYears, Years);
    
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
    for i=1:Years
        CurrentYearElectricityConsumption = ElectricityConsumptionTable{:,i};
        CurrentElectricityFromWater = ElectricityFromWaterCell{i};
        TotalElectricityFromWater = CurrentElectricityFromWater{6,2};
        CurrentYearElectricityConsumption(6,i) = TotalElectricityFromWater;
        EmissionsByYears{2,i}=CalcElectricityConsumption(Data, CurrentYearElectricityConsumption,PercentageOfElectricitySourcesByYears{i});
        CurrentYearElectricityManufacturing = ElectricityConsumptionTable{:,i}; %% manufacturing (upstream)
        [EmissionsByYears{3,i},ConsumptionAmounts{3,i}] = CalcElectricityManufacturing(Data, CurrentYearElectricityManufacturing,PercentageOfElectricitySourcesByYears{i});
    end
%% Transportation - Downstream

    for i = 1:Years
        CurrentTransportatiionConsumtpion = TransportationConsumptionTable{:,i};
        CurrentVehicleAmount = table2array(VehicleAmountsCell{i});
        EmissionsByYears{4,i} = CalcTransportationConsumption(Data, CurrentTransportatiionConsumtpion,CurrentVehicleAmount);
        [EmissionsByYears{5,i},ConsumptionAmounts{4,i}] = CalcTransportationManufacturing(Data, CurrentTransportatiionConsumtpion,CurrentVehicleAmount);
    end
%%     
    for i = 1:Years
        CurrentConstruction = ConstructionTable{:,i};
        [ConsumptionAmounts{5,i},EmissionsByYears{6,i}] = CalcConstruction(Data, CurrentConstruction);
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
    
    function PercentageByYears = CalculatePercentageOfElectricitySourcesByYears (ChangeByYears, Percentage)
        Years = width(ChangeByYears);
        PercentageByYears = cell(1,Years); 
        PercentageByYears{1} = Percentage;
        for i = 2:Years
            CurrentChange = ChangeByYears(i)-ChangeByYears(i-1);
            if (Percentage(1)>0)
                if(Percentage(1)>CurrentChange)
                    Percentage(1)=Percentage(1)-CurrentChange;
                    Percentage(3)=Percentage(3)+CurrentChange;
                else
                    Percentage(2)=Percentage(2)-CurrentChange+Percentage(1);
                    Percentage(1)=0;
                    Percentage(3)=Percentage(3)+CurrentChange;
                end
            else
                Percentage(2)=Percentage(2)-CurrentChange;
                Percentage(3)=Percentage(3)+CurrentChange;
            end
            PercentageByYears{i}=Percentage;
        end
    end

