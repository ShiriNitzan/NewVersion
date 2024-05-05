%% Read Files  - needs to convert to function
addpath("Scenarios");
addpath("CalcFunctions");
addpath("UI");
addpath("Data");

Data = "Data.xlsx";
DataBase = struct;

%% Electricity Consumption - UPDATED 
RowNames = {'Home', 'Public & Commercial', 'Industrial', 'Other', 'Transportation', 'Water Supply and Seweage Treatment', 'Total'};
DataBase.ElectricityConsumptionTable = array2table(zeros(7, Years),'RowNames',RowNames);
ColumnNames = cell(1,Years);
s1 = "KWH for ";
for i=1:Years
    s2 = num2str(i+2016);
    ColumnNames{i} = strcat(s1, s2);
end
DataBase.ElectricityConsumptionTable.Properties.VariableNames = cellstr(ColumnNames);
DataBase.ElectricityConsumptionTable{1:6, 1} = table2array(readtable(Data,'Sheet','ElectricityConsumption','Range','B3:B8','ReadVariableNames',false));

IndustryElectricityConsumptionChange = readtable(Data,'Sheet','ElectricityConsumption','Range','R5:R5','ReadVariableNames',false);
DataBase.IndustryElectricityConsumptionChange = IndustryElectricityConsumptionChange{1,1};

ElectricityLossRatio = readtable(Data,'Sheet','ElectricityConsumption','Range','B17:B17','ReadVariableNames',false);
DataBase.ElectricityLossRatio = ElectricityLossRatio{1,1};
%% Transportation Cosnumption
RowNames = {'Bus', 'Car', 'Minibus', 'Motorcycle', 'Truck', 'LCV', 'PassengerTrain','Freight Train', 'Total'};
DataBase.TransportationConsumptionTable = array2table(zeros(9, Years),'RowNames', RowNames);
ColumnNames = cell(1,Years);
s1 = "Annual Travel (KM) for ";
for i=1:Years
    s2 = num2str(i+2016);
    ColumnNames{i} = strcat(s1, s2);
end
DataBase.TransportationConsumptionTable.Properties.VariableNames = cellstr(ColumnNames);
DataBase.TransportationConsumptionTable{1:8, 1} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','B3:B10','ReadVariableNames',false));
DataBase.TransportationConsumptionTable{9, 1} = sum(DataBase.TransportationConsumptionTable{1:8,1});

%% Vehicle Amounts
DataBase.VehicleAmountsCell = cell(1,Years);
RowNames = {'Quantity', 'Gasoline', 'Diesel', 'Drive Per Day', 'Drive Per Year', 'Cars Per Year'};
DataBase.VehicleAmountsCell{1} = array2table(zeros(6,6), 'RowNames', RowNames);
DataBase.VehicleAmountsCell{1}{:,:} = table2array(readtable(Data,'Sheet','TransportationConsumption','Range','B14:G19','ReadVariableNames',false));
ColNames = {'Bus','Car','Minibus','Motorcycle', 'Truck', 'LCV'};
DataBase.VehicleAmountsCell{1}.Properties.VariableNames = ColNames;

%% Food Cosnumption
DataBase.FoodConsumptionCell = cell(1,Years);
RowNames = table2cell(readtable(Data,'Sheet','Food','Range','A5:A68','ReadVariableNames',false))';
DataBase.FoodConsumptionCell{1} = array2table(zeros(64,4), 'RowNames', RowNames);
DataBase.FoodConsumptionCell{1}{:,:} = table2array(readtable(Data,'Sheet','Food','Range','B5:E68','ReadVariableNames',false));
ColNames = {'Humans and Other - Local','Animals - Local','Humans and Others - Import','Animals - Import'};
DataBase.FoodConsumptionCell{1}.Properties.VariableNames = ColNames;
DataBase.FoodRowName = table2cell(readtable(Data,'Sheet','Food','Range','A5:A68','ReadVariableNames',false))';

% the maximal value possible in order to keep the area for food in Israel under 4500000 m^2.
TotalGrowthForLocalFood = readtable(Data,'Sheet','Food','Range','AJ3:AJ3','ReadVariableNames',false);
DataBase.TotalGrowthForLocalFood = TotalGrowthForLocalFood{1,1};
%% water consumption
DataBase.WaterConsumptionCell = cell(1,Years);
RowNames = {'Agriculture', 'Marginal Water Percentage', 'Home Consumption(Urban)', 'Industry', 'Water for Nature', 'Water for Neighbors'};
DataBase.WaterConsumptionCell{1} = array2table(zeros(6,5), 'RowNames', RowNames);
DataBase.WaterConsumptionCell{1}{:,3:5} = table2array(readtable(Data,'Sheet','Water','Range','F12:H17','ReadVariableNames',false));
% choosing brakish, treated water water and flood of 2017.

