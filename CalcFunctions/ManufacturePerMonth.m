function [] = ManufacturePerMonth(TimePeriod, MounthInterval, KwhTotal)

    ElectricityManufacturePerMonthTotal = zeros(1,12);

   for i=1:TimePeriod
        ElectricityManufacturePerMonthTotal(MounthInterval(i)) = ElectricityManufacturePerMonthTotal(MounthInterval(i))+KwhTotal(i);
   end

   x = (1:12);
   y = ElectricityManufacturePerMonthTotal;
   bar(x,y);
   legend('Electricity Manufacture');
   xlabel('Months', 'FontSize', 18);
   ylabel('KWH', 'FontSize', 18);

end