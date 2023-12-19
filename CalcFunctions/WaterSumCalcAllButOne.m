function [WaterSum, GlobalWaterDiff, LocalWaterDiff] = WaterSumCalcAllButOne(AllButOneScenario,FullScenario, WaterFromFood, WaterFromFoodFull)
   WaterForAllButOneScenario = sum(AllButOneScenario{1,width(AllButOneScenario)}{1,1}{1,5:8});
   WaterForFullScenario = sum(FullScenario{1,width(FullScenario)}{1,1}{1,5:8});
   WaterSum = WaterForFullScenario - WaterForAllButOneScenario; %% m^3*10^6

 GlobalWaterDiff = sum(WaterFromFoodFull{1,width(WaterFromFoodFull)}{1,3:4})/1000000 - sum(WaterFromFood{1,width(WaterFromFood)}{1,3:4})/1000000;
 LocalWaterDiff = WaterSum;
end