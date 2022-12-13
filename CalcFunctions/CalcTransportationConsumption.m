function [TotalTransportationConsumptionEmissions, TotalTrainEmissions] = CalcTransportationConsumption(Data, CurrentYearTransportationConsumption,VehicleAmount)
    %% Read Files

    TransportationHotEmissionsCoefficients = Data.TransportationHotEmissionsCoefficients;

    TransportationColdEmissionsCoefficients = Data.TransportationColdEmissionsCoefficients;

    TransportationEvaporationEmissionsWhileDriving = Data.TransportationEvaporationEmissionsWhileDriving;

    TransportationEvaporationEmissionsAfterDriving = Data.TransportationEvaporationEmissionsAfterDriving;

    TransportationGridingEmissions = Data.TransportationGridingEmissions;
    
    PassengerTrainEmissionCoefficients = Data.PassengerTrainEmissionCoefficients;
    
    FreightTrainEmissionCoefficients = Data.FreightTrainEmissionCoefficients;
    
    TransportationEvaporationEmissionsEveryDay = Data.TransportationEvaporationEmissionsEveryDay;

    %%

    HotEmissionsTon = zeros(15,7);
    ColdEmissionsTon = zeros(15,7);
    EvaporationEmissionsWhileDrivingTon = zeros(15,7);
    EvaporationEmissionsAfterDrivingTon = zeros(15,7);
    EvaporationEmissionsEveryDayTon = zeros(15,7);
    GridingEmissionsTon = zeros(15,7);

    for i=1:height(CurrentYearTransportationConsumption)-2 %% rows - vehicle types
            TotalHotEmissionsTonAirPollutants=0;
            TotalEvaporationEmissionsWhileDrivingTonAirPollutants=0;
            TotalGridingEmissionsTonAirPollutants=0;
            for j=1:14
                HotEmissionsTon(j,i) = CurrentYearTransportationConsumption(i)*TransportationHotEmissionsCoefficients(j,i)/1000000;
                EvaporationEmissionsWhileDrivingTon(j,i) = CurrentYearTransportationConsumption(i)*TransportationEvaporationEmissionsWhileDriving(j,i)/1000000;
                GridingEmissionsTon(j,i) = CurrentYearTransportationConsumption(i)*TransportationGridingEmissions(j,i)/1000000;
                if (j<=12)
                    TotalHotEmissionsTonAirPollutants=TotalHotEmissionsTonAirPollutants+HotEmissionsTon(j,i);
                    TotalEvaporationEmissionsWhileDrivingTonAirPollutants=TotalEvaporationEmissionsWhileDrivingTonAirPollutants+EvaporationEmissionsWhileDrivingTon(j,i);
                    TotalGridingEmissionsTonAirPollutants=TotalGridingEmissionsTonAirPollutants+GridingEmissionsTon(j,i);
                end
            end
            HotEmissionsTon(j+1,i) = TotalHotEmissionsTonAirPollutants;
            EvaporationEmissionsWhileDrivingTon(j+1,i) = TotalEvaporationEmissionsWhileDrivingTonAirPollutants;
            GridingEmissionsTon(j+1,i) = TotalGridingEmissionsTonAirPollutants;
    end

    for i=1:width(VehicleAmount)
            TotalColdEmissionsTonAirPollutants=0;
            TotalEvaporationEmissionsAfterDrivingTonAirPollutants=0;
            TotalEvaporationEmissionsEveryDayTonAirPollutants=0;
            for j=1:14
                ColdEmissionsTon(j,i) = VehicleAmount(5,i)*TransportationColdEmissionsCoefficients(j,i)/1000000;
                EvaporationEmissionsAfterDrivingTon(j,i) = VehicleAmount(5,i)*TransportationEvaporationEmissionsAfterDriving(j,i)/1000000;
                EvaporationEmissionsEveryDayTon(j,i) = VehicleAmount(6,i)*TransportationEvaporationEmissionsEveryDay(j,i)/1000000;
                if (j<=12)
                    TotalColdEmissionsTonAirPollutants=TotalColdEmissionsTonAirPollutants+ColdEmissionsTon(j,i);
                    TotalEvaporationEmissionsAfterDrivingTonAirPollutants=TotalEvaporationEmissionsAfterDrivingTonAirPollutants+EvaporationEmissionsAfterDrivingTon(j,i);
                    TotalEvaporationEmissionsEveryDayTonAirPollutants=TotalEvaporationEmissionsEveryDayTonAirPollutants+EvaporationEmissionsEveryDayTon(j,i);
                end
            end
            ColdEmissionsTon(j+1,i) = TotalColdEmissionsTonAirPollutants;
            EvaporationEmissionsAfterDrivingTon(j+1,i) = TotalEvaporationEmissionsAfterDrivingTonAirPollutants;
            EvaporationEmissionsEveryDayTon(j+1,i) = TotalEvaporationEmissionsEveryDayTonAirPollutants;
    end
    
    RowNames = {'Bus', 'Car', 'Minibus', 'Motorcycle', 'Truck', 'LCV'};
    TotalTransportationConsumptionEmissions = array2table(zeros(6,16), 'RowNames', RowNames);
    TotalTransportationConsumptionEmissions.Properties.VariableNames =  {'c6h6', 'ch2o', 'ch4', 'co', 'n2o', 'nh3', 'nmvoc', 'no2', 'nox', 'PM2.5', 'PM10', 'so2', 'co2', 'Fuel Consumption', 'Total Air Pollutants', 'Co2e'};

    for i=1:height(TotalTransportationConsumptionEmissions) %% 1-6
        for j=1:width(TotalTransportationConsumptionEmissions)-1 %% 1-15
            TotalTransportationConsumptionEmissions{i,j}=HotEmissionsTon(j,i)+ColdEmissionsTon(j,i)+EvaporationEmissionsWhileDrivingTon(j,i)+EvaporationEmissionsAfterDrivingTon(j,i)+EvaporationEmissionsEveryDayTon(j,i)+GridingEmissionsTon(j,i);
        end
    end
    
    %%train
    RowNames = {'Passenger Train', 'Friehgt Train'};
    TotalTrainEmissions = array2table(zeros(2,12),'RowNames',RowNames);
    TotalTrainEmissions.Properties.VariableNames = {'NOX' , 'CO','NMVOC', 'NH3', 'TSP', 'PM10', 'PM2.5', 'N2O', 'CH4', 'SO2', 'CO2', 'CO2E'};
    for i=1:width(TotalTrainEmissions)-1
        TotalTrainEmissions{1,i} = PassengerTrainEmissionCoefficients(i)*CurrentYearTransportationConsumption(7)/1000000;
        TotalTrainEmissions{2,i} = FreightTrainEmissionCoefficients(i)*CurrentYearTransportationConsumption(8)/1000000;
    end
    for i = 1:height(TotalTrainEmissions)
        TotalTrainEmissions{i,12} = TotalTrainEmissions{i,9}*28+TotalTrainEmissions{i,11};
    end    
    
    for i=1:height(TotalTransportationConsumptionEmissions) %% 1-6
        TotalTransportationConsumptionEmissions{i,width(TotalTransportationConsumptionEmissions)}=TotalTransportationConsumptionEmissions{i,3}*28+TotalTransportationConsumptionEmissions{i,5}*265+TotalTransportationConsumptionEmissions{i,13};
    end
end
