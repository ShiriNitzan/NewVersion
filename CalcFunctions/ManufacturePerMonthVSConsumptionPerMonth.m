function [] = ManufacturePerMonthVSConsumptionPerMonth(TimePeriod, MounthInterval, KwhTotal, TotalElectricityConsumption)

    ElectricityManufacturePerMonthTotal = zeros(1,12);

   for i=1:TimePeriod
        ElectricityManufacturePerMonthTotal(MounthInterval(i)) = ElectricityManufacturePerMonthTotal(MounthInterval(i))+KwhTotal(i);
   end

   x = (1:12);
   y = [ElectricityManufacturePerMonthTotal;TotalElectricityConsumption];
   bar(x,y);
   legend('Electricity Manufacture','Electricity Consumption');
   xlabel('Months', 'FontSize', 18);
   ylabel('KWH', 'FontSize', 18);

end