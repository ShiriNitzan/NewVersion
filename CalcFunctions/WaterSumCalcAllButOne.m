function [WaterTotalDiff, GlobalWaterForFoodDiff, LocalWaterForFoodDiff] = WaterSumCalcAllButOne(AllButOneScenario,FullScenario, WaterFromFood, WaterFromFoodFull)
 WaterForAllButOneScenario = sum(AllButOneScenario{1,width(AllButOneScenario)}{1,1}{1,5:8});
 WaterForFullScenario = sum(FullScenario{1,width(FullScenario)}{1,1}{1,5:8});
 GlobalWaterForFoodDiff = sum(WaterFromFoodFull{1,width(WaterFromFoodFull)}{1,3:4})/1000000 - sum(WaterFromFood{1,width(WaterFromFood)}{1,3:4})/1000000;% Change in global water is calculated by changing the amount of global water for food
 LocalWaterForFoodDiff = sum(WaterFromFoodFull{1,width(WaterFromFoodFull)}{1,1:2})/1000000 - sum(WaterFromFood{1, width(WaterFromFood)}{1,1:2})/1000000; % A change in local water calculated by changing the global amounts of water for food
 
 if WaterForFullScenario ~= WaterForAllButOneScenario %If the amount of water between the full scenario and the specific scenario is different, the amount of water is calculated as the difference between them
    LocalWaterForFoodDiff = WaterForFullScenario - WaterForAllButOneScenario; 
 end

 WaterTotalDiff = GlobalWaterForFoodDiff + LocalWaterForFoodDiff;    %m^3*10^6

end