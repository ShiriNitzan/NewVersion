function ElectricityForWaterConsumption = CalcElectricityForWater(Data, WaterConsumption, ElectricityConsumptionCoefficients)
 %% Urban
 UrbanConsumptionPercentages = Data.UrbanConsumptionPercentages;
 RatioForBrackishWater = Data.RatioForBrackishWater;

 UrbanConsumption_FreshWater = sum(WaterConsumption{3,1:2}); %% inculding diselinated water
 UrbanConsumption = sum(WaterConsumption{3,1:4});
 Contruction = UrbanConsumption_FreshWater*UrbanConsumptionPercentages(6);
 Gardening = UrbanConsumption_FreshWater*UrbanConsumptionPercentages(4) + WaterConsumption{3,3}*RatioForBrackishWater(1);
 Residential = (UrbanConsumption_FreshWater)*UrbanConsumptionPercentages(1);

 UrbanNoConstruction = UrbanConsumption - Contruction;
 %% From Nature
 FromNature = sum(WaterConsumption{:,1});
 DesalinatedWater = sum(WaterConsumption{:,2});

 %% Treated Waste Water
 TreatedWasteWater = sum(WaterConsumption{:,4});

 %% Electricity consumption
 UrbanElectricity = UrbanNoConstruction*ElectricityConsumptionCoefficients(3);
 FromNatureElectrcity = FromNature*(ElectricityConsumptionCoefficients(2) + ElectricityConsumptionCoefficients(6));
 DesalinatedElectricity = DesalinatedWater*(ElectricityConsumptionCoefficients(1) + ElectricityConsumptionCoefficients(2));
 TreatedWasteWaterElectricity = TreatedWasteWater*ElectricityConsumptionCoefficients(4);

 TotalSewege = UrbanConsumption-Contruction-Gardening-0.15*Residential;
 SewewgeElectricity = TotalSewege*ElectricityConsumptionCoefficients(5);

 %% Output
 RowNames = {'Water From Nature', 'Total Urban Consumption', 'Diselinated Water', 'Treated Waste Water', 'Sewege', 'Total'};
 ElectricityForWaterConsumption = array2table(zeros(6,1), 'RowNames', RowNames);
 ElectricityForWaterConsumption.Properties.VariableNames = {'Total KWH'};
 LossRatio = Data.LossRatio;

 ElectricityForWaterConsumption{1,1} = FromNatureElectrcity*LossRatio;
 ElectricityForWaterConsumption{2,1} = UrbanElectricity*LossRatio;
 ElectricityForWaterConsumption{3,1} = DesalinatedElectricity*LossRatio;
 ElectricityForWaterConsumption{4,1} = TreatedWasteWaterElectricity*LossRatio;
 ElectricityForWaterConsumption{5,1} = SewewgeElectricity*LossRatio;

 ElectricityForWaterConsumption{6,1} = sum(ElectricityForWaterConsumption{1:5,1});
end

