function [ElectricityManufacturingEmissions, FuelAmounts] = CalcElectricityManufacturing(Data, CurrentYearManufacturing,ElectricityConsumptionPercentages) %% no renewable energies - for now
%% Read files
EmissionsCoefficientsUpstream = Data.EmissionsCoefficientsUpstreamElectricity;

%% Create Table
RowNames = {'Home', 'Public & Commercial', 'Industrial', 'Other', 'Transportation', 'Water Supply & Sewage Treatment', 'Total'};
CurrentYear = array2table(zeros(7,5), 'RowNames', RowNames);
CurrentYear.Properties.VariableNames = {'KWh From Coal', 'KWh From Natural Gas', 'KWh From Renewable Energies', 'KWh From Soler', 'KWh From Mazut'};

%% Consumption Table

Total=0;
for j=1:width(CurrentYear) %% 1-5
    for i=1:height(CurrentYear)-1 %% 1-6
        CurrentYear{i,j} = CurrentYearManufacturing(i)*ElectricityConsumptionPercentages(j);
        Total = Total + CurrentYear{i,j};
    end
    CurrentYear{7,j} = Total;
    Total=0;
end

%% Electricity Manufacturing Coefficients

ElectrictyManufacturingCoefficients = Data.ElectrictyManufacturingCoefficients;

%% Fuel Amounts
ElectricityForFules = CurrentYear{7,1:width(CurrentYear)};
ElectricityForFules(3) = [];
FuelAmounts = ElectricityForFules.*ElectrictyManufacturingCoefficients;
CrudeOilToFuelRatio = Data.CrudeOilToFuelRatio;
FuelAmounts(end+1) = (FuelAmounts(3)+FuelAmounts(4))*CrudeOilToFuelRatio;

%% fuel amounts for electricity
FuelAmounts = array2table(FuelAmounts, 'RowNames', {'Amount'});
FuelAmounts.Properties.VariableNames = {'Coal', 'Natural Gas','Diesel', 'Mazut','Crude Oil'};

%% Total Emissions Per Current Year
RowNames = {'Coal', 'Natural Gas','Soler', 'Mazut', 'Crude Oil', 'PV'};
TotalEmissionsPerYear = array2table(zeros(6,7), 'RowNames', RowNames);
for i = 1:height(EmissionsCoefficientsUpstream) %% 1-6
    for  j = 1:width(EmissionsCoefficientsUpstream) %% 1-7
        if(i == 6)
            TotalEmissionsPerYear{i,j} = CurrentYear{7,3}*EmissionsCoefficientsUpstream(i,j)/1000000; % tons
        else    
            TotalEmissionsPerYear{i,j} = EmissionsCoefficientsUpstream(i,j)*FuelAmounts{1,i}/1000; %tons
        end    
    end    
end 
TotalEmissionsPerYear.Properties.VariableNames = {'CH4', 'CO2','Hydroflour Carbon', 'Air Pollutants','Mining Waste', 'Waste Water', 'CO2 Equivalent'};
ElectricityManufacturingEmissions = TotalEmissionsPerYear;
FuelAmounts = removevars(FuelAmounts, 'Crude Oil');
end

