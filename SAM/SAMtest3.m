function SAM-test2
	function [result] = ssccall(action, arg0, arg1, arg2 )
    [pathstr, fn, fext] = fileparts(mfilename('fullpath'));
        ssclibpath = './';
        ssclib = 'ssc';
    if ~libisloaded(ssclib)
        oldFolder = cd(pathstr);
        loadlibrary(strcat(ssclibpath,ssclib),strcat(ssclibpath,'sscapi.h'));
        cd(oldFolder);
    end
    if strcmp(action,'load')
        if ~libisloaded(ssclib)
            oldFolder = cd(pathstr);
            loadlibrary(strcat(ssclibpath,ssclib),strcat(ssclibpath,'../sscapi.h'));
            cd(oldFolder);
        end
    elseif strcmp(action,'unload')
        if libisloaded(ssclib)
            unloadlibrary(ssclib)    
        end
    elseif strcmp(action,'version')
        result = calllib(ssclib,'ssc_version');
    elseif strcmp(action,'build_info')
        result = calllib(ssclib, 'ssc_build_info');
    elseif strcmp(action,'data_create')
        result = calllib(ssclib, 'ssc_data_create');
        if ( isnullpointer(result) )
            result = 0;
        end
    elseif strcmp(action,'data_free')
        result = calllib(ssclib, 'ssc_data_free', arg0);
    elseif strcmp(action,'data_unassign')
        result = calllib(ssclib, 'ssc_data_unassign', arg0, arg1);
    elseif strcmp(action,'data_query')
        result = calllib(ssclib, 'ssc_data_query', arg0, arg1 );
    elseif strcmp(action,'data_first')
        result = calllib(ssclib, 'ssc_data_first', arg0 );
    elseif strcmp(action,'data_next')
        result = calllib(ssclib, 'ssc_data_next', arg0 );
    elseif strcmp(action,'data_set_string')
        result = calllib(ssclib, 'ssc_data_set_string', arg0, arg1, arg2 );
    elseif strcmp(action,'data_set_number')
        result = calllib(ssclib, 'ssc_data_set_number', arg0, arg1, arg2 );
    elseif strcmp(action,'data_set_array')
        len = length(arg2);
        arr = libpointer( 'doublePtr', arg2 );
        result = calllib(ssclib,'ssc_data_set_array',arg0,arg1,arr,len);
    elseif strcmp(action,'data_set_matrix')
        [nr nc] = size(arg2);
        mat = zeros(nr*nc, 1);
        ii = 1;
        for r=1:nr,
            for c=1:nc,
                mat(ii) = arg2(r,c);
                ii=ii+1;
            end
        end
        arr = libpointer( 'doublePtr', mat );
        result = calllib(ssclib,'ssc_data_set_matrix',arg0,arg1,arr,nr,nc);
    elseif strcmp(action,'data_set_table')
        result = calllib(ssclib,'ssc_data_set_table',arg0,arg1,arg2);
    elseif strcmp(action,'data_get_string')
        result = calllib(ssclib,'ssc_data_get_string',arg0,arg1);
    elseif strcmp(action,'data_get_number')
         p = libpointer('doublePtr',0);
         calllib(ssclib,'ssc_data_get_number', arg0,arg1,p);
         result = get(p,'Value');
    elseif strcmp(action,'data_get_array')
        p_count = libpointer('int32Ptr',0);   
        [xobj] = calllib(ssclib,'ssc_data_get_array',arg0,arg1,p_count);
        setdatatype(xobj,'int64Ptr',p_count.Value,1);
        len = p_count.Value;
        result = zeros( len, 1 );
        for i=1:len,
            pidx = xobj+(i-1);
            setdatatype(pidx,'doublePtr',1,1);
            result(i) = pidx.Value;
        end
    elseif strcmp(action,'data_get_matrix')
        p_rows = libpointer('int32Ptr',0);
        p_cols = libpointer('int32Ptr',0);
        [xobj] = calllib(ssclib,'ssc_data_get_matrix',arg0,arg1,p_rows,p_cols);
        setdatatype(xobj,'int64Ptr',p_rows.Value*p_cols.Value,1);
        nrows = p_rows.Value;
        ncols = p_cols.Value;
        if ( nrows*ncols > 0 )
            result = zeros( nrows, ncols );
            ii=1;
            for r=1:nrows,
                for c=1:ncols,
                    pidx = xobj+(ii-1);
                    setdatatype(pidx,'doublePtr',1,1);
                    result(r,c) = pidx.Value;
                    ii=ii+1;
                end
            end
        end
    elseif strcmp(action,'data_get_table')
        result = calllib(ssclib,'ssc_data_get_table',arg0,arg1);
    elseif strcmp(action,'module_entry')
        result = calllib(ssclib,'ssc_module_entry',arg0);
        if isnullpointer( result ),
            result = 0;
        end
    elseif strcmp(action,'entry_name')
        result = calllib(ssclib,'ssc_entry_name',arg0);
    elseif strcmp(action,'entry_description')
        result = calllib(ssclib,'ssc_entry_description',arg0);
    elseif strcmp(action,'entry_version')
        result = calllib(ssclib,'ssc_entry_version',arg0);
    elseif strcmp(action,'module_var_info')
        result = calllib(ssclib,'ssc_module_var_info',arg0,arg1);
        if isnullpointer( result ),
            result = 0;
        end
    elseif strcmp(action,'info_var_type')
        ty = calllib(ssclib,'ssc_info_var_type',arg0);
        if (ty == 1)
            result = 'input';
        elseif ( ty==2 )
            result = 'output';
        else
            result = 'inout';
        end
    elseif strcmp(action,'info_data_type')
        dt = calllib(ssclib,'ssc_info_data_type',arg0);
        if (dt == 1)
            result = 'string';
        elseif (dt == 2)
            result = 'number';
        elseif (dt == 3)
            result = 'array';
        elseif (dt == 4)
            result = 'matrix';
        elseif (dt == 5)
            result = 'table';
        else
            result = 'invalid';
        end
    elseif strcmp(action,'info_name')
        result = calllib(ssclib,'ssc_info_name',arg0);
    elseif strcmp(action,'info_label')
        result = calllib(ssclib,'ssc_info_label',arg0);
    elseif strcmp(action,'info_units')
        result = calllib(ssclib,'ssc_info_units',arg0);
    elseif strcmp(action,'info_meta')
        result = calllib(ssclib,'ssc_info_meta',arg0);
    elseif strcmp(action,'info_group')
        result = calllib(ssclib,'ssc_info_group',arg0);
    elseif strcmp(action,'info_required')
        result = calllib(ssclib,'ssc_info_required',arg0);
    elseif strcmp(action,'info_constraints')
        result = calllib(ssclib,'ssc_info_constraints',arg0);
    elseif strcmp(action,'info_uihint')
        result = calllib(ssclib,'ssc_info_uihint',arg0);
    elseif strcmp(action,'exec_simple')
        result = calllib(ssclib,'ssc_module_exec_simple',arg0,arg1);
    elseif strcmp(action,'exec_simple_nothread')
        result = calllib(ssclib,'ssc_module_exec_simple_nothread',arg0,arg1);
    elseif strcmp(action,'module_create')
        result = calllib(ssclib,'ssc_module_create',arg0);
        if ( isnullpointer(result) )
            result = 0;
        end
    elseif strcmp(action,'module_free')
        result = calllib(ssclib,'ssc_module_free',arg0);
    elseif strcmp(action,'module_exec_set_print')
        calllib(ssclib,'ssc_module_exec_set_print',arg0);
        result = 0;
    elseif strcmp(action,'module_exec')
        result = calllib(ssclib,'ssc_module_exec',arg0,arg1);
    elseif strcmp(action,'module_log')
        p_type = libpointer('int32Ptr',1);
        p_time = libpointer('singlePtr',1);
        result = calllib(ssclib,'ssc_module_log', arg0, arg1, p_type, p_time);
    elseif strcmp(action,'module_log_detailed')
        p_type = libpointer('int32Ptr',1);
        p_time = libpointer('singlePtr',1);
        text = calllib(ssclib,'ssc_module_log', arg0, arg1, p_type, p_time);
        typetext = 'notice';
        if (p_type.Value == 2)
            typetext = 'warning';
        elseif (p_type.Value == 3)
            typetext = 'error';
        end
        if ( strcmp(text,'') )
            result = 0;
        else
            result = {text , typetext , p_time.Value};
        end
    else
        disp( sprintf('ssccall: invalid action %s', action) );        
        result = 0;
    end
	end
	function bb = isnullpointer(p)
    bb = false;
    try
        setdatatype(p, 'voidPtr', 1, 1);
        deref = get(p);
    catch
        e = lasterror();
        if strcmp(e.identifier, 'MATLAB:libpointer:ValueNotDefined')
            bb = true;
        end
    end
	end
	clear
	ssccall('load');
	disp('Current folder = C:/Users/jvjos/Desktop/System/SAM');
	disp(sprintf('SSC Version = %d', ssccall('version')));
	disp(sprintf('SSC Build Information = %s', ssccall('build_info')));
	ssccall('module_exec_set_print',0);
	data = ssccall('data_create');
	ssccall('data_set_string', data, 'solar_resource_file', 'C:/Users/jvjos/SAM Downloaded Weather Files/omer_israel_31.2659_34.8476_msg-iodc_60_2019.csv');
	albedo =[ 0.20000000000000001 ];
	ssccall( 'data_set_array', data, 'albedo', albedo );
	ssccall('data_set_number', data, 'use_wf_albedo', 1);
	ssccall('data_set_number', data, 'system_use_lifetime_output', 0);
	ssccall('data_set_number', data, 'analysis_period', 25);
	ssccall('data_set_number', data, 'system_capacity', 1000);
	ssccall('data_set_number', data, 'module_type', 0);
	ssccall('data_set_number', data, 'dc_ac_ratio', 1.2);
	ssccall('data_set_number', data, 'bifaciality', 0);
	ssccall('data_set_number', data, 'array_type', 0);
	ssccall('data_set_number', data, 'tilt', 22);
	ssccall('data_set_number', data, 'azimuth', 180);
	ssccall('data_set_number', data, 'gcr', 0.29999999999999999);
	soiling =[ 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0 ];
	ssccall( 'data_set_array', data, 'soiling', soiling );
	ssccall('data_set_number', data, 'losses', 14.075660688264469);
	ssccall('data_set_number', data, 'en_snowloss', 0);
	ssccall('data_set_number', data, 'inv_eff', 98);
	ssccall('data_set_number', data, 'batt_simple_enable', 0);
	ssccall('data_set_number', data, 'adjust:constant', 0);
	load = csvread( 'C:/Users/jvjos/Desktop/System/SAM/load.csv');
	ssccall( 'data_set_array', data, 'load', load );
	load_escalation =[ 0 ];
	ssccall( 'data_set_array', data, 'load_escalation', load_escalation );
	grid_curtailment = csvread( 'C:/Users/jvjos/Desktop/System/SAM/grid_curtailment.csv');
	ssccall( 'data_set_array', data, 'grid_curtailment', grid_curtailment );
	ssccall('data_set_number', data, 'enable_interconnection_limit', 0);
	ssccall('data_set_number', data, 'grid_interconnection_limit_kwac', 100000);
	ssccall('data_set_number', data, 'inflation_rate', 2.5);
	degradation =[ 0.5 ];
	ssccall( 'data_set_array', data, 'degradation', degradation );
	rate_escalation =[ 0 ];
	ssccall( 'data_set_array', data, 'rate_escalation', rate_escalation );
	ssccall('data_set_number', data, 'ur_metering_option', 0);
	ssccall('data_set_number', data, 'ur_nm_yearend_sell_rate', 0);
	ssccall('data_set_number', data, 'ur_nm_credit_month', 11);
	ssccall('data_set_number', data, 'ur_nm_credit_rollover', 0);
	ssccall('data_set_number', data, 'ur_monthly_fixed_charge', 30);
	ssccall('data_set_number', data, 'ur_monthly_min_charge', 0);
	ssccall('data_set_number', data, 'ur_annual_min_charge', 0);
	ssccall('data_set_number', data, 'ur_en_ts_sell_rate', 0);
	ur_ts_sell_rate = csvread( 'C:/Users/jvjos/Desktop/System/SAM/ur_ts_sell_rate.csv');
	ssccall( 'data_set_array', data, 'ur_ts_sell_rate', ur_ts_sell_rate );
	ssccall('data_set_number', data, 'ur_en_ts_buy_rate', 0);
	ur_ts_buy_rate = csvread( 'C:/Users/jvjos/Desktop/System/SAM/ur_ts_buy_rate.csv');
	ssccall( 'data_set_array', data, 'ur_ts_buy_rate', ur_ts_buy_rate );
	ur_ec_sched_weekday =[ 4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   3   3   3   3   3   4   4   4   4 ; 4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   3   3   3   3   3   4   4   4   4 ; 4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   3   3   3   3   3   4   4   4   4 ; 4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   3   3   3   3   3   4   4   4   4 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   3   3   3   3   3   4   4   4   4 ; 4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   3   3   3   3   3   4   4   4   4 ];
	ssccall( 'data_set_matrix', data, 'ur_ec_sched_weekday', ur_ec_sched_weekday );
	ur_ec_sched_weekend =[ 4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4 ; 4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4 ; 4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4 ; 4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4 ; 4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4   4 ];
	ssccall( 'data_set_matrix', data, 'ur_ec_sched_weekend', ur_ec_sched_weekend );
	ur_ec_tou_mat =[ 1   1   9.9999999999999998e+37   0   0.050000000000000003   0 ; 2   1   9.9999999999999998e+37   0   0.074999999999999997   0 ; 3   1   9.9999999999999998e+37   0   0.059999999999999998   0 ; 4   1   9.9999999999999998e+37   0   0.050000000000000003   0 ];
	ssccall( 'data_set_matrix', data, 'ur_ec_tou_mat', ur_ec_tou_mat );
	ssccall('data_set_number', data, 'ur_dc_enable', 1);
	ur_dc_sched_weekday =[ 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   1   1   1   1   1   2   2   2   2 ];
	ssccall( 'data_set_matrix', data, 'ur_dc_sched_weekday', ur_dc_sched_weekday );
	ur_dc_sched_weekend =[ 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ; 2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2 ];
	ssccall( 'data_set_matrix', data, 'ur_dc_sched_weekend', ur_dc_sched_weekend );
	ur_dc_tou_mat =[ 1   1   100   20 ; 1   2   9.9999999999999998e+37   15 ; 2   1   100   10 ; 2   2   9.9999999999999998e+37   5 ];
	ssccall( 'data_set_matrix', data, 'ur_dc_tou_mat', ur_dc_tou_mat );
	ur_dc_flat_mat =[ 0   1   9.9999999999999998e+37   0 ; 1   1   9.9999999999999998e+37   0 ; 2   1   9.9999999999999998e+37   0 ; 3   1   9.9999999999999998e+37   0 ; 4   1   9.9999999999999998e+37   0 ; 5   1   9.9999999999999998e+37   0 ; 6   1   9.9999999999999998e+37   0 ; 7   1   9.9999999999999998e+37   0 ; 8   1   9.9999999999999998e+37   0 ; 9   1   9.9999999999999998e+37   0 ; 10   1   9.9999999999999998e+37   0 ; 11   1   9.9999999999999998e+37   0 ];
	ssccall( 'data_set_matrix', data, 'ur_dc_flat_mat', ur_dc_flat_mat );
	ssccall('data_set_number', data, 'ur_enable_billing_demand', 0);
	ssccall('data_set_number', data, 'ur_billing_demand_minimum', 100);
	ssccall('data_set_number', data, 'ur_billing_demand_lookback_period', 11);
	ur_billing_demand_lookback_percentages =[ 60   0 ; 60   0 ; 60   0 ; 60   0 ; 60   0 ; 95   1 ; 95   1 ; 95   1 ; 95   1 ; 60   0 ; 60   0 ; 60   0 ];
	ssccall( 'data_set_matrix', data, 'ur_billing_demand_lookback_percentages', ur_billing_demand_lookback_percentages );
	ur_dc_billing_demand_periods =[ 1   1 ; 2   1 ];
	ssccall( 'data_set_matrix', data, 'ur_dc_billing_demand_periods', ur_dc_billing_demand_periods );
	ur_yearzero_usage_peaks =[ 234.67599999999999; 173.422; 172.00700000000001; 191.434; 198.29499999999999; 236.46899999999999; 274.23099999999999; 260.33600000000001; 226.751; 185.12299999999999; 156.19999999999999; 184.05000000000001 ];
	ssccall( 'data_set_array', data, 'ur_yearzero_usage_peaks', ur_yearzero_usage_peaks );
	federal_tax_rate =[ 21 ];
	ssccall( 'data_set_array', data, 'federal_tax_rate', federal_tax_rate );
	state_tax_rate =[ 7 ];
	ssccall( 'data_set_array', data, 'state_tax_rate', state_tax_rate );
	ssccall('data_set_number', data, 'property_tax_rate', 0);
	ssccall('data_set_number', data, 'prop_tax_cost_assessed_percent', 100);
	ssccall('data_set_number', data, 'prop_tax_assessed_decline', 0);
	ssccall('data_set_number', data, 'real_discount_rate', 6.4000000000000004);
	ssccall('data_set_number', data, 'insurance_rate', 0);
	ssccall('data_set_number', data, 'loan_term', 25);
	ssccall('data_set_number', data, 'loan_rate', 4);
	ssccall('data_set_number', data, 'debt_fraction', 100);
	om_fixed =[ 0 ];
	ssccall( 'data_set_array', data, 'om_fixed', om_fixed );
	ssccall('data_set_number', data, 'om_fixed_escal', 0);
	om_production =[ 0 ];
	ssccall( 'data_set_array', data, 'om_production', om_production );
	ssccall('data_set_number', data, 'om_production_escal', 0);
	om_capacity =[ 16 ];
	ssccall( 'data_set_array', data, 'om_capacity', om_capacity );
	ssccall('data_set_number', data, 'om_capacity_escal', 0);
	ssccall('data_set_number', data, 'depr_fed_type', 1);
	ssccall('data_set_number', data, 'depr_fed_sl_years', 7);
	depr_fed_custom =[ 0 ];
	ssccall( 'data_set_array', data, 'depr_fed_custom', depr_fed_custom );
	ssccall('data_set_number', data, 'depr_sta_type', 1);
	ssccall('data_set_number', data, 'depr_sta_sl_years', 7);
	depr_sta_custom =[ 0 ];
	ssccall( 'data_set_array', data, 'depr_sta_custom', depr_sta_custom );
	ssccall('data_set_number', data, 'itc_fed_amount', 0);
	ssccall('data_set_number', data, 'itc_fed_amount_deprbas_fed', 1);
	ssccall('data_set_number', data, 'itc_fed_amount_deprbas_sta', 1);
	ssccall('data_set_number', data, 'itc_sta_amount', 0);
	ssccall('data_set_number', data, 'itc_sta_amount_deprbas_fed', 0);
	ssccall('data_set_number', data, 'itc_sta_amount_deprbas_sta', 0);
	ssccall('data_set_number', data, 'itc_fed_percent', 26);
	ssccall('data_set_number', data, 'itc_fed_percent_maxvalue', 9.9999999999999998e+37);
	ssccall('data_set_number', data, 'itc_fed_percent_deprbas_fed', 1);
	ssccall('data_set_number', data, 'itc_fed_percent_deprbas_sta', 1);
	ssccall('data_set_number', data, 'itc_sta_percent', 0);
	ssccall('data_set_number', data, 'itc_sta_percent_maxvalue', 9.9999999999999998e+37);
	ssccall('data_set_number', data, 'itc_sta_percent_deprbas_fed', 0);
	ssccall('data_set_number', data, 'itc_sta_percent_deprbas_sta', 0);
	ptc_fed_amount =[ 0 ];
	ssccall( 'data_set_array', data, 'ptc_fed_amount', ptc_fed_amount );
	ssccall('data_set_number', data, 'ptc_fed_term', 10);
	ssccall('data_set_number', data, 'ptc_fed_escal', 0);
	ptc_sta_amount =[ 0 ];
	ssccall( 'data_set_array', data, 'ptc_sta_amount', ptc_sta_amount );
	ssccall('data_set_number', data, 'ptc_sta_term', 10);
	ssccall('data_set_number', data, 'ptc_sta_escal', 0);
	ssccall('data_set_number', data, 'ibi_fed_amount', 0);
	ssccall('data_set_number', data, 'ibi_fed_amount_tax_fed', 1);
	ssccall('data_set_number', data, 'ibi_fed_amount_tax_sta', 1);
	ssccall('data_set_number', data, 'ibi_fed_amount_deprbas_fed', 0);
	ssccall('data_set_number', data, 'ibi_fed_amount_deprbas_sta', 0);
	ssccall('data_set_number', data, 'ibi_sta_amount', 0);
	ssccall('data_set_number', data, 'ibi_sta_amount_tax_fed', 1);
	ssccall('data_set_number', data, 'ibi_sta_amount_tax_sta', 1);
	ssccall('data_set_number', data, 'ibi_sta_amount_deprbas_fed', 0);
	ssccall('data_set_number', data, 'ibi_sta_amount_deprbas_sta', 0);
	ssccall('data_set_number', data, 'ibi_uti_amount', 0);
	ssccall('data_set_number', data, 'ibi_uti_amount_tax_fed', 1);
	ssccall('data_set_number', data, 'ibi_uti_amount_tax_sta', 1);
	ssccall('data_set_number', data, 'ibi_uti_amount_deprbas_fed', 0);
	ssccall('data_set_number', data, 'ibi_uti_amount_deprbas_sta', 0);
	ssccall('data_set_number', data, 'ibi_oth_amount', 0);
	ssccall('data_set_number', data, 'ibi_oth_amount_tax_fed', 1);
	ssccall('data_set_number', data, 'ibi_oth_amount_tax_sta', 1);
	ssccall('data_set_number', data, 'ibi_oth_amount_deprbas_fed', 0);
	ssccall('data_set_number', data, 'ibi_oth_amount_deprbas_sta', 0);
	ssccall('data_set_number', data, 'ibi_fed_percent', 0);
	ssccall('data_set_number', data, 'ibi_fed_percent_maxvalue', 9.9999999999999998e+37);
	ssccall('data_set_number', data, 'ibi_fed_percent_tax_fed', 1);
	ssccall('data_set_number', data, 'ibi_fed_percent_tax_sta', 1);
	ssccall('data_set_number', data, 'ibi_fed_percent_deprbas_fed', 0);
	ssccall('data_set_number', data, 'ibi_fed_percent_deprbas_sta', 0);
	ssccall('data_set_number', data, 'ibi_sta_percent', 0);
	ssccall('data_set_number', data, 'ibi_sta_percent_maxvalue', 9.9999999999999998e+37);
	ssccall('data_set_number', data, 'ibi_sta_percent_tax_fed', 1);
	ssccall('data_set_number', data, 'ibi_sta_percent_tax_sta', 1);
	ssccall('data_set_number', data, 'ibi_sta_percent_deprbas_fed', 0);
	ssccall('data_set_number', data, 'ibi_sta_percent_deprbas_sta', 0);
	ssccall('data_set_number', data, 'ibi_uti_percent', 0);
	ssccall('data_set_number', data, 'ibi_uti_percent_maxvalue', 9.9999999999999998e+37);
	ssccall('data_set_number', data, 'ibi_uti_percent_tax_fed', 1);
	ssccall('data_set_number', data, 'ibi_uti_percent_tax_sta', 1);
	ssccall('data_set_number', data, 'ibi_uti_percent_deprbas_fed', 0);
	ssccall('data_set_number', data, 'ibi_uti_percent_deprbas_sta', 0);
	ssccall('data_set_number', data, 'ibi_oth_percent', 0);
	ssccall('data_set_number', data, 'ibi_oth_percent_maxvalue', 9.9999999999999998e+37);
	ssccall('data_set_number', data, 'ibi_oth_percent_tax_fed', 1);
	ssccall('data_set_number', data, 'ibi_oth_percent_tax_sta', 1);
	ssccall('data_set_number', data, 'ibi_oth_percent_deprbas_fed', 0);
	ssccall('data_set_number', data, 'ibi_oth_percent_deprbas_sta', 0);
	ssccall('data_set_number', data, 'cbi_fed_amount', 0);
	ssccall('data_set_number', data, 'cbi_fed_maxvalue', 9.9999999999999998e+37);
	ssccall('data_set_number', data, 'cbi_fed_tax_fed', 1);
	ssccall('data_set_number', data, 'cbi_fed_tax_sta', 1);
	ssccall('data_set_number', data, 'cbi_fed_deprbas_fed', 0);
	ssccall('data_set_number', data, 'cbi_fed_deprbas_sta', 0);
	ssccall('data_set_number', data, 'cbi_sta_amount', 0);
	ssccall('data_set_number', data, 'cbi_sta_maxvalue', 9.9999999999999998e+37);
	ssccall('data_set_number', data, 'cbi_sta_tax_fed', 1);
	ssccall('data_set_number', data, 'cbi_sta_tax_sta', 1);
	ssccall('data_set_number', data, 'cbi_sta_deprbas_fed', 0);
	ssccall('data_set_number', data, 'cbi_sta_deprbas_sta', 0);
	ssccall('data_set_number', data, 'cbi_uti_amount', 0);
	ssccall('data_set_number', data, 'cbi_uti_maxvalue', 9.9999999999999998e+37);
	ssccall('data_set_number', data, 'cbi_uti_tax_fed', 1);
	ssccall('data_set_number', data, 'cbi_uti_tax_sta', 1);
	ssccall('data_set_number', data, 'cbi_uti_deprbas_fed', 0);
	ssccall('data_set_number', data, 'cbi_uti_deprbas_sta', 0);
	ssccall('data_set_number', data, 'cbi_oth_amount', 0);
	ssccall('data_set_number', data, 'cbi_oth_maxvalue', 9.9999999999999998e+37);
	ssccall('data_set_number', data, 'cbi_oth_tax_fed', 1);
	ssccall('data_set_number', data, 'cbi_oth_tax_sta', 1);
	ssccall('data_set_number', data, 'cbi_oth_deprbas_fed', 0);
	ssccall('data_set_number', data, 'cbi_oth_deprbas_sta', 0);
	pbi_fed_amount =[ 0 ];
	ssccall( 'data_set_array', data, 'pbi_fed_amount', pbi_fed_amount );
	ssccall('data_set_number', data, 'pbi_fed_term', 10);
	ssccall('data_set_number', data, 'pbi_fed_escal', 0);
	ssccall('data_set_number', data, 'pbi_fed_tax_fed', 1);
	ssccall('data_set_number', data, 'pbi_fed_tax_sta', 1);
	pbi_sta_amount =[ 0 ];
	ssccall( 'data_set_array', data, 'pbi_sta_amount', pbi_sta_amount );
	ssccall('data_set_number', data, 'pbi_sta_term', 10);
	ssccall('data_set_number', data, 'pbi_sta_escal', 0);
	ssccall('data_set_number', data, 'pbi_sta_tax_fed', 1);
	ssccall('data_set_number', data, 'pbi_sta_tax_sta', 1);
	pbi_uti_amount =[ 0 ];
	ssccall( 'data_set_array', data, 'pbi_uti_amount', pbi_uti_amount );
	ssccall('data_set_number', data, 'pbi_uti_term', 10);
	ssccall('data_set_number', data, 'pbi_uti_escal', 0);
	ssccall('data_set_number', data, 'pbi_uti_tax_fed', 1);
	ssccall('data_set_number', data, 'pbi_uti_tax_sta', 1);
	pbi_oth_amount =[ 0 ];
	ssccall( 'data_set_array', data, 'pbi_oth_amount', pbi_oth_amount );
	ssccall('data_set_number', data, 'pbi_oth_term', 10);
	ssccall('data_set_number', data, 'pbi_oth_escal', 0);
	ssccall('data_set_number', data, 'pbi_oth_tax_fed', 1);
	ssccall('data_set_number', data, 'pbi_oth_tax_sta', 1);
	ssccall('data_set_number', data, 'total_installed_cost', 1719251.2);
	ssccall('data_set_number', data, 'salvage_percentage', 0);
	ssccall('data_set_number', data, 'batt_salvage_percentage', 0);
	module = ssccall('module_create', 'pvwattsv8'); 
	ok = ssccall('module_exec', module, data);
	if ~ok,
		disp('pvwattsv8 errors:'); 
		ii=0;
		while 1,
			err = ssccall('module_log', module, ii);
			if strcmp(err,''),
			      break;
			end
			disp( err );
			ii=ii+1;
		end
		return 
	end
	ssccall('module_free', module);
	module = ssccall('module_create', 'grid'); 
	ok = ssccall('module_exec', module, data);
	if ~ok,
		disp('grid errors:'); 
		ii=0;
		while 1,
			err = ssccall('module_log', module, ii);
			if strcmp(err,''),
			      break;
			end
			disp( err );
			ii=ii+1;
		end
		return 
	end
	ssccall('module_free', module);
	module = ssccall('module_create', 'utilityrate5'); 
	ok = ssccall('module_exec', module, data);
	if ~ok,
		disp('utilityrate5 errors:'); 
		ii=0;
		while 1,
			err = ssccall('module_log', module, ii);
			if strcmp(err,''),
			      break;
			end
			disp( err );
			ii=ii+1;
		end
		return 
	end
	ssccall('module_free', module);
	module = ssccall('module_create', 'cashloan'); 
	ok = ssccall('module_exec', module, data);
	if ~ok,
		disp('cashloan errors:'); 
		ii=0;
		while 1,
			err = ssccall('module_log', module, ii);
			if strcmp(err,''),
			      break;
			end
			disp( err );
			ii=ii+1;
		end
		return 
	end
	ssccall('module_free', module);
	annual_energy = ssccall('data_get_number', data, 'annual_energy' );
	disp(sprintf('%s = %g', 'Annual energy (year 1)', annual_energy));
	capacity_factor = ssccall('data_get_number', data, 'capacity_factor' );
	disp(sprintf('%s = %g', 'Capacity factor (year 1)', capacity_factor));
	kwh_per_kw = ssccall('data_get_number', data, 'kwh_per_kw' );
	disp(sprintf('%s = %g', 'Energy yield (year 1)', kwh_per_kw));
	lcoe_nom = ssccall('data_get_number', data, 'lcoe_nom' );
	disp(sprintf('%s = %g', 'Levelized COE (nominal)', lcoe_nom));
	lcoe_real = ssccall('data_get_number', data, 'lcoe_real' );
	disp(sprintf('%s = %g', 'Levelized COE (real)', lcoe_real));
	elec_cost_without_system_year1 = ssccall('data_get_number', data, 'elec_cost_without_system_year1' );
	disp(sprintf('%s = %g', 'Electricity bill without system (year 1)', elec_cost_without_system_year1));
	elec_cost_with_system_year1 = ssccall('data_get_number', data, 'elec_cost_with_system_year1' );
	disp(sprintf('%s = %g', 'Electricity bill with system (year 1)', elec_cost_with_system_year1));
	savings_year1 = ssccall('data_get_number', data, 'savings_year1' );
	disp(sprintf('%s = %g', 'Net savings with system (year 1)', savings_year1));
	npv = ssccall('data_get_number', data, 'npv' );
	disp(sprintf('%s = %g', 'Net present value', npv));
	payback = ssccall('data_get_number', data, 'payback' );
	disp(sprintf('%s = %g', 'Simple payback period', payback));
	discounted_payback = ssccall('data_get_number', data, 'discounted_payback' );
	disp(sprintf('%s = %g', 'Discounted payback period', discounted_payback));
	adjusted_installed_cost = ssccall('data_get_number', data, 'adjusted_installed_cost' );
	disp(sprintf('%s = %g', 'Net capital cost', adjusted_installed_cost));
	first_cost = ssccall('data_get_number', data, 'first_cost' );
	disp(sprintf('%s = %g', 'Equity', first_cost));
	loan_amount = ssccall('data_get_number', data, 'loan_amount' );
	disp(sprintf('%s = %g', 'Debt', loan_amount));
	ssccall('data_free', data);
	ssccall('unload');
end