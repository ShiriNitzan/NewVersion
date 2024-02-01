function [SettingCost] = CalcSettingCosts(KWForElectricity, CostCoefficients)
    SettingCost = zeros(6, 1);
    SettingCost(1) = (KWForElectricity(2) + KWForElectricity(2))*CostCoefficients(1);
  %  SettingCost(1) = KWForElectricity(2)*CostCoefficients(1);
    for i = 3:6
        SettingCost(i-1) = KWForElectricity(i)*CostCoefficients(i);
    end
    SettingCost(6) = sum(SettingCost(1:5)); %% total
    SettingCost = array2table(SettingCost);
    SettingCost.Properties.RowNames = {'Natural Gas', 'PV', 'Wind', 'Biomass', 'Thermo Solar', 'Total'};
end