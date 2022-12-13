%% Function for growth rate of renewable energy - we can decide milestones on the vector

function [ManufacturingPercentVector] = RenewableManufactuirngPercents(ManufacturingDemandsVector, Years)
ManufacturingPercentVector = ones(1,Years);
StartYear = 1;
for i = 1:length(ManufacturingDemandsVector)
    if(ManufacturingDemandsVector(i) ~= 0)
        EndYear = i;
        GrowthVector = GrowthVectorCalc(StartYear, EndYear, ManufacturingDemandsVector(i), ManufacturingPercentVector);
        for j = 1:length(GrowthVector)
            ManufacturingPercentVector(StartYear+j-1) = GrowthVector(j);
        end    
        StartYear = i;
    end
end
end


function GrowthVector = GrowthVectorCalc(StartYear, EndYear, S, PercentVector)
Period = EndYear-StartYear+1;
GrowthVector = ones(1, Period);
GrowthVector(1) = PercentVector(StartYear);
GrowthVector(length(GrowthVector)) = 1+S; %According to S2
FutureValue = GrowthVector(Period);
Rate = nthroot(FutureValue/GrowthVector(1),Period-1);
for i = 1:length(GrowthVector)
    GrowthVector(i) = GrowthVector(1)*((Rate)^(i-1));
end
end