function [Costs] = CalcFuelCosts(AmountOfFuels,CostsCoefficients)
    Costs = array2table(zeros(2,1));
    for i = 1:height(Costs)
        Costs{i,1} = AmountOfFuels(i)*CostsCoefficients(i);
    end
    Costs.Properties.RowNames = {'Coal', 'Natural Gas'};
end