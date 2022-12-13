function [TotalTransportationManufacturingEmissions, TotalFuelAmounts] = CalcTransportationManufacturing(Data, CurrentYearTransportationConsumption,VehicleAmount, KMByEV)

 NumOfDailyTrips = 4;
%% Read Files - fuel consumption
    FuelConsumptionCoefficients = Data.FuelConsumptionCoefficients;

    %% Total Motor Vehicle Fuel Consumption
    
    TotalFuelConsumptionForMV = array2table(zeros(1, 7));
    TotalFuelConsumptionForMV.Properties.VariableNames = {'Bus', 'Car', 'Minibus', 'Motorcycle', 'Truck', 'LCV', 'Train'};
    for i=1:width(TotalFuelConsumptionForMV)-1
        TotalFuelConsumptionForMV{1,i} = (FuelConsumptionCoefficients{1,i}*CurrentYearTransportationConsumption(i) +  FuelConsumptionCoefficients{2,i}*VehicleAmount(5,i))/1000000;
    end
    
   %% Train fuel consumption - tons
   
    TrainFuelConsumptionCoefficints =Data.TrainFuelConsumptionCoefficints;
    TotalKMBYTrain = CurrentYearTransportationConsumption(7:8)';
    %%EngineeringToolsFuelConsumption = readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','O68:O68','ReadVariableNames',false);
    %%EngineeringToolsFuelConsumption = EngineeringToolsFuelConsumption{1,1};
    InflationCoefficient = Data.InflationCoefficient;
    temp = TrainFuelConsumptionCoefficints.*TotalKMBYTrain*0.85;
    TotalFuelConsumptionForMV{1,7} = ((sum(temp))/1000)*InflationCoefficient; %%+EngineeringToolsFuelConsumption)*InflationCoefficient; %% fuel consumption is in litters - 0.85 is conversion coefficint from litter to KG
    
    
    %% All vehicles fuel consumption
    CrudeOilToFuelRatio = Data.CrudeOilToFuelRatio;
    NaturalGasForFuelRefining = Data.NaturalGasForFuelRefining;
    %FuelForOtherUses = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','B33:F33','ReadVariableNames',false));
    TotalFuelConsumption = array2table(zeros(1,8));
    TotalFuelConsumption.Properties.VariableNames = {'Mazut', 'Diesel', 'Kerosene', 'Gasoline','Liquefied Petroleum Gas', 'Crude Oil', 'Natural Gas', 'Battery Manufacturing'};
    %MazutConsumption = readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','B30:B30','ReadVariableNames',false);
    %TotalFuelConsumption{1,1} = MazutConsumption{1,1} + FuelForOtherUses(1);
    %ShipInternationalConsumption = readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','C30:C30','ReadVariableNames',false);
    %ShipInternationalConsumption = ShipInternationalConsumption{1,1};
    TotalFuelConsumption{1,2} = TotalFuelConsumptionForMV{1,1}+TotalFuelConsumptionForMV{1,3}+TotalFuelConsumptionForMV{1,5}+TotalFuelConsumptionForMV{1,6}+TotalFuelConsumptionForMV{1,7}; %+ ShipInternationalConsumption +FuelForOtherUses(2);%+sum(ShipAndPlaneFuelConsumption{:,2});
    %KeroseneConsumption = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','D31:D32','ReadVariableNames',false));
    %TotalFuelConsumption{1,3} = sum(KeroseneConsumption) + FuelForOtherUses(3);
    TotalFuelConsumption{1,4} = TotalFuelConsumptionForMV{1,2} + TotalFuelConsumptionForMV{1,4};% + FuelForOtherUses(4);
    %LiquefiedPetroleumGasConsumption = readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','F29:F29','ReadVariableNames',false);
    %TotalFuelConsumption{1,5} = LiquefiedPetroleumGasConsumption{1,1};
    TotalFuelConsumption{1,6} = sum(TotalFuelConsumption{1,1:5})*CrudeOilToFuelRatio;
    TotalFuelConsumption{1,7} = NaturalGasForFuelRefining;
    %% emissions coefficients - upstream
    EmissionsCoefficientsUpstream = Data.EmissionsCoefficientsUpstream; %% array(6,7)
    %% total emissions per year
    RowNames = {'Mazut', 'Diesel', 'Kerosene', 'Gasoline','Liquefied Petroleum Gas','Crude Oil', 'Natural Gas', 'Battery Manufaturing'};
    TotalEmissionsPerCurrentYear = array2table(zeros(8,7), 'RowNames', RowNames);
    TotalEmissionsPerCurrentYear.Properties.VariableNames = {'CH4', 'CO2','Hydroflour Carbon','Air Pollutants','Mining Waste','Waste Water','CO2E'};
    for i=1:height(TotalEmissionsPerCurrentYear)-1 %% 1-7
        for j=1:width(TotalEmissionsPerCurrentYear) %%1-7
            TotalEmissionsPerCurrentYear{i,j} = EmissionsCoefficientsUpstream(i,j)*TotalFuelConsumption{1,i}/1000; % tons
        end    
    end
    TotalFuelAmounts = removevars(TotalFuelConsumption, {'Crude Oil', 'Natural Gas', 'Battery Manufacturing'});
    %% Emissions from EV manufacturing
    TotalEmissionsPerCurrentYear{8,7} = Data.EmissionsCoefficientsFromBatteryManufacturing*KMByEV/1000000; % tons
    
    TotalTransportationManufacturingEmissions = TotalEmissionsPerCurrentYear;

end

