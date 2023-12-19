TargetYear = 2050;
BaseYear = 2017;
ScenarioNumber = 19;
Years = TargetYear-BaseYear+1;
ScenariosAndValues = readtable("The Three Scenarios.xlsx",'Sheet','Scenarios','Range','A1:I20','ReadRowNames',true,'ReadVariableNames',true);
ReadValues;
TechnologicalImprovements;
RowNames = {'Population Growth', 'Increase In Electricity Per Capita', 'Increase in Desalinated Water', 'Reducing Beef Consumption', 'Preventing Food Loss', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', 'Reducing Mileage', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
AllButOneAnalysis = array2table(zeros(height(ScenariosAndValues),9));
AllButOneAnalysis.Properties.RowNames = RowNames;
AllButOneAnalysis.Properties.VariableNames = {'Emissions', 'Emissions - Global', 'Emissions - Local', 'Water', 'Water - Global', 'Water - Local', 'Area', 'Area - Global', 'Area - Local'};
OnlyOneAnalysis = array2table(zeros(height(ScenariosAndValues),9));
OnlyOneAnalysis.Properties.RowNames = RowNames;
OnlyOneAnalysis.Properties.VariableNames = {'Emissions', 'Emissions - Global', 'Emissions - Local', 'Water', 'Water - Global', 'Water - Local', 'Area', 'Area - Global', 'Area - Local'};

PopulationGrowth = {0, 0.45, 0.9};
ElectricityPerCapita = {0, 0.2, 0.41};
DesalinatedWater = {0,1.32,2.64};

%% population data
population  = array2table(zeros(4,34));
RowNames = {'Num','Years', 'Israel population', 'Palestinian Authority population'};
pop.Properties.RowNames = RowNames;

for i =1:34
    population(1,i) = {i};
    population(2,i) = {i+2016};
    population(3,i) = {8.8*1.0192^(i-1)};
    population(4,i) = {4.455*1.0223^(i-1)};

end

%%
beep;