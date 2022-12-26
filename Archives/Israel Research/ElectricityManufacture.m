%% Read Files

    global Data
    Data = "Total Electricty Data.xlsx";
    
    addpath("CalcFunctions");

    TotalElectricityConsumption = readtable(Data,'Sheet','ElectricityConsumption','Range','BJ13:BU13','ReadVariableNames',false);
    TotalElectricityConsumption = table2array(TotalElectricityConsumption);
    IrradiationPerMonth = readtable(Data,'Sheet','Irradiation','Range','B2:B13','ReadVariableNames',false);
    IrradiationPerMonth = table2array(IrradiationPerMonth);
    AvergeTempaturePerMonth = readtable(Data,'Sheet','Tempature','Range','B2:B13','ReadVariableNames',false);
    AvergeTempaturePerMonth = table2array(AvergeTempaturePerMonth);
    AreaRoofsTop = readtable(Data,'Sheet','Area','Range','B2:B21','ReadVariableNames',false);
    AreaRoofsTop = table2array(AreaRoofsTop);
    AreaParking = readtable(Data,'Sheet','Area','Range','H2:H9','ReadVariableNames',false);
    AreaParking = table2array(AreaParking);
    AreaNorthCampus = readtable(Data,'Sheet','Area','Range','E14:E14','ReadVariableNames',false);
    AreaNorthCampus = table2array(AreaNorthCampus);

%% PV System Model
    
    AvergeTempaturePerMonth = AvergeTempaturePerMonth+30;
    ElectricityManufacturePerMonthRoofs = zeros(1,12);
    ElectricityManufacturePerMonthParking = zeros(1,12);
    ElectricityManufacturePerMonthNorthCampus = zeros(1,12);
    ElectricityManufacturePerMonthTotal = zeros(1,12);
    SumAreaRoofsTop = sum(AreaRoofsTop);
    SumAreaParking = sum(AreaParking);
    SumAreaNorthCampus = sum(AreaNorthCampus);
    PanelType = -1;
     
    while(PanelType~=0)

        PanelType = input("Select Panel Type\nBIC - 1\nHJT - 2\nMono PERC - 3\nCancel - 0 \n");

        switch PanelType

            case 1 %% BIC
                InitialEfficiency = 0.228;
                ReductionTemperatureCoefficient = 0.003;
                IncreaseTemperatureCoefficient = 0.0004;
                break

            case 2 %% HJT
                InitialEfficiency = 0.219;
                ReductionTemperatureCoefficient = 0.0025;
                IncreaseTemperatureCoefficient = 0.0004;
                break
            case 3 %% Mono PERC
                InitialEfficiency = 0.17;
                ReductionTemperatureCoefficient = 0.0041;
                IncreaseTemperatureCoefficient = 0.0004;
                break
  
        end
    end

    for i=1:12
        if AvergeTempaturePerMonth(i)>25
            PowerTemperatureCoefficient = 1-(AvergeTempaturePerMonth(i)-25)*ReductionTemperatureCoefficient;
        else
            PowerTemperatureCoefficient = 1+(25-AvergeTempaturePerMonth(i))*IncreaseTemperatureCoefficient;
        end

        Efficiency=InitialEfficiency*PowerTemperatureCoefficient;

        ElectricityManufacturePerMonthRoofs(i) = Efficiency*SumAreaRoofsTop*IrradiationPerMonth(i)/1000;
        ElectricityManufacturePerMonthParking(i) = Efficiency*SumAreaParking*IrradiationPerMonth(i)/1000;
        ElectricityManufacturePerMonthNorthCampus(i) = Efficiency*SumAreaNorthCampus*IrradiationPerMonth(i)/1000;
        ElectricityManufacturePerMonthTotal(i) = ElectricityManufacturePerMonthRoofs(i)+ElectricityManufacturePerMonthParking(i)+ElectricityManufacturePerMonthNorthCampus(i);
   
    end
    x = (1:12);
    y = [ElectricityManufacturePerMonthTotal;TotalElectricityConsumption];
    bar(x,y);
    legend('Electricity Manufacture','Electricity Consumption');
    xlabel('Months', 'FontSize', 18);
    ylabel('KWH', 'FontSize', 18);
        