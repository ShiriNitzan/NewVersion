function KwhRawDistribution = KwhRawDistributionCalc(KwhLongArray)

    NumberOfDaysperMonth = [31;28;31;30;31;30;31;31;30;31;30;31];
    KwhRawDistribution = cell(12,24);
    DaySum=0;

    for i=1:12
        SpecificTime = zeros(1,NumberOfDaysperMonth(i));
        for j=1:24
            DayIndex=j+DaySum;
            for k=1:NumberOfDaysperMonth(i)
                SpecificTime(1,k) = KwhLongArray(DayIndex);
                DayIndex=DayIndex+24;
            end
            KwhRawDistribution{i,j} = SpecificTime;
        end
        DaySum = DaySum+(24*NumberOfDaysperMonth(i));
    end
end

