function ElectricityForWaterConsumption = CalcElectricityForWater(Data, WaterConsumption)
 %% 
global ElectricityConsumptionCoefficients
ElectricityConsumptionCoefficients = table2array(readtable(Data,'Sheet','Water','Range','B12:B17','ReadVariableNames',false))';
WaterConsumption = WaterConsumption{:,1:5};
%% urban consumption
global UrbanConsumption
UrbanConsumption = array2table(zeros(9, 8)); %line 5 diselinated, line 6 natural
UrbanConsumption.Properties.VariableNames = {'Residential', 'Local Authority', 'Hospitals', 'Gardening', 'Trade and Crafts', 'Construction', 'Loss', 'Other'};
UrbanConsumption{1, 1:8} = table2array(readtable(Data,'Sheet','Water','Range','M17:T17','ReadVariableNames',false));

for i = 1:width(UrbanConsumption)
    UrbanConsumption{2,i} = UrbanConsumption{1,i}/sum(UrbanConsumption{1,1:7});
    UrbanConsumption{3,i} = UrbanConsumption{2,i}*(WaterConsumption(4,1)+WaterConsumption(5,1));
end
for i=1:6
    UrbanConsumption{4,i} = UrbanConsumption{3,i}/(WaterConsumption(4,1)+WaterConsumption(5,1)-UrbanConsumption{3,7});
    UrbanConsumption{5,i} = UrbanConsumption{4,i}*WaterConsumption(4,2);
    UrbanConsumption{6,i} = UrbanConsumption{4,i}*WaterConsumption(4,1);
end    
UrbanConsumption{7,4} = UrbanConsumption{2,4}/(UrbanConsumption{2,4}+UrbanConsumption{2,5}); %gardening and trade ratio for brackish water
UrbanConsumption{7,5} = 1-UrbanConsumption{6,4};
UrbanConsumption{8,4} = WaterConsumption(4,3)*UrbanConsumption{6,4}; % brackish for gardening
UrbanConsumption{8,5} = WaterConsumption(4,3)*UrbanConsumption{6,5}; % brackish for trade
UrbanConsumption{9,4} = WaterConsumption(4,4); %treated waste water

%% general consumption
global GeneralConsumption
RowNames = {'Diselinated Drinking Water', 'Natural Drinking Water', 'Brackish Water', 'Flood Water', 'Total'};
GeneralConsumption = array2table(zeros(5,7), 'RowNames', RowNames);
GeneralConsumption.Properties.VariableNames = {'Total Urban Consumption', 'Construction', 'Industry', 'Agriculture','Water For Nature', 'Water For Neighbors', 'Total'};

%urban consumption
for i=1:height(GeneralConsumption)-1
    GeneralConsumption{i,1} = sum(UrbanConsumption{i,1:5});
end
%construction
GeneralConsumption{1,2} = UrbanConsumption{5,6};
GeneralConsumption{2,2} = UrbanConsumption{6,6};
%industry
GeneralConsumption{1,3} = WaterConsumption(5,2);
GeneralConsumption{2,3} = WaterConsumption(5,1);
GeneralConsumption{3,3} = WaterConsumption(5,3);
GeneralConsumption{4,3} = WaterConsumption(5,5);
%agriculture
GeneralConsumption{1,4} = WaterConsumption(1,2);
GeneralConsumption{2,4} = WaterConsumption(1,1);
GeneralConsumption{3,4} = WaterConsumption(1,3);
GeneralConsumption{4,4} = WaterConsumption(1,4);
%For Nature
GeneralConsumption{2,5} = WaterConsumption(6,1);
GeneralConsumption{3,5} = WaterConsumption(6,3);
%Neighbors
GeneralConsumption{1,6} = WaterConsumption(7,2);
GeneralConsumption{2,6} = WaterConsumption(7,1);
GeneralConsumption{3,6} = WaterConsumption(7,3);
%total
for i=1:height(GeneralConsumption)
    GeneralConsumption{i,7} = sum(GeneralConsumption{i,1:6});
end    

%% sewege
TotalSewege = sum(GeneralConsumption{2:4,1}) - UrbanConsumption{6,4}  - UrbanConsumption{9,4} - UrbanConsumption{6,1}*0.15;
TotalSewege = TotalSewege+GeneralConsumption{1,1} - UrbanConsumption{5,4} - UrbanConsumption{5,1}*0.15;
%% Electricity
global TotalElectricityFromWater
RowNames = {'Water From Nature', 'Total Urban Consumption', 'Diselinated Water', 'Treated Waste Water', 'Sewege', 'Total'};
TotalElectricityFromWater = array2table(zeros(6,2), 'RowNames', RowNames);
TotalElectricityFromWater.Properties.VariableNames = {'Water Consumption', 'Total KWH'};
TotalElectricityFromWater{1,1} = sum(GeneralConsumption{2:4,7});
TotalElectricityFromWater{2,1} =sum(GeneralConsumption{2:4,1}) + UrbanConsumption{9,4};
TotalElectricityFromWater{3,1} =GeneralConsumption{1,7};
TotalElectricityFromWater{4,1} = sum(WaterConsumption(:,4));
TotalElectricityFromWater{5,1} = TotalSewege;

TotalElectricityFromWater{1,2} = TotalElectricityFromWater{1,1}*(ElectricityConsumptionCoefficients(6)+ElectricityConsumptionCoefficients(2));
TotalElectricityFromWater{2,2} = TotalElectricityFromWater{2,1}*(ElectricityConsumptionCoefficients(3));
TotalElectricityFromWater{3,2} = TotalElectricityFromWater{3,1}*(ElectricityConsumptionCoefficients(1)+ElectricityConsumptionCoefficients(2));
TotalElectricityFromWater{4,2} = TotalElectricityFromWater{4,1}*(ElectricityConsumptionCoefficients(4));
TotalElectricityFromWater{5,2} = TotalElectricityFromWater{5,1}*(ElectricityConsumptionCoefficients(5));

TotalElectricityFromWater{6,2} = sum(TotalElectricityFromWater{1:5,2});
ElectricityForWaterConsumption = TotalElectricityFromWater;
end