DataBase.DrinkingWater = table2array(readtable(Data,'Sheet','Water','Range','E12:E17','ReadVariableNames',false));
% choosing drinking water for all purpuses.

DiselinatedWaterPercntage = readtable(Data,'Sheet','Water','Range','N44:N44','ReadVariableNames',false);
% precentage of desalinated from all SHAFIRIM

DataBase.DiselinatedWaterPercntage = DiselinatedWaterPercntage{1,1};
DiselinatedWaterPercntage = DiselinatedWaterPercntage{1,1};
DataBase.WaterConsumptionCell{1}{:,1} = DataBase.DrinkingWater*(1-DiselinatedWaterPercntage);
% the total water from nature is all the drinkingWater X precentage of not desalinated

DataBase.WaterConsumptionCell{1}{:,2} = DataBase.DrinkingWater*DiselinatedWaterPercntage;
DataBase.WaterConsumptionCell{1}{5,1} = DataBase.WaterConsumptionCell{1}{5,1}+DataBase.WaterConsumptionCell{1}{5,2};
DataBase.WaterConsumptionCell{1}{5,2} = 0;
ColNames = {'Water From Nature', 'Diselinated Water','Brackish Water','Treated WasteWater','Flood Water'};
DataBase.WaterConsumptionCell{1}.Properties.VariableNames = ColNames;

DataBase.SewegeTreatmentEmissionsCoefficitns = readtable(Data,'Sheet','Water','Range','B42:C42','ReadVariableNames',false);
DataBase.SewegeTreatmentEmissionsCoefficitns.Properties.VariableNames = {'Air Pollutants (KG\Ton)', 'GHG (KG\Ton)'};

LossRatio = readtable(Data,'Sheet','Water','Range','J33:J33','ReadVariableNames',false);
DataBase.LossRatio = LossRatio{1,1};
%% Electricity Consumption For Water	
DataBase.ElectricityConsumptionForWaterCell = cell(1,1);
RowNames = {'Natural Water', 'Urban Consumption','Diselinated Water','Treated Waste Water', 'Sewege'};
DataBase.ElectricityConsumptionForWaterCell{1} = array2table(zeros(5,1), 'RowNames', RowNames);
DataBase.ElectricityConsumptionForWaterCell{1}{:,1} = table2array(readtable(Data,'Sheet','Water','Range','I33:I37','ReadVariableNames',false));
								

%% construction
RowNames = {'Agriculture', 'Other Public Buildings', 'Helathcare', 'Education', 'Industry and Storage', 'Transportation and Communications', 'Trade', 'Offices', 'Hosting', 'Residential', 'Total'};
DataBase.ConstructionTable = array2table(zeros(11,Years), 'RowNames', RowNames);
s1 = "Area for Construction ";
ColumnNames = cell(1,Years);
for i=1:Years
    s2 = num2str(i+2016);
    ColumnNames{i} = strcat(s1, s2);
end
DataBase.ConstructionTable.Properties.VariableNames = cellstr(ColumnNames);
DataBase.ConstructionTable{1:10, 1} = table2array(readtable(Data,'Sheet','Construction','Range','C3:C12','ReadVariableNames',false));
DataBase.ConstructionTable{11, 1} = sum(DataBase.ConstructionTable{1:10, 1});

DataBase.TotalBuiltArea = 2288; % square kilometer

%% Materials - generated waste and recycling - on hold
WateAndRecyclingCell = cell(1,Years);
RowNames = {'Organic Products','Plastic', 'Paper', 'Cardboard', 'Diapers', 'Garden Waste', 'Textile', 'Metal', 'Glass', 'Pruned Trees','Wood', 'Oils', 'Others'};
WateAndRecyclingCell{1} =  array2table(zeros(13,8), 'RowNames', RowNames);
WateAndRecyclingCell{1}{:,:} = table2array(readtable(Data,'Sheet','Materials','Range','I4:P16','ReadVariableNames',false));
ColNames = {'Local Authorities - Waste', 'Local Authorities - Recycling', 'Industry - Waste', 'Industry - Recycling','Food Industry - Waste','Food Industry - Recycling' ,'Agriculture - Waste', 'Agriculture - Recycling'};
WateAndRecyclingCell{1}.Properties.VariableNames = ColNames;

