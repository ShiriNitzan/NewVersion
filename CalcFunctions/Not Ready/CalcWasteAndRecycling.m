%% Read Files

    global Data
    Data = "Data.xlsx";
    
    global WasteAndRecycling
    WasteAndRecycling = readtable(Data,'Sheet','Materials','Range','I4:N16','ReadVariableNames',false);
    WasteAndRecycling =table2array(WasteAndRecycling);
    
    global ExportWasteForRecyclingPercentage
    ExportWasteForRecyclingPercentage = readtable(Data,'Sheet','Materials','Range','I20:I32','ReadVariableNames',false);
    ExportWasteForRecyclingPercentage =table2array(ExportWasteForRecyclingPercentage);
    
    LocalAuthoritiesWaste = WasteAndRecycling(:,1);
    LocalAuthoritiesRecycling = WasteAndRecycling(:,2);
    IndustryWaste = WasteAndRecycling(:,3);
    IndustryRecycling = WasteAndRecycling(:,4);
    AgriculturalWaste = WasteAndRecycling(:,5);
    AgriculturalRecycling = WasteAndRecycling(:,6);
    
    ModeledProducts = height(WasteAndRecycling);
    
 %% Waste & Recycling From Local Authorities
 
    LocalBurialWasteFromLocalAuthorities = zeros(ModeledProducts,1);
    TotalLocalBurialWasteFromLocalAuthorities = 0;
    LocalRecyclingWasteFromLocalAuthorities = zeros(ModeledProducts,1);
    TotalLocalRecyclingWasteFromLocalAuthorities = 0;
    GlobalRecyclingWasteFromLocalAuthorities = zeros(ModeledProducts,1);
    TotalGlobalRecyclingWasteFromLocalAuthorities = 0;
    for i = 1:ModeledProducts
        if (LocalAuthoritiesWaste(i) > LocalAuthoritiesRecycling(i))
            LocalBurialWasteFromLocalAuthorities(i,1) = LocalAuthoritiesWaste(i) - LocalAuthoritiesRecycling(i);
            TotalLocalBurialWasteFromLocalAuthorities = TotalLocalBurialWasteFromLocalAuthorities + LocalBurialWasteFromLocalAuthorities(i,1);
        else
            LocalBurialWasteFromLocalAuthorities(i,1) = 0;
        end
        GlobalRecyclingWasteFromLocalAuthorities(i,1) = LocalAuthoritiesRecycling(i) * ExportWasteForRecyclingPercentage(i);
        TotalGlobalRecyclingWasteFromLocalAuthorities = TotalGlobalRecyclingWasteFromLocalAuthorities + GlobalRecyclingWasteFromLocalAuthorities(i,1);
        LocalRecyclingWasteFromLocalAuthorities(i,1) = LocalAuthoritiesRecycling(i) - GlobalRecyclingWasteFromLocalAuthorities(i,1);
        TotalLocalRecyclingWasteFromLocalAuthorities = TotalLocalRecyclingWasteFromLocalAuthorities + LocalRecyclingWasteFromLocalAuthorities(i,1);
    end
    
 %% Waste & Recycling From Industry
 
    LocalBurialWasteFromIndustry = zeros(ModeledProducts,1);
    TotalLocalBurialWasteFromIndustry = 0;
    LocalRecyclingWasteFromIndustry = zeros(ModeledProducts,1);
    TotalLocalRecyclingWasteFromIndustry = 0;
    GlobalRecyclingWasteFromIndustry = zeros(ModeledProducts,1);
    TotalGlobalRecyclingWasteFromIndustry = 0;
    for i = 1:ModeledProducts
        if (IndustryWaste(i) > IndustryRecycling(i))
            LocalBurialWasteFromIndustry(i,1) = IndustryWaste(i) - IndustryRecycling(i);
            TotalLocalBurialWasteFromIndustry = TotalLocalBurialWasteFromIndustry + LocalBurialWasteFromIndustry(i,1);
        else
            LocalBurialWasteFromIndustry(i,1) = 0;
        end
        GlobalRecyclingWasteFromIndustry(i,1) = IndustryRecycling(i) * ExportWasteForRecyclingPercentage(i);
        TotalGlobalRecyclingWasteFromIndustry = TotalGlobalRecyclingWasteFromIndustry + GlobalRecyclingWasteFromIndustry(i,1);
        LocalRecyclingWasteFromIndustry(i,1) = IndustryRecycling(i) - GlobalRecyclingWasteFromIndustry(i,1);
        TotalLocalRecyclingWasteFromIndustry = TotalLocalRecyclingWasteFromIndustry + LocalRecyclingWasteFromIndustry(i,1);
    end
    
 %% Waste & Recycling From Agricultural
 
    LocalBurialWasteFromAgricultural = zeros(ModeledProducts,1);
    TotalLocalBurialWasteFromAgricultural = 0;
    LocalRecyclingWasteFromAgricultural = zeros(ModeledProducts,1);
    TotalLocalRecyclingWasteFromAgricultural = 0;
    GlobalRecyclingWasteFromAgricultural = zeros(ModeledProducts,1);
    TotalGlobalRecyclingWasteFromAgricultural = 0;
    for i = 1:ModeledProducts
        if (AgriculturalWaste(i) > AgriculturalRecycling(i))
            LocalBurialWasteFromAgricultural(i,1) = AgriculturalWaste(i) - AgriculturalRecycling(i);
            TotalLocalBurialWasteFromAgricultural = TotalLocalBurialWasteFromAgricultural + LocalBurialWasteFromAgricultural(i,1);
        else
            LocalBurialWasteFromAgricultural(i,1) = 0;
        end
        GlobalRecyclingWasteFromAgricultural(i,1) = AgriculturalRecycling(i) * ExportWasteForRecyclingPercentage(i);
        TotalGlobalRecyclingWasteFromAgricultural = TotalGlobalRecyclingWasteFromAgricultural + GlobalRecyclingWasteFromAgricultural(i,1);
        LocalRecyclingWasteFromAgricultural(i,1) = AgriculturalRecycling(i) - GlobalRecyclingWasteFromAgricultural(i,1);
        TotalLocalRecyclingWasteFromAgricultural = TotalLocalRecyclingWasteFromAgricultural + LocalRecyclingWasteFromAgricultural(i,1);
    end
    
