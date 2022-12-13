function [CurrentYearWaterForFood] = CalcWaterForFoodConsumption(Data, FoodQuantityConsumption)
%% Read Files
    
    WaterConsumptionCoefficientsLocal = Data.WaterConsumptionCoefficientsLocal;
    WaterConsumptionCoefficientsGlobal = Data.WaterConsumptionCoefficientsGlobal;
    
    LocalWaterConsumptionForHumansFood = FoodQuantityConsumption{:,1};
    LocalWaterConsumptionForAnimalsFood = FoodQuantityConsumption{:,2};
    GlobalWaterConsumptionForHumansFood = FoodQuantityConsumption{:,3};
    GlobalWaterConsumptionForAnimalsFood = FoodQuantityConsumption{:,4};
    
    ModeledProducts = height(FoodQuantityConsumption);
     
    %% Calculate Local Water
    
    LocalWaterForHumans = zeros(ModeledProducts,1);
    LocalWaterForAnimals = zeros(ModeledProducts,1);    
    TotalLocalWaterForHumans = 0;
    TotalLocalWaterForAnimals = 0;
    for i = 1:ModeledProducts
        LocalWaterForHumans(i) = LocalWaterConsumptionForHumansFood(i)*WaterConsumptionCoefficientsLocal(i);
        TotalLocalWaterForHumans = TotalLocalWaterForHumans+LocalWaterForHumans(i);
        LocalWaterForAnimals(i) = LocalWaterConsumptionForAnimalsFood(i)*WaterConsumptionCoefficientsLocal(i);
        TotalLocalWaterForAnimals = TotalLocalWaterForAnimals+LocalWaterForAnimals(i);
    end 
    
    %% Calculate Global Water Production
    
    GlobalWaterForHumans = zeros(ModeledProducts,1);
    GlobalWaterForAnimals = zeros(ModeledProducts,1);
    TotalGlobalWaterForHumans = 0;
    TotalGlobalWaterForAnimals = 0;
    for i = 1:ModeledProducts
        GlobalWaterForHumans(i) = GlobalWaterConsumptionForHumansFood(i)*WaterConsumptionCoefficientsGlobal(i);
        TotalGlobalWaterForHumans = TotalGlobalWaterForHumans+GlobalWaterForHumans(i);
        GlobalWaterForAnimals(i) = GlobalWaterConsumptionForAnimalsFood(i)*WaterConsumptionCoefficientsGlobal(i);
        TotalGlobalWaterForAnimals = TotalGlobalWaterForAnimals+GlobalWaterForAnimals(i);
    end
    
    %% Create Final Table
    
    CurrentYearWaterForFood = zeros(1,4);
    CurrentYearWaterForFood = array2table(CurrentYearWaterForFood);
    CurrentYearWaterForFood.Properties.VariableNames = {'Local Water For Humans','Local Water For Animals', 'Global Water For Humans', 'Global Water For Animals'};
    CurrentYearWaterForFood{1,1} = TotalLocalWaterForHumans;
    CurrentYearWaterForFood{1,2} = TotalLocalWaterForAnimals;
    CurrentYearWaterForFood{1,3}= TotalGlobalWaterForHumans;
    CurrentYearWaterForFood{1,4} = TotalGlobalWaterForAnimals;
