addpath("Israel Research")
ElectricityManufacturingData = readtable("Files_Netunei_hashmal_doch_reshut_hasmal_2020_data_n.xlsx",'Sheet', '10.2 תחזיות צריכת חשמל', 'Range','A3:J24', 'ReadVariableNames', true);

%% Population growth - raw data model

%raw data

PopulationRawData = ElectricityManufacturingData{:,1:2};
PopulationRawData = array2table(PopulationRawData);
PopulationRawData.Properties.VariableNames = {'Years', 'Population (Millions)'};
PopulationGrowthRate = (PopulationRawData{2:end,2}./PopulationRawData{1:end-1,2}-1)*100;
figure
plot(PopulationRawData{2:end,1},PopulationGrowthRate,'LineWidth',2);
title('Population Growth',  'FontSize', 24);
xlabel('Years', 'FontSize', 18) ;
ylabel('Growth Rate (Percentages)', 'FontSize', 18);
figure
plot(PopulationRawData{:,1}, PopulationRawData{:,2}, 'x', 'Color', 'r', 'linewidth', 2);
title('Population',  'FontSize', 24);
xlabel('Years', 'FontSize', 18) ;
ylabel('Population (Millions)', 'FontSize', 18);

%% electricity manufacturing

ElectricityRawData = ElectricityManufacturingData{:,{'Year','ElectricityManufacturing_TwH_'}};
ElectricityRawData = array2table(ElectricityRawData);
ElectricityRawData.Properties.VariableNames = {'Year', 'Electricity Manufacturing (TwH)'};

figure
plot(ElectricityRawData{:,1}, ElectricityRawData{:,2}, 'linewidth', 2);
title('Electricity Manufacturing',  'FontSize', 24);
xlabel('Years', 'FontSize', 18) ;
ylabel('Electricity Manufacturing (TwH)', 'FontSize', 18);
%% electricity per capita
x2 = ElectricityManufacturingData{:,1};
ElectriciyPerCapita1 = ElectricityManufacturingData{:,6};

plot(x2, ElectriciyPerCapita1, 'LineWidth',2, 'Color', 'k');
title('Electricty Per Capita',  'FontSize', 24);
xlabel('Years', 'FontSize', 18) ;
ylabel('MwH Per Capita', 'FontSize', 18);

%% find rate that minimizes mse - from 1.8 to 2.2 in 0.01 intervals

Rates = 1.8:0.01:2.2;
Preds = zeros(21, length(Rates));
Preds = array2table(Preds);
Preds.Properties.VariableNames = string(Rates);
for rate = 1:width(Rates)
    for i = 1:height(Preds)
        Preds{i,rate} = PopulationRawData{1,2}*((1+(Rates(rate)/100))^(i-1));
    end    
end

MSEArray = zeros(1, length(Rates));
for i = 1:length(MSEArray)
    MSEArray(i) = mse(PopulationRawData{:,2}, Preds{:,i});
end

plot(Rates, MSEArray, 'LineWidth', 2);
title('MSE',  'FontSize', 24);
xlabel('Rate Values', 'FontSize', 18) ;
ylabel('MSE', 'FontSize', 18);

%% 

plot(PopulationRawData{:,1}, PopulationRawData{:,2}, 'o', PopulationRawData{:,1}, Preds{:,13}, 'LineWidth',2);
title('Prediction and Raw Data',  'FontSize', 24);
xlabel('Year', 'FontSize', 18) ;
ylabel('Population(Millions)', 'FontSize', 18);
legend('Real Values', 'Predicted Values', 'FontSize', 14);

%% model extention to the year 2065 - assumption: growth rate 1.92%
CBSValues = readtable("01_17_138t1.xls", 'Range','A5:D122', 'ReadVariableNames', false);
CBSValues(1:1:52,:) = [];
PredictedValues = zeros(66,1);
Rate = 1.0192;
 for i = 1:66
        PredictedValues(i) = PopulationRawData{1,2}*((Rate)^(i-1));
 end
 %% 
 plot(CBSValues{:,1}, CBSValues{:,4},CBSValues{:,1},CBSValues{:,6},CBSValues{:,1},CBSValues{:,8},CBSValues{:,1},PredictedValues, 'LineWidth',2);
 legend('CBS-High', 'CBS-Medium', 'CBS-Low', 'Our Model', 'FontSize', 14)
