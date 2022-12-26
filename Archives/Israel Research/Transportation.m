transportationRawData = table2array(readtable("cbsTransport.xlsx", 'Range','B2:B22'));
growth=(transportationRawData(2:end)./transportationRawData(1:end-1)-1)*100;

avg = 1+(mean(growth(1:end-1))/100);

x = 2000:1:2019;
x2 = 2000:1:2020;
pred = zeros(1,21);
for i = 1:21
    pred(i) = transportationRawData(1)*(avg^(i-1));
end
TransportPredictionModel = fitlm(x2, log(transportationRawData));
plot(x,log(transportationRawData(1:end-1)), x, TransportPredictionModel.Fitted(1:end-1), 'LineWidth',2);
legend('Raw Data','Fitted Model', 'FontSize', 14)
title('Transportation',  'FontSize', 24);
xlabel('Years', 'FontSize', 18) ;
ylabel('Log-Km travelled (Millions of KM)', 'FontSize', 18);