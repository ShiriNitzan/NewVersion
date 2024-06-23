function [population] = populationCal(PrecentegeByTheYears)
%% population data
population  = array2table(zeros(4,34));
RowNames = {'Num','Years', 'Israel population', 'Palestinian Authority population'};
population.Properties.RowNames = RowNames;

for i =1:width(PrecentegeByTheYears)
    population(1,i) = {i};
    population(2,i) = {i+2016};
    population(3,i) = {8.8*PrecentegeByTheYears{1,i}};
    if PrecentegeByTheYears{1,i} == 1
        population(4,i) = {4.455};
    else
        population(4,i) = {4.455*1.0223^(i-1)};
    end

end