%% Create Final Table

    RowNames = {'Local Authorities', 'Industry', 'Agricultural'};
    CurrentYearWasteAndRecycling = zeros(3,4);
    CurrentYearWasteAndRecycling = array2table(CurrentYearWasteAndRecycling, 'RowNames', RowNames);
    CurrentYearWasteAndRecycling.Properties.VariableNames = {'Local Recycling Waste', 'Global Recycling Waste', 'Local Burial Waste', 'Global Burial Waste'};
    CurrentYearWasteAndRecycling{1,1} = TotalLocalRecyclingWasteFromLocalAuthorities;
    CurrentYearWasteAndRecycling{1,2} = TotalGlobalRecyclingWasteFromLocalAuthorities;
    CurrentYearWasteAndRecycling{1,3} = TotalLocalBurialWasteFromLocalAuthorities;
    CurrentYearWasteAndRecycling{2,1} = TotalLocalRecyclingWasteFromIndustry;
    CurrentYearWasteAndRecycling{2,2} = TotalGlobalRecyclingWasteFromIndustry;
    CurrentYearWasteAndRecycling{2,3} = TotalLocalBurialWasteFromIndustry;
    CurrentYearWasteAndRecycling{3,1} = TotalLocalRecyclingWasteFromAgricultural;
    CurrentYearWasteAndRecycling{3,2} = TotalGlobalRecyclingWasteFromAgricultural;
    CurrentYearWasteAndRecycling{3,3} = TotalLocalBurialWasteFromAgricultural;

%% Create Final Table