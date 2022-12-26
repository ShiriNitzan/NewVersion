%%
[OtherGlobalLocal, OtherTotalGlobalLocal] = CalcGlobalLocal(EmissionsByYearsOther);
OtherUpDownStream = CalcUpDownStream(EmissionsByYearsOther);
OtherEmissionsBySectors = TotalEmissionsBySectors(EmissionsByYearsOther);

[OtherGlobalLocalNoElectric, OtherTotalGlobalLocalNoElectric] = CalcGlobalLocal(EmissionsByYearsOtherNoElectric);
OtherUpDownStreamNoElectric = CalcUpDownStream(EmissionsByYearsOtherNoElectric);
OtherEmissionsBySectorsNoElectric = TotalEmissionsBySectors(EmissionsByYearsOtherNoElectric);

x = categorical(EmissionsByYearsOther.Properties.VariableNames);
y = ElectricityConsumptionTable{"Transportation",:}/1000000;
bar(x, y, 0.4, 'FaceColor', [0 0.4470 0.7410]);
title('Electricity Consumption in Transportation',  'FontSize', 20);
xlabel('Years', 'FontSize', 14);
ylabel('GwH', 'FontSize', 14);

%% Emissions Difference - transportation only
EmissionsDiff = zeros(1, Years);
for i = 1:Years
    EmissionsDiff(i) = OtherGlobalLocal{"Global",i}{1,2} + OtherGlobalLocal{"Local",i}{1,2} - OtherGlobalLocalNoElectric{"Global",i}{1,2} - OtherGlobalLocalNoElectric{"Local",i}{1,2};
end

x = categorical(EmissionsByYearsOther.Properties.VariableNames);
y = EmissionsDiff;
bar(x, y, 0.4, 'FaceColor', [0 0.4470 0.7410]);
title('Emissions Difference - After 30% Electric Vehicels',  'FontSize', 20);
xlabel('Years', 'FontSize', 14);
ylabel('MtCO2eq', 'FontSize', 14);

%% Sesitivity Analysis - population growth chnages, renewable 30%, electricity per capita 15%

y3 = table2array(TotalEmissionsBySectors(SensitivityAnalysisCell{1,9}));
y3(5,:) = [];
y4 = table2array(TotalEmissionsBySectors(SensitivityAnalysisCell{1,21}));
y4(5,:) = [];
y5 = table2array(TotalEmissionsBySectors(SensitivityAnalysisCell{1,33}));
y5(5,:) = [];
y6 = table2array(TotalEmissionsBySectors(SensitivityAnalysisCell{1,45}));
y6(5,:) = [];

t = tiledlayout(2,2);
nexttile
b1 = bar(x, y3, 0.4, 'stacked');
set(gca,'XTickLabel',a,'fontsize',14)
title('Yearly CO2E Emissions By Sectors - 5% Population Growth',  'FontSize', 20);
xlabel('Years', 'FontSize', 14);
ylabel('MtCO2eqs', 'FontSize', 14);

nexttile
bar(x, y4, 0.4, 'stacked');
title('Yearly CO2E Emissions By Sectors - 10% Population Growth',  'FontSize', 20);
xlabel('Years', 'FontSize', 14);
ylabel('MtCO2eqs', 'FontSize', 14);


nexttile
bar(x, y5, 0.4, 'stacked');
title('Yearly CO2E Emissions By Sectors - 15% Population Growth',  'FontSize', 20);
xlabel('Years', 'FontSize', 14);
ylabel('MtCO2eqs', 'FontSize', 14);

nexttile
bar(x, y6, 0.4, 'stacked');
title('Yearly CO2E Emissions By Sectors - 20% Population Growth',  'FontSize', 20);
xlabel('Years', 'FontSize', 14);
ylabel('MtCO2eqs', 'FontSize', 14);

LegendLabels = {'Electricity', 'Transporatation', 'Construction', 'Water', 'Food'};
legend(flip(b1), flip(LegendLabels), 'FontSize',12,'Location','northwest')

%% 3d graphs
for i = 1:48
    SensitivityAnalysisCell{2,i} = [];
    SensitivityAnalysisCell{2,i} = TotalEmissionsBySectors(SensitivityAnalysisCell{1,i});
end

x = linspace(30,100,8);
y = linspace(5, 15, 3);
z = zeros(3,8);
ScenariosAndValues{1,5} =  0.05;
k = 1;
for i = 1:3
    for j = 1:8
        ScenariosAndValues{2,5} =  y(i)/100;
        ScenariosAndValues{6,5} =  x(j)/100;
        ScenariosTable = AllButOneChangesByScenarios(DataBase, 0, Years, ScenariosAndValues{:,5});
        [EmissionsTable, ConsumptioTable] = FullScenario(DataBase, ScenariosTable, Years);
        SensitivityAnalysisCell{1,k} = EmissionsTable;
        Total = TotalEmissionsBySectors(SensitivityAnalysisCell{1,k});
        k = k+1;
        z(i, j) = sum(Total{:, 14});
    end
end
%% 

surf(z,'Marker','s',...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor','g')
title('Sensitivity Analysis - 5% Population Growth',  'FontSize', 20);
xlabel('Electricity From Renewable Sources (%)', 'FontSize', 14);
ylabel('Change in Electricity Per Capita (%)', 'FontSize', 14);
zlabel('MtCO2eqs', 'FontSize', 14);




%%
surf(z,'Marker','s',...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor','g')
title('Sensitivity Analysis - 5% Population Growth',  'FontSize', 20);
xlabel('Electricity From Renewable Sources (%)', 'FontSize', 14);
ylabel('Change in Electricity Per Capita (%)', 'FontSize', 14);
zlabel('MtCO2eqs', 'FontSize', 14);
xticklabels({'10','20','30','40','50','60','70', '80', '90', '100'})
yticklabels({'5','10','15','20'})
%%
[X, Y] = meshgrid(x, y);
surf(X,Y,z);
title('Sensitivity Analysis - 5% Population Growth',  'FontSize', 20);
xlabel('Electricity From Renewable Sources (%)', 'FontSize', 14);
ylabel('Change in Electricity Per Capita (%)', 'FontSize', 14);
zlabel('MtCO2eqs', 'FontSize', 14);
colorbar

%% functions
function z = FixedPopulationGrowth(Scenarios, SensitivityAnalysisCell)
x = linspace(30,100,8);
y = linspace(5, 15, 3);
z = zeros(3,8);
Scenarios{1,5} =  0.05;
for i = 1:3
    for j = 1:8
        ScenariosAndValues{2,5} =  y(i)/100;
        ScenariosAndValues{6,5} =  x(j)/100;
        ScenariosTable = AllButOneChangesByScenarios(DataBase, 0, Years, Scenarios{:,5});
        [EmissionsTable, ConsumptioTable] = FullScenario(DataBase, ScenariosTable, Years);
        Total = TotalEmissionsBySectors(SensitivityAnalysisCell{1,i});
        z(i, j) = sum(Total{:, 14});
    end
end
end
