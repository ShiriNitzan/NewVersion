function [SewegeTreatmentEmmissionsTable] = CalcSewegeEmissions(Data,WaterConsumption)
%% Sewege
SewegeEmissionsCoefficients = Data.SewegeTreatmentEmissionsCoefficitns;
UrbanConsumptionPercentages = Data.UrbanConsumptionPercentages;
RatioForBrackishWater = Data.RatioForBrackishWater;
UrbanConsumption_FreshWater = WaterConsumption{1,1};
%%UrbanConsumption_FreshWater = WaterConsumption{4,1}+WaterConsumption{4,2}+WaterConsumption{4,3}; %% inculding diselinated water and brackish water

WaterForConstruction = (WaterConsumption{1,1}*0.16)*UrbanConsumptionPercentages(6);
%WaterForConstruction = (WaterConsumption{4,1}+WaterConsumption{4,2})*UrbanConsumptionPercentages(6);
UrbanConsumption_NoConstruction = UrbanConsumption_FreshWater-WaterForConstruction; %% and no treated waste water

Gardening = (WaterConsumption{1,1}*0.11)*UrbanConsumptionPercentages(4) ;
%Gardening = (WaterConsumption{4,1}+WaterConsumption{4,2})*UrbanConsumptionPercentages(4) + WaterConsumption{4,3}*RatioForBrackishWater(1);
Residential = (WaterConsumption{1,1})*UrbanConsumptionPercentages(1);
%Residential = (WaterConsumption{4,1}+WaterConsumption{4,2})*UrbanConsumptionPercentages(1);
TotalSewege = WaterConsumption{1,6};
%TotalSewege = UrbanConsumption_NoConstruction-Gardening-0.15*Residential;

SewegeTreatmentEmmissionsTable = array2table(zeros(1,2));
SewegeTreatmentEmmissionsTable.Properties.VariableNames = {'Air Pollutants', 'GHG'};
SewegeTreatmentEmmissionsTable{1,1} = SewegeEmissionsCoefficients{1,1}*TotalSewege/1000; %% tons
SewegeTreatmentEmmissionsTable{1,2} = SewegeEmissionsCoefficients{1,2}*TotalSewege/1000; %% tons


end