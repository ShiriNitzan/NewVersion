%% Only 2017
t = tiledlayout(1,3);
BySectors = CalcUpDownStream(EmissionsByYearsTest1);
[AreaSum1, CostsSum1, WaterSum1] = CalcTotalResources(Resources1, ConsumptionAmounts1);
AreaSum1 = sortrows(AreaSum1,1,'descend');
WaterSum1 = sortrows(WaterSum1,1,'descend');
AreaSum1(1, :) = [];
WaterSum1(1, :) = [];
AreaSum1(4, :) = [];

x1 = categorical({'All Sectors'});
y1 = zeros(1, 7); 
y1(1,:) = BySectors{1:7,1};
ax1 = nexttile;
b1 = bar(x1,y1,'Stacked');
ylim ([0 110])
ylabel('MtCO2Eq', 'FontSize', 20);
legend(ax1, flip(b1), flip(BySectors.Properties.RowNames(1:7,1)), 'FontSize',16,'Location','northeast')
a1 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a1,'fontsize',20)
title('Emissions',  'FontSize', 28);
ytips1 = zeros(1, length(b1));
for i = 1:length(b1)
    ytips1(i) = b1(i).YEndPoints;
end
ytxt1 = round(y1./repmat(sum(y1,2),1,size(y1,2))*100);
ytxt1 = num2cell(ytxt1);
ytxt1 = cellfun(@(x1) [sprintf('%0.0f',x1), '%'], ytxt1,'UniformOutput', false);
xtips1 = zeros(1, length(b1));
for i = 1:length(b1)
    xtips1(i) = b1(i).XEndPoints;
end
text(xtips1,ytips1,ytxt1,'HorizontalAlignment','left','VerticalAlignment','top', 'FontSize', 14);


x2 = categorical({'All Sectors'});
y2 = zeros(1, 3);
y2(1,:) = AreaSum1{1:3,1};
nexttile
b2 = bar(x2,y2,'Stacked');
ylim([0 35000])
ylabel('Km^2', 'FontSize', 20);
legend(flip(b2), flip(AreaSum1.Properties.RowNames(1:3,1)), 'FontSize',16,'Location','northwest')
a2 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a2,'fontsize',20)
title('Area',  'FontSize', 28);
ytips2 = zeros(1, length(b2));
for i = 1:length(b2)
    ytips2(i) = b2(i).YEndPoints;
end
ytxt2 = round(y2./repmat(sum(y2,2),1,size(y2,2))*100);
ytxt2 = num2cell(ytxt2);
ytxt2 = cellfun(@(x) [sprintf('%0.0f',x), '%'], ytxt2,'UniformOutput', false);
xtips2 = zeros(1, length(b2));
for i = 1:length(b2)
    xtips2(i) = b2(i).XEndPoints;
end
text(xtips2,ytips2,ytxt2, 'HorizontalAlignment','left','VerticalAlignment','top', 'FontSize', 14);

nexttile
x3 = categorical({'All Sectors'});
y3 = zeros(1, 4); 
y3(1,:) = WaterSum1{1:4,1};
b3 = bar(x3,y3,'Stacked');
ylim([0 2700])
ylabel('Million M^3', 'FontSize', 20);
legend(flip(b3), flip(WaterSum1.Properties.RowNames(1:4,1)), 'FontSize',16,'Location','north')
a3 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a3,'fontsize',20)
title('Water',  'FontSize', 28);
precents = y3(1,:)./sum(y3(1,:));
ytips3 = zeros(1, length(b3));
for i = 1:length(b3)
    ytips3(i) = b3(i).YEndPoints;
end
ytxt3 = round(y3./repmat(sum(y3,2),1,size(y3,2))*100);
ytxt3 = num2cell(ytxt3);
ytxt3 = cellfun(@(x) [sprintf('%0.0f',x), '%'], ytxt3,'UniformOutput', false);
xtips3 = zeros(1, length(b3));
for i = 1:length(b3)
    xtips3(i) = b3(i).XEndPoints;
end
text(xtips3,ytips3,ytxt3,'HorizontalAlignment','left','VerticalAlignment','top', 'FontSize', 14);