function [SettingCost] = CalcSettingCosts(RenewableKWConsumption, CostCoefficients)
    SettingCost = zeros(6, 1);
    SettingCost(1) = RenewableKWConsumption(2)*CostCoefficients(1);
    for i = 3:6
        SettingCost(i-1) = RenewableKWConsumption(i)*CostCoefficients(i);
    end
    SettingCost(6) = sum(SettingCost(1:5)); %% total
    SettingCost = array2table(SettingCost);
    SettingCost.Properties.RowNames = {'Natural Gas', 'PV', 'Wind', 'Biomass', 'Thermo Solar', 'Total'};
end