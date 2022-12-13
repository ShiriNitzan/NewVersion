
addpath("Data");
HourlyData = readtable("Files_Netunei_hashmal_doch_reshut_hasmal_2020_data_n.xlsx",'Sheet', '3.5 שעות יצור מצטברות לפי דלק', 'Range','A6:M8788', 'ReadVariableNames', false);
HourlyData.Properties.VariableNames = {'Day', 'Month', 'Time', 'Hour Of Year', 'Total Manufacturing (MwH)', 'Coal (MwH)', 'Gas (MwH)', 'Renewable (MwH)', 'Other (MwH)', 'Percentage Of Natural Gas', 'GHI (Wh/m^2)', 'Air Temperature (C)', 'Wind Speed (m\sec)'};
Time = HourlyData{:,3};
Time.Format = 'HH:mm:ss';
HourlyData = removevars(HourlyData, 'Time');
HourlyData = addvars(HourlyData,Time, 'Before', 'Hour Of Year');
TimeStrings = HourlyData.Time;
TimeStrings.Format = 'HH:mm:ss';
TimeStrings = string(TimeStrings);
HourlyData = addvars(HourlyData,TimeStrings, 'Before', 'Hour Of Year');
Day = HourlyData{:,1};
Day.Format = 'yyyy-MM-dd';
HourlyData = removevars(HourlyData, 'Day');
HourlyData = addvars(HourlyData,Day, 'Before', 'Month');

MonthNames = ["January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December"];

 %% Total Area
Area = table2array(readtable("Files_Netunei_hashmal_doch_reshut_hasmal_2020_data_n.xlsx",'Sheet', '3.5 שעות יצור מצטברות לפי דלק', 'Range','R20:R21', 'ReadVariableNames', false));
TotalSolarEnergyPerHour = (sum(Area)*HourlyData{:,12})/1000;

HourlyData = addvars(HourlyData,TotalSolarEnergyPerHour);
%% Day Strings
DayStrings = HourlyData.Day;
DayStrings = string(DayStrings);
HourlyData = addvars(HourlyData,DayStrings, 'After', 'Day');
%% Difference between renewable and total manufacturing
TotalRenewableDiff = HourlyData{:,7} - HourlyData{:,10};
HourlyData = addvars(HourlyData,TotalRenewableDiff);
%% Electricity By Panels
ElectricityByPanels = array2table(zeros(height(HourlyData), 4));
ElectricityByPanels.Properties.VariableNames = {'Potential', 'BIC - Lab', 'HJT - Lab', 'Mono PERC - Lab'};
ElectricityByPanels{:,1} = HourlyData.TotalSolarEnergyPerHour;
ElectricityByPanels{:,2} = 0.228.*ElectricityByPanels{:,1};
ElectricityByPanels{:,3} = 0.219.*ElectricityByPanels{:,1};
ElectricityByPanels{:,4} = 0.17.*ElectricityByPanels{:,1};
ElectricityByPanels = addvars(ElectricityByPanels,Day, 'Before', 'Potential');
ElectricityByPanels = addvars(ElectricityByPanels,Time, 'Before', 'Potential');
TotalRenewable = HourlyData{:,10};
ElectricityByPanels = addvars(ElectricityByPanels,TotalRenewable);
ElectricityByPanels = addvars(ElectricityByPanels,HourlyData.('Total Manufacturing (MwH)'));
ElectricityByPanels.Properties.VariableNames(8) = "Total Manufacturing";
BICDiff = ElectricityByPanels{:,8} - ElectricityByPanels{:,4};
ElectricityByPanels = addvars(ElectricityByPanels,BICDiff);
HJTDiff = ElectricityByPanels{:,8} - ElectricityByPanels{:,5};
ElectricityByPanels = addvars(ElectricityByPanels,HJTDiff);
MonoPERCDiff = ElectricityByPanels{:,8} - ElectricityByPanels{:,6};
ElectricityByPanels = addvars(ElectricityByPanels,MonoPERCDiff);
%% 
GNI = HourlyData{:, 13};
AirTemperature = HourlyData{:, 14};
WindSpeed = HourlyData{:, 15};
ElectricityByPanels = addvars(ElectricityByPanels,GNI, 'Before', 'Potential');
ElectricityByPanels = addvars(ElectricityByPanels,AirTemperature, 'Before', 'Potential');
ElectricityByPanels = addvars(ElectricityByPanels,WindSpeed, 'Before', 'Potential');
MonthNumber = HourlyData{:, 3};
ElectricityByPanels = addvars(ElectricityByPanels,MonthNumber, 'Before', 'GNI');
%% Actual Panel Efficiency
u0 = 25;
u1 = 6.84;
%%BIC
BICInitialEfficiency = 0.228;
BICReductionTemperatureCoefficient = 0.003;
BICIncreaseTemperatureCoefficient = 0.0004;

