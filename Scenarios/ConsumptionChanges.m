 function [ElectricityConsumptionTable, TransportationConsumptionTable, VehicleAmountsCell, FoodConsumptionCell, WaterConsumptionCell, ConstructionTable,WateAndRecyclingCell, AmountsOfFuelsCells, OrganicWasteAmount] = ConsumptionChanges(Data, ScenariosTable,Years,pop,orderIndex, varargin)
 % gets PrecentegeByTheYears as the population growth vector,
 % gets Pop as the population amount, israel and paletinian authorith.
 % returns all these tables based only on population growath/ some coefficient*population growth,
 % (all the other factors arent being taken into account).

%% Electricity Consumption
p = inputParser;
addOptional(p,'ChangesStruct', []);
parse(p,varargin{:});

% NEW: Electicity that the industry consumes isnt affected by the population growth.

ElectricityConsumptionTable = Data.ElectricityConsumptionTable;
IndustryElectricityConsumptionChange = Data.IndustryElectricityConsumptionChange; % assuming industrial grow by 1.1
ChangeInElectricityConsumptionPercentageIndustry = CalculatePercentageLinear(1, IndustryElectricityConsumptionChange, Years);

for i=2:Years
  %  ElectricityConsumptionTable{:, i} = PrecentegeByTheYears(i)*ElectricityConsumptionTable{:,1};
  ElectricityConsumptionTable{1, i} = ScenariosTable{1,i} * ElectricityConsumptionTable{1,1}; %home
  ElectricityConsumptionTable{2, i} = ScenariosTable{1,i} * ElectricityConsumptionTable{2,1}; %public/commercial
  ElectricityConsumptionTable{4, i} = ScenariosTable{1,i} * ElectricityConsumptionTable{4,1}; %other
  if ScenariosTable{1,1} == ScenariosTable{1,Years}
    ElectricityConsumptionTable{3, i} =   ScenariosTable{1,i} * ElectricityConsumptionTable{3,1}; %industrial 
  else
    ElectricityConsumptionTable{3, i} =   ChangeInElectricityConsumptionPercentageIndustry(i) * ElectricityConsumptionTable{3,1}; %industrial
  end
end

%% Transportation Consumption
TransportationConsumptionTable = Data.TransportationConsumptionTable;

for i=2:Years
    Growth = ScenariosTable{1,i}*1.011;
    TransportationConsumptionTable{1:8, i} = Growth*TransportationConsumptionTable{1:8,1};
    TransportationConsumptionTable{9,i} = sum(TransportationConsumptionTable{1:8,i});
end
%% Vehicle Amoount
VehicleAmountsCell = Data.VehicleAmountsCell;
RowNames = {'Quantity', 'Gasoline', 'Diesel', 'Drive Per Day', 'Drive Per Year', 'Cars Per Year'};
ColNames = {'Bus','Car','Minibus','Motorcycle', 'Truck', 'LCV'};

for i = 1:Years
    CurrentAmount = array2table(zeros(6,6), 'RowNames', RowNames);
    CurrentAmount{:,:} = VehicleAmountsCell{1}{:,:}*(ScenariosTable{1,i});
    CurrentAmount.Properties.VariableNames = ColNames;
    VehicleAmountsCell{i} =  CurrentAmount;
end

%% Food Consumption
% assuming perfect corrrelation between population growth and food consumption.
FoodConsumptionCell = Data.FoodConsumptionCell;
% 1X34 cell, each one conatains a table of consumption for the relevant year.
RowNames = Data.FoodRowName;
ColNames = {'Humans and Other - Local','Animals - Local','Humans and Others - Import','Animals - Import'};
Initialization = FoodConsumptionCell{1}{:,:}; % data of 2017

% SHIRI'S UPDATE:
% adding upper-bound to the growth of local consumption due to area limitation.
UpperBound = Data.TotalGrowthForLocalFood;
if (ScenariosTable{5,34} < 0.8267 && ScenariosTable{5,34} > 0.826) 
    % moderate scenario: due to the prevention of food loss we can use more land.
    UpperBound = UpperBound * 1.24;
elseif (ScenariosTable{5,34} < 0.7467 && ScenariosTable{5,34} > 0.746) %advanced
    UpperBound = UpperBound * 1.41;
end

