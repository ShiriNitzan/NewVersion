function [WaterSum, GlobalWaterDiff, LocalWaterDiff] = WaterSumCalcOnlyOne(ConsumptionAmounts, WaterFromFood,i)
    WaterFor2017 = sum(ConsumptionAmounts{1,1}{1,1}{1,5:8});
    WaterFor2022 = sum(ConsumptionAmounts{1,6}{1,1}{1,5:8});
    WaterFor2050 = sum(ConsumptionAmounts{1,width(ConsumptionAmounts)}{1,1}{1,5:8});
    GlobalWaterDiff = sum(WaterFromFood{1,width(WaterFromFood)}{1,3:4})/1000000 - sum(WaterFromFood{1,1}{1,3:4})/1000000; % Change in global water is calculated by changing the amount of global water for food
    LocalWaterDiff = sum(WaterFromFood{1,width(WaterFromFood)}{1,1:2})/1000000 - sum(WaterFromFood{1,1}{1,1:2})/1000000; %A change in local water calculated by changing the global amounts of water for food

    if WaterFor2050 ~= WaterFor2022 % If the amount of water between the base year and the target year is different, the amount of water is calculated as the difference between them
          LocalWaterDiff = WaterFor2050-WaterFor2017;
         
             if i == 19   %The reason for this section is to produce a result that is considered in the base year which is 2017 for the article
               LocalWaterDiff = WaterFor2050-WaterFor2022;
             end 
         
    end

     WaterSum = GlobalWaterDiff + LocalWaterDiff; %% m^3*10^6
end