%%HJT
HJTInitialEfficiency = 0.219;
HJTReductionTemperatureCoefficient = 0.0025;
HJTIncreaseTemperatureCoefficient = 0.0004;

%%MonoPERC
MonoPERCInitialEfficiency = 0.17;
MonoPERCReductionTemperatureCoefficient = 0.0041;
MonoPERCIncreaseTemperatureCoefficient = 0.0004;
%% BIC New Efficiency
ActualBIC = zeros(height(ElectricityByPanels),1);
ElectricityByPanels = addvars(ElectricityByPanels,ActualBIC, 'Before', 'Total Manufacturing');
for j = 1:(height(ElectricityByPanels))
    PanelTemperatue = ElectricityByPanels.AirTemperature(j) +  (ElectricityByPanels.GNI(j)/(u0+u1*ElectricityByPanels.WindSpeed(j)));
    if PanelTemperatue > 25
        NewEfficiency = BICInitialEfficiency*(1-(PanelTemperatue-25)*BICReductionTemperatureCoefficient);
    else
        NewEfficiency = BICInitialEfficiency*(1+(25-PanelTemperatue)*BICIncreaseTemperatureCoefficient);
    end   
    ElectricityByPanels.ActualBIC(j) = NewEfficiency*ElectricityByPanels.Potential(j);
end

%% HJT New Efficiency
ActualHJT = zeros(height(ElectricityByPanels),1);
ElectricityByPanels = addvars(ElectricityByPanels,ActualHJT, 'Before', 'Total Manufacturing');
for j = 1:(height(ElectricityByPanels))
    PanelTemperatue = ElectricityByPanels.AirTemperature(j) +  (ElectricityByPanels.GNI(j)/(u0+u1*ElectricityByPanels.WindSpeed(j)));
    if PanelTemperatue > 25
        NewEfficiency = HJTInitialEfficiency*(1-(PanelTemperatue-25)*HJTReductionTemperatureCoefficient);
    else
        NewEfficiency = HJTInitialEfficiency*(1+(25-PanelTemperatue)*HJTIncreaseTemperatureCoefficient);
    end   
    ElectricityByPanels.ActualHJT(j) = NewEfficiency*ElectricityByPanels.Potential(j);
end
%% Mono PERC New Efficiency
ActualMonoPERC = zeros(height(ElectricityByPanels),1);
ElectricityByPanels = addvars(ElectricityByPanels,ActualMonoPERC, 'Before', 'Total Manufacturing');
for j = 1:(height(ElectricityByPanels))
    PanelTemperatue = ElectricityByPanels.AirTemperature(j) +  (ElectricityByPanels.GNI(j)/(u0+u1*ElectricityByPanels.WindSpeed(j)));
    if PanelTemperatue > 25
        NewEfficiency = MonoPERCInitialEfficiency*(1-(PanelTemperatue-25)*MonoPERCReductionTemperatureCoefficient);
    else
        NewEfficiency = MonoPERCInitialEfficiency*(1+(25-PanelTemperatue)*MonoPERCIncreaseTemperatureCoefficient);
    end   
    ElectricityByPanels.ActualMonoPERC(j) = NewEfficiency*ElectricityByPanels.Potential(j);
end

