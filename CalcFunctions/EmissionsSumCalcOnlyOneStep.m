function [EmissionsSum] = EmissionsSumCalcOnlyOneStep(EmissionsByYears, Years)

    CO2EFor2014 = sum(EmissionsByYears{1,1}{1,1}{1,:}) + EmissionsByYears{2,1}{1,1}{7,9}+sum(EmissionsByYears{3,1}{1,1}{:,7})+sum(EmissionsByYears{4,1}{1,1}{:,16}) + sum(EmissionsByYears{5,1}{1,1}{:,12})  + sum(EmissionsByYears{6,1}{1,1}{:,7})+sum(EmissionsByYears{7,1}{1,1}{:,2}) + EmissionsByYears{10,1}{1,1}{1,2};
    CO2EFor2030 = sum(EmissionsByYears{1,Years}{1,1}{1,:}) + EmissionsByYears{2,Years}{1,1}{7,9}+sum(EmissionsByYears{3,Years}{1,1}{:,7})+sum(EmissionsByYears{4,Years}{1,1}{:,16}) +sum(EmissionsByYears{5,1}{1,1}{:,12}) + sum(EmissionsByYears{6,Years}{1,1}{:,7})+sum(EmissionsByYears{7,Years}{1,1}{:,2}) + EmissionsByYears{10,Years}{1,1}{1,2};
    CO2E = CO2EFor2030-CO2EFor2014;
%     NOXFor2014 = EmissionsByYears{2,1}{1,1}{8,4}+sum(EmissionsByYears{4,1}{1,1}{:,9}) + sum(EmissionsByYears{5,1}{1,1}{:,1})  +EmissionsByYears{7,1}{1,1}{11,3};
%     NOXFor2030 = EmissionsByYears{2,Years}{1,1}{8,4}+sum(EmissionsByYears{4,Years}{1,1}{:,9}) +sum(EmissionsByYears{5,Years}{1,1}{:,1})  +EmissionsByYears{7,Years}{1,1}{11,3};
%     NOX = NOXFor2030-  NOXFor2014;
%     PM10For2014 = EmissionsByYears{2,1}{1,1}{8,5}+sum(EmissionsByYears{4,1}{1,1}{:,11}) + sum(EmissionsByYears{5,1}{1,1}{:,6}) +EmissionsByYears{7,1}{1,1}{11,4};
%     PM10For2030 = EmissionsByYears{2,Years}{1,1}{8,5}+sum(EmissionsByYears{4,Years}{1,1}{:,11}) + sum(EmissionsByYears{5,Years}{1,1}{:,6}) + EmissionsByYears{7,Years}{1,1}{11,4};
%     PM10 = PM10For2030 - PM10For2014;
%     SO2For2014 = EmissionsByYears{2,1}{1,1}{8,6}+sum(EmissionsByYears{4,1}{1,1}{:,12}) +sum(EmissionsByYears{5,1}{1,1}{:,10})  +EmissionsByYears{7,1}{1,1}{11,5};
%     SO2For2030 = EmissionsByYears{2,Years}{1,1}{8,6}+sum(EmissionsByYears{4,Years}{1,1}{:,12}) + sum(EmissionsByYears{5,Years}{1,1}{:,10}) + EmissionsByYears{7,Years}{1,1}{11,5};
%     SO2 = SO2For2030 - SO2For2014;
    
    EmissionsSum = zeros(1,4);
    EmissionsSum(1) = CO2E/1000000;

%     EmissionsSum(2) = NOX/1000000;
%     EmissionsSum(3) = PM10/1000000;
%     EmissionsSum(4) = SO2/1000000;
    
end