FoodPercentegeByTheYearsLocal = CalcFoodPercentegeByTheYearsLocal(ScenariosTable, UpperBound, Years);
FoodPercentegeByTheYearsGlobal = CalcFoodPercentegeByTheYearsGlobal(ScenariosTable, UpperBound, Years);
FoodPercentageByTheYearsOriginal = ScenariosTable{1,:};
OnlyImportedFoodIndex = [2, 8, 45, 46, 47, 55, 57, 62];

for i = 1:Years
    % each column is multiplied by the relevant percentages, in order to
    % limit the area for food in Israel to 4500
    CurrentConsumption = array2table(zeros(64,4), 'RowNames', RowNames);
    CurrentConsumption{:,1} = Initialization(:,1)*(FoodPercentegeByTheYearsLocal(i));
    CurrentConsumption{:,2} = Initialization(:,2)*(FoodPercentegeByTheYearsLocal(i));
    CurrentConsumption{:,3} = Initialization(:,3)*(FoodPercentegeByTheYearsGlobal(i));
    CurrentConsumption{:,4} = Initialization(:,4)*(FoodPercentegeByTheYearsGlobal(i));
    CurrentConsumption.Properties.VariableNames = ColNames;

    for j = OnlyImportedFoodIndex
        % food that is grown only overseas isnt affacted by the area
        % limitation, and therefore only by the population growth: 
        % (change when updating the area coefficients in the orignal DATA)
        CurrentConsumption{j,:} = Initialization(j,:) * FoodPercentageByTheYearsOriginal(i);
    end

    FoodConsumptionCell{i} =  CurrentConsumption;

end

% for i = 1:Years
%    CurrentConsumption = array2table(zeros(64,4), 'RowNames', RowNames);
%    CurrentConsumption{:,:} = Initialization*(PrecentegeByTheYears(i));
%    CurrentConsumption.Properties.VariableNames = ColNames;
%    FoodConsumptionCell{i} =  CurrentConsumption;
% end

%% Water model pre-data 
waterData  = array2table(zeros(3,34));
RowNames = {'Agriculture per capita', 'Water for nature', 'Drilling Water'};
waterData.Properties.RowNames = RowNames;
waterData(3,1) = {956}; % Ground Water
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
   if i>1    % Ground Water
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
CurrentConsumption{1,2} = 1248;
CurrentConsumption{1,3} = 135;
CurrentConsumption{1,4} = 23;
CurrentConsumption{1,5} = 940;
CurrentConsumption{1,6} = 613;
CurrentConsumption{1,7} = 250;
CurrentConsumption{1,8} = 586;

WaterConsumptionCell{1} =  CurrentConsumption;

if (ScenariosTable{1,1}) == ScenariosTable{1,width(ScenariosTable)} && (orderIndex == 2) %The essential change that ensures the correctness of the water model in a single scenario
    for i =2:Years
        CurrentConsumption = array2table(zeros(1,8), 'VariableNames', ColNames);
        CurrentConsumption{1,1} = 1070;
        CurrentConsumption{1,2} = 1300;
        CurrentConsumption{1,3} = 190;
        CurrentConsumption{1,4} = 25;
        CurrentConsumption{1,5} = 1080;
        CurrentConsumption{1,6} = 636;
        CurrentConsumption{1,7} = 250;
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
        CurrentConsumption{1,7} = 250; %% Brackish water, fresh and non-fresh reservoir water
        CurrentConsumption{1,8} = CurrentConsumption{1,1}*0.898904 + CurrentConsumption{1,2}*0.35 + CurrentConsumption{1,3} - CurrentConsumption{1,5}; %% desalinated from
        if i == 6 % Adjustment to the water model data for 2022, until all the data in the software is updated
            CurrentConsumption{1,1} = 1070;
            CurrentConsumption{1,2} = 1300;
            CurrentConsumption{1,3} = 190;
            CurrentConsumption{1,4} = 25;
            CurrentConsumption{1,5} = 1080;
            CurrentConsumption{1,6} = 636;
            CurrentConsumption{1,7} = 250;
            CurrentConsumption{1,8} = 524;  
        end
       
          WaterConsumptionCell{i} =  CurrentConsumption;
    end
  end

%% Construction

ConstructionTable = Data.ConstructionTable;
ConstructionInitialization = ConstructionTable{1:10,1};
for i=2:Years
    ConstructionTable{1:10, i} = ScenariosTable{1,i}*ConstructionInitialization;
    ConstructionTable{11, i} = sum(ConstructionTable{1:10, i});
end

