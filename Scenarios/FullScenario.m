function [EmissionsByYears,ConsumptionAmounts, Resources, WaterFromFoodCell] = FullScenario(Data,ScenariosTable,Years,pop,orderIndex, index)
%% Cut Vectors from Scenarios Table

PopulationGrowthPercentage = ScenariosTable{1,:};
ChangeInElectricityConsumptionPercentage = ScenariosTable{2,:};
IncreaseInDiselinatedWater = ScenariosTable{3,:};
ReducingBeefConsumptionPercentage = ScenariosTable{4,:};
PreventingFoodLoss = ScenariosTable{5,:};
IncreaseInEnergyConsumptionFromRenewableEnergiesPercentage = ScenariosTable{6,:};
IncreaseInEnergyConsumptionFromNaturalGasPercentage  = ScenariosTable{7,:};
ElectricitySavingPercentage = ScenariosTable{8,:};
WasteMinimazation = ScenariosTable{9,:};
RecycleWaste = ScenariosTable{10,:};
BurningWaste = ScenariosTable{11,:};
ReductionOfMileage = ScenariosTable{12,:};
TransitionToPublicTransportationPercentage = ScenariosTable{13,:};
TransitionToElectricCar = ScenariosTable{14,:};
TransitionToElectricVan = ScenariosTable{15,:};
TransitionToElectricTruck = ScenariosTable{16,:};
TransitionToElectricBus = ScenariosTable{17,:};
%%Scenario18 = ScenariosTable{18,:}; %% vehicles improved emissions coefficients
WaterSaving = ScenariosTable{19,:};

