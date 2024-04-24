function [Area, Costs, Water] = CalcTotalResources(Resources, ConsumptionAmounts,WaterFromFood)
    Area = array2table(zeros(5,width(Resources)));
    Costs = array2table(zeros(5,width(Resources)));
    Water = array2table(zeros(5,width(Resources)));
    Area.Properties.RowNames = {'Electricity- Local', 'Food - Local', 'Food - Gloabl', 'Construction - Local', 'Total'};
    Costs.Properties.RowNames = {'Operating Costs', 'Setting Costs', 'Fuels Costs', 'Cost of Area for PV', 'Total'};
    Water.Properties.RowNames = {'Ground Water', 'Desalinated Water', 'Brackish & Reservoirs Water', 'Treated Wastewater', 'Global Water'};
    ColumnNames = ones(1,width(Resources));
    for i = 1:width(ColumnNames)
        ColumnNames(i) = 2016+i;
    end
    ColumnNames = string(ColumnNames);
    Area.Properties.VariableNames = ColumnNames;
    Costs.Properties.VariableNames = ColumnNames;
    Water.Properties.VariableNames = ColumnNames;
    OperatingCostsSum = zeros(1,width(Area));
    SettingCostsSum = zeros(1,width(Area));
    AreaElectricity = zeros(1,width(Area));
    AreaElectricityOfDualPV = zeros(1,width(Area));

    AreaConstruction = zeros(1,width(Area));
    PVAreaCost = zeros(1,width(Area));
    FuelCost = zeros(1,width(Area));
    for i = 1:length(OperatingCostsSum)
       % if i == 34
       %    check =1 ;
       % end
       %OperatingCostsSum(i) = Resources{4,i}{1}{6,1}/10^9;
       %SettingCostsSum(i) = Resources{5,i}{1}{6,1}/10^9;
       %PVAreaCost(i) = sum(Resources{7,i}{1}{1,:})/10^9;
       %FuelCost(i) = sum(Resources{6,i}{1}{:,1})/10^9;

        AreaElectricity(i) = sum(Resources{1,i}{1}{1,:}) - Resources{1,i}{1}{1,4} ; % sum of area for this year minus the DUAL
        AreaElectricityOfDualPV(i) = Resources{1,i}{1}{1,4}; % the area needed for dual PV only
        if i > 1 % cumulative sum
            AreaElectricity(i) = AreaElectricity(i) + AreaElectricity(i-1);
            AreaElectricityOfDualPV(i) = AreaElectricityOfDualPV(i) + AreaElectricityOfDualPV(i-1);
        end
        AreaConstruction(i) = Resources{8,i}{1};

    end


    for i = 1:width(Area)
        %Area{1,i} = sum(AreaElectricity(1:i));
        Area{1,i} = AreaElectricity(1,i);
        Area{2,i} = Resources{3,i}{1}{65,1};
        Area{3,i} = Resources{3,i}{1}{65,2};
        Costs{1,i} = Resources{4,i}{1}{6,1}/10^9;
        Costs{2,i} = Resources{5,i}{1}{6,1}/10^9;
        Costs{3,i} = sum(Resources{6,i}{1}{:,1})/10^9;
        Costs{4,i} = sum(Resources{7,i}{1}{1,:})/10^9;
    end
    for i = 1:width(Water)
     %%Water{1:5,i} = ((ConsumptionAmounts.(i){1,1}{7,1:5}))';
         Water{1,i} = ConsumptionAmounts.(i){1,1}{1,5};
         Water{2,i} = ConsumptionAmounts.(i){1,1}{1,8};
         Water{3,i} = 250;
         Water{4,i} = ConsumptionAmounts.(i){1,1}{1,6};
         a = WaterFromFood{i};
         Water{5,i} = sum(WaterFromFood{1,i}{1,3:4})/10^6;

    end    

    Area{4,:} = AreaConstruction;
    for i = 1:width(Area)
        Area{5,i} = sum(Area{1:4,i});
        Costs{5,i} = sum(Costs{1:4,i});       
        Water{6,i} = sum(Water{1:4,i});
    end    
end