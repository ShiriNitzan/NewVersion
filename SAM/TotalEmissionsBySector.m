function [TotalEmissions] = TotalEmissionsBySector(EmissionsTable, Years)
RowNames = {'Co2e', 'NOX', 'PM10', 'SO2'};
TotalEmissions = array2table(zeros(4,5),'RowNames', RowNames);
TotalEmissions.Properties.VariableNames = {'Electricity','Transportation','Food','Construction','Materials'};

  % co2e
  TotalEmissions{1,3} = sum(EmissionsTable{1,Years}{1,1}{1,:});
  TotalEmissions{1,1} = EmissionsTable{2,Years}{1,1}{8,9}+sum(EmissionsTable{3,Years}{1,1}{:,7});
  TotalEmissions{1,2} = sum(EmissionsTable{4,Years}{1,1}{:,16}) + sum(EmissionsTable{6,Years}{1,1}{:,7})+sum(EmissionsTable{5,Years}{1,1}{:,2});
  TotalEmissions{1,4} = sum(EmissionsTable{7,Years}{1,1}{:,2});
  TotalEmissions{1,5} = sum(EmissionsTable{8,Years}{1,1}{:,3}) + sum(EmissionsTable{9,Years}{1,1}{2,:}) + sum(EmissionsTable{9,Years}{1,1}{6,:}) + sum(EmissionsTable{9,Years}{1,1}{10,:});
  
  %nox
  TotalEmissions{2,1} = EmissionsTable{2,Years}{1,1}{8,4};
  TotalEmissions{2,2} = sum(EmissionsTable{4,Years}{1,1}{:,9}) + sum(EmissionsTable{5, Years}{1,1}{:,1});
  TotalEmissions{2,4} = EmissionsTable{7,Years}{1,1}{11,3};
  
  %pm10
  TotalEmissions{3,1} = EmissionsTable{2,Years}{1,1}{8,5};
  TotalEmissions{3,2} = sum(EmissionsTable{4,Years}{1,1}{:,11}) + sum(EmissionsTable{5,Years}{1,1}{:,6}) ;
  TotalEmissions{3,4} = EmissionsTable{7,Years}{1,1}{11,4};
  
  %so2
  TotalEmissions{4,1} = EmissionsTable{2,Years}{1,1}{8,6};
  TotalEmissions{4,2} = sum(EmissionsTable{4,Years}{1,1}{:,12}) + sum(EmissionsTable{5,Years}{1,1}{:,10});
  TotalEmissions{4,4} = EmissionsTable{7,Years}{1,1}{11,5};
  
end

