%% Read Files

    global Data
    Data = "Data.xlsx";
    
    global TradeBalance
    TradeBalance = readtable(Data,'Sheet','Materials','Range','C3:F22','ReadVariableNames',false);
    TradeBalance =table2array(TradeBalance);
    
    Export = TradeBalance(:,1);
    ExportTradeValue = TradeBalance(:,2);
    Import = TradeBalance(:,3);
    ImportTradeValue = TradeBalance(:,4);
    
    ModeledProducts = height(TradeBalance);
    
 %% Waste & Recycling From Local Authorities
 
    TotalExport =