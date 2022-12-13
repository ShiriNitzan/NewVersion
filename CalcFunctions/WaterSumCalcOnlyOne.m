function [WaterSum, GlobalWaterDiff, LocalWaterDiff] = WaterSumCalcOnlyOne(ConsumptionAmounts, WaterFromFood)
    WaterFor2017 = sum(ConsumptionAmounts{1,1}{1,1}{7,:});
    WaterFor2050 = sum(ConsumptionAmounts{1,width(ConsumptionAmounts)}{1,1}{7,:});
    WaterSum = WaterFor2050-WaterFor2017; %% m^3*10^6

    GlobalWaterDiff = sum(WaterFromFood{1,width(WaterFromFood)}{1,3:4})/1000000 - sum(WaterFromFood{1,1}{1,3:4})/1000000;
    LocalWaterDiff = (WaterFor2050 - sum(WaterFromFood{1,width(WaterFromFood)}{1,3:4})/1000000)...
    -(WaterFor2017 - sum(WaterFromFood{1, 1}{1,3:4})/1000000);
end