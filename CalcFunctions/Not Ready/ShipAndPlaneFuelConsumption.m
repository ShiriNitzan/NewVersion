function [ShipAndPlaneFuelConsumptionCell] = ShipAndPlaneFuelConsumption(Data, ChangeInPercentages, Years)
    %% 
   ShipAndPlaneFuelConsumptionCell = cell(1,Years);
   RowNames = {'Ship International', 'Plane International','Plane Israel', 'Motor Vehicle - Liquified Petroleum Gas'};
   ColNames = {'Mazut', 'Diesel', 'Kerosene', 'Liquified Petroleum Gas'};
   ShipAndPlaneFuelConsumptionTable = array2table(zeros(4,4), 'RowNames', RowNames);
   ShipAndPlaneFuelConsumptionTable.Properties.VariableNames = ColNames;
   %% initialize
   ShipAndPlaneFuelConsumptionTable{:,:} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','B30:D32','ReadVariableNames',false));
   ShipAndPlaneFuelConsumptionCell{1} = ShipAndPlaneFuelConsumptionTable;
   %% calculate changes in fuel consumtion
    for i=2:Years
        ShipAndPlaneFuelConsumptionCell{i} = array2table(ShipAndPlaneFuelConsumptionCell{1}{:,:}*ChangeInPercentages(i));
    end
end

