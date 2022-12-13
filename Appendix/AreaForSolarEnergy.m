
%%General Assumptions
addpath("Data");
CostEfficiency = "Files_Files_pirsumim_nilve_alut_tohelet.xlsx";
AreaPotential = "Data\Files_Shimuah_Files_Shimuah_nilve_shtahim_poten _nnnxlsx.xlsx";
RowNames = {'Ground', 'Rooftops','Reservoirs', 'Interchanges','Other Potentials', 'Other Dual Usages'};

PotentialSummary = readtable(AreaPotential,'Sheet','ריכוז פוטנציאל','Range','C3:D8','ReadVariableNames',false, 'ReadRowNames', false);
PotentialSummary.Properties.RowNames = RowNames;
PotentialSummary.Properties.VariableNames = {'Potential (KM^2)', 'Power(mWh)'};
CostsOfPollutans = readtable(CostEfficiency,'Sheet','הנחות עבודה','Range','L39:M42','ReadVariableNames',false, 'ReadRowNames', true);
ElectricityCoefficientsForSurfaces = readtable(AreaPotential,'Sheet','ריכוז פוטנציאל','Range','K4:L5','ReadVariableNames',false, 'ReadRowNames', false);

GroundBias = [0.7 0.3];
DualBias = [0.3 0.7];
SolarPowerUntilNow = readtable(AreaPotential,'Sheet','ריכוז פוטנציאל','Range','D11:D11','ReadVariableNames',false, 'ReadRowNames', false);
SolarPowerUntilNow = SolarPowerUntilNow{1,1};

ElectricityManufacturingNeeded = readtable(CostEfficiency,'Sheet','הספק קיים ותחזית יצור','Range','I112:O134','ReadVariableNames',true, 'ReadRowNames', true);
%% Scenario 1 - Ground, 17% solar power

RowNames = 2020:1:2030;
ColNames = 2020:1:2040;
RowNames = string(RowNames);
ColNames = string(ColNames);
RenewableEnergyMatrix = readtable(CostEfficiency,'Sheet','מטריצת ייצור מתחדשות','Range','C56:W66','ReadVariableNames',false, 'ReadRowNames', false);
RenewableEnergyMatrix.Properties.RowNames = RowNames;
RenewableEnergyMatrix.Properties.VariableNames = ColNames;
AreaForSolarElectricityScenario1  = array2table(zeros(2, height(RenewableEnergyMatrix)+1));
RowNames(length(RowNames)+1) = 'Total';
AreaForSolarElectricityScenario1.Properties.VariableNames = RowNames;
AreaForSolarElectricityScenario1.Properties.RowNames = {'Ground','Dual'};
for i = 1:height(RenewableEnergyMatrix)
    AreaForSolarElectricityScenario1{1,i} = RenewableEnergyMatrix{i,i}*0.7/ElectricityCoefficientsForSurfaces{1,1};
    AreaForSolarElectricityScenario1{2,i} = RenewableEnergyMatrix{i,i}*0.3/ElectricityCoefficientsForSurfaces{1,2};
end

AreaForSolarElectricityScenario1{1, width(AreaForSolarElectricityScenario1)} = sum(AreaForSolarElectricityScenario1{1,1:width(AreaForSolarElectricityScenario1)-1});
AreaForSolarElectricityScenario1{2, width(AreaForSolarElectricityScenario1)} = sum(AreaForSolarElectricityScenario1{2,1:width(AreaForSolarElectricityScenario1)-1});
%% Scenario 2 - Dual, 17% solar power

RowNames = 2020:1:2030;
ColNames = 2020:1:2040;
RowNames = string(RowNames);
ColNames = string(ColNames);
RenewableEnergyMatrix = readtable(CostEfficiency,'Sheet','מטריצת ייצור מתחדשות','Range','C56:W66','ReadVariableNames',false, 'ReadRowNames', false);
RenewableEnergyMatrix.Properties.RowNames = RowNames;
RenewableEnergyMatrix.Properties.VariableNames = ColNames;
AreaForSolarElectricityScenario2  = array2table(zeros(2, height(RenewableEnergyMatrix)+1));
RowNames(length(RowNames)+1) = 'Total';
AreaForSolarElectricityScenario2.Properties.VariableNames = RowNames;
AreaForSolarElectricityScenario2.Properties.RowNames = {'Ground','Dual'};
for i = 1:height(RenewableEnergyMatrix)
    AreaForSolarElectricityScenario2{1,i} = RenewableEnergyMatrix{i,i}*0.3/ElectricityCoefficientsForSurfaces{1,1};
    AreaForSolarElectricityScenario2{2,i} = RenewableEnergyMatrix{i,i}*0.7/ElectricityCoefficientsForSurfaces{1,2};
end

AreaForSolarElectricityScenario2{1, width(AreaForSolarElectricityScenario2)} = sum(AreaForSolarElectricityScenario2{1,1:width(AreaForSolarElectricityScenario2)-1});
AreaForSolarElectricityScenario2{2, width(AreaForSolarElectricityScenario2)} = sum(AreaForSolarElectricityScenario2{2,1:width(AreaForSolarElectricityScenario2)-1});
