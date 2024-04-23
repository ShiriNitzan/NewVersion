function [ElectricityManufacturingEmissions, FuelAmounts] = CalcElectricityManufacturing(Data, CurrentYearManufacturing, PreviousYearElectricity, ElectricityConsumptionPercentages, Year) 

%% Taking into account the changes in PV emissions by the year.
CurrentElectricityConsumptionPercentages = ElectricityConsumptionPercentages(:, Year);
if Year ~= 1 
    PreviousElectricityConsumptionPercentages = ElectricityConsumptionPercentages(:, Year-1); 
end

%% Read files
EmissionsCoefficientsUpstream = Data.EmissionsCoefficientsUpstreamElectricity;
EmissionsCoefficientsForPv = Data.EmissionsCoefficientsForPv;

%% Create Table
RowNames = {'Home', 'Public & Commercial', 'Industrial', 'Other', 'Transportation', 'Water Supply & Sewage Treatment', 'Total'};
CurrentYearTable = array2table(zeros(7,5), 'RowNames', RowNames);
CurrentYearTable.Properties.VariableNames = {'KWh From Coal', 'KWh From Natural Gas', 'KWh From Renewable Energies', 'KWh From Soler', 'KWh From Mazut'};

%% Create Table For current year
RowNames = {'Home', 'Public & Commercial', 'Industrial', 'Other', 'Transportation', 'Water Supply & Sewage Treatment', 'Total'};
CurrentYearTable = array2table(zeros(7,5), 'RowNames', RowNames);
CurrentYearTable.Properties.VariableNames = {'KWh From Coal', 'KWh From Natural Gas', 'KWh From Renewable Energies', 'KWh From Soler', 'KWh From Mazut'};

% Consumption Table - Current year
Total=0;
for j=1:width(CurrentYearTable) %% 1-5
    for i=1:height(CurrentYearTable)-1 %% 1-6
        CurrentYearTable{i,j} = CurrentYearManufacturing(i)*CurrentElectricityConsumptionPercentages(j);
        Total = Total + CurrentYearTable{i,j};
    end
    CurrentYearTable{7,j} = Total;
    Total=0;
end

%% Create Table for previous year
% (if its the first year creating a fictive tavle of zeros 
RowNames = {'Home', 'Public & Commercial', 'Industrial', 'Other', 'Transportation', 'Water Supply & Sewage Treatment', 'Total'};
PrevYearTable = array2table(zeros(7,5), 'RowNames', RowNames);
PrevYearTable.Properties.VariableNames = {'KWh From Coal', 'KWh From Natural Gas', 'KWh From Renewable Energies', 'KWh From Soler', 'KWh From Mazut'};
if Year ~= 1 
    % Consumption Table - prev year
    Total=0;
    for j=1:width(PrevYearTable) %% 1-5
        for i=1:height(PrevYearTable)-1 %% 1-6
            PrevYearTable{i,j} = PreviousYearElectricity(i)*PreviousElectricityConsumptionPercentages(j);
            Total = Total + PrevYearTable{i,j};
        end
     PrevYearTable{7,j} = Total;
     Total=0;
    end
end
%% Electricity Manufacturing Coefficients
% (ton of Coal, Soler, Gas etc' per KWH)
ElectrictyManufacturingCoefficients = Data.ElectrictyManufacturingCoefficients;

%% Fuel Amounts
ElectricityForFules = CurrentYearTable{7,1:width(CurrentYearTable)};
ElectricityForFules(3) = []; %removing renewables
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
        if(i == 6) % dealing with PV
            if (j==2 || j==7) % only relevant for CO2 / CO2E
                Delta = CurrentYearTable{7,3} - PrevYearTable{7,3}; % extra KHW consumption for this year
                    if Delta < 0
                        Delta = 0;
                    end
            TotalEmissionsPerYear{i,j} = Delta * EmissionsCoefficientsForPv{Year, 2}/1000000 * 25; %tons
            % TotalEmissionsPerYear{i,j} = CurrentYear{7,3}*EmissionsCoefficientsUpstream(i,j)/1000000; % tons
            end
        else % rest of the energy sources   
            TotalEmissionsPerYear{i,j} = EmissionsCoefficientsUpstream(i,j)*FuelAmounts{1,i}/1000; %tons
        end    
    end    
end 
TotalEmissionsPerYear.Properties.VariableNames = {'CH4', 'CO2','Hydroflour Carbon', 'Air Pollutants','Mining Waste', 'Waste Water', 'CO2 Equivalent'};
ElectricityManufacturingEmissions = TotalEmissionsPerYear;
FuelAmounts = removevars(FuelAmounts, 'Crude Oil');
end
