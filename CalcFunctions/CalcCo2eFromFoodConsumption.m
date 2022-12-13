function [CurrentYearEmissionsFromFood] = CalcCo2eFromFoodConsumption(Data, FoodQuantityConsumption, WasteAmounts)
%% Read Files
    
    EmissionCoefficients = Data.FoodEmissionCoefficients;
    
    LocalFoodConsumptionForHumans = FoodQuantityConsumption{:,1};
    LocalFoodConsumptionForAnimals = FoodQuantityConsumption{:,2};
    GlobalFoodConsumptionForHumans = FoodQuantityConsumption{:,3};
    GlobalFoodConsumptionForAnimals = FoodQuantityConsumption{:,4};
    
    ModeledProducts = height(FoodQuantityConsumption);
     
%% Calculate Local Emissions From Food Production
    
    LocalEmissionsFromHumansFood = zeros(ModeledProducts,1);
    LocalEmissionsFromAnimalsFood = zeros(ModeledProducts,1);
    TotalLocalEmissionsFromHumansFood = 0;
    TotalLocalEmissionsFromAnimalsFood = 0;
    for i = 1:ModeledProducts
        LocalEmissionsFromHumansFood(i) = LocalFoodConsumptionForHumans(i)*EmissionCoefficients(i,1);
        TotalLocalEmissionsFromHumansFood = TotalLocalEmissionsFromHumansFood+LocalEmissionsFromHumansFood(i);
        LocalEmissionsFromAnimalsFood(i) = LocalFoodConsumptionForAnimals(i)*EmissionCoefficients(i,1);
        TotalLocalEmissionsFromAnimalsFood = TotalLocalEmissionsFromAnimalsFood+LocalEmissionsFromAnimalsFood(i);
    end
    
    
%% Calculate Global Emissions From Food Production
    
    GlobalEmissionsFromHumansFood = zeros(ModeledProducts,1);
    GlobalEmissionsFromAnimalsFood = zeros(ModeledProducts,1);
    TotalGlobalEmissionsFromHumansFood = 0;
    TotalGlobalEmissionsFromAnimalsFood = 0;
    for i = 1:ModeledProducts
        GlobalEmissionsFromHumansFood(i) = GlobalFoodConsumptionForHumans(i)*EmissionCoefficients(i,2);
        TotalGlobalEmissionsFromHumansFood = TotalGlobalEmissionsFromHumansFood+GlobalEmissionsFromHumansFood(i);
        GlobalEmissionsFromAnimalsFood(i) = GlobalFoodConsumptionForAnimals(i)*EmissionCoefficients(i,2);
        TotalGlobalEmissionsFromAnimalsFood = TotalGlobalEmissionsFromAnimalsFood+GlobalEmissionsFromAnimalsFood(i);
    end

%% EmissionsFromFood 
BurriedOrganicWaste = sum(WasteAmounts{:,1})*Data.OrganicWasteCoefficients;
    
%% Create Final Table
    
    CurrentYearEmissionsFromFood = zeros(1,5);
    CurrentYearEmissionsFromFood = array2table(CurrentYearEmissionsFromFood);
    CurrentYearEmissionsFromFood.Properties.VariableNames = {'LocalEmissionsFromHumansFood','LocalEmissionsFromAnimalsFood', 'GlobalEmissionsFromHumansFood', 'GlobalEmissionsFromAnimalsFood', 'OrganicWasteEmissioins'};
    CurrentYearEmissionsFromFood{1,1} = TotalLocalEmissionsFromHumansFood;
    CurrentYearEmissionsFromFood{1,2} = TotalLocalEmissionsFromAnimalsFood;
    CurrentYearEmissionsFromFood{1,3} = TotalGlobalEmissionsFromHumansFood;
    CurrentYearEmissionsFromFood{1,4} = TotalGlobalEmissionsFromAnimalsFood;
    CurrentYearEmissionsFromFood{1,5} = BurriedOrganicWaste*28;