DataBase.WateAndRecyclingCell = WateAndRecyclingCell;
%% Amounts of Fuels For Industry in tons of oil equivelent
DataBase.AmountsOfFuelsCells = cell(1,Years); %% including mazut, kerosene and LPG for transportation
RowNames = {'Crude Oil Products - Not for Energy', 'Crude Oil For Export', 'Crude Oil Import','Crude Oil Products - For Energy', 'LPG - Home', 'LPG - Commertiel'  };
DataBase.AmountsOfFuelsCells{1} = array2table(zeros(6,7),'RowNames', RowNames);
DataBase.AmountsOfFuelsCells{1}{1,:} = table2array(readtable(Data,'Sheet','Materials','Range','P45:V45','ReadVariableNames',false));
DataBase.AmountsOfFuelsCells{1}{2,:} = table2array(readtable(Data,'Sheet','Materials','Range','P49:V49','ReadVariableNames',false));
DataBase.AmountsOfFuelsCells{1}{3,:} = table2array(readtable(Data,'Sheet','Materials','Range','P57:V57','ReadVariableNames',false));
DataBase.AmountsOfFuelsCells{1}{4,:} = table2array(readtable(Data,'Sheet','Materials','Range','P41:V41','ReadVariableNames',false));
DataBase.AmountsOfFuelsCells{1}{5,6} = table2array(readtable(Data,'Sheet','Materials','Range','R30:R30','ReadVariableNames',false));
DataBase.AmountsOfFuelsCells{1}{6,6} = table2array(readtable(Data,'Sheet','Materials','Range','R31:R31','ReadVariableNames',false));
ColNames = {'Naptha', 'Mazut','Diesel','Kerosene','Gasoline','Liquified Petroleum Gas', 'Other'};
DataBase.AmountsOfFuelsCells{1}.Properties.VariableNames = ColNames;

%% Water for food percentages

DataBase.WaterForFoodPercentages = table2array(readtable(Data,'Sheet','Food','Range','T6:T10','ReadVariableNames',false))';
%% initial percentage
DataBase.InitialPercentage = table2array(readtable(Data,'Sheet','ElectricityConsumption','Range','B13:F13','ReadVariableNames',false));

%% Electricity Consumption Emissions In Transportation
DataBase.ElectricityConsumptionEmissionsInTransportation = table2array(readtable(Data,'Sheet','ElectricityConsumption','Range','I22:I25','ReadVariableNames',false)); %% all zeroes at the moment
DataBase.EmissionsCoefficientsFromBatteryManufacturing = table2array(readtable(Data,'Sheet','ElectricityConsumption','Range','K22:K22','ReadVariableNames',false)); %% all zeroes at the moment

%% Calc Area For food consumption
DataBase.AreaCoefficientsLocal = readtable(Data,'Sheet','Food','Range','W4:W67','ReadVariableNames',false);
DataBase.AreaCoefficientsLocal = table2array(DataBase.AreaCoefficientsLocal);
DataBase.AreaCoefficientsGlobal = readtable(Data,'Sheet','Food','Range','X4:X67','ReadVariableNames',false);
DataBase.AreaCoefficientsGlobal =table2array(DataBase.AreaCoefficientsGlobal);

%% Calc CO2E For food consumption
DataBase.FoodEmissionCoefficients = table2array(readtable(Data,'Sheet','Food','Range','L3:M66','ReadVariableNames',false));

%% Calc Construction
DataBase.CostructionEmissionCoefficients = table2array(readtable(Data,'Sheet','Construction','Range','A24:F24','ReadVariableNames',false));
DataBase.ConstructionMaterialCoefficients = table2array(readtable(Data,'Sheet','Construction','Range','A19:F19','ReadVariableNames',false));

%Material consumption table
DataBase.MaterialConsumption = table2array(readtable(Data,'Sheet','Construction','Range','B41:G42','ReadVariableNames',false));

% Mortar production
MortarProductionCO2ECoefficient = readtable(Data,'Sheet','Construction','Range','L36:L36','ReadVariableNames',false);
DataBase.MortarProductionCO2ECoefficient = MortarProductionCO2ECoefficient{1,1};
%% Calc Consumption emissions

DataBase.ConsumptionEmissionCoefficients = table2array(readtable(Data,'Sheet','Materials','Range','X3:X15','ReadVariableNames',false));
DataBase.CrudeOilRefiningEmissionsCoefficients = readtable(Data,'Sheet','Materials','Range','B41:H46','ReadVariableNames',false);
%% Calc Electricity Consumption
DataBase.EmissionsFromElectricityConsumption = table2array(readtable(Data,'Sheet','ElectricityConsumption','Range','I12:P18','ReadVariableNames',true));

