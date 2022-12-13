function ElectricityForWaterConsumption = CalcElectricityForWater(Data, WaterConsumption, ElectricityConsumptionCoefficients)
 %% 
 
UrbanConsumptionPercentages = Data.UrbanConsumptionPercentages;
RatioForBrackishWater = Data.RatioForBrackishWater;
%% Sewege

UrbanConsumption_FreshWater = sum(WaterConsumption{3,1:2}); %% inculding diselinated water and brackish water
UrbanConsumption = sum(WaterConsumption{3,1:4});
Contruction = UrbanConsumption_FreshWater*UrbanConsumptionPercentages(6);
Gardening = UrbanConsumption_FreshWater*UrbanConsumptionPercentages(4) + WaterConsumption{3,3}*RatioForBrackishWater(1);
Residential = (UrbanConsumption_FreshWater)*UrbanConsumptionPercentages(1);

TotalSewege = UrbanConsumption-Contruction-Gardening-0.15*Residential;

%% 

WaterFromNature = WaterConsumption{height(WaterConsumption),1}+WaterConsumption{height(WaterConsumption),3}+WaterConsumption{height(WaterConsumption),5};
DiselinatedWater = WaterConsumption{height(WaterConsumption),2};
TotalUrbanConsumption = UrbanConsumption-Contruction;
TreatedWasteWater = WaterConsumption{height(WaterConsumption),4};

%% Electricity

RowNames = {'Water From Nature', 'Total Urban Consumption', 'Diselinated Water', 'Treated Waste Water', 'Sewege', 'Total'};
TotalElectricityFromWater = array2table(zeros(6,2), 'RowNames', RowNames);
TotalElectricityFromWater.Properties.VariableNames = {'Water Consumption', 'Total KWH'};
TotalElectricityFromWater{1,1} = WaterFromNature;
TotalElectricityFromWater{2,1} = TotalUrbanConsumption;
TotalElectricityFromWater{3,1} = DiselinatedWater;
TotalElectricityFromWater{4,1} = TreatedWasteWater;
TotalElectricityFromWater{5,1} = TotalSewege;

TotalElectricityFromWater{1,2} = TotalElectricityFromWater{1,1}*(ElectricityConsumptionCoefficients(6)+ElectricityConsumptionCoefficients(2));
TotalElectricityFromWater{2,2} = TotalElectricityFromWater{2,1}*(ElectricityConsumptionCoefficients(3));
TotalElectricityFromWater{3,2} = TotalElectricityFromWater{3,1}*(ElectricityConsumptionCoefficients(1)) + TotalElectricityFromWater{3,1}*(ElectricityConsumptionCoefficients(2));
TotalElectricityFromWater{4,2} = TotalElectricityFromWater{4,1}*(ElectricityConsumptionCoefficients(4));
TotalElectricityFromWater{5,2} = TotalElectricityFromWater{5,1}*(ElectricityConsumptionCoefficients(5));

TotalElectricityFromWater{6,2} = sum(TotalElectricityFromWater{1:5,2});
ElectricityForWaterConsumption = TotalElectricityFromWater;
end

