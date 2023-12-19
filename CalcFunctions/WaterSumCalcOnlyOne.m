function [WaterSum, GlobalWaterDiff, LocalWaterDiff] = WaterSumCalcOnlyOne(ConsumptionAmounts, WaterFromFood,localWaterForFood)
    WaterFor2017 = sum(ConsumptionAmounts{1,1}{1,1}{1,5:8});
    GlobalWaterDiff = sum(WaterFromFood{1,width(WaterFromFood)}{1,3:4})/1000000 - sum(WaterFromFood{1,1}{1,3:4})/1000000;
   
   
    gap =  ConsumptionAmounts{1,width(ConsumptionAmounts)}{1,1}{1,2} - (localWaterForFood -sum(WaterFromFood{1,1}{1,1:2}))/1000000;
    ConsumptionAmounts{1,width(ConsumptionAmounts)}{1,1}{1,2}  =  ConsumptionAmounts{1,width(ConsumptionAmounts)}{1,1}{1,2} - gap;
    ConsumptionAmounts{1,width(ConsumptionAmounts)}{1,1}{1,8}  =  ConsumptionAmounts{1,width(ConsumptionAmounts)}{1,1}{1,8} - gap*0.35;
    ConsumptionAmounts{1,width(ConsumptionAmounts)}{1,1}{1,6}  =  ConsumptionAmounts{1,width(ConsumptionAmounts)}{1,1}{1,6} - gap*0.65;
    WaterFor2050 = sum(ConsumptionAmounts{1,width(ConsumptionAmounts)}{1,1}{1,5:8});
    LocalWaterDiff = WaterFor2050-WaterFor2017 ;

     WaterSum = GlobalWaterDiff + LocalWaterDiff; %% m^3*10^6
end