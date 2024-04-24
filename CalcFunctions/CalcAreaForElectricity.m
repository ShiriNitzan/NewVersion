function [TotalAreaForElectricity] = CalcAreaForElectricity(CurrentYearConsumption ,AreaCoeficients, AreaDistrubustion, AreaType)
    TotalAreaForElectricity = array2table(zeros(1,4));
    %TotalAreaForElectricity.Properties.VariableNames = {'Coal','Natural Gas','Ground and Large Reserves','Small Reserves', 'Interchanges', 'Large Rooftops', 'Small Rooftops'};
    TotalAreaForElectricity.Properties.VariableNames = {'Coal','Natural Gas','Ground PV','Dual PV'};

    % coal
    if(CurrentYearConsumption(1) <= 0)
        TotalAreaForElectricity{1,1} = 0;
    else    
        TotalAreaForElectricity{1,1} = CurrentYearConsumption(1)*AreaCoeficients(3)/1000; %% units - m^2*10^3
    end

    % natural gas
    if(CurrentYearConsumption(2) <= 0)
        TotalAreaForElectricity{1,2} = 0;
    else    
        TotalAreaForElectricity{1,2} = CurrentYearConsumption(2)*AreaCoeficients(4)/1000;
    end
    
    %for i = 1:size(AreaDistrubustion)
    %        TotalAreaForElectricity{1,i+2} = CurrentYearConsumption(3)*AreaCoeficients(1)*AreaDistrubustion(i)/1000;
    %    else
    %        TotalAreaForElectricity{1,i+2} = CurrentYearConsumption(3)*AreaCoeficients(2)*AreaDistrubustion(i)/1000;
    %    end    
    %end
    
    % PV 
    GroundPVConsumption = 0.3 * CurrentYearConsumption(3);
    DualPVConsumption= 0.7 * CurrentYearConsumption(3);
    TotalAreaForElectricity{1,3} = AreaCoeficients(1)* GroundPVConsumption /1000; % ground
    TotalAreaForElectricity{1,4} = AreaCoeficients(2) * DualPVConsumption /1000; % dual


end