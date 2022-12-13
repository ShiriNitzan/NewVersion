function [KMTraveledByElectricVehicle, UpdatedTranportationConsumption] = CalcTransitionToEV(TrasnporationConsumption,TransitionToEV)
    KMTraveledByElectricVehicle = TrasnporationConsumption*TransitionToEV;
    if(KMTraveledByElectricVehicle >= TrasnporationConsumption)
        KMTraveledByElectricVehicle = TrasnporationConsumption;
        UpdatedTranportationConsumption = 0;
    else
        UpdatedTranportationConsumption = TrasnporationConsumption - KMTraveledByElectricVehicle;
    end
end