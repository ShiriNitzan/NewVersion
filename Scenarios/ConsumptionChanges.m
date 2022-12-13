function [ElectricityConsumptionTable, TransportationConsumptionTable, VehicleAmountsCell, FoodConsumptionCell, WaterConsumptionCell, ConstructionTable,WateAndRecyclingCell, AmountsOfFuelsCells, OrganicWasteAmount] = ConsumptionChanges(Data, PrecentegeByTheYears,Years, varargin)
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
%% Water Consumption
WaterConsumptionCell = Data.WaterConsumptionCell;

RowNames = {'Agriculture', 'Marginal Water Percentage', 'Home Consumption(Urban)', 'Industry', 'Water for Nature', 'Water for Neighbors'};
Initialization = WaterConsumptionCell{1}{:,1:5};

for i =1:Years   
    CurrentConsumption = array2table(zeros(6,5), 'RowNames', RowNames);
    CurrentConsumption{:,1} = Initialization(:,1)*(PrecentegeByTheYears(i)); %% from nature
    CurrentConsumption{:,2} = Initialization(:,2); %% deslinated - only from scenario
    CurrentConsumption{:,3} = Initialization(:,3)*(PrecentegeByTheYears(i)); %% all but desalinated
    CurrentConsumption{:,4} = Initialization(:,4)*(PrecentegeByTheYears(i)); %% all but desalinated
    CurrentConsumption{:,5} = Initialization(:,5)*(PrecentegeByTheYears(i)); %% all but desalinated
    ColNames = {'Water From Nature','Diselinated Water','Brackish Water','Treated WasteWater','Flood Water'};
    CurrentConsumption.Properties.VariableNames = ColNames;
    WaterConsumptionCell{i} =  CurrentConsumption;
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


