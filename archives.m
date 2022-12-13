%-------------Sensitivity analysis
PopulationGrowth = {0, 0.45, 0.9};
ElectricityPerCapita = {0, 0.2, 0.41};
DesalinatedWater = {0,1.32,2.64};

%% test runs
[ValidaionLocalGlobal, ValidationTotalGlobalLocal] = CalcGlobalLocal(EmissionsByYearsTest);
ValidationUpDownStream = CalcUpDownStream(EmissionsByYearsTest);
ValidationEmissionsBySectors = TotalEmissionsBySectors(EmissionsByYearsTest);