%% difference in electricity manufacture
Percent17 = HourlyData{:,7}*0.17;
HourlyData = addvars(HourlyData,Percent17);
Percent25 = HourlyData{:,7}*0.25;
HourlyData = addvars(HourlyData,Percent25);
Percent30 = HourlyData{:,7}*0.30;
HourlyData = addvars(HourlyData,Percent30);
Percent50 = HourlyData{:,7}*0.50;
HourlyData = addvars(HourlyData,Percent50);
Percent80 = HourlyData{:,7}*0.80;
HourlyData = addvars(HourlyData,Percent80);
Percent100 = HourlyData{:,7};
HourlyData = addvars(HourlyData,Percent100);
group = ["Percent17" "Percent25" "Percent30" "Percent50" "Percent80" "Percent100"];

for i = 1:3:12
    figure;
    t = tiledlayout(2,3);
    title(t, sprintf('Manufacture and Potential - %s', MonthNames(i)), 'FontSize', 24);
    ylabel(t, 'Manufacturing (MwH)', 'FontSize', 20);
    xlabel(t, 'Hours of Day', 'FontSize', 20);
    for member = group
        nexttile
        idx = (HourlyData.Month == i);
        temp = HourlyData(idx,:);
        PanelData = ElectricityByPanels(idx,:);
        g = findgroups(temp.TimeStrings);
        y1 = splitapply(@mean,temp.(member),g);
        y2 = splitapply(@mean,PanelData.('ActualBIC'),g);
        x = [0:1:23];
        plot(x,y1,x,y2, 'LineWidth', 2);
        title(member, 'FontSize', 14);
        
        legend(member, 'BIC Potential', 'FontSize', 12);
    end
end
%% difference in energy - lab conditions

for i = 1:12
figure
idx = (HourlyData.Month == i);
temp = HourlyData(idx,:);
PanelData = ElectricityByPanels(idx,:);
g = findgroups(temp.TimeStrings);
y2 = splitapply(@mean, PanelData.('BICDiff'),g);
y3 = splitapply(@mean, PanelData.('HJTDiff'),g);
y4 = splitapply(@mean, PanelData.('MonoPERCDiff'),g);
x = [0:1:23];
plot(x,y2,x,y3,x,y4, 'LineWidth', 2);
title(sprintf('Difference Bewtween Solar Potential and Total Manufacturing (Lab Conditions) - %s',MonthNames(i)), 'FontSize', 24);
ylabel('Difference (MwH)', 'FontSize', 20);
xlabel('Hours of Day', 'FontSize', 20);
legend('BIC Potential','HJT Potential','Mono PERC Potential','FontSize',12);
end



%% total manufacturing and GHI
for i = 1:12
 figure
idx = (HourlyData.Month == i);
y1 = HourlyData(idx,:);
g = findgroups(y1.TimeStrings);
y1 = splitapply(@mean, y1.('Total Manufacturing (MwH)'),g);
x = [0:1:23];
yyaxis left
plot(x,y1, 'LineWidth', 2);
title(sprintf('Solar Irradiation and Electricity Manufacturing - %s',MonthNames(i)), 'FontSize', 24);
ylabel('Electricity Manufacturing (MwH)', 'FontSize', 20);
xlabel('Hours of Day', 'FontSize', 20);
y2 = HourlyData(idx,:);
g2 = findgroups(y2.TimeStrings);
y2 = splitapply(@mean, y2.('GHI (Wh/m^2)'),g2);
yyaxis right
plot(x,y2, 'LineWidth', 2);
ylabel('GHI (Wh/m^2)', 'FontSize', 20) 
legend('Electricity Manufacturing', 'Global Horizontal Irradiation (Wh/m^2)','FontSize',12);
end
%% Absolut manufacturing from renewable energies
for i = 1:12
 figure
idx = (HourlyData.Month == i);
y1 = HourlyData(idx,:);
g = findgroups(y1.TimeStrings);
y1 = splitapply(@mean, y1.('Renewable (MwH)'),g);
x = [0:1:23];
plot(x,y1, 'LineWidth', 2);
title(sprintf('Electricity Manufacturing From Renewable Energies - %s',MonthNames(i)), 'FontSize', 24);
ylabel('Electricity Manufacturing (MwH)', 'FontSize', 20);
xlabel('Hours of Day', 'FontSize', 20);
end
%% percentage of total manufacturing from renewable
SolarManufacturingPercantage = HourlyData{:,10}./HourlyData{:,7};
HourlyData = addvars(HourlyData,SolarManufacturingPercantage, 'Before', 'GHI (Wh/m^2)');
%% percentage of total manufacturing from renewable - graphs
for i = 1:12
 figure
