function UpDownStreamEmissions = CalcUpDownStream(EmissionsByYears)
    UpDownStreamEmissions = array2table(zeros(9, width(EmissionsByYears)));
    UpDownStreamEmissions.Properties.RowNames = {'Electricity-Direct', 'Electricity-Indirect','Transportation-Direct','Transportation-Indirect', 'Food','Construction', 'Water', 'Materials','Total'};
    for i = 1:width(UpDownStreamEmissions)
        UpDownStreamEmissions{1,i} = sum(EmissionsByYears{2,i}{1,1}{1:4,9})/1000000;
        UpDownStreamEmissions{2,i} = sum(EmissionsByYears{3,i}{1,1}{:,7})/1000000;
        UpDownStreamEmissions{3,i} = (sum(EmissionsByYears{4,i}{1,1}{:,16}) + sum(EmissionsByYears{5,i}{1,1}{:,12}))/1000000;
        UpDownStreamEmissions{4,i} = (sum(EmissionsByYears{6,i}{1,1}{:,7}) + EmissionsByYears{2,i}{1,1}{5,9})/1000000;
        UpDownStreamEmissions{6,i} = sum(EmissionsByYears{7,i}{1,1}{11:13,2})/1000000;
        UpDownStreamEmissions{7,i} = (EmissionsByYears{10,i}{1,1}{1,2} + EmissionsByYears{2,i}{1,1}{6,9})/1000000;
        %%UpDownStreamEmissions{7,i} = (sum(EmissionsByYears{8,i}{1,1}{:,3}) + sum(EmissionsByYears{9,i}{1,1}{2,:}) + sum(EmissionsByYears{9,i}{1,1}{6,:}) + sum(EmissionsByYears{9,i}{1,1}{10,:}))/1000000; %% fuels in production
        %%UpDownStreamEmissions{7,i} = (UpDownStreamEmissions{7,i} + sum(EmissionsByYears{9,i}{1,1}{:,12}))/1000000; %% added downstream
        UpDownStreamEmissions{5,i} = sum(EmissionsByYears{1,i}{1,1}{1,:})/1000000;

    end
    
    for i = 1:width(UpDownStreamEmissions)
        UpDownStreamEmissions{9,i} = sum(UpDownStreamEmissions{1:8,i});
    end   

    ColumnNames = cell(1,width(EmissionsByYears));
    for i=1:width(EmissionsByYears)
        s1 = num2str(i+2016);
        ColumnNames{i} = s1;
    end
    UpDownStreamEmissions.Properties.VariableNames = ColumnNames;
end