function [ManualScenariosTable] = ManualChangesByScenarios(Data)
    %% Create Scenarios Table
    Years = 34;
    ME = MException('MyComponent:noSuchVariable', ...
            'Not a valid number!');

    RowNames = {'Growth in Population', 'Electricity Saving Scenario', 'Change in Diselinated Water ', 'Reducing Beef Consumption', '5', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving','9','10', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
    ColumnNames = zeros(1, Years);
    ManualScenariosTable = array2table(zeros(19, Years), 'RowNames', RowNames);

    for i = 1:width(ColumnNames)
        ColumnNames(i) = 2016+i;
    end
    ColumnNames = string(ColumnNames);
    ManualScenariosTable.Properties.VariableNames = ColumnNames;
    %% Growth in Population Scenario

    x = input("Enter change in population for 2030: ");
    ManualScenariosTable{1, 1} = 1;
    if(-1<=x && x<=1)
        ManualScenariosTable{1,Years} = 1+x;
        FutureValue = ManualScenariosTable{1,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{1, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{1, i} = ManualScenariosTable{1, 1}*((Rate)^(i-1));
        end  
    else %% how to throw exceptions in matlab?
        throw(ME)
    end

    %% change in electricity consumption per capita in 2030

    x = input("Enter change in electricity consumption per capita for 2030: ");

    ManualScenariosTable{2, 1} = 1;
    if(-1<=x && x<=1)
        ManualScenariosTable{2,Years} = 1+x;
        FutureValue = ManualScenariosTable{2,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{2, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{2, i} = ManualScenariosTable{2, 1}*((Rate)^(i-1));
        end   
    else %% how to throw exceptions in matlab?
        throw(ME)
    end

    %% Scenario 3

    x = input("Enter change in diselinated water consumption for 2030: ");
    ManualScenariosTable{3, 1} = 1;
    if(-1<=x && x<=1)
        ManualScenariosTable{3,Years} = 1+x;
        FutureValue = ManualScenariosTable{3,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{3, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{3, i} = ManualScenariosTable{3, 1}*((Rate)^(i-1));
        end    
    else %% how to throw exceptions in matlab?
        throw(ME)
    end

    %% Reducing Beef Consumption

    x = input("Enter the Percentage of Decrease in Beef Consumption in 2030: ");
    ManualScenariosTable{4, 1} = 1;
    if(0<=x && x<=1)
        ManualScenariosTable{4,Years} =  (1-x);
        FutureValue = ManualScenariosTable{4,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{4, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{4, i} = ManualScenariosTable{4, 1}*(Rate)^(i-1);
        end   
    else %% how to throw exceptions in matlab?
        throw(ME)
    end

    %% Scenario 5

    x = 0;
    ManualScenariosTable{5, 1} = 1;
    if(-1<=x && x<=1)
        ManualScenariosTable{5,Years} = 1+x;
        FutureValue = ManualScenariosTable{5,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{5, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{5, i} = ManualScenariosTable{5, 1}*((Rate)^(i-1));
        end    
    else %% how to throw exceptions in matlab?
        throw(ME)
    end

    %% Change In Energy Consumption From Renewable Energies

    x = input("Enter the Percentage of Electricity that will be Supplied from Renewable Energies in 2030: ");
    CurrentEnergyConsumptionFromRenewableEnergies = Data.InitialPercentage(1,3);
    if(0<=x && x<=1)
        if (x==0 || x==CurrentEnergyConsumptionFromRenewableEnergies)
            ManualScenariosTable{6,Years} = CurrentEnergyConsumptionFromRenewableEnergies;
            for i = 1:Years
                ManualScenariosTable{6, i} = CurrentEnergyConsumptionFromRenewableEnergies;
            end
        else
            ManualScenariosTable{6, 1} = 1+CurrentEnergyConsumptionFromRenewableEnergies;
            ManualScenariosTable{6,Years} =  (1+x);
            FutureValue = ManualScenariosTable{6,Years};
            Rate = nthroot(FutureValue,Years-1)-1;
            for i = 2:Years-1
                ManualScenariosTable{6, i} = (1+Rate)^(i-1);
            end
        end
    else %% how to throw exceptions in matlab?
           throw(ME)
    end

    if (x~=0)
        for i = 1:Years
            ManualScenariosTable{6,i} = ManualScenariosTable{6,i}-1;
        end
    end

    %% Change In Energy Consumption From Natural Gas

    x = input("Enter the Percentage of Electricity that will be Supplied from Natural Gas in 2030: ");
    CurrentEnergyConsumptionFromNaturalGas = Data.InitialPercentage(1,2);
    if(0<=x && x<=1)
        if (x==0 || x==CurrentEnergyConsumptionFromNaturalGas)
            ManualScenariosTable{7,Years} = CurrentEnergyConsumptionFromNaturalGas;
            for i = 1:Years
                ManualScenariosTable{7, i} = CurrentEnergyConsumptionFromNaturalGas;
            end
        else
            ManualScenariosTable{7, 1} = 1+CurrentEnergyConsumptionFromNaturalGas;
            ManualScenariosTable{7,Years} =  (1+x);
            FutureValue = ManualScenariosTable{7,Years};
            Rate = nthroot(FutureValue/ManualScenariosTable{7, 1},Years-1);
            for i = 2:Years-1
                ManualScenariosTable{7, i} = ManualScenariosTable{7, 1}*((Rate)^(i-1));
            end
        end
    else %% how to throw exceptions in matlab?
           throw(ME)
    end
    
    if (x~=0)
        for i = 1:Years
            ManualScenariosTable{7,i} = ManualScenariosTable{7,i}-1;
        end
    end

    %% Electricity saving

    x = input("Enter electricity saving percentage: ");
    ManualScenariosTable{8, 1} = 1;
    if(0<=x && x<=1)
        ManualScenariosTable{8,Years} =  (1-x);
        FutureValue = ManualScenariosTable{8,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{8, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{8, i} = ManualScenariosTable{8, 1}*((Rate)^(i-1));
        end    
    else %% how to throw exceptions in matlab?
        throw(ME)
    end


    %% Scenario 9

    x = 0;
    ManualScenariosTable{9, 1} = 1;
    if(-1<=x && x<=1)
        ManualScenariosTable{9,Years} =  (1+x);
        FutureValue = ManualScenariosTable{9,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{9, 1},Years-1);
       for i = 2:Years-1
            ManualScenariosTable{9, i} = ManualScenariosTable{9, 1}*((Rate)^(i-1));
        end  
    else %% how to throw exceptions in matlab?
        throw(ME)
    end

    %% Scenario 10

    x = 0;
    ManualScenariosTable{10, 1} = 1;
    if(-1<=x && x<=1)
        ManualScenariosTable{10,Years} =  (1+x);
        FutureValue = ManualScenariosTable{10,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{10, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{10, i} = ManualScenariosTable{10, 1}*((Rate)^(i-1));
        end   
    else %% how to throw exceptions in matlab?
        throw(ME)
    end

    %% Scenario 11

    x = 0;
    ManualScenariosTable{11, 1} = 1;
    if(-1<=x && x<=1)
        ManualScenariosTable{11,Years} =  (1+x);
        FutureValue = ManualScenariosTable{11,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{11, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{11, i} = ManualScenariosTable{11, 1}*((Rate)^(i-1));
        end   
    else %% how to throw exceptions in matlab?
        throw(ME)
    end

    %% Change in mileage

    x = input("Enter the change percentage of mileage: ");
        ManualScenariosTable{12, 1} = 1;
    if(-1<=x && x<=1)
        ManualScenariosTable{12,Years} =  (1+x);
        FutureValue = ManualScenariosTable{12,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{12, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{12, i} = ManualScenariosTable{12, 1}*((Rate)^(i-1));
        end   
    else %% how to throw exceptions in matlab?
        throw(ME)
    end


    %% Transition To Public Transportation

    x = input("Enter the Percentage of Transition To Public Transportation in 2030: ");
    ManualScenariosTable{13, 1} = 1;
    if(0<=x && x<=1)
        ManualScenariosTable{13,Years} =  (1-x);
        FutureValue = ManualScenariosTable{13,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{13, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{13, i} = ManualScenariosTable{13, 1}*((Rate)^(i-1));
        end   
    else %% how to throw exceptions in matlab?
           throw(ME)
    end


    %% electric private vehicle

    x = input("Enter the Percentage of KM Traveled by Private electric car in 2030: ");
    ManualScenariosTable{14, 1} = 1;
    if(0<=x && x<=1)
        ManualScenariosTable{14,Years} =  1+x;
        FutureValue = ManualScenariosTable{14,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{14, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{14, i} = ManualScenariosTable{14, 1}*((Rate)^(i-1));
        end
        for i = 1:Years
            ManualScenariosTable{14, i} = ManualScenariosTable{14, i}-1;
        end    
    else %% how to throw exceptions in matlab?
           throw(ME)
    end

    %% electric van

    x = input("Enter the Percentage of KM Traveled by electric van in 2030: ");
    ManualScenariosTable{15, 1} = 1;
    if(0<=x && x<=1)
        ManualScenariosTable{15,Years} =  (1+x);
        FutureValue = ManualScenariosTable{15,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{15, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{15, i} = ManualScenariosTable{15, 1}*((Rate)^(i-1));
        end
        for i = 1:Years
            ManualScenariosTable{15, i} = ManualScenariosTable{15, i}-1;
        end  
    else %% how to throw exceptions in matlab?
           throw(ME)
    end


    %% electric Truck

    x = input("Enter the Percentage of KM Traveled by electric truck in 2030: ");
    ManualScenariosTable{16, 1} = 1;
    if(0<=x && x<=1)
        ManualScenariosTable{16,Years} =  (1+x);
        FutureValue = ManualScenariosTable{16,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{16, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{16, i} = ManualScenariosTable{16, 1}*((Rate)^(i-1));
        end
        for i = 1:Years
            ManualScenariosTable{16, i} = ManualScenariosTable{16, i}-1;
        end  
    else %% how to throw exceptions in matlab?
        throw(ME);
    end


    %% electric bus

    x = input("Enter the Percentage of KM Traveled by electric bus in 2030: ");
    ManualScenariosTable{17, 1} = 1;
    if(0<=x && x<=1)
        ManualScenariosTable{17,Years} =  (1+x);
        FutureValue = ManualScenariosTable{17,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{17, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{17, i} = ManualScenariosTable{17, 1}*((Rate)^(i-1));
        end
        for i = 1:Years
            ManualScenariosTable{17, i} = ManualScenariosTable{17, i}-1;
        end  
    else %% how to throw exceptions in matlab?
           throw(ME)
    end

    %%  vehicles with improved emission factors

    x = 0;
    ManualScenariosTable{18, 1} = 1;
    if(0<=x && x<=1)
        ManualScenariosTable{18,Years} =  (1-x);
        FutureValue = ManualScenariosTable{18,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{18, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{18, i} = ManualScenariosTable{18, 1}*((Rate)^(i-1));
        end   
    else %% how to throw exceptions in matlab?
           throw(ME)
    end

    %%  vehicles with improved emission factors

    x = input("Enter the Percentage of water saved in 2030: ");
    ManualScenariosTable{19, 1} = 1;
    if(0<=x && x<=1)
        ManualScenariosTable{19,Years} =  (1-x);
        FutureValue = ManualScenariosTable{19,Years};
        Rate = nthroot(FutureValue/ManualScenariosTable{19, 1},Years-1);
        for i = 2:Years-1
            ManualScenariosTable{19, i} = ManualScenariosTable{19, 1}*((Rate)^(i-1));
        end   
    else %% how to throw exceptions in matlab?
           throw(ME)
    end

end