%% Preparations - scenario 1`

EmissionsByYears = cell(10,Years);
ConsumptionAmounts = cell(5,Years);
addpath("CalcFunctions");
ConsumptionChangesTable = PopulationGrowthPercentage;
[ElectricityConsumptionTable, TransportationConsumptionTable, VehicleAmountsCell, FoodConsumptionCell, WaterConsumptionCell, ConstructionTable,WasteAndRecyclingCell,AmountsOfFuelsCells, OrganicWasteCell] = ConsumptionChanges(Data,ConsumptionChangesTable, Years,pop,orderIndex);

YearsStringsForColNames = cell(1,Years);
for i=1:Years
    s1 = num2str(i+2016);
    YearsStringsForColNames{i} = s1;
end
%% Food Emissions & Food Resource Consumption - scenario 4

WaterFromFoodCell = cell(1,Years);
CaloricCompletion = ones(1,Years) + (1-(ReducingBeefConsumptionPercentage))/5;


for i=1:Years
    CurrentFoodConsumption = FoodConsumptionCell{i};
    if (index == 4 || index == 5 && orderIndex == 2 ) || (orderIndex ~= 2)
        CurrentFoodConsumption{52,1} = CurrentFoodConsumption{52,1} * ReducingBeefConsumptionPercentage(i);
        CurrentFoodConsumption{52,3} = CurrentFoodConsumption{52,3} * ReducingBeefConsumptionPercentage(i);
        for j = 10:14
            CurrentFoodConsumption{j,1} = CurrentFoodConsumption{j,1} * CaloricCompletion(i);
            CurrentFoodConsumption{j,3} = CurrentFoodConsumption{j,3} * CaloricCompletion(i);
        end    
        for j = 1:width(CurrentFoodConsumption)
            CurrentFoodConsumption{:,j} = CurrentFoodConsumption{:,j}.*PreventingFoodLoss(i);
        end
    end
   

    WaterFromFoodCell{i} = CalcWaterForFoodConsumption(Data, CurrentFoodConsumption);
    EmissionsFromFood = CalcCo2eFromFoodConsumption(Data, CurrentFoodConsumption, OrganicWasteCell{i});
    %EmissionsFromWaterToGlobalFood = sum(WaterFromFoodCell{i}{1,3:4})*(0.4+0.2+0.51)*10^6;
    EmissionsByYears{1,i} = EmissionsFromFood;
    %EmissionsByYears{11,i} = EmissionsFromWaterToGlobalFood ;
    FoodConsumptionCell{i} = CurrentFoodConsumption;
end


%% Water Emissions

for i = 1:Years
    EmmisionsFromSewegeTreatment = CalcSewegeEmissions(Data, WaterConsumptionCell{i});
    EmissionsByYears{10,i} = EmmisionsFromSewegeTreatment;
end

%% { change in diselinated water consumption - scenario 3  - not useful, need to be change

%{
for i =1:Years
    DiselinatedWaterConsumption = WaterConsumptionCell{i}{:,2};
    DiselinatedWaterConsumption = DiselinatedWaterConsumption*IncreaseInDiselinatedWater(i);
    WaterConsumptionCell{i}{:,2} = DiselinatedWaterConsumption;
end ConsumptionAmounts{1
%}


%% water saving - scenario 19
for i=1:Years
    CurrentWaterConsumption = WaterConsumptionCell{i}{:,:}*WaterSaving(i);
    WaterConsumptionCell{i}{:,:} = CurrentWaterConsumption;
    ConsumptionAmounts{1,i} = WaterConsumptionCell{i};
end

for i = 1:Years
    CurrentWater = WaterConsumptionCell{1,i};
    NewCurrentWater = array2table(zeros(height(CurrentWater)+1,width(CurrentWater)));
    NewCurrentWater{1:height(NewCurrentWater)-1,:} = CurrentWater{:,:};
    NewCurrentWater.Properties.VariableNames = CurrentWater.Properties.VariableNames;
    for j = 1:width(NewCurrentWater)
        NewCurrentWater{1,j} = sum(NewCurrentWater{1,j});
    end
   
    %NewCurrentWater{:,:} = NewCurrentWater{:,:}/1000000;%% m^3 * 10^6
    ConsumptionAmounts{1,i} = (NewCurrentWater); 
end    


%% Transportation - Downstream

%%change in mileage - scenario 12
for i = 1:Years
    CurrentMileage = TransportationConsumptionTable{:,i};
    CurrentMileage = CurrentMileage*ReductionOfMileage(i);
    TransportationConsumptionTable{:,i} = CurrentMileage;
end

%KM from car to bus (percentages) - scenario 13
PercentageToBuses  = Data.TransitionToBus;
PercentageToTrains = Data.TransitionToTrain;

TransitionToBus = (1-TransitionToPublicTransportationPercentage)*PercentageToBuses;
TransitionToTrain = (1-TransitionToPublicTransportationPercentage)*PercentageToTrains;

PercentageOfBusTransportation = CalculateBusPercentages(TransitionToBus);

for i = 1:Years
    TransportationConsumptionTable{2,i} = TransportationConsumptionTable{2,i}*TransitionToPublicTransportationPercentage(i);
    TransportationConsumptionTable{1,i} = TransportationConsumptionTable{1,i}*PercentageOfBusTransportation(i);
end

%%change in vehicle amounts
VehicleAmountsCell = CalulateChangeInVehicleAmountsTransitionToPublicTransport(TransportationConsumptionTable, VehicleAmountsCell);

ElectricityConsumptionEmissionsInTransportation = Data.ElectricityConsumptionEmissionsInTransportation;

KWHForElectricCar = zeros(1,Years);
KWHForElectricVan = zeros(1,Years);
KWHForElectricTruck = zeros(1,Years);
KWHForElectricBus = zeros(1,Years);
KMTraveledByElectricCar = zeros(1,Years);

for i = 1:Years    
    [KMTraveledByElectricCar(i), TransportationConsumptionTable{2,i}] = CalcTransitionToEV(TransportationConsumptionTable{2,i},TransitionToElectricCar(i));
    [KMTraveledByElectricVan, TransportationConsumptionTable{6,i}] = CalcTransitionToEV(TransportationConsumptionTable{6,i},TransitionToElectricVan(i));
    [KMTraveledByElectricTruck, TransportationConsumptionTable{5,i}] = CalcTransitionToEV(TransportationConsumptionTable{5,i},TransitionToElectricTruck(i));
    [KMTraveledByElectricBus, TransportationConsumptionTable{1,i}] = CalcTransitionToEV(TransportationConsumptionTable{1,i},TransitionToElectricBus(i));
    
    % electricity consumption from ev
    KWHForElectricCar(i) = (KMTraveledByElectricCar(i))*ElectricityConsumptionEmissionsInTransportation{1,i};
    KWHForElectricVan(i) = (KMTraveledByElectricVan)*ElectricityConsumptionEmissionsInTransportation{2,i};
    KWHForElectricTruck(i) = (KMTraveledByElectricTruck)*ElectricityConsumptionEmissionsInTransportation{3,i};
    KWHForElectricBus(i) = (KMTraveledByElectricBus)*ElectricityConsumptionEmissionsInTransportation{4,i};

    % indirect emissions from ev
    
end

%changes in vehicle amounts - needed?
VehicleAmountsCell = ChangesInVehicelAmountsAfterElectricVehicels(TransportationConsumptionTable, VehicleAmountsCell);

for i = 1:Years
    CurrentTransportatiionConsumtpion = TransportationConsumptionTable{:,i};
    CurrentVehicleAmount = table2array(VehicleAmountsCell{i});
    [EmissionsByYears{4,i},EmissionsByYears{5,i}]  = CalcTransportationConsumption(Data, CurrentTransportatiionConsumtpion,CurrentVehicleAmount);
    [EmissionsByYears{6,i}, ConsumptionAmounts{3,i}]  = CalcTransportationManufacturing(Data, CurrentTransportatiionConsumtpion,CurrentVehicleAmount, KMTraveledByElectricCar(i));
end

for i = 1:Years
    for j =1:width(EmissionsByYears{4,i})
        EmissionsByYears{4,i}{2,j} = EmissionsByYears{4,i}{2,j}*(1-TransitionToTrain(i)); %% reduction in fuel amount not changed
    end
    for j =1:width(EmissionsByYears{5,i})
        EmissionsByYears{5,i}{1,j} = EmissionsByYears{5,i}{1,j}*(1+(TransitionToTrain(i)*(0.0027806/2.01))); %% what is this number?
    end
end

%% Electricity - Consumption
%%change in electricity consumption pe capita - scenario 2
for i = 1:Years
    CurrentYearElectricity = ElectricityConsumptionTable{:,i};
    CurrentYearElectricity = CurrentYearElectricity*ChangeInElectricityConsumptionPercentage(i);
    ElectricityConsumptionTable{:,i} = CurrentYearElectricity;
end

%%electricity saving - scenario 8
for i = 1:Years
    CurrentYearElectricity = ElectricityConsumptionTable{:,i}*ElectricitySavingPercentage(i);
    ElectricityConsumptionTable{:,i} = CurrentYearElectricity;
end

%%percentage of renewable energies - scenario 6
InitialPercentage = Data.InitialPercentage;
PercentageOfElectricitySourcesByYears = CalculatePercentageOfElectricitySourcesByYears(IncreaseInEnergyConsumptionFromRenewableEnergiesPercentage, IncreaseInEnergyConsumptionFromNaturalGasPercentage, InitialPercentage);
ElectricityFromWaterCell = CalculateElectricityFromWaterAllYears(Data, WaterConsumptionCell,Years);
for i = 1:Years
    ElectricityConsumptionTable{5,i} = KWHForElectricCar(i)+KWHForElectricVan(i)+KWHForElectricTruck(i)+KWHForElectricTruck(i);
end

%% construction waste
for i = 1:Years
    CurrentConstruction = ConstructionTable{:,i};
    [ConsumptionAmounts{4,i},EmissionsByYears{7,i}] = CalcConstruction(Data, CurrentConstruction);
end
%% waste minimization - scenario 9

for i=1:Years
    CurrentWaste = WasteAndRecyclingCell{i};
    for j = 1:height(WasteAndRecyclingCell{i})
        for k =1:width(CurrentWaste)
            CurrentWaste{j,k} = WasteMinimazation(i)*CurrentWaste{j,k};
        end
    end
    WasteAndRecyclingCell{i} = CurrentWaste;
end


%% recycled waste - scenario 10

for i=1:Years
    CurrentWaste = WasteAndRecyclingCell{i};
    for j = 1:2:width(CurrentWaste)
        CurrentBurial = CurrentWaste{:,j};
        NewBurial = CurrentBurial.*RecycleWaste(i);
        diff = CurrentBurial-NewBurial;
        CurrentWaste{:,j+1} = CurrentWaste{:,j+1}+diff;
        CurrentWaste{:,j} = NewBurial;
    end
    WasteAndRecyclingCell{i} = CurrentWaste;
end

%% burning waste - scenario 11
WasteInciniration = zeros(1,Years); %% amounts of waste to incinirate
for i=1:Years
    CurrentWaste = WasteAndRecyclingCell{i};
    for j = 1:2:width(CurrentWaste)
        CurrentBurial = CurrentWaste{:,j};
        NewBurial = CurrentBurial.*BurningWaste(i);
        WasteInciniration(i) = WasteInciniration(i) + sum(CurrentBurial-NewBurial); %% how much waste in incinareted
        CurrentWaste{:,j} = NewBurial;
    end
    WasteAndRecyclingCell{i} = CurrentWaste;
end
%% Electricity emissions
ElectricityBySources = array2table(zeros(7,Years));
ElectricityBySources.Properties.RowNames = {'KWh From Coal', 'KWh From Natural Gas', 'KWh From Renewable Energies', 'KWh From Soler', 'KWh From Mazut', 'KWh From Waste Incinaration', 'Total'};
ElectricityBySources.Properties.VariableNames = YearsStringsForColNames;

for i=1:Years
    CurrentYearElectricity = ElectricityConsumptionTable{:,i};
    CurrentElectricityFromWater = ElectricityFromWaterCell{i};
    TotalElectricityFromWater = CurrentElectricityFromWater{6,1};
    CurrentYearElectricity(6) = TotalElectricityFromWater;
    CurrentYearElectricity(7,1) = sum(WaterFromFoodCell{1,i}{1,3:4})*(0.51+0.4); % The amount of water for global food per cubic meter is twice the electricity coefficients for global water in KWH per cubic meter. The electricity coefficient discount is for producing and transporting fresh water
    ElectricityConsumptionTable{6,i} = CurrentYearElectricity(6);
    [EmissionsByYears{2,i}, ElectricityBySources{1:6,i}] = CalcElectricityConsumption(Data, CurrentYearElectricity, PercentageOfElectricitySourcesByYears{:,i},WasteInciniration(i));

    [EmissionsByYears{3,i},ConsumptionAmounts{2,i}] = CalcElectricityManufacturing(Data, CurrentYearElectricity, PercentageOfElectricitySourcesByYears{:,i});
    ElectricityBySources{7,i} = sum(ElectricityBySources{1:6,i});
end


%% emissions from consumption - on hold until further analysis
% WasteAndRecyclingSummaryCell = cell(1,Years);
% for i=1:Years
%     WasteAndRecyclingSummaryCell{i} = CalcWasteAndRecycling(WasteAndRecyclingCell{i}, Data);
%     [EmissionsByYears{8,i}, EmissionsByYears{9,i}] = CalcConsumptionEmissions(WasteAndRecyclingCell{i} ,Data);
% end

Resources = cell(8,Years);
% Area
KWForElectricity = array2table(zeros(7,Years));
  
for i = 1:Years
    KWForElectricity{1:6,i} = CalcKWFromKwh(ElectricityBySources{1:3,i}, Data.KWToKwh, Data.RenewablePercents{1,:});
    KWForElectricity{7,i} = sum(KWForElectricity{1:7,i});
end
KWForElectricity.Properties.RowNames = {'Coal','Natural Gas','PV', 'Wind', 'Biomass', 'Thermo Solar', 'Total'};
KWForElectricity.Properties.VariableNames = YearsStringsForColNames;

if(Data.PVType == "Ground")
    RenewableDistribution = Data.AreaDistribution.GroundPV;
else
    RenewableDistribution = Data.AreaDistribution.DualPV;
end  

%Electricity Installed Power
DeltaKW = array2table(zeros(7,Years)); %% the difference in installed KW for the setting costs
DeltaKW{:,1} = KWForElectricity{:,1};
for i = 2:Years
    DeltaKW{:,i} =  KWForElectricity{:,i} - KWForElectricity{:,i-1};
    %{
    for j = 1:height(DeltaKW)
        if (DeltaKW{j,i}) < 0
            DeltaKW{j,i} = 0;
        end
    end  
    %}
end

DeltaKW.Properties.RowNames = {'Coal','Natural Gas', 'PV', 'Wind', 'Biomass', 'Thermo Solar', 'Total'};
DeltaKW.Properties.VariableNames = YearsStringsForColNames;
TotalArea = 0;
for i = 1:Years
    CurrentAreaCoefficient = Data.AreaForSolarEnergyCoefficients{i,:}; % AreaForSolarEnergyCoefficients need a re-name
   AreaForElectricity = CalcAreaForElectricity(DeltaKW{:,i}, CurrentAreaCoefficient, RenewableDistribution, Data.AreaDistribution{:,3});
    %AreaForElectricity = CalcAreaForElectricity(KWForElectricity{:,i}, CurrentAreaCoefficient, RenewableDistribution, Data.AreaDistribution{:,3});
    AreaForElectricity{:,:} = AreaForElectricity{:,:}/1000;%% km^2
   
    Resources{1,i} = AreaForElectricity; 
    
    TotalArea = sum(AreaForElectricity{1,:}) + TotalArea;
    Resources{2,i} = TotalArea;
end

for i = 1:Years
    CurrentAreaForFood = CalcAreaForFoodConsumption(FoodConsumptionCell{i}, Data.AreaForFoodCoefficients);
    CurrentAreaForFood{:,:} = CurrentAreaForFood{:,:}/1000;%% km^2
    Resources{3,i} = CurrentAreaForFood; 
end

%% Money
%OperationCost
if(Data.PVType == "Ground")
    Data.OperatingCosts.DualPV = [];
    Data.SettingCosts.DualPV = [];
else
    Data.OperatingCosts.GroundPV = [];
    Data.SettingCosts.GroundPV = [];
end    
for i = 1:Years
    Resources{4,i} = CalcOperationCosts(KWForElectricity{:,i}, Data.OperatingCosts{i,:});
end

%%Setting Costs
for i = 1:Years
     Resources{5,i} = CalcSettingCosts(KWForElectricity{:,i}, Data.SettingCosts{i,:});
   % Resources{5,i} = CalcSettingCosts(DeltaKW{:,i}, Data.SettingCosts{i,:});
end

% cost of Fuels For Electriciy Manufacturing ONLY, not include transportation
for i = 1:Years
    Resources{6,i} = CalcFuelCosts(ConsumptionAmounts{2,i}{1,:},ConsumptionAmounts{3,i}{1,:}, Data.ILSPerTon{:,1}, Data.ILSPerTon{:,3});
end

% cost of area
for i = 1:Years
     Resources{7,i} = CalcCostOfArea(Resources{1,i}{1,3:7}, Data.AreaCostForElectricity{i,:});
end
%% Construction area 
InitBuiltArea = Data.TotalBuiltArea;
Resources{8,1} = InitBuiltArea;
for i = 2:Years
    if (orderIndex == 2 && ConstructionTable{height(ConstructionTable),1} ~= ConstructionTable{height(ConstructionTable),width(ConstructionTable)}) || orderIndex ~= 2
     Resources{8,i} = ConstructionTable{height(ConstructionTable),i}/1000 + Resources{8,i-1};
    else
            Resources{8,i} = InitBuiltArea;
    end
end
%% Create Final Table

RowNames = {'Food', 'Electricity - Direct', 'Electricity - Indirect', 'Transportation - Direct', 'Train Emissions','Transportation - Indirect', 'Construction', 'Consumption Emissions' ,'Emissions From Crude Oil Byproducts (Materials)', 'Sewege Treatment'}; %, 'Water from food'
EmissionsByYears = cell2table(EmissionsByYears, 'RowNames', RowNames);
EmissionsByYears.Properties.VariableNames = YearsStringsForColNames;

RowNames = {'Water', 'Fuels For Electriciy Manufacturing', 'Fuels For Transportation Amounts', 'Materials For Construction', 'Fuels For Energy'};
ConsumptionAmounts = cell2table(ConsumptionAmounts, 'RowNames', RowNames);
ConsumptionAmounts.Properties.VariableNames = YearsStringsForColNames;

RowNames = {'Area For Electricity', 'Cumulative Area','Area For Food', 'Operating Costs', 'Setting Costs', 'Fuels Costs', 'Cost Of Area For PV','Area For Construction'};
Resources = cell2table(Resources);
Resources.Properties.RowNames = RowNames;
Resources.Properties.VariableNames = YearsStringsForColNames;


%% Other Functions

function ElectricityFromWater = CalculateElectricityFromWaterAllYears(Data, WaterConsumptionCell, Years) %% in data file - needs to multiply the electricity by 1.18336
    ElectricityFromWater = cell(1,Years);
    for i=1:Years
        ElectricityFromWater{i} = CalcElectricityForWater(Data, WaterConsumptionCell{i}, Data.ElectricityConsumptionCoefficients{:,i});
    end
end

function PercentageByYears = CalculatePercentageOfElectricitySourcesByYears(RenewableEnergiesPercentage, NaturalGasPercentage, Percentage)
Years = width(RenewableEnergiesPercentage);
PercentageByYears = array2table(zeros(5,Years)); %% cell array that contains the percentages of manufacturing
RowNames = {'Coal', 'Natural Gas', 'Renewable', 'Soler', 'Mazut'};
ColumnNames = cell(1,Years);
for i=1:Years
    s1 = num2str(i+2016);
    ColumnNames{i} = s1;
end
PercentageByYears.Properties.VariableNames = ColumnNames;
PercentageByYears.Properties.RowNames = RowNames;
PercentageByYears{:,1} = Percentage'; %% initialization
for i = 2:Years
    CurrentRenewableChange = RenewableEnergiesPercentage(i)-RenewableEnergiesPercentage(i-1);
    CurrentGasChange = NaturalGasPercentage(i)-NaturalGasPercentage(i-1);
    if (Percentage(1) > 0) %% if coal manufacturing still not zero
        if(Percentage(1)>CurrentGasChange) %% if the change in natural gas is laeger than what is left
            Percentage(1)=Percentage(1)-CurrentGasChange; %% substract from coal
            Percentage(2)=Percentage(2)+CurrentGasChange; %% add to natural gas
        else
            Percentage(2)=Percentage(2)+Percentage(1); %% add  to natural gas
            Percentage(1)=0; %% put coal to zero
        end
        if(Percentage(1)>CurrentRenewableChange) %% same for renewable
            Percentage(1)=Percentage(1)-CurrentRenewableChange; %% take from coal
            Percentage(3)=Percentage(3)+CurrentRenewableChange; %% add to renewable
        else
            Percentage(2)=Percentage(2)-CurrentRenewableChange+Percentage(1); %% substract renewable change from natural gas
            Percentage(1)=0; %% set coal to zero
            Percentage(3)=Percentage(3)+CurrentRenewableChange; %% add to renewable energy
        end
    else %% if no more electricity is manufactured by coal
        Percentage(2)=Percentage(2)-CurrentRenewableChange; %% subtract from natural gas
        Percentage(3)=Percentage(3)+CurrentRenewableChange; %% add to renewable
    end
    PercentageByYears{:,i}=Percentage';
end
end



function PercentageByYears = CalculateBusPercentages(ChangeByYears)
Years = width(ChangeByYears);
PercentageByYears = zeros(1,width(ChangeByYears));
PercentageByYears(1) = 1;
for i = 2:Years
    CurrentChange = (ChangeByYears(i)-ChangeByYears(i-1))*(1.5/20);
    PercentageByYears(i) = PercentageByYears(i-1) + CurrentChange;
end
end


function PercentageByYears = CalculateTrainPercentages(ChangeByYears)
PercentageByYears = zeros(1,width(ChangeByYears));
end

function NewVehicleAmountCell = CalulateChangeInVehicleAmountsTransitionToPublicTransport(TrasnportationConsumptionTable, VehicleAmountCell)
NewVehicleAmountCell = cell(1,width(TrasnportationConsumptionTable));
NewVehicleAmountCell{1} = VehicleAmountCell{1};
RidesPerDay = 4;
KMPerCar = TrasnportationConsumptionTable{2,1}/VehicleAmountCell{1}{1,2};
KMPerBus = TrasnportationConsumptionTable{1,1}/VehicleAmountCell{1}{1,1};
RowNames = {'Quantity', 'Gasoline', 'Diesel', 'Drive Per Day', 'Drive Per Year', 'Cars Per Year'};
NewVehicleAmountCell{1} = array2table(zeros(6,6), 'RowNames', RowNames);
NewVehicleAmountCell{1}{:,:} = VehicleAmountCell{1}{:,:};
ColNames = {'Bus','Car','Minibus','Motorcycle', 'Truck', 'LCV'};
NewVehicleAmountCell{1}.Properties.VariableNames = ColNames;

for i=2:width(TrasnportationConsumptionTable)
    NewVehicleAmountCell{i} = array2table(zeros(6,6), 'RowNames', RowNames);
    NewVehicleAmountCell{i}{:,:} = VehicleAmountCell{i}{:,:};
    NewVehicleAmountCell{i}{1,1} = ceil((TrasnportationConsumptionTable{1,i}-TrasnportationConsumptionTable{1,i-1})/KMPerBus) + NewVehicleAmountCell{i-1}{1,1};
    NewVehicleAmountCell{i}{4,1} = NewVehicleAmountCell{i}{1,1}*RidesPerDay;
    NewVehicleAmountCell{i}{5,1} = NewVehicleAmountCell{i}{4,1}*365;
    NewVehicleAmountCell{i}{6,1} = NewVehicleAmountCell{i}{1,1}*365;

    NewVehicleAmountCell{i}{1,2} = NewVehicleAmountCell{i-1}{1,2} - floor((TrasnportationConsumptionTable{2,i-1}-TrasnportationConsumptionTable{2,i})/KMPerCar);
    NewVehicleAmountCell{i}{4,2} = NewVehicleAmountCell{i}{1,2}*RidesPerDay;
    NewVehicleAmountCell{i}{5,2} = NewVehicleAmountCell{i}{4,2}*365;
    NewVehicleAmountCell{i}{6,2} = NewVehicleAmountCell{i}{1,2}*365;

    NewVehicleAmountCell{i}.Properties.VariableNames = ColNames;
end
end

function NewVehicleAmountCell = ChangesInVehicelAmountsAfterElectricVehicels(TrasnportationConsumptionTable, VehicleAmountCell)
NewVehicleAmountCell = cell(1,width(VehicleAmountCell));
NewVehicleAmountCell{1} = VehicleAmountCell{1};
RidesPerDay = 4;
KMPerCar = TrasnportationConsumptionTable{2,1}/VehicleAmountCell{1}{1,2};
KMPerBus = TrasnportationConsumptionTable{1,1}/VehicleAmountCell{1}{1,1};
KMPerTruck = TrasnportationConsumptionTable{5,1}/VehicleAmountCell{1}{1,5};
KMPerVan = TrasnportationConsumptionTable{6,1}/VehicleAmountCell{1}{1,6};
RowNames = {'Quantity', 'Gasoline', 'Diesel', 'Drive Per Day', 'Drive Per Year', 'Cars Per Year'};
NewVehicleAmountCell{1} = array2table(zeros(6,6), 'RowNames', RowNames);
NewVehicleAmountCell{1}{:,:} = VehicleAmountCell{1}{:,:};
ColNames = {'Bus','Car','Minibus','Motorcycle', 'Truck', 'LCV'};
NewVehicleAmountCell{1}.Properties.VariableNames = ColNames;

for i=2:width(TrasnportationConsumptionTable)
    NewVehicleAmountCell{i} = array2table(zeros(6,6), 'RowNames', RowNames);
    NewVehicleAmountCell{i}{:,:} = VehicleAmountCell{i}{:,:};
    %buses
    NewVehicleAmountCell{i}{1,1} = NewVehicleAmountCell{i-1}{1,1} - floor((TrasnportationConsumptionTable{1,i-1}-TrasnportationConsumptionTable{1,i})/KMPerBus); %x
    NewVehicleAmountCell{i}{4,1} = NewVehicleAmountCell{i}{1,1}*RidesPerDay; %4x
    NewVehicleAmountCell{i}{5,1} = NewVehicleAmountCell{i}{4,1}*365; % 4x*365
    NewVehicleAmountCell{i}{6,1} = NewVehicleAmountCell{i}{1,1}*365; % 365x
    %cars
    NewVehicleAmountCell{i}{1,2} = NewVehicleAmountCell{i-1}{1,2} - floor((TrasnportationConsumptionTable{2,i-1}-TrasnportationConsumptionTable{2,i})/KMPerCar);
    NewVehicleAmountCell{i}{4,2} = NewVehicleAmountCell{i}{1,2}*RidesPerDay;
    NewVehicleAmountCell{i}{5,2} = NewVehicleAmountCell{i}{4,2}*365;
    NewVehicleAmountCell{i}{6,2} = NewVehicleAmountCell{i}{1,2}*365;
    %trucks
    NewVehicleAmountCell{i}{1,5} = NewVehicleAmountCell{i-1}{1,5} - floor((TrasnportationConsumptionTable{5,i-1}-TrasnportationConsumptionTable{5,i})/KMPerTruck);
    NewVehicleAmountCell{i}{4,5} = NewVehicleAmountCell{i}{1,5}*RidesPerDay;
    NewVehicleAmountCell{i}{5,5} = NewVehicleAmountCell{i}{4,5}*365;
    NewVehicleAmountCell{i}{6,5} = NewVehicleAmountCell{i}{1,5}*365;
    %vans
    NewVehicleAmountCell{i}{1,6} = ceil(NewVehicleAmountCell{i-1}{1,6} - ((TrasnportationConsumptionTable{6,i-1}-TrasnportationConsumptionTable{6,i})/KMPerVan));
    NewVehicleAmountCell{i}{4,6} = NewVehicleAmountCell{i}{1,6}*RidesPerDay;
    NewVehicleAmountCell{i}{5,6} = NewVehicleAmountCell{i}{4,6}*365;
    NewVehicleAmountCell{i}{6,6} = NewVehicleAmountCell{i}{1,6}*365;

    NewVehicleAmountCell{i}.Properties.VariableNames = ColNames;
end
end


end