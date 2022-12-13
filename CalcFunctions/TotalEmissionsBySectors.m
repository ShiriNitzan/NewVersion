function EmissionsBySectors = TotalEmissionsBySectors(EmissionsByYears)
    EmissionsBySectors = array2table(zeros(6, width(EmissionsByYears)));
    EmissionsBySectors.Properties.RowNames = {'Electricity', 'Transportation', 'Construction', 'Water', 'Materials', 'Food'};
    for i = 1:width(EmissionsBySectors)
        EmissionsBySectors{6,i} = sum(EmissionsByYears{1,i}{1,1}{1,:})/1000000;
        EmissionsBySectors{1,i} = (sum(EmissionsByYears{2,i}{1,1}{1:4,9})+sum(EmissionsByYears{3,i}{1,1}{:,7}))/1000000;
        EmissionsBySectors{2,i} = (sum(EmissionsByYears{4,i}{1,1}{:,16}) + sum(EmissionsByYears{5,i}{1,1}{:,12})  + sum(EmissionsByYears{6,i}{1,1}{:,7}) + EmissionsByYears{2,i}{1,1}{5,9})/1000000;
        EmissionsBySectors{4,i} = (EmissionsByYears{10,i}{1,1}{1,2} + EmissionsByYears{2,i}{1,1}{6,9})/1000000;
        EmissionsBySectors{3,i} = sum(EmissionsByYears{7,i}{1,1}{11:13,2})/1000000;
%       EmissionsBySectors{5,i} = (sum(EmissionsByYears{8,i}{1,1}{:,3}) + sum(EmissionsByYears{9,i}{1,1}{2,:}) + sum(EmissionsByYears{9,i}{1,1}{6,:}) + sum(EmissionsByYears{9,i}{1,1}{10,:}))/1000000; %% fuels in production
%       EmissionsBySectors{5,i} = (EmissionsBySectors{5,i} + sum(EmissionsByYears{9,i}{1,1}{:,12}))/1000000; %% added downstream
    end

    ColumnNames = cell(1,width(EmissionsByYears));
    for i=1:width(EmissionsByYears)
        s1 = num2str(i+2016);
        ColumnNames{i} = s1;
    end
    EmissionsBySectors.Properties.VariableNames = ColumnNames;
end