idx = (HourlyData.Month == i);
y1 = HourlyData(idx,:);
g = findgroups(y1.TimeStrings);
y1 = splitapply(@mean, y1.('SolarManufacturingPercantage'),g);
x = [0:1:23];
plot(x,y1.*100, 'LineWidth', 2);
title(sprintf('Percentage of Renewable Energies-%s',MonthNames(i)), 'FontSize', 24);
ylabel('Percentage of Renewable Electricity', 'FontSize', 20);
xlabel('Hours of Day', 'FontSize', 20);
end
%% Panel Energy Potential - lab conditions
for i = 1:12
 figure
idx = (HourlyData.Month == i);
temp = HourlyData(idx,:);
PanelData = ElectricityByPanels(idx,:);
g = findgroups(temp.TimeStrings);
y1 = splitapply(@mean, PanelData.('TotalRenewable'),g);
y2 = splitapply(@mean, PanelData.('BIC - Lab'),g);
y3 = splitapply(@mean, PanelData.('HJT - Lab'),g);
y4 = splitapply(@mean, PanelData.('Mono PERC - Lab'),g);
x = [0:1:23];
plot(x,y1,x,y2,x,y3,x,y4, 'LineWidth', 2);
title(sprintf('Solar Energy Potential (Lab Conditions) - %s',MonthNames(i)), 'FontSize', 24);
ylabel('Manufacturing (MwH)', 'FontSize', 20);
xlabel('Hours of Day', 'FontSize', 20);
legend('Actual', 'BIC Potential','HJT Potential','Mono PERC Potential','FontSize',12);
end
%% Difference Between Lab Conditions and Actual
Lab = ["BIC - Lab" "HJT - Lab" "Mono PERC - Lab"];
Actual = ["ActualBIC" "ActualHJT" "ActualMonoPERC"];
for i = 1:3:12
    for j = 1:3
        figure
        idx = (HourlyData.Month == i);
        temp = HourlyData(idx,:);
        PanelData = ElectricityByPanels(idx,:);
        g = findgroups(temp.TimeStrings);
        y1 = splitapply(@mean,PanelData.(Lab(j)),g);
        y2 = splitapply(@mean,PanelData.(Actual(j)),g);
        x = [0:1:23];
        plot(x,y1,x,y2, 'LineWidth', 2);
        title(sprintf(strcat(Actual(j),' - Lab and Actual Conditions - %s'),MonthNames(i)), 'FontSize', 24);
        ylabel('Manufacturing (MwH)', 'FontSize', 20);
        xlabel('Hours of Day', 'FontSize', 20);
        legend('Lab Conditions', 'Actual Conditions', 'FontSize',12);
    end
end
%% 
for i = 1:3:12
    figure;
    t = tiledlayout(2,1);
    idx = (HourlyData.Month == i);
    temp = HourlyData(idx,:);
    PanelData = ElectricityByPanels(idx,:);
    g = findgroups(temp.TimeStrings);
    y1 = splitapply(@mean,PanelData.('BIC - Lab'),g);
    y2 = splitapply(@mean,temp.('Percent100'),g);
    x = [0:1:23];
    nexttile;
    scatter(x,y1, 'filled');
    title(sprintf('BIC Potential - %s',MonthNames(i)), 'FontSize', 24);
    ylabel('Manufacturing (MwH)', 'FontSize', 20);
    xlabel('Hours of Day', 'FontSize', 20);
    nexttile;
    scatter(x,y2, 'filled');
    title(sprintf('Total Manufacturing - %s',MonthNames(i)), 'FontSize', 24);
    ylabel('Manufacturing (MwH)', 'FontSize', 20);
    xlabel('Hours of Day', 'FontSize', 20);
