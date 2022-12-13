function [MaterialConsumption, TotalConstructionEmissionsAndWaste] = CalcConstruction(Data, CurrentYearConstruction)
%% read file

EmissionCoefficients = Data.CostructionEmissionCoefficients;
MaterialCoefficients = Data.ConstructionMaterialCoefficients;

%% Materials Consumption Table
RowNames = {'Agriculture', 'Other Public Buldings', 'Healthcare', 'Education', 'Industry and Storage', 'Transportation and Communications', 'Trade', 'Offices', 'Hosting', 'Residential', 'Total For Construction', 'Local Cement For Other Uses', 'Imported Cement For Other Uses'};
ColNames = {'Gravel', 'Sand', 'Calcite', 'Plaster', 'Clay', 'Other Constructionn Materials'};
MaterialConsumption = array2table(zeros(13,6), 'RowNames', RowNames);
for i=1:width(MaterialConsumption) %%1-6
    for j = 1:height(MaterialConsumption)-3 %%1-10
        MaterialConsumption{j,i} = CurrentYearConstruction(j)*MaterialCoefficients(i); % tons of materials
    end
    MaterialConsumption{11, i} = sum(MaterialConsumption{1:10, i});
end
MaterialConsumption{12:13, :} = Data.MaterialConsumption;
MaterialConsumption.Properties.VariableNames = ColNames;


%% emissions table
RowNames = {'Agriculture', 'Other Public Buldings', 'Healthcare', 'Education', 'Industry and Storage', 'Transportation and Communications', 'Trade', 'Offices', 'Hosting', 'Residential', 'Total For Construction', 'Local Cement For Other Uses', 'Imported Cement For Other Uses'};
ColNames = {'Mining Waste', 'CO2', 'NOX', 'PM10', 'SO2', 'CO2E From Mortar Production'};
TotalConstructionEmissionsAndWaste = array2table(zeros(13,6), 'RowNames', RowNames);
for i = 1:width(TotalConstructionEmissionsAndWaste)-1 %% 1-5
    for j = 1:height(TotalConstructionEmissionsAndWaste) %% 1-13
        TotalConstructionEmissionsAndWaste{j,i} = EmissionCoefficients(i)*sum(MaterialConsumption{j, 3:5}); % million tons  
    end
end
TotalConstructionEmissionsAndWaste.Properties.VariableNames = ColNames;

%% Emissions from mortar manufacturing
MortarProductionCO2ECoefficient = Data.MortarProductionCO2ECoefficient;
for j = 1:height(TotalConstructionEmissionsAndWaste)
    TotalConstructionEmissionsAndWaste{j,6} = sum(MaterialConsumption{j, 3:5})*MortarProductionCO2ECoefficient;
end

end

