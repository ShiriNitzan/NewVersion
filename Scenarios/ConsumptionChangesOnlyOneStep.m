 function [ElectricityConsumptionTable, TransportationConsumptionTable, VehicleAmountsCell, FoodConsumptionCell, WaterConsumptionCell, ConstructionTable,WateAndRecyclingCell, AmountsOfFuelsCells, OrganicWasteAmount] = ConsumptionChangesOnlyOneStep(Data, PrecentegeByTheYears,Years,pop, varargin)
% A function that correctly calculates the water model for a single scenario. There is an option to merge with FULLSCENARIO, you need to debug
%% Electricity Consumption
p = inputParser;
addOptional(p,'ChangesStruct', []);
parse(p,varargin{:});
    
ElectricityConsumptionTable = Data.ElectricityConsumptionTable;
for i=2:Years
   ElectricityConsumptionTable{:, i} = PrecentegeByTheYears(i)*ElectricityConsumptionTable{:,1};
end

%% Transportation Consumption
TransportationConsumptionTable = Data.TransportationConsumptionTable;

for i=2:Years
    Growth = PrecentegeByTheYears(i)*1.011;
    TransportationConsumptionTable{1:8, i} = Growth*TransportationConsumptionTable{1:8,1};
    TransportationConsumptionTable{9,i} = sum(TransportationConsumptionTable{1:8,i});
end
%% Vehicle Amoount
VehicleAmountsCell = Data.VehicleAmountsCell;
RowNames = {'Quantity', 'Gasoline', 'Diesel', 'Drive Per Day', 'Drive Per Year', 'Cars Per Year'};
ColNames = {'Bus','Car','Minibus','Motorcycle', 'Truck', 'LCV'};

for i = 1:Years
    CurrentAmount = array2table(zeros(6,6), 'RowNames', RowNames);
    CurrentAmount{:,:} = VehicleAmountsCell{1}{:,:}*(PrecentegeByTheYears(i));
    CurrentAmount.Properties.VariableNames = ColNames;
    VehicleAmountsCell{i} =  CurrentAmount;
end
%% Food Consumption
FoodConsumptionCell = Data.FoodConsumptionCell;
RowNames = Data.FoodRowName;
ColNames = {'Humans and Other - Local','Animals - Local','Humans and Others - Import','Animals - Import'};
Initialization = FoodConsumptionCell{1}{:,:};

for i = 1:Years
    CurrentConsumption = array2table(zeros(64,4), 'RowNames', RowNames);
    CurrentConsumption{:,:} = Initialization*(PrecentegeByTheYears(i));
    CurrentConsumption.Properties.VariableNames = ColNames;
    FoodConsumptionCell{i} =  CurrentConsumption;
end
%% Water model pre-data 
waterData  = array2table(zeros(3,34));
RowNames = {'Agriculture per capita', 'Water for nature', 'Drilling Water'};
waterData.Properties.RowNames = RowNames;
waterData(3,1) = {956}; % Drilling Water
for i =1:34
   waterData(1,i) = {-10.79*log(i+16)+167.91}; % Agriculture per capita
   switch true % water for nature
       case i<10
          waterData(2,i) = {25};
       case i>=10 & i<15
          waterData(2,i) = {35};
       case i>=15 & i<25
          waterData(2,i) = {50};
       case i>=25 & i<35
          waterData(2,i) = {75};
   end
   if i>1    % Drilling Water
       waterData(3,i) = {waterData{3,i-1}*0.9901};
       if i==6 %A djustment to the water model data for 2022, until all the data in the software is updated
            waterData(3,i) = {1080};
       end
   
   end

end

%% Water Consumption
WaterConsumptionCell = Data.WaterConsumptionCell;
ColNames = {'Water for Domestic & Industrial', 'Water for Agriculture', 'Water for Neighbors', 'Water for  Nature', 'Drilling Water', 'Reclaimed Wastewater', 'Brackish water, fresh and non-fresh reservoir water', 'Desalinated Water'};
Initialization = WaterConsumptionCell{1}{:,1:5};
CurrentConsumption = array2table(zeros(1,8), 'VariableNames', ColNames);
%%2017 Data
CurrentConsumption{1,1} = 983;
CurrentConsumption{1,2} = 1253;
CurrentConsumption{1,3} = 137;
CurrentConsumption{1,4} = 23;
CurrentConsumption{1,5} = 940;
CurrentConsumption{1,6} = 512;
CurrentConsumption{1,7} = 250;
CurrentConsumption{1,8} = 586;

WaterConsumptionCell{1} =  CurrentConsumption;
if PrecentegeByTheYears(1) == PrecentegeByTheYears(width(PrecentegeByTheYears)) %The essential change that ensures the correctness of the water mod in a single scenario
    for i =2:Years
        CurrentConsumption = array2table(zeros(1,8), 'VariableNames', ColNames);
        CurrentConsumption{1,1} = 1070;
        CurrentConsumption{1,2} = 1300;
        CurrentConsumption{1,3} = 190;
        CurrentConsumption{1,4} = 25;
        CurrentConsumption{1,5} = 1080;
        CurrentConsumption{1,6} = 636;
        CurrentConsumption{1,7} = 400;
        CurrentConsumption{1,8} = 524;  

        WaterConsumptionCell{i} =  CurrentConsumption;
    end
