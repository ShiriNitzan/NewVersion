function [ConsumptionEmissionsTable,EmissionsFromCrudeOil] = CalcConsumptionEmissions(WasteAndRecycling,CrudeOilProductsAmountMaterials ,Data)
RowNames = {'Organic Products','Plastic', 'Paper', 'Cardboard', 'Diapers', 'Garden Waste', 'Textile', 'Metal', 'Glass', 'Pruned Trees','Wood', 'Oils', 'Others'};
EmissionCoefficients = Data.ConsumptionEmissionCoefficients;
ConsumptionEmissionsTable = array2table(zeros(height(WasteAndRecycling),3), 'RowNames', RowNames);
ConsumptionEmissionsTable.Properties.VariableNames = {'Burried Waste', 'CH4', 'CO2E'};
%%

%%consumption from waste handling
for i = 1:height(ConsumptionEmissionsTable)
    if(i ~= 10)
        IndustryGenerated = WasteAndRecycling{i,3} - WasteAndRecycling{i,5};
        IndustryRecycled =  WasteAndRecycling{i,4} - WasteAndRecycling{i,6};
        ConsumptionEmissionsTable{i,1} = WasteAndRecycling{i,1} - WasteAndRecycling{i,2} + WasteAndRecycling{i,7} - WasteAndRecycling{i,8} + IndustryGenerated - IndustryRecycled;
    end
    ConsumptionEmissionsTable{i,2} = ConsumptionEmissionsTable{i,1}*EmissionCoefficients(i);
    ConsumptionEmissionsTable{i,3} = ConsumptionEmissionsTable{i,2}*28;
end
%% emissions from crude oil for industry - local consumtpion and import - no energy (modeled in electricity sector)

ColNames = {'Naphta','Mazut', 'Diesel','Kerosene', 'Petrol', 'Liquified Petroleum Gas', 'Others' ,'Consumption For Industry', 'Amount of Crude Oil', 'Amount of Mining Waste', 'CH4 Emissions', 'CO2e'};
RowNames = {'Crude Oil Byproduts for Local Production - Amount', 'Crude Oil Byproduts for Local Production - GHG', 'Crude Oil Byproduts for Local Production - Air Pollutants', 'Crude Oil Byproduts for Local Production - Waste Water', 'Local Production For Export - Amount', 'Local Production For Export - GHG', 'Local Production For Export - Air Pollutants', 'Local Production For Export - Waste Water', 'Import - Amount', 'Import - GHG', 'Import - Air Pollutants', 'Import - Waste Water'};
EmissionsFromCrudeOil = array2table(zeros(12,12), 'RowNames', RowNames); %% rows 1-4 local production for local consumption // rows 5-8 local production for export // rows 9-12 import - not for energy
EmissionsFromCrudeOil.Properties.VariableNames = ColNames;

CrudeOilRefiningEmissionsCoefficients = Data.CrudeOilRefiningEmissionsCoefficients;
EmissionsFromCrudeOil{1,1:width(CrudeOilProductsAmountMaterials)} = CrudeOilProductsAmountMaterials{1,:}; %% not for energy
EmissionsFromCrudeOil{5, 1:width(CrudeOilProductsAmountMaterials)} = CrudeOilProductsAmountMaterials{2, :}; %% for export
EmissionsFromCrudeOil{9, 1:width(CrudeOilProductsAmountMaterials)} = CrudeOilProductsAmountMaterials{3, :}; %% import - not for energy

for i=1:(width(EmissionsFromCrudeOil)-5) %% 1-7
    EmissionsFromCrudeOil{2, i} = CrudeOilRefiningEmissionsCoefficients{4,i}*EmissionsFromCrudeOil{1,i}/1000;
    EmissionsFromCrudeOil{3, i} = CrudeOilRefiningEmissionsCoefficients{5,i}*EmissionsFromCrudeOil{1,i}/1000;
    EmissionsFromCrudeOil{4, i} = CrudeOilRefiningEmissionsCoefficients{6,i}*EmissionsFromCrudeOil{1,i}/1000;
    
    EmissionsFromCrudeOil{6, i} = CrudeOilRefiningEmissionsCoefficients{4,i}*EmissionsFromCrudeOil{5,i}/1000;
    EmissionsFromCrudeOil{7, i} = CrudeOilRefiningEmissionsCoefficients{5,i}*EmissionsFromCrudeOil{5,i}/1000;
    EmissionsFromCrudeOil{8, i} = CrudeOilRefiningEmissionsCoefficients{6,i}*EmissionsFromCrudeOil{5,i}/1000;
        
    EmissionsFromCrudeOil{10, i} = CrudeOilRefiningEmissionsCoefficients{4,i}*EmissionsFromCrudeOil{9,i}/1000; %% global
    EmissionsFromCrudeOil{11, i} = CrudeOilRefiningEmissionsCoefficients{5,i}*EmissionsFromCrudeOil{9,i}/1000; %% global
    EmissionsFromCrudeOil{12, i} = CrudeOilRefiningEmissionsCoefficients{6,i}*EmissionsFromCrudeOil{9,i}/1000; %% global
end

for i = 1:4:9
    EmissionsFromCrudeOil{i,8} = sum(EmissionsFromCrudeOil{i,1:7});
    EmissionsFromCrudeOil{i,9} = EmissionsFromCrudeOil{i,8}*Data.CrudeOilToFuelRatio;
    EmissionsFromCrudeOil{i,10} = EmissionsFromCrudeOil{i,9}*Data.EmissionsCoefficientsUpstreamElectricity(5,5);
    EmissionsFromCrudeOil{i,11} = EmissionsFromCrudeOil{i,9}*Data.EmissionsCoefficientsUpstreamElectricity(5,1)/1000;
    EmissionsFromCrudeOil{i,12} = EmissionsFromCrudeOil{i,11}*28;
end

%% 

end
