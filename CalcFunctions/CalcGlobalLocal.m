function [GlobalLocalEmission, TotalGlobalLocal] = CalcGlobalLocal(EmissionsByYears)
    GlobalLocalEmission = cell(2,width(EmissionsByYears));
    TotalGlobalLocal = table(2,width(EmissionsByYears));
    for i = 1:width(EmissionsByYears)
        GlobalLocalEmission{1,i} = array2table(zeros(1,6));
        GlobalLocalEmission{2,i} = array2table(zeros(1,6));
        GlobalLocalEmission{1,i}.Properties.VariableNames = {'Electricity', 'Transportation', 'Construction', 'Water', 'Materials', 'Food'};
        GlobalLocalEmission{2,i}.Properties.VariableNames = {'Electricity', 'Transportation', 'Construction', 'Water', 'Materials', 'Food'};
        GlobalLocalEmission{1,i}.Electricity(1) = (sum(EmissionsByYears{2,i}{1,1}{1:4,9})+EmissionsByYears{3,i}{1,1}{2,7}+EmissionsByYears{3,i}{1,1}{3,7}+EmissionsByYears{3,i}{1,1}{4,7})/1000000;
        GlobalLocalEmission{2,i}.Electricity(1) = (EmissionsByYears{3,i}{1,1}{1,7}+EmissionsByYears{3,i}{1,1}{5,7}+EmissionsByYears{3,i}{1,1}{6,7})/1000000;
        GlobalLocalEmission{1,i}.Transportation(1) = (sum(EmissionsByYears{4,i}{1,1}{:,16}) + sum(EmissionsByYears{6,i}{1,1}{1:5,7})+EmissionsByYears{6,i}{1,1}{7,7}+sum(EmissionsByYears{5,i}{1,1}{:,12}) + EmissionsByYears{2,i}{1,1}{5,9})/1000000;
        GlobalLocalEmission{2,i}.Transportation(1) = (EmissionsByYears{6,i}{1,1}{6,7} + EmissionsByYears{6,i}{1,1}{8,7} )/1000000;        GlobalLocalEmission{1,i}.Food(1) = sum(EmissionsByYears{1,i}{1:1}{1,1:2})/1000000 + EmissionsByYears{1,i}{1:1}{1,5}/1000000;
        GlobalLocalEmission{1,i}.Food(1) = sum(EmissionsByYears{1,i}{1:1}{1,1:2})/1000000 + EmissionsByYears{1,i}{1:1}{1,5}/1000000;
        GlobalLocalEmission{2,i}.Food(1) = sum(EmissionsByYears{1,i}{1:1}{1,3:4})/1000000;
        GlobalLocalEmission{1,i}.Water(1)  = (EmissionsByYears{10,i}{1,1}{1,2} + EmissionsByYears{2,i}{1,1}{6,9})/1000000;
        GlobalLocalEmission{2,i}.Water(1)  = (EmissionsByYears{2,i}{1,1}{7,9})/1000000;
        GlobalLocalEmission{1,i}.Materials(1)  = (sum(EmissionsByYears{9,i}{1,1}{1,:})+EmissionsByYears{9,i}{1,1}{2,6}+EmissionsByYears{9,i}{1,1}{3,6})/1000000;
%       GlobalLocalEmission{2,i}.Materials(1) = sum(EmissionsByYears{9,i}{1,1}{:,12})/1000000;
        GlobalLocalEmission{1,i}.Construction(1) = sum(EmissionsByYears{7,i}{1,1}{11:12,2})/1000000;
        GlobalLocalEmission{2,i}.Construction(1) = EmissionsByYears{7,i}{1,1}{13,2}/1000000;
        TotalGlobalLocal{1,i} = sum(GlobalLocalEmission{1,i}{1,:});
        TotalGlobalLocal{2,i} = sum(GlobalLocalEmission{2,i}{1,:});
    end

    GlobalLocalEmission = cell2table(GlobalLocalEmission);
    ColumnNames = cell(1,width(EmissionsByYears));
    for i=1:width(EmissionsByYears)
        s1 = num2str(i+2016);
        ColumnNames{i} = s1;
    end
    GlobalLocalEmission.Properties.VariableNames = ColumnNames;
    GlobalLocalEmission.Properties.RowNames = {'Local', 'Global'};

    TotalGlobalLocal.Properties.VariableNames = ColumnNames;
    TotalGlobalLocal.Properties.RowNames = {'Local', 'Global'};


end