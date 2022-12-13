function KwhDistribution = KwhMeanCalc(KwhRawDistribution)

    KwhDistribution = zeros(height(KwhRawDistribution),width(KwhRawDistribution));
    for i=1:height(KwhRawDistribution)
        for j=1:width(KwhRawDistribution)
            KwhDistribution(i,j) = mean(KwhRawDistribution{i,j});
        end
    end
end