%% Materials - generated waste and recycling
RowNames = {'Organic Products','Plastic', 'Paper', 'Cardboard', 'Diapers', 'Garden Waste', 'Textile', 'Metal', 'Glass', 'Pruned Trees','Wood', 'Oils', 'Others'};
ColNames = {'Local Authorities - Waste', 'Local Authorities - Recycling', 'Industry - Waste', 'Industry - Recycling','Food Industry - Waste' , 'Food Industry - Recycling','Agriculture - Waste', 'Agriculture - Recycling'};

WateAndRecyclingCell = Data.WateAndRecyclingCell;
for i =2:Years
    CurrentRecyclingAndWate =  array2table(zeros(13,8), 'RowNames', RowNames);
    CurrentRecyclingAndWate.Properties.VariableNames = ColNames;
    CurrentRecyclingAndWate{:,:} = WateAndRecyclingCell{1}{:,:}*ScenariosTable{1,i};
    WateAndRecyclingCell{i} = CurrentRecyclingAndWate;
end

%% Organic Waste

OrganicWasteAmount = Data.OrganicWasteAmountsCell;
RowNames = {'Local Authorities', 'Food Industry', 'Agriculture'};
ColNames = OrganicWasteAmount{1}.Properties.VariableNames;
for i = 2:Years
    CurrentOrganicWaste = array2table(zeros(3,2), 'RowNames',RowNames, 'VariableNames',ColNames);
    CurrentOrganicWaste{:,:} = OrganicWasteAmount{1}{:,:}*ScenariosTable{1,i};
    OrganicWasteAmount{i} = CurrentOrganicWaste;
end    


%% Amounts of Fuels
RowNames = {'Crude Oil Products - Not for Energy', 'Crude Oil For Export', 'Crude Oil Import', 'Crude Oil Products - For Energy', 'LPG - Home', 'LPG - Commertiel' };
ColNames = {'Naptha', 'Mazut','Diesel','Kerosene','Gasoline','Liquified Petroleum Gas', 'Other'};
AmountsOfFuelsCells = Data.AmountsOfFuelsCells;
AmountsOfFuelsCells{1,1}{4,:} = AmountsOfFuelsCells{1,1}{4,:}*2;%Completion to an estimated size of 1.5 MTOE Because currently the data is 0.75
for i = 1:Years
    CurrentFuelConsumption = array2table(zeros(6,7),'RowNames', RowNames);
    CurrentFuelConsumption.Properties.VariableNames = ColNames;
    CurrentFuelConsumption{:,:}  =  AmountsOfFuelsCells{1}{:,:};
    CurrentFuelConsumption{1:4,:} = AmountsOfFuelsCells{1}{1:4,:}*ScenariosTable{9,i}; % The multiplication in ScenariosTable{9,i} is because we understand that the amount of fuels in the industry will decrease according to this vector
    CurrentFuelConsumption{5:6,:} = AmountsOfFuelsCells{1}{5:6,:}*ScenariosTable{1,i}; % The multiplication in ScenariosTable{1,i} is because we understand that the amount of LPG will increase according to the increase in the population
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

 end

 %% OTHER FUNCTIONS:

 function LinearPercentageVector = CalculatePercentageLinear(StartValue, EndValue, Years)
    step = (EndValue - StartValue) / (Years - 1);
    LinearPercentageVector = zeros(1, Years);
    for i = 1:Years
        LinearPercentageVector(i) = StartValue + (i - 1) * step;
    end
end

function FoodPercentegeByTheYearsLocal = CalcFoodPercentegeByTheYearsLocal(ScenariosTable, UpperBound, Years)
% doesnt allow the growth vector to bigger than the defined percentae.
    PercentegeByTheYears = ScenariosTable{1,:};
    FoodPercentegeByTheYearsLocal = PercentegeByTheYears;
    for i = 1:Years
        if PercentegeByTheYears(i) > UpperBound
           FoodPercentegeByTheYearsLocal(i) = UpperBound;
        end
    end
end

function FoodPercentegeByTheYearsGlobal = CalcFoodPercentegeByTheYearsGlobal(ScenariosTable, UpperBound, Years)
% if there's no more available area in Israel - the growth is moved to overseas.
    PercentegeByTheYears = ScenariosTable{1,:};
    FoodPercentegeByTheYearsGlobal = PercentegeByTheYears;
    for i = 1:Years
        if PercentegeByTheYears(i) > UpperBound
           DeltaArea = PercentegeByTheYears(i) - UpperBound; % adding the gap so it would be imported
           FoodPercentegeByTheYearsGlobal(i) = FoodPercentegeByTheYearsGlobal(i) + DeltaArea;
        end
    end
end

