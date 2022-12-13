function [KWValues] = CalcKWFromKwh(ElectricityFromSources,ConversionValues, Percents)
    KWValues = zeros(height(ConversionValues),1);
    %conventional
    for i = 1:2
        KWValues(i) = ElectricityFromSources(i)/ConversionValues{i,1};
    end    
    %renewable sources
    for i = 3:height(ConversionValues)
        KWValues(i) = ElectricityFromSources(3)/ConversionValues{i,1}*Percents(i-2);
    end
end