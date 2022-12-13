function [OperatingCost] = CalcOperationCosts(RenewableKWConsumption, CostCoefficients)
    OperatingCost = zeros(6, 1);
    OperatingCost(1) = RenewableKWConsumption(2)*CostCoefficients(1);
    for i = 3:6
        OperatingCost(i-1) = RenewableKWConsumption(i)*CostCoefficients(i);
    end
    OperatingCost(6) = sum(OperatingCost(1:5));
    OperatingCost = array2table(OperatingCost);
    OperatingCost.Properties.RowNames = {'Natural Gas', 'PV', 'Wind', 'Biomass', 'Thermo Solar', 'Total'};
end