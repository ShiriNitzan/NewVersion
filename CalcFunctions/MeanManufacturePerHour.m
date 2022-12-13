function [] = MeanManufacturePerHour(KwhDistribution,RowNames)

    tiledlayout(4,3);
    for i=1:12
        nexttile
        plot(KwhDistribution(i,:),'-o','MarkerIndices',1:1:height(RowNames),'LineWidth',1.5)
        xticklabels(transpose(RowNames));
        xticks(1:1:height(RowNames));
        title(i, 'FontSize', 24);
        xlabel('Hour', 'FontSize', 18);
        ylabel('KWH', 'FontSize', 18);
    end
end