else
    for i =2:Years 
        CurrentConsumption = array2table(zeros(1,8), 'VariableNames', ColNames);
        CurrentConsumption{1,1} = pop{3,i}*110.452; % Water for Domestic & Industrial
        CurrentConsumption{1,2} = pop{3,i}*waterData{1,i}; % for agriculture
        CurrentConsumption{1,3} = pop{4,i}*20.31282+90; % Water for Neighbors
        CurrentConsumption{1,4} = waterData{2,i}; %% for Nature
        CurrentConsumption{1,5} = waterData{3,i}; %% natural from
        CurrentConsumption{1,6} = 0.66*CurrentConsumption{1,1}; %% WasteWater from
        CurrentConsumption{1,7} = 400; %% Brackish water, fresh and non-fresh reservoir water
        CurrentConsumption{1,8} = CurrentConsumption{1,1}*0.898904 + CurrentConsumption{1,2}*0.35 + CurrentConsumption{1,3} - CurrentConsumption{1,5}; %% desalinated from
        if i == 6 % Adjustment to the water model data for 2022, until all the data in the software is updated
            CurrentConsumption{1,1} = 1070;
            CurrentConsumption{1,2} = 1300;
            CurrentConsumption{1,3} = 190;
            CurrentConsumption{1,4} = 25;
            CurrentConsumption{1,5} = 1080;
            CurrentConsumption{1,6} = 636;
            CurrentConsumption{1,7} = 400;
            CurrentConsumption{1,8} = 524;  
        end
       
          WaterConsumptionCell{i} =  CurrentConsumption;
    end
  end

%% Construction

ConstructionTable = Data.ConstructionTable;
ConstructionInitialization = ConstructionTable{1:10,1};
for i=2:Years
    ConstructionTable{1:10, i} = PrecentegeByTheYears(i)*ConstructionInitialization;
    ConstructionTable{11, i} = sum(ConstructionTable{1:10, i});
end

%% Materials - generated waste and recycling
RowNames = {'Organic Products','Plastic', 'Paper', 'Cardboard', 'Diapers', 'Garden Waste', 'Textile', 'Metal', 'Glass', 'Pruned Trees','Wood', 'Oils', 'Others'};
ColNames = {'Local Authorities - Waste', 'Local Authorities - Recycling', 'Industry - Waste', 'Industry - Recycling','Food Industry - Waste' , 'Food Industry - Recycling','Agriculture - Waste', 'Agriculture - Recycling'};

WateAndRecyclingCell = Data.WateAndRecyclingCell;
for i =2:Years
    CurrentRecyclingAndWate =  array2table(zeros(13,8), 'RowNames', RowNames);
    CurrentRecyclingAndWate.Properties.VariableNames = ColNames;
    CurrentRecyclingAndWate{:,:} = WateAndRecyclingCell{1}{:,:}*PrecentegeByTheYears(i);
    WateAndRecyclingCell{i} = CurrentRecyclingAndWate;
end

%% Organic Waste

OrganicWasteAmount = Data.OrganicWasteAmountsCell;
RowNames = {'Local Authorities', 'Food Industry', 'Agriculture'};
ColNames = OrganicWasteAmount{1}.Properties.VariableNames;
for i = 2:Years
    CurrentOrganicWaste = array2table(zeros(3,2), 'RowNames',RowNames, 'VariableNames',ColNames);
    CurrentOrganicWaste{:,:} = OrganicWasteAmount{1}{:,:}*PrecentegeByTheYears(i);
    OrganicWasteAmount{i} = CurrentOrganicWaste;
end    


%% Amounts of Fuels

RowNames = {'Crude Oil Products - Not for Energy', 'Crude Oil For Export', 'Crude Oil Import'};
ColNames = {'Naptha', 'Mazut','Diesel','Kerosene','Gasoline','Liquified Petroleum Gas', 'Other'};

AmountsOfFuelsCells = Data.AmountsOfFuelsCells;

for i =2:Years
    CurrentFuelConsumption = array2table(zeros(3,7),'RowNames', RowNames);
    CurrentFuelConsumption.Properties.VariableNames = ColNames;
    CurrentFuelConsumption{:,:} = AmountsOfFuelsCells{1}{:,:}*PrecentegeByTheYears(i);
    AmountsOfFuelsCells{i} = CurrentFuelConsumption;
end    


%%
function PercentVector = CalcChangeVector(MileStoneVector, Years, S, varargin)
    p = inputParser;
    addOptional(p,'Type','Exponential');
    addOptional(p,'Growth',true);
    parse(p,varargin{:});
    if(strcmp(p.Results.Type, 'Exponential'))
        PercentVector = Exponential(MileStoneVector, Years, S, p.Results.Growth);
    elseif(strcmp(p.Results.Type, 'Linear'))
         PercentVector = Linear(MileStoneVector, Years, S, p.Results.Growth);
    elseif(strcmp(p.Results.Type, 'Step'))
        PercentVector = Step(MileStoneVector, Years, S, p.Results.Growth);
    else
        PercentVector = zeros(1,Years);
    end
