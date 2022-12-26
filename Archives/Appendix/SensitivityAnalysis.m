%% CO2E all sectors - currently only the sum because the materials are significantly higher than rest of the sectors
percentages = zeros(1,4);
percentages(2) = ((sum(EmissionsBySectorsS1{1,:}) - CO2EFor2014)/CO2EFor2014)*100;
percentages(3) = ((sum(EmissionsBySectorsS2{1,:}) - CO2EFor2014)/CO2EFor2014)*100;
percentages(4) = ((sum(EmissionsBySectorsS3{1,:}) - CO2EFor2014)/CO2EFor2014)*100;

fig = figure;
left_color = [0 0 1];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);
x = 1:1:4;
y = [CO2EFor2014; sum(EmissionsBySectorsS1{1,:});sum(EmissionsBySectorsS2{1,:});sum(EmissionsBySectorsS3{1,:})];
b = bar(x, y, 0.5);
set(gca,'xticklabel',{'Current State', 'S1','S2','S3'});
title('CO2E For All Sectors - 2030',  'FontSize', 24);
xlabel('Scenarios', 'FontSize', 18) ;
ylabel('CO2E - Kilotons', 'FontSize', 18);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = append(string(round(b(1).YData/(10^3),0)), " kt");
text(xtips1,ytips1,labels1,'HorizontalAlignment','right','VerticalAlignment','bottom', 'FontSize', 14);
ax = gca;
ax.YAxis.Exponent = 3;
hold on
yyaxis right
y2 = percentages;
plot(x, y2, 'LineWidth', 4, 'Color', [0.123 0.104 0.238]);
ylabel('Percents')
hold off

%% delta 2017-2030 - only S2
ScenariosNames = {'Growth in Population', 'Electricity Saving Scenario', 'Increase in Diselinated Water', 'Reducing Beef Consumption', '5', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};
Co2eS2 = SensitivityAnalysisTableOnlyOneStepS2;
Co2eS2{7,:} = zeros(1,4);
Co2eS2(ismember(Co2eS2.('CO2Equivalent'),0),:)=[];

Co2eS2 = sortrows(Co2eS2,'CO2Equivalent', 'descend');
CO2EFor2014 = sum(EmissionsByYears{1,1}{1}{1,:}) + EmissionsByYears{2,1}{1}{8,9}+sum(EmissionsByYears{3,1}{1}{:,7})+sum(EmissionsByYears{4,1}{1}{:,16}) + sum(EmissionsByYears{5,1}{1}{:,12})  + sum(EmissionsByYears{6,1}{1}{:,7})+sum(EmissionsByYears{7,1}{1}{:,2}) + sum(EmissionsByYears{8,1}{1}{:,3}) + sum(EmissionsByYears{9,1}{1}{2,:}) + sum(EmissionsByYears{9,1}{1}{6,:}) + sum(EmissionsByYears{9,1}{1}{10,:});

sums = zeros(1, height(Co2eS2));
temp = 0;
for i = 1:height(Co2eS2)
    temp = temp + Co2eS2{i, 1};
    sums(i) = temp;
end

percentages =  zeros(1, height(Co2eS2));
percent = 0;
temp = 0;
for i = 1:height(Co2eS2)
    percent = (Co2eS2{i,1}/CO2EFor2014)*100;
    temp = temp + percent;
    percentages(i) = temp;
end    

fig = figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);

x = categorical(Co2eS2.Properties.RowNames).';
x = reordercats(x, Co2eS2.Properties.RowNames);
y = (Co2eS2{:, 1}).';
b = bar(x, y, 0.4, 'FaceColor', [0.8500, 0.3250, 0.0980]);
title('Changes in CO2E Emissions - After Considering Population Growth and Chnages in Consumption Habits',  'FontSize', 28);
xlabel('Scenarios', 'FontSize', 20);
ylabel('CO2E -Kilotons', 'FontSize', 20);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',16)
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = append(string(round(b(1).YData/(10^3),0)), " kt");
text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','top', 'FontSize', 14);
ax = gca;
ax.YAxis.Exponent = 3;
hold on

y2 = sums;
plot(x, y2, 'LineWidth', 4, 'Color', [0.123 0.104 0.238]);

yyaxis right
ylabel('Percents')
y3 = percentages;
plot(x, y3, 'LineWidth', 4, 'Color', [0.255 0.127 0.80])


legend('Emissions', 'Sum', 'Percentage')
hold off