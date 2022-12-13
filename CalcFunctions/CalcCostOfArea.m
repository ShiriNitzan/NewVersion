function [CostOfArea] = CalcCostOfArea(TotalArea, CurrentAreaCost)
    CostOfArea = array2table(zeros(1,length(TotalArea)));
    for i = 1:length(CurrentAreaCost)
        switch i
            case 1
                CostOfArea{1,1} = TotalArea(1)*CurrentAreaCost(i);
            case 2
                CostOfArea{1,2} = TotalArea(2)*CurrentAreaCost(i);
                CostOfArea{1,3} = TotalArea(3)*CurrentAreaCost(i);
            case 3
                CostOfArea{1,4} = TotalArea(4)*CurrentAreaCost(i);
                CostOfArea{1,5} = TotalArea(5)*CurrentAreaCost(i); 
        end       
    end
    CostOfArea.Properties.VariableNames = {'Ground and Large Reserves', 'Small Reserves', 'Interchanges', 'Small Rofftops', 'Large Rooftops'};
end