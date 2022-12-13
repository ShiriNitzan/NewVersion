function [CurrentYearAreaForFood] = CalcAreaForFoodConsumption(FoodConsumption,AreaCoefficients)
    CurrentYearAreaForFood = array2table(zeros(height(FoodConsumption)+1,2));
    CurrentYearAreaForFood.Properties.VariableNames = {'Local', 'Global'};
    RowNames =  FoodConsumption.Properties.RowNames;
    RowNames{end+1} = 'Total';
    CurrentYearAreaForFood.Properties.RowNames = RowNames;
    for i = 1:height(FoodConsumption)
        CurrentYearAreaForFood{i,1} =  sum(FoodConsumption{i,1:2})*AreaCoefficients{i,1};
        CurrentYearAreaForFood{i,2} =  sum(FoodConsumption{i,3:4})*AreaCoefficients{i,2};
    end
    CurrentYearAreaForFood{height(CurrentYearAreaForFood), 1} = sum(CurrentYearAreaForFood{1:height(CurrentYearAreaForFood)-1,1});
    CurrentYearAreaForFood{height(CurrentYearAreaForFood), 2} = sum(CurrentYearAreaForFood{1:height(CurrentYearAreaForFood)-1,2});
end
    