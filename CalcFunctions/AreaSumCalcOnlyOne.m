function [AreaSum, GlobalAreaDiff, LocalAreaDiff] = AreaSumCalcOnlyOne(Resources)
  AreaFor2017 = Resources{2,1}{1,1} + sum(Resources{3,1}{1,1}{65,:}) + Resources{8,1}{1,1};
  AreaFor2050 = Resources{2,width(Resources)}{1,1} + sum(Resources{3,width(Resources)}{1,1}{65,:}) + Resources{8,width(Resources)}{1,1};
  AreaSum = AreaFor2050-AreaFor2017; %% km^2
  GlobalAreaDiff = Resources{3,width(Resources)}{1,1}{65,2} - Resources{3,1}{1,1}{65,2};
  LocalAreaDiff = Resources{2,width(Resources)}{1,1} - Resources{2,1}{1,1}...
                     + Resources{3,width(Resources)}{1,1}{65,1} - Resources{3,1}{1,1}{65,1}...
                     + Resources{8,width(Resources)}{1,1} - Resources{8,1}{1,1};

end