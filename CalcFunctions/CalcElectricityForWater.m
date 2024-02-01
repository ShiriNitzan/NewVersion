 function ElectricityForWaterConsumption = CalcElectricityForWater(Data, WaterConsumption, ElectricityConsumptionCoefficients)
 %{
     %% Urban
     UrbanConsumptionPercentages = Data.UrbanConsumptionPercentages;
     UrbanConsumption_FreshWater = WaterConsumption{1,1}*0.89; %Fresh water for domestic consumption without 11 percent of non-fresh water
     UrbanConsumption = WaterConsumption{1,1};
     Construction = UrbanConsumption_FreshWater*UrbanConsumptionPercentages(6);
     
     Gardening = (WaterConsumption{1,1}*0.11)*UrbanConsumptionPercentages(4);
     Residential =(WaterConsumption{1,1})*UrbanConsumptionPercentages(1);
     UrbanNoConstruction = UrbanConsumption - Construction;
 %}
 %% Water consumption
 DrillingWater = WaterConsumption{1,5};
 DesalinatedWater = WaterConsumption{1,8};
 ReclaimedWastewater = WaterConsumption{1,6};

 %% Electricity consumption
 DrillingWaterElectrcity = (ElectricityConsumptionCoefficients(2) + ElectricityConsumptionCoefficients(6))* DrillingWater;
 DesalinatedElectricity = DesalinatedWater*(ElectricityConsumptionCoefficients(1) + ElectricityConsumptionCoefficients(2));
 MovingReclaimedWastewaterElectricity = ElectricityConsumptionCoefficients(4)*ReclaimedWastewater;
 ReclaimedWastewaterElectricity = ReclaimedWastewater*ElectricityConsumptionCoefficients(5);
 MovingBrackishandReservoirWater = WaterConsumption{1,7}*ElectricityConsumptionCoefficients(2);
 %{
 UrbanElectricity = UrbanNoConstruction*ElectricityConsumptionCoefficients(3);
 FromNatureElectrcity = FromNature*(ElectricityConsumptionCoefficients(2) + ElectricityConsumptionCoefficients(6));
 TreatedWasteWaterElectricity = TreatedWasteWater*ElectricityConsumptionCoefficients(4);
 TotalSewege = UrbanConsumption-Contruction-Gardening-0.15*Residential;
 %}

 %% Output
 RowNames = {'Drilling Water', 'Desalinated Water', 'Moving Reclaimed Wastewater', 'Reclaimed Wastewater','Moving Brackish water, fresh and non-fresh reservoir water', 'Total'};
 %RowNames = {'Water From Nature', 'Total Urban Consumption', 'Diselinated Water', 'Treated Waste Water', 'Sewege', 'Total'};
 ElectricityForWaterConsumption = array2table(zeros(6,1), 'RowNames', RowNames);
 ElectricityForWaterConsumption.Properties.VariableNames = {'Total KWH'};
 LossRatio = Data.LossRatio;
 ElectricityForWaterConsumption{1,1} = DrillingWaterElectrcity*LossRatio;
 ElectricityForWaterConsumption{2,1} = DesalinatedElectricity*LossRatio;
 ElectricityForWaterConsumption{3,1} = MovingReclaimedWastewaterElectricity*LossRatio;
 ElectricityForWaterConsumption{4,1} = ReclaimedWastewaterElectricity*LossRatio;
 ElectricityForWaterConsumption{5,1} = MovingBrackishandReservoirWater*LossRatio;
 ElectricityForWaterConsumption{6,1} = sum(ElectricityForWaterConsumption{1:5,1})*1000000; %to compare to a cubic meter
 %{
     ElectricityForWaterConsumption{1,1} = FromNatureElectrcity*LossRatio;
     ElectricityForWaterConsumption{2,1} = UrbanElectricity*LossRatio;
     ElectricityForWaterConsumption{3,1} = DesalinatedElectricity*LossRatio;
     ElectricityForWaterConsumption{4,1} = TreatedWasteWaterElectricity*LossRatio;
     ElectricityForWaterConsumption{5,1} = SewewgeElectricity*LossRatio;
    
     ElectricityForWaterConsumption{6,1} = sum(ElectricityForWaterConsumption{1:5,1});
 %}
end

