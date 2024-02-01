function [CostsTotal] = CalcFuelCosts(AmountOfFuelsManufacturing,AmountOfFuelsTransportation,CostsCoefficientsManufacturing,CostsCoefficientsTransportation)
    CostsManufacturing = array2table(zeros(4,1));
    CostsTransportation = array2table(zeros(5,1));
    CostsTotal = array2table(zeros(5,1));

    for i = 1:height(CostsManufacturing)
        CostsManufacturing{i,1} = AmountOfFuelsManufacturing(i)*CostsCoefficientsManufacturing(i);
    end

    for i = 1:height(CostsTransportation)
        CostsTransportation{i,1} = AmountOfFuelsTransportation(i)*CostsCoefficientsTransportation(i);
    end
     a{1,1} = CostsManufacturing{3,1};
     b{1,1} = CostsTransportation{1,1}; 
     b{1,1} = b{1,1} +a{1,1};
     c{1,1} = CostsTransportation{2,1};
     d{1,1} = CostsManufacturing{4,1};
     d{1,1} = d{1,1} + c{1,1};
     CostsTotal(1,1) = CostsManufacturing(1,1);
     CostsTotal(2,1) = CostsManufacturing(2,1);
     CostsTotal(3,1) = b;
     CostsTotal(4,1) = d;
     CostsTotal(5,1) = CostsTransportation(4,1);

    

    CostsTotal.Properties.RowNames = {'Coal', 'Natural Gas', 'Diesel', 'Mazut', 'Gasoline'};
    

end