end
%%
for i = 1:3:12
    figure;
    t = tiledlayout(2,1);
    idx = (HourlyData.Month == i);
    temp = HourlyData(idx,:);
    PanelData = ElectricityByPanels(idx,:);
    g = findgroups(temp.TimeStrings);
    y1 = splitapply(@mean,PanelData.('BIC - Lab'),g);
    y2 = splitapply(@mean,temp.('Percent100'),g);
    x = [0:1:23];
    nexttile;
    bar(x,y1);
    title(sprintf('BIC Potential - %s',MonthNames(i)), 'FontSize', 24);
    ylabel('Manufacturing (MwH)', 'FontSize', 20);
    xlabel('Hours of Day', 'FontSize', 20);
    nexttile;
    bar(x,y2);
    title(sprintf('Total Manufacturing - %s',MonthNames(i)), 'FontSize', 24);
    ylabel('Manufacturing (MwH)', 'FontSize', 20);
    xlabel('Hours of Day', 'FontSize', 20);
 end

%% 
for i = 1:12
figure
idx = (HourlyData.Month == i);
temp = HourlyData(idx,:);
g = findgroups(temp.TimeStrings);
y1 = splitapply(@mean,temp.TotalRenewableDiff,g);
x = [0:1:23];
plot(x,y1, 'LineWidth', 2);
title(sprintf('Difference Bewteen Total and Renewable - %s',MonthNames(i)), 'FontSize', 24);
ylabel('Difference (MwH)', 'FontSize', 20);
xlabel('Hours of Day', 'FontSize', 20);
end

%% 
for i = 1:12
figure
idx = (HourlyData.Month == i);
temp = HourlyData(idx,:);
g = findgroups(temp.TimeStrings);
y1 = splitapply(@mean,temp.('Total Manufacturing (MwH)'),g);
y2 = splitapply(@mean,temp.('Renewable (MwH)'),g);
x = [0:1:23];
plot(x,y1,x,y2, 'LineWidth', 2);
title(sprintf('Total and Renewable Electricity Manufacturing - %s',MonthNames(i)), 'FontSize', 24);
ylabel('Manufacturing (MwH)', 'FontSize', 20);
xlabel('Hours of Day', 'FontSize', 20);
legend('Total', 'Renewable', 'FontSize',12);
end

%% 
AccumaltedDailyManufacturing = zeros(height(HourlyData),1);
AccumaltionBICPotential = zeros(height(HourlyData),1);
start = 1;
finish = 1;
for i = 0:(floor(height(HourlyData)/24) - 1)
    while(mod(finish,24) ~= 0)
        finish = finish + 1;
    end
    sum1 = cumsum(HourlyData{start:finish, 7});
    sum2 = cumsum(ElectricityByPanels{start:finish, 12});
    AccumaltedDailyManufacturing(start:finish) = sum1;
    AccumaltionBICPotential(start:finish) = sum2;
    start = finish+1;
    finish = finish+1;
end    
HourlyData = addvars(HourlyData,AccumaltedDailyManufacturing, 'Before', 'Coal (MwH)');
ElectricityByPanels = addvars(ElectricityByPanels,AccumaltionBICPotential, 'Before', 'ActualHJT');
%% Monthly Accumalation Average - notice the decenber 31st was not calculated, and can divert the monthly average of december
MonthlyAccumaltionAverage = zeros(12,2);
idx = (HourlyData.('TimeStrings') == "23:00:00");
temp = HourlyData(idx,:);
g = findgroups(temp.Month);
MonthlyAccumaltionAverage(:,1) = splitapply(@mean,temp.('AccumaltedDailyManufacturing'),g);

temp2 = ElectricityByPanels(idx,:);
g2 = findgroups(temp2.MonthNumber);
MonthlyAccumaltionAverage(:,2) = splitapply(@mean,temp2.('AccumaltionBICPotential'),g);

x = categorical(MonthNames);
y = (MonthlyAccumaltionAverage);
bar(x,y);
title('Monthly Accumalation And Solar Potential' ,'FontSize', 24);
xlabel('Months', 'FontSize', 20);
ylabel('Mwh', 'FontSize', 20);
legend('Total Manufacturing', 'Potential', 'FontSize', 12);

%% Weekly average - january
Januay = (HourlyData.('Month') == 1);
Januay = HourlyData(Januay,:);


%% 

SAM
