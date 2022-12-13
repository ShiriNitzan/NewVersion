function [TotalElectricityConsumptionEmissions, CurrentYearTotal] = CalcElectricityConsumption(Data, CurrentYearConsumption,ElectricityConsumptionPercentages, WasteIncinaration)
    %% Read Files

    Emissions = Data.EmissionsFromElectricityConsumption;
    
    %% Create Table

    RowNames = {'Home', 'Public & Commercial', 'Industrial', 'Other', 'Transportation', 'Water Supply & Sewage Treatment','Total'};
    CurrentYear = zeros(7,6);
    CurrentYear = array2table(CurrentYear, 'RowNames', RowNames);
    CurrentYear.Properties.VariableNames = {'KWh From Coal', 'KWh From Natural Gas', 'KWh From Renewable Energies', 'KWh From Soler', 'KWh From Mazut', 'KWh From Waste Incinaration'};

    %% Consumption Table
    % KWH from sources     
    Total=0;
    for j=1:width(CurrentYear)-1
        for i=1:height(CurrentYear)-1
            CurrentYear{i,j} = CurrentYearConsumption(i)*ElectricityConsumptionPercentages(j);
            Total = Total + CurrentYear{i,j};
        end
        CurrentYear{i+1,j} = Total;
        Total=0;
    end

    KwhFromInciniration = Data.WasteToElectricity*WasteIncinaration;
    if(CurrentYear{7,1} > KwhFromInciniration)
        CurrentYear{7,1} = CurrentYear{7,1}-KwhFromInciniration;
    else
        KwhFromInciniration = CurrentYear{7,1};
        CurrentYear{:,1} = 0;
    end

    CurrentYear{7,6} = KwhFromInciniration;
    
    CurrentYearTotal = table2array(CurrentYear('Total',:))';
    %% Emissions Tables

    for Table=1:6
        Temp = zeros(7,9);
        Temp = array2table(Temp, 'RowNames', RowNames);
        Temp.Properties.VariableNames = {'Co2', 'CH4', 'Nitrous Oxide (N2O)', 'NOX', 'PM', 'SO2', 'Other Air Pollutants', 'Sewage', 'Co2e'};
        for j=1:width(Temp)-1
            for i=1:height(Temp)
                Temp{i,j} = Emissions(Table,j)*CurrentYear{i,Table}/1000000; %% tons
            end
        end
        for i=1:height(Temp)
            Temp{i,9}=Temp{i,1}+Temp{i,2}*28+Temp{i,3}*265; %Temporary
        end
        switch Table
        case 1
            CoalEmissions=Temp;
        case 2
            NaturalGasEmissions=Temp;
        case 3
            RenewableEnergiesEmissions=Temp;
        case 4
            SolerEmissions=Temp;
        case 5
            MazutEmissions=Temp;
        case 6
            IncinarationEmissions = Temp;
        end
    end

    
    TotalElectricityConsumptionEmissions = array2table(zeros(7,9), 'RowNames', RowNames);
    TotalElectricityConsumptionEmissions.Properties.VariableNames = {'Co2', 'CH4', 'Nitrous Oxide (N2O)', 'NOX', 'PM', 'SO2', 'Other Air Pollutants', 'Sewage', 'Co2e'};
    for i=1:height(TotalElectricityConsumptionEmissions)
        for j=1:width(TotalElectricityConsumptionEmissions)
            TotalElectricityConsumptionEmissions{i,j} = CoalEmissions{i,j} + NaturalGasEmissions{i,j}+RenewableEnergiesEmissions{i,j}+SolerEmissions{i,j}+MazutEmissions{i,j}+IncinarationEmissions{i,j};
        end
    end
    
    
end

