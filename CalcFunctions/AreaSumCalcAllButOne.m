function [AreaSum, GlobalAreaDiff, LocalAreaDiff] = AreaSumCalcAllButOne(AllButOneScenario,FullScenario)
    AreaForAllButOne = AllButOneScenario{2,width(AllButOneScenario)}{1,1} + sum(AllButOneScenario{3,width(AllButOneScenario)}{1,1}{65,:}) + AllButOneScenario{8,width(AllButOneScenario)}{1,1};
    AreaForFullScenario = FullScenario{2,width(FullScenario)}{1,1} + sum(FullScenario{3,width(FullScenario)}{1,1}{65,:}) + FullScenario{8,width(FullScenario)}{1,1};
    AreaSum = (AreaForFullScenario-AreaForAllButOne); %% km^2
    GlobalAreaDiff = FullScenario{3,width(FullScenario)}{1,1}{65,2} - AllButOneScenario{3,width(AllButOneScenario)}{1,1}{65,2};
    LocalAreaDiff = FullScenario{2,width(FullScenario)}{1,1} - AllButOneScenario{2,width(AllButOneScenario)}{1,1}...
                     + FullScenario{3,width(FullScenario)}{1,1}{65,1} - AllButOneScenario{3,width(AllButOneScenario)}{1,1}{65,1}...
                     + FullScenario{8,width(FullScenario)}{1,1} - AllButOneScenario{8,width(AllButOneScenario)}{1,1};
end