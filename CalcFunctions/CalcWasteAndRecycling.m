function WasteAndRecyclingTable = 	 CalcWasteAndRecycling(WasteAndRecycling, Data)%% hazardous waste not modled
    ExportWasteForRecyclingPercentage = Data.ExportWasteForRecyclingPercentage;

    LocalAuthoritiesWaste = WasteAndRecycling{:,1};
    LocalAuthoritiesRecycling = WasteAndRecycling{:,2};
    IndustryWaste = WasteAndRecycling{:,3};
    IndustryRecycling = WasteAndRecycling{:,4};
    AgriculturalWaste = WasteAndRecycling{:,5};
    AgriculturalRecycling = WasteAndRecycling{:,6};
    
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
    
    TotalLocalRecyclingWasteFromLocalAuthorities = TotalLocalRecyclingWasteFromLocalAuthorities-LocalRecyclingWasteFromLocalAuthorities(10); %% no pruning waste
    
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
    for i = 1:ModeledProducts
        if (AgriculturalWaste(i) > AgriculturalRecycling(i))
            LocalBurialWasteFromAgricultural(i,1) = AgriculturalWaste(i) - AgriculturalRecycling(i);
            TotalLocalBurialWasteFromAgricultural = TotalLocalBurialWasteFromAgricultural + LocalBurialWasteFromAgricultural(i,1);
        else
            LocalBurialWasteFromAgricultural(i,1) = 0;
        end
        LocalRecyclingWasteFromAgricultural(i,1) = AgriculturalRecycling(i);
        TotalLocalRecyclingWasteFromAgricultural = TotalLocalRecyclingWasteFromAgricultural + LocalRecyclingWasteFromAgricultural(i,1);
    end
    
    PruningBurial = AgriculturalWaste(10) - AgriculturalRecycling(10);
    TotalLocalBurialWasteFromAgricultural = TotalLocalBurialWasteFromAgricultural - 2*PruningBurial;
    TotalLocalRecyclingWasteFromAgricultural = TotalLocalRecyclingWasteFromAgricultural - 2*AgriculturalRecycling(10);
%% Create Final Table

    RowNames = {'Local Authorities', 'Industry', 'Agricultural'};
    CurrentYearWasteAndRecycling = zeros(3,3);
    CurrentYearWasteAndRecycling = array2table(CurrentYearWasteAndRecycling, 'RowNames', RowNames);
    CurrentYearWasteAndRecycling.Properties.VariableNames = {'Local Recycling Waste', 'Global Recycling Waste', 'Local Burial Waste'};
    CurrentYearWasteAndRecycling{1,1} = TotalLocalRecyclingWasteFromLocalAuthorities;
    CurrentYearWasteAndRecycling{1,2} = TotalGlobalRecyclingWasteFromLocalAuthorities;
    CurrentYearWasteAndRecycling{1,3} = TotalLocalBurialWasteFromLocalAuthorities;
    CurrentYearWasteAndRecycling{2,1} = TotalLocalRecyclingWasteFromIndustry;
    CurrentYearWasteAndRecycling{2,2} = TotalGlobalRecyclingWasteFromIndustry;
    CurrentYearWasteAndRecycling{2,3} = TotalLocalBurialWasteFromIndustry;
    CurrentYearWasteAndRecycling{3,1} = TotalLocalRecyclingWasteFromAgricultural;
    CurrentYearWasteAndRecycling{3,3} = TotalLocalBurialWasteFromAgricultural;

%% Create Final Table
WasteAndRecyclingTable = CurrentYearWasteAndRecycling;
end

