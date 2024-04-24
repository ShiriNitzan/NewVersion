function [CostOfArea] = CalcCostOfArea(TotalArea, CurrentAreaCost, GroundDist, DualDist)
    CostOfArea = array2table(zeros(1,5));
    CostOfArea.Properties.VariableNames = {'Ground and Large Reserves', 'Small Reserves', 'Interchanges', 'Small Rofftops', 'Large Rooftops'};
    for i = 1:length(CurrentAreaCost)
        switch i
            case 1 %ground
                temp = CurrentAreaCost(i) * (TotalArea(1)*GroundDist(1) + TotalArea(2)* DualDist(1));
                CostOfArea{1,1} = temp;
                % CostOfArea{1,1} = TotalArea(1)*CurrentAreaCost(i);

            case 2 %interchange$reserves
                SmallReserves = CurrentAreaCost(i) * (TotalArea(1)*GroundDist(2) + TotalArea(2)* DualDist(2));
                Intechanges = CurrentAreaCost(i) * (TotalArea(1)*GroundDist(3) + TotalArea(2)* DualDist(3));
                CostOfArea{1,2} = SmallReserves;
                CostOfArea{1,3} = Intechanges;
                %CostOfArea{1,2} = TotalArea(2)*CurrentAreaCost(i);
                %CostOfArea{1,3} = TotalArea(3)*CurrentAreaCost(i);

            case 3 %rooftops
                LargeRooftops = CurrentAreaCost(i) * (TotalArea(1)*GroundDist(4) + TotalArea(2)* DualDist(4));
                SmallRooftope = CurrentAreaCost(i) * (TotalArea(1)*GroundDist(5) + TotalArea(2)* DualDist(5));
                CostOfArea{1,4} = LargeRooftops;
                CostOfArea{1,5} = SmallRooftope;
                %CostOfArea{1,4} = TotalArea(4)*CurrentAreaCost(i);
                %CostOfArea{1,5} = TotalArea(5)*CurrentAreaCost(i); 
        end       
    end
end