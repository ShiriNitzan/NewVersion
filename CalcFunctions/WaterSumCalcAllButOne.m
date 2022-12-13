function [WaterSum, GlobalWaterDiff, LocalWaterDiff] = WaterSumCalcAllButOne(AllButOneScenario,FullScenario, WaterFromFood, WaterFromFoodFull)
   WaterForAllButOneScenario = sum(AllButOneScenario{1,width(AllButOneScenario)}{1,1}{7,:});
   WaterForFullScenario = sum(FullScenario{1,width(FullScenario)}{1,1}{7,:});
   WaterSum = WaterForFullScenario - WaterForAllButOneScenario; %% m^3*10^6

    GlobalWaterDiff = sum(WaterFromFoodFull{1,width(WaterFromFoodFull)}{1,3:4})/1000000 - sum(WaterFromFood{1,width(WaterFromFood)}{1,3:4})/1000000;
    LocalWaterDiff = (WaterForFullScenario - sum(WaterFromFoodFull{1,width(WaterFromFoodFull)}{1,3:4})/1000000)...
    -(WaterForAllButOneScenario - sum(WaterFromFood{1, width(WaterFromFood)}{1,3:4})/1000000);
end