DataBase.ElctricityFromNatualGasCoeff = array2table(zeros(2,1));
RowNames = {'Converted', 'Combined Cycle'};
DataBase.ElctricityFromNatualGasCoeff.Properties.RowNames = RowNames;
DataBase.ElctricityFromNatualGasCoeff{1,1}  = 474;
DataBase.ElctricityFromNatualGasCoeff{2,1}  = 369;

%% Calc electricity for water

DataBase.ElectricityConsumptionCoefficients = table2array(readtable(Data,'Sheet','Water','Range','B12:B17','ReadVariableNames',false));
DataBase.UrbanConsumptionPercentages = table2array(readtable(Data,'Sheet','Water','Range','M20:R20','ReadVariableNames',false));
DataBase.RatioForBrackishWater = table2array(readtable(Data,'Sheet','Water','Range','P23:Q23','ReadVariableNames',false));

%% Calc electricity manufacturing
DataBase.EmissionsCoefficientsForPv = readtable(Data,'Sheet','PVEmissions','Range','I8:J42','ReadVariableNames',true);
DataBase.EmissionsCoefficientsUpstreamElectricity = table2array(readtable(Data,'Sheet','ElectricityManufactureEmissions','Range','B37:G43','ReadVariableNames',false))';
DataBase.ElectrictyManufacturingCoefficients = table2array(readtable(Data,'Sheet','ElectricityManufactureEmissions','Range','B33:E33','ReadVariableNames',false));
CrudeOilToFuelRatio = readtable(Data,'Sheet','ElectricityManufactureEmissions','Range','R28:R28','ReadVariableNames',false);
DataBase.CrudeOilToFuelRatio = CrudeOilToFuelRatio{1,1};

%% Calc transportation consumption

DataBase.TransportationHotEmissionsCoefficients = table2array(readtable(Data,'Sheet','TransportationConsumption','Range','K25:Q38','ReadVariableNames',false));
DataBase.TransportationColdEmissionsCoefficients = table2array(readtable(Data,'Sheet','TransportationConsumption','Range','T25:Z38','ReadVariableNames',false));
DataBase.TransportationEvaporationEmissionsWhileDriving = table2array(readtable(Data,'Sheet','TransportationConsumption','Range','AC25:AI38','ReadVariableNames',false));
DataBase.TransportationEvaporationEmissionsAfterDriving = table2array(readtable(Data,'Sheet','TransportationConsumption','Range','AL25:AR38','ReadVariableNames',false));
DataBase.TransportationEvaporationEmissionsEveryDay = table2array(readtable(Data,'Sheet','TransportationConsumption','Range','AU25:BA38','ReadVariableNames',false));
DataBase.TransportationGridingEmissions = table2array(readtable(Data,'Sheet','TransportationConsumption','Range','BD25:BJ38','ReadVariableNames',false));
DataBase.PassengerTrainEmissionCoefficients = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','L55:L66','ReadVariableNames',false));
DataBase.PassengerTrainEmissionCoefficients(11, :) = []; 
DataBase.FreightTrainEmissionCoefficients = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','N55:N66','ReadVariableNames',false));
DataBase.FreightTrainEmissionCoefficients(11,:) = [];

%% Calc transportation manufacturing

RowNames = {'Hot Emissions', 'Cold Emissions', 'Evaporation Emissions', 'Evaporation Emissions - After Driving', 'Evaporation Emissions - Every Day', 'Grinding Emissiobs'};
DataBase.FuelConsumptionCoefficients = array2table(zeros(6, 7), 'RowNames', RowNames);
DataBase.FuelConsumptionCoefficients.Properties.VariableNames = {'Bus', 'Car', 'Minibus', 'Motorcycle', 'Truck', 'LCV', 'Train'};

DataBase.FuelConsumptionCoefficients{1,1:6} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','U17:Z17','ReadVariableNames',false));
DataBase.FuelConsumptionCoefficients{2,1:6} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','AD17:AI17','ReadVariableNames',false));
DataBase.FuelConsumptionCoefficients{3,1:6} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','AM18:AR18','ReadVariableNames',false));
DataBase.FuelConsumptionCoefficients{4,1:6} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','AV17:BA17','ReadVariableNames',false));
DataBase.FuelConsumptionCoefficients{5,1:6} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','BE17:BJ17','ReadVariableNames',false));
DataBase.FuelConsumptionCoefficients{6,1:6} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','BN17:BS17','ReadVariableNames',false));
    
DataBase.TrainFuelConsumptionCoefficints = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','K73:K74','ReadVariableNames',false))';
    
