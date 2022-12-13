function [EmissionsSumFull] = EmissionsSumCalcAllButOne(AllButOneScenario, FullS3Scenario,Years)

    CO2EForAllButOneScenario = sum(AllButOneScenario{1,Years}{1,1}{1,:}) +...
        AllButOneScenario{2,Years}{1,1}{7,9}+...
        sum(AllButOneScenario{3,Years}{1,1}{:,7})+...
        sum(AllButOneScenario{4,Years}{1,1}{:,16}) +...
        sum(AllButOneScenario{5,Years}{1,1}{:,12})+ ...
        sum(AllButOneScenario{6,Years}{1,1}{:,7})+...
        sum(AllButOneScenario{7,Years}{1,1}{:,2}) + ...
        AllButOneScenario{10, Years}{1,1}{1,2};
    CO2EForFullS3Scenario = sum(FullS3Scenario{1,Years}{1,1}{1,:}) + ...
        FullS3Scenario{2,Years}{1,1}{7,9}+...
        sum(FullS3Scenario{3,Years}{1,1}{:,7})+...
        sum(FullS3Scenario{4,Years}{1,1}{:,16}) +...
        sum(FullS3Scenario{5,Years}{1,1}{:,12})+...
        sum(FullS3Scenario{6,Years}{1,1}{:,7})+...
        sum(FullS3Scenario{7,Years}{1,1}{:,2}) +...
        FullS3Scenario{10, Years}{1,1}{1,2};
    CO2E = CO2EForFullS3Scenario - CO2EForAllButOneScenario;
%     NOXForAllButOneScenario = AllButOneScenario{2,Years}{1,1}{8,4}+sum(AllButOneScenario{4,Years}{1,1}{:,9}) +sum(AllButOneScenario{5,Years}{1,1}{:,1})+AllButOneScenario{7,Years}{1,1}{11,3};
%     NOXForFullS3Scenario = FullS3Scenario{2,Years}{1,1}{8,4}+sum(FullS3Scenario{4,Years}{1,1}{:,9})+sum(FullS3Scenario{5,Years}{1,1}{:,1}) +FullS3Scenario{7,Years}{1,1}{11,3};
%     NOX = NOXForFullS3Scenario - NOXForAllButOneScenario;
%     PM10ForAllButOneScenario = AllButOneScenario{2,Years}{1,1}{8,5}+sum(AllButOneScenario{4,Years}{1,1}{:,11})+sum(AllButOneScenario{5,Years}{1,1}{:,6}) +AllButOneScenario{7,Years}{1,1}{11,4};
%     PM10ForFullS3Scenario = FullS3Scenario{2,Years}{1,1}{8,5}+sum(FullS3Scenario{4,Years}{1,1}{:,11}) +sum(FullS3Scenario{5,Years}{1,1}{:,6}) +FullS3Scenario{7,Years}{1,1}{11,4};
%     PM10 = PM10ForFullS3Scenario - PM10ForAllButOneScenario;
%     SO2ForAllButOneScenario = AllButOneScenario{2,Years}{1,1}{8,6}+sum(AllButOneScenario{4,Years}{1,1}{:,12}) +sum(AllButOneScenario{5,Years}{1,1}{:,10})+AllButOneScenario{7,Years}{1,1}{11,5};
%     SO2ForFullS3Scenario = FullS3Scenario{2,Years}{1,1}{8,6}+sum(FullS3Scenario{4,Years}{1,1}{:,12}) +sum(FullS3Scenario{5,Years}{1,1}{:,10}) +FullS3Scenario{7,Years}{1,1}{11,5};
%     SO2 = SO2ForFullS3Scenario - SO2ForAllButOneScenario;
    
%     EmissionsSumFull = zeros(1,4);
    EmissionsSumFull = CO2E/1000000;
%     EmissionsSumFull(2) = NOX/1000000;
%     EmissionsSumFull(3) = PM10/1000000;
%     EmissionsSumFull(4) = SO2/1000000;
%     
%     CO2EForAllButOneScenario = sum(AllButOneScenario{1,Years}{1,1}{1,:}) + AllButOneScenario{2,Years}{1,1}{7,9}+sum(AllButOneScenario{3,Years}{1,1}{:,7})+sum(AllButOneScenario{4,Years}{1,1}{:,16}) +sum(AllButOneScenario{5,Years}{1,1}{:,12})+ sum(AllButOneScenario{6,Years}{1,1}{:,7})+sum(AllButOneScenario{7,Years}{1,1}{:,2}) + AllButOneScenario{10,Years}{1,1}{1,2};
%     CO2EForBaseYear = sum(AllButOneScenario{1,1}{1,1}{1,:}) + AllButOneScenario{2,1}{1,1}{7,9}+sum(AllButOneScenario{3,1}{1,1}{:,7})+sum(AllButOneScenario{4,1}{1,1}{:,16}) +sum(AllButOneScenario{5,1}{1,1}{:,12})+ sum(AllButOneScenario{6,1}{1,1}{:,7})+sum(AllButOneScenario{7,1}{1,1}{:,2}) + AllButOneScenario{10,1}{1,1}{1,2};
%     CO2E = CO2EForAllButOneScenario - CO2EForBaseYear;
%     NOXForAllButOneScenario = AllButOneScenario{2,Years}{1,1}{7,4}+sum(AllButOneScenario{4,Years}{1,1}{:,9}) +sum(AllButOneScenario{5,Years}{1,1}{:,1})+AllButOneScenario{7,Years}{1,1}{11,3};
%     NOXForBaseYear = AllButOneScenario{2,1}{1,1}{7,4}+sum(AllButOneScenario{4,1}{1,1}{:,9})+sum(AllButOneScenario{5,1}{1,1}{:,1}) +AllButOneScenario{7,1}{1,1}{11,3};
%     NOX = NOXForBaseYear - NOXForAllButOneScenario;
%     PM10ForBaseYear = AllButOneScenario{2,Years}{1,1}{7,5}+sum(AllButOneScenario{4,Years}{1,1}{:,11})+sum(AllButOneScenario{5,Years}{1,1}{:,6}) +AllButOneScenario{7,Years}{1,1}{11,4};
%     PM10ForFullS3Scenario = AllButOneScenario{2,1}{1,1}{7,5}+sum(AllButOneScenario{4,1}{1,1}{:,11}) +sum(AllButOneScenario{5,1}{1,1}{:,6}) +AllButOneScenario{7,1}{1,1}{11,4};
%     PM10 = PM10ForFullS3Scenario - PM10ForBaseYear;
%     SO2ForAllButOneScenario = AllButOneScenario{2,Years}{1,1}{7,6}+sum(AllButOneScenario{4,Years}{1,1}{:,12}) +sum(AllButOneScenario{5,Years}{1,1}{:,10})+AllButOneScenario{7,Years}{1,1}{11,5};
%     SO2ForBaseYear= AllButOneScenario{2,1}{1,1}{7,6}+sum(AllButOneScenario{4,1}{1,1}{:,12}) +sum(AllButOneScenario{5,1}{1,1}{:,10}) +AllButOneScenario{7,1}{1,1}{11,5};
%     SO2 = SO2ForBaseYear - SO2ForAllButOneScenario;
    
    %EmissionsSumBase = zeros(1,4);
    %EmissionsSumBase(1) = CO2E/1000000;
%     EmissionsSumBase(2) = NOX/1000000;
%     EmissionsSumBase(3) = PM10/1000000;
%     EmissionsSumBase(4) = SO2/1000000;
end
