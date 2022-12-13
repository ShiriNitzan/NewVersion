classdef TableDataAppExample_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        BloodPressureAnalyisisUIFigure  matlab.ui.Figure
        UITable                         matlab.ui.control.Table
    end


    methods (Access = private)
    
        function updateplot(app)
            % Get Table UI component data
            t = app.UITable.DisplayData;            
            
            % Plot modified data 
            x2 = t.Age;
            y2 = t.BloodPressure(:,2);
            plot(app.UIAxes2,x2,y2,'-o');
        end
        
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Read table array from file
            t = readtable('patients.xls');
            vars = {'Age','Systolic','Diastolic','SelfAssessedHealthStatus','Smoker'};
            
            % Select a subset of the table array
            t = t(1:20,vars);
            
            % Sort the data by age
            t = sortrows(t,'Age');
            
            % Combine Systolic and Diastolic into one variable
            t.BloodPressure = [t.Systolic t.Diastolic];
            t.Systolic = [];
            t.Diastolic = [];
            
            % Convert SelfAssessedHealthStatus to categorical
            cats = categorical(t.SelfAssessedHealthStatus,{'Poor','Fair','Good','Excellent'});
            t.SelfAssessedHealthStatus = cats;
            
            % Rearrange columns
            t = t(:,[1 4 3 2]);
            
            % Add data to the Table UI Component
            app.UITable.Data = t;
            
            % Plot the original data
            x1 = app.UITable.Data.Age;
            y1 = app.UITable.Data.BloodPressure(:,2);
            plot(app.UIAxes,x1,y1,'o-');
            
            % Plot the data
            updateplot(app);
        end

        % Display data changed function: UITable
        function UITableDisplayDataChanged(app, event)
            % Update the plots when user sorts the columns of the table
            updateplot(app);
        end

        % Cell edit callback: UITable
        function UITableCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create BloodPressureAnalyisisUIFigure and hide until all components are created
            app.ScenariosTable = uifigure('Visible', 'off');
            app.ScenariosTable.Position = [100 100 733 478];
            app.ScenariosTable.Name = 'Blood Pressure Analyisis';

            % Create UITable
            app.UITable = uitable(app.ScenariosTable);
            app.UITable.ColumnName = {'Scenario'; '2017'; '2018'; '2019'; '2020'; '2021'; '2022'; '2023'; '2024'; '2025'; '2026'; '2027'; '2028'; '2029'; '2030'};
            app.UITable.RowName = {'Growth in Population', 'Electricity Saving Scenario', '3', 'Reducing Beef Consumption', '5', 'Change In Energy Consumption From Renewable Energies', '7','8','9','10', '11', '12', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving'};

            app.UITable.ColumnSortable = [true false true true false false false false false false false false false false false];
            app.UITable.ColumnEditable = [true false true true false false false false false false false false false false true];
            app.UITable.CellEditCallback = createCallbackFcn(app, @UITableCellEdit, true);
            app.UITable.DisplayDataChangedFcn = createCallbackFcn(app, @UITableDisplayDataChanged, true);
            app.UITable.Position = [53 52 648 255];

            % Show the figure after all components are created
            app.BloodPressureAnalyisisUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = TableDataAppExample_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.BloodPressureAnalyisisUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.BloodPressureAnalyisisUIFigure)
        end
    end
end