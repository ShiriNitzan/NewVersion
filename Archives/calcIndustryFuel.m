%% calc fuel for industry
    function [fuelForIndustryByYears] = calcIndustryFuel(AmountsOfFuelsCells,FuelForEnergyPercentage)

        
        fuelForIndustryByYears = cell(1,Years);
        ColumnNames = cell(1,width(fuelForIndustryByYears));

        for i = 1:Years
            A = array2table(AmountsOfFuelsCells{i}{4,:}*FuelForEnergyPercentage(i));
            A.Properties.VariableNames =  {'Naptha', 'Mazut','Diesel','Kerosene','Gasoline','Liquified Petroleum Gas', 'Other'}; % Naming the variables
            fuelForIndustryByYears{1, i} = A;

            year = num2str(i+2016);%for years on tha table
            ColumnNames{i} = year;
        end
        
        fuelForIndustryByYears = cell2table(fuelForIndustryByYears);
       
        fuelForIndustryByYears.Properties.VariableNames = ColumnNames;

     end