InflationCoefficient = readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','P53:P53','ReadVariableNames',false);
DataBase.InflationCoefficient = InflationCoefficient{1,1};
    
CrudeOilToFuelRatio = readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','AC51:AC51','ReadVariableNames',false);
DataBase.CrudeOilToFuelRatio = CrudeOilToFuelRatio{1,1};
    
NaturalGasForFuelRefining = readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','I35:I35','ReadVariableNames',false);
DataBase.NaturalGasForFuelRefining = NaturalGasForFuelRefining{1,1};
    
DataBase.EmissionsCoefficientsUpstream = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','B50:H56','ReadVariableNames',false))'; %% array(6,7)

%% Calc Waste and recycling    
DataBase.ExportWasteForRecyclingPercentage = table2array(readtable(Data,'Sheet','Materials','Range','I20:I32','ReadVariableNames',false));
    
%% Calc Water for Food Consumption 
DataBase.WaterConsumptionCoefficientsLocal = table2array(readtable(Data,'Sheet','Food','Range','H4:H68','ReadVariableNames',false));
DataBase.WaterConsumptionCoefficientsGlobal = table2array(readtable(Data,'Sheet','Food','Range','I4:I68','ReadVariableNames',false));    

%% Waste incinaration values
DataBase.WasteToElectricity = 0.807;
DataBase.IncinarationEmissionCoefficient = 1.01;

%% Transition to buses and trains
DataBase.TransitionToBus = 0.5;
DataBase.TransitionToTrain = 1- DataBase.TransitionToBus;

%% Organic Waste Amounts - for food
DataBase.OrganicWasteCoefficients = table2array(readtable(Data,'Sheet','Food','Range','H80:H80','ReadVariableNames',false));

DataBase.OrganicWasteAmountsCell = cell(1,Years);
RowNames = {'Local Authorities', 'Food Industry', 'Agriculture'};
DataBase.OrganicWasteAmountsCell{1} = readtable(Data,'Sheet','Food','Range','H73:I76','ReadVariableNames',true);
DataBase.OrganicWasteAmountsCell{1}.Properties.RowNames = RowNames;

%% Resources - Area
DataBase.AreaForSolarEnergyCoefficients = readtable(Data,'Sheet','Area','Range','A1:E35','ReadVariableNames',true, 'ReadRowNames',true);
DataBase.RenewablePercents = [1 0 0 0];
DataBase.RenewablePercents = array2table(DataBase.RenewablePercents);
DataBase.RenewablePercents.Properties.VariableNames = {'PV','Wind', 'Biomass', 'Thermo Solar'};
DataBase.LowerBoundForArea = 6; %% according to shockley-queisser limit
DataBase.KWToKwh = readtable(Data,'Sheet','Area','Range','N39:O44','ReadRowNames',true);
DataBase.PVType = 'Dual';

%area distribution
DataBase.AreaDistribution = readtable(Data,'Sheet','Area','Range','H1:K6','ReadVariableNames',true, 'ReadRowNames',true);
DataBase.AreaCostForElectricity = readtable(Data,'Sheet','Money','Range','N37:Q71','ReadVariableNames',true, 'ReadRowNames',true);

%area for food
DataBase.AreaForFoodCoefficients = readtable(Data,'Sheet','Food','Range','W3:X67','ReadVariableNames',true);
%% Money
DataBase.SettingCosts = readtable(Data,'Sheet','Money','Range','A2:I36','ReadVariableNames',true, 'ReadRowNames',true);
DataBase.OperatingCosts = readtable(Data,'Sheet','Money','Range','A41:I75','ReadVariableNames',true, 'ReadRowNames',true);
DataBase.ILSPerTon = readtable(Data,'Sheet','Money','Range','L19:O23','ReadVariableNames',false, 'ReadRowNames',true);

%% 
DataBase.ChnageStruct = struct;
DataBase.ChnageStruct.Electricity = readtable("The Three Scenarios.xlsx",'Sheet','ChangesInConsumptionType','Range','A2:B5','ReadRowNames',true);
DataBase.ChnageStruct.Water = readtable("The Three Scenarios.xlsx",'Sheet','ChangesInConsumptionType','Range','A8:B12','ReadRowNames',true);
DataBase.ChnageStruct.Transportation = readtable("The Three Scenarios.xlsx",'Sheet','ChangesInConsumptionType','Range','A15:B21','ReadRowNames',true);
DataBase.ChnageStruct.Food = readtable("The Three Scenarios.xlsx",'Sheet','ChangesInConsumptionType','Range','D2:E65','ReadRowNames',true);