end

% exponential
function [PercentVector] = Exponential(MileStoneVector, Years, S, Growth)
    PercentVector = ones(1,Years);
    if Growth == 1
        PercentVector(Years) = 1+S;
        MileStoneVector(Years) = S;
    else
        PercentVector(Years) = 1-S;
        MileStoneVector(Years) = -1*S;
    end    
    StartYear = 1;
    for i = 1:length(MileStoneVector)
        if(MileStoneVector(i) ~= 0)
            EndYear = i;
            GrowthVector = GrowthVectorCalc(StartYear, EndYear, MileStoneVector(i), MileStoneVector(StartYear));
            for j = 1:length(GrowthVector)
                PercentVector(StartYear+j-1) = GrowthVector(j);
            end
            StartYear = i;
        end
    end
end

function GrowthVector = GrowthVectorCalc(StartYear, EndYear, EndYearVal, StartYearVal)
Period = EndYear-StartYear+1;
GrowthVector = ones(1, Period);
GrowthVector(1) = 1 + StartYearVal;
GrowthVector(Period) = 1 + EndYearVal;
FutureValue = GrowthVector(Period);
Rate = nthroot(FutureValue/GrowthVector(1),Period-1);
for i = 1:Period
    GrowthVector(i) = GrowthVector(1)*((Rate)^(i-1));
end
end

%Step
function [PercentVector] = Step(MileStoneVector, Years, S)
    PercentVector = ones(1,Years);
    if Growth == 1
        PercentVector(Years) = 1+S;
        MileStoneVector(Years) = S;
    else
        PercentVector(Years) = 1-S;
        MileStoneVector(Years) = -1*S;
    end    
    StartYear = 1;
    for i = 1:length(MileStoneVector)
        if(MileStoneVector(i) ~= 0)
            EndYear = i;
            GrowthVector = StepCalc(StartYear, EndYear, MileStoneVector(i));
            for j = 1:length(GrowthVector)
                PercentVector(StartYear+j-1) = GrowthVector(j);
            end
            StartYear = i;
        end
    end
end

function GrowthVector = StepCalc(StartYear, EndYear, EndYearVal)
    Period = EndYear-StartYear+1;
    GrowthVector = ones(1, Period)+EndYearVal;
end

%linear
function [PercentVector] = Linear(MileStoneVector, Years, S)
    PercentVector = ones(1,Years);
    if Growth == 1
        PercentVector(Years) = 1+S;
        MileStoneVector(Years) = S;
    else
        PercentVector(Years) = 1-S;
        MileStoneVector(Years) = -1*S;
    end    
    MileStoneVector(Years) = S;
    StartYear = 1;
    for i = 1:length(MileStoneVector)
        if(MileStoneVector(i) ~= 0)
            EndYear = i;
            GrowthVector = LinearCalc(StartYear, EndYear, MileStoneVector(i),MileStoneVector(StartYear));
            for j = 1:length(GrowthVector)
                PercentVector(StartYear+j-1) = GrowthVector(j);
            end
            StartYear = i;
        end
    end
end

function GrowthVector = LinearCalc(StartYear, EndYear, EndYearVal,StartYearVal)
    Period = EndYear-StartYear+1;
    GrowthVector = ones(1, Period);
    GrowthVector(1) = 1 + StartYearVal;
    GrowthVector(Period) = 1+EndYearVal;
    if(EndYearVal > StartYearVal)
        Rate = (EndYearVal-StartYearVal)/(Period-1);
    else
        Rate = -1*(StartYearVal-EndYearVal)/Period;
    end
    for i = 1:Period
        GrowthVector(i) = GrowthVector(1)+Rate*(i-1);
    end
end

%% Other Functions
function [PercentVector] = MileStonesGrowth(MileStoneVector, Years, S)
PercentVector = ones(1,Years);
PercentVector(Years) = 1+S;
MileStoneVector(Years) = S;
StartYear = 1;
for i = 1:length(MileStoneVector)
    if(MileStoneVector(i) ~= 0)
        EndYear = i;
        GrowthVector = GrowthVectorCalc(StartYear, EndYear, MileStoneVector(i), MileStoneVector(StartYear));
        for j = 1:length(GrowthVector)
            PercentVector(StartYear+j-1) = GrowthVector(j);
        end    
        StartYear = i;
    end
end
end

% function GrowthVector = GrowthVectorCalc(StartYear, EndYear, EndYearVal, StartYearVal)
% Period = EndYear-StartYear+1;
% GrowthVector = ones(1, Period);
% GrowthVector(1) = 1 + StartYearVal;
% GrowthVector(Period) = 1+EndYearVal; 
% FutureValue = GrowthVector(Period);
% Rate = nthroot(FutureValue/GrowthVector(1),Period-1);
%     for i = 1:Period
%         GrowthVector(i) = GrowthVector(1)*((Rate)^(i-1));
%     end
% end

end