title('Population Growth',  'FontSize', 24);
xlabel('Years', 'FontSize', 18) ;
ylabel('Population (Millions)', 'FontSize', 18);

%% CBS - population growth rates

plot(CBSValues{:,1}, CBSValues{:,3},CBSValues{:,1},CBSValues{:,5},CBSValues{:,1},CBSValues{:,7}, 'LineWidth',2);
yline(1.92, 'LineWidth',2);
legend('CBS - High', 'CBS - Medium', 'CBS - Low', 'Our Model', 'FontSize', 14);
title('Population Growth - CBS Comparison',  'FontSize', 24);
xlabel('Years', 'FontSize', 18) ;
ylabel('Growth Rate (Percantages)', 'FontSize', 18);

%% logistic transformation to the data
LogPop = log(PopulationRawData{:,2});
PopulationRawData = addvars(PopulationRawData, LogPop);
x = 1:1:21;
PopulationLogModel = fitlm(x', LogPop);
plot(PopulationRawData{:,1}, PopulationRawData{:,3}, 'o',PopulationRawData{:,1}, PopulationLogModel.Fitted ,'LineWidth',2);
title('Population Raw Data - Log',  'FontSize', 24);
xlabel('Year', 'FontSize', 18) ;
ylabel('Log(Population)', 'FontSize', 18);
figure
plot(PopulationLogModel.Residuals.Raw, 'o', 'linewidth',2);
yline(0, 'LineWidth', 2);
title('Model Residuals',  'FontSize', 24);
xlabel('Observations', 'FontSize', 18) ;
ylabel('Residuals', 'FontSize', 18);
aic = aicbic(PopulationLogModel.LogLikelihood, 1);

%% growth rate prediction model
RateRawData = array2table(zeros(12,2));
RateRawData.Properties.VariableNames = {'Year', 'Rate (Percentages)'};
RateRawData{:,1} = (2009:1:2020)';
RateRawData{:,2} = PopulationGrowthRate(9:20);
x = 1:1:12;
GrowthRateModel = fitlm(x, RateRawData{:,2});

plot(RateRawData{:,1} , RateRawData{:,2},'o',RateRawData{:,1},GrowthRateModel.Fitted,'LineWidth',2);
title('Growth Rate',  'FontSize', 24);
xlabel('Year', 'FontSize', 18) ;
ylabel('Growth Rate (Percents)', 'FontSize', 18);
GrowthRateModelAic = aicbic(GrowthRateModel.LogLikelihood, 1);

figure
plot(GrowthRateModel.Residuals.Raw, 'o', 'linewidth',2);
yline(0, 'LineWidth', 2);
title('Model Residuals',  'FontSize', 24);
xlabel('Observations', 'FontSize', 18) ;
ylabel('Residuals', 'FontSize', 18);

%% Predict Population
Xnew = (1:1:65)';
GrowthRatePred = predict(GrowthRateModel, Xnew);
PopulationPreds = zeros(66, 1);
PopulationPreds(1:21) = PopulationRawData{1:21,2};
CurrentPop = PopulationRawData{21,2};
for i = 22:length(PopulationPreds)
    NewPop = CurrentPop*(1+(GrowthRatePred(i-1)/100));
    PopulationPreds(i) = NewPop;
    CurrentPop = NewPop;
end

 plot(CBSValues{:,1}, CBSValues{:,4},CBSValues{:,1},CBSValues{:,6},CBSValues{:,1},CBSValues{:,8},CBSValues{:,1},PopulationPreds, 'LineWidth',2);
 legend('CBS-High', 'CBS-Medium', 'CBS-Low', 'Our Model', 'FontSize', 14)
title('Population Growth',  'FontSize', 24);
xlabel('Years', 'FontSize', 18) ;
ylabel('Population (Millions)', 'FontSize', 18);
%% Predict Electricity
x = 1:1:21;
logElectricity = log(ElectricityRawData{:,2});
ElectricityPredictionModel = fitlm(x, logElectricity);
plot(ElectricityRawData{:,1},log(ElectricityRawData{:,2}),'o',ElectricityRawData{:,1},ElectricityPredictionModel.Fitted, 'LineWidth',2);
legend('Raw Data','Fitted Model', 'FontSize', 14)
title('Electricity Manufacturing',  'FontSize', 24);
xlabel('Years', 'FontSize', 18) ;
ylabel('Electricity Manufacturing (TwH)', 'FontSize', 18);
ElectricityPredictionModelAic = aicbic(ElectricityPredictionModel.LogLikelihood, 2);

%% Model Residuals

figure
plot(ElectricityPredictionModel.Residuals.Raw, 'o', 'linewidth',2);
yline(0, 'LineWidth', 2);
title('Electriciy Manufacturing Model Residuals',  'FontSize', 24);
xlabel('Observations', 'FontSize', 18) ;
ylabel('Residuals', 'FontSize', 18);

%% Model Predictions
Xnew = (1:1:41)';
ElectricityManufacturingPred = predict(ElectricityPredictionModel, Xnew);
ElectricityAuthorityPrediction = zeros(41,1);
ElectricityAuthorityPrediction(1:21) = log(ElectricityRawData{:,2});
ElectricityAuthorityPrediction(22:41) = log(table2array(readtable("Files_Files_pirsumim_nilve_alut_tohelet.xlsx",'Sheet', 'הספק קיים ותחזית יצור', 'Range','C8:C27')));

%% 

plot(2000:1:2040,ElectricityManufacturingPred,2000:1:2040,ElectricityAuthorityPrediction, 'LineWidth',2);
legend('Our Model','Electricity Authority Predictions', 'FontSize', 14)
title('Electricity Manufacturing',  'FontSize', 24);
xlabel('Years', 'FontSize', 18) ;
ylabel('Electricity Manufacturing (TwH)', 'FontSize', 18);

%% Electricity Per Capita Model

ElectricityPerCaiptaData = array2table(ElectricityManufacturingData{:,{'Year','ElectricityPerCapita_Low_MwhPerCapita_'}});
ElectricityPerCaiptaData.Properties.VariableNames = {'Year', 'Electricity Per Capita (MwH)'};
x = 1:1:21;
ElectricityPerCapitaModel = fitlm(x, ElectricityPerCaiptaData{:,2});
plot(ElectricityPerCaiptaData{:,1}, ElectricityPerCaiptaData{:,2}, 'o',ElectricityPerCaiptaData{:,1}, ElectricityPerCapitaModel.Fitted, 'LineWidth',2);
legend('Raw Data','Fitted Model', 'FontSize', 14)
title('Electricity Per Capita',  'FontSize', 24);
xlabel('Years', 'FontSize', 18) ;
ylabel('Electricity Per Capita (MwH)', 'FontSize', 18);

%% 
AverageChange = (ElectricityManufacturingData{21,8}/ElectricityManufacturingData{1,8})^(1/height(ElectricityManufacturingData))-1;
ElectricityProductionPreds = zeros(41,1);
ElectricityProductionPreds(1:20) = ElectricityManufacturingData{1:20,5};
for i = 1:21
    ElectricityProductionPreds(i+20) = 73.9*(1.0192^(i-1))*((AverageChange+1)^(i-1));
end

plot(2000:1:2040, ElectricityProductionPreds, 2000:1:2040, ElectricityAuthorityPrediction, 'LineWidth', 2);
legend('Our Prediction','Electricity Authority Prediction', 'FontSize', 14)
title('Electricity Manufacturing',  'FontSize', 24);
xlabel('Years', 'FontSize', 18) ;
ylabel('Electricity Manufacturing (TwH)', 'FontSize', 18);

