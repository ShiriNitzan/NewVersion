function untitled__1_
	function [result] = ssccall(action, arg0, arg1, arg2 ) %% sscall function
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
    end %% sscall end function
%%  verification for nulls

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
%% 

	clear
	ssccall('load');
	disp('Current folder = C:/Users/jvjos/Desktop/System'); %%project folder path
	disp(sprintf('SSC Version = %d', ssccall('version')));
	disp(sprintf('SSC Build Information = %s', ssccall('build_info')));
	ssccall('module_exec_set_print',0);
	data = ssccall('data_create');
	ssccall('data_set_string', data, 'solar_resource_file', 'C:/Users/jvjos/SAM Downloaded Weather Files/israel_31.182882_34.811615_msg-iodc_30_2019.csv'); %%climate data file - in this case israel, 2019, 30 min resolution
	ssccall('data_set_number', data, 'transformer_no_load_loss', 0);
	ssccall('data_set_number', data, 'transformer_load_loss', 0);
	ssccall('data_set_number', data, 'system_use_lifetime_output', 1);
    %% financial parameters
   
	ssccall('data_set_number', data, 'analysis_period', 25); %% financial parameters
    
    %% lifetime and degregation
    
	dc_degradation =[ 0.5 ]; %% lifetime degregation - %\year
	ssccall( 'data_set_array', data, 'dc_degradation', dc_degradation );
	ssccall('data_set_number', data, 'en_dc_lifetime_losses', 0);
	dc_lifetime_losses = csvread( 'C:/Users/jvjos/Desktop/System/dc_lifetime_losses.csv'); %% file added to folder
	ssccall( 'data_set_array', data, 'dc_lifetime_losses', dc_lifetime_losses );
	ssccall('data_set_number', data, 'en_ac_lifetime_losses', 0);
	ac_lifetime_losses = csvread( 'C:/Users/jvjos/Desktop/System/ac_lifetime_losses.csv'); %% file added to folder
	ssccall( 'data_set_array', data, 'ac_lifetime_losses', ac_lifetime_losses );
	ssccall('data_set_number', data, 'save_full_lifetime_variables', 1);
	ssccall('data_set_number', data, 'en_snow_model', 0);
    
    %% system design
    
 	ssccall('data_set_number', data, 'system_capacity', 50002.22178); %% system dedign
	ssccall('data_set_number', data, 'use_wf_albedo', 0); 
	albedo =[ 0.20000000000000001; 0.20000000000000001; 0.20000000000000001; 0.20000000000000001; 0.20000000000000001; 0.20000000000000001; 0.20000000000000001; 0.20000000000000001; 0.20000000000000001; 0.20000000000000001; 0.20000000000000001; 0.20000000000000001 ]; %% albedo values- not sure where these values came from
	ssccall( 'data_set_array', data, 'albedo', albedo );
	ssccall('data_set_number', data, 'irrad_mode', 0); 
	ssccall('data_set_number', data, 'sky_model', 2); 
	ssccall('data_set_number', data, 'inverter_count', 54); %% system design - # num of inverters
	ssccall('data_set_number', data, 'enable_mismatch_vmax_calc', 0);
	ssccall('data_set_number', data, 'subarray1_nstrings', 13435); %% system design - strings in parallel
	ssccall('data_set_number', data, 'subarray1_modules_per_string', 12); %% system - design
	ssccall('data_set_number', data, 'subarray1_mppt_input', 1); %% maximum power point track - 
	ssccall('data_set_number', data, 'subarray1_tilt', 30); %% system design - tilt angel
	ssccall('data_set_number', data, 'subarray1_tilt_eq_lat', 0); 
	ssccall('data_set_number', data, 'subarray1_azimuth', 180); %% system desgin azimuth in degrees - 180 is south
	ssccall('data_set_number', data, 'subarray1_track_mode', 0); %% track mode - 0 is fixed
	ssccall('data_set_number', data, 'subarray1_rotlim', 45); %% tracker rotation limit
	ssccall('data_set_number', data, 'subarray1_shade_mode', 0); 
	ssccall('data_set_number', data, 'subarray1_gcr', 0.29999999999999999); %% system design - groung coverage ratio
	ssccall('data_set_number', data, 'subarray1_slope_tilt', 0); %% system desgin-  slope tilt
	ssccall('data_set_number', data, 'subarray1_slope_azm', 0); %% system desgin-  slope azimuth
	subarray1_monthly_tilt =[ 40; 40; 40; 20; 20; 20; 20; 20; 20; 40; 40; 40 ]; %% 
	ssccall( 'data_set_array', data, 'subarray1_monthly_tilt', subarray1_monthly_tilt );
	subarray1_soiling =[ 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5 ];
	ssccall( 'data_set_array', data, 'subarray1_soiling', subarray1_soiling );
	ssccall('data_set_number', data, 'subarray1_rear_irradiance_loss', 0);
	ssccall('data_set_number', data, 'subarray1_mismatch_loss', 2);
	ssccall('data_set_number', data, 'subarray1_diodeconn_loss', 0.5);
	ssccall('data_set_number', data, 'subarray1_dcwiring_loss', 2);
	ssccall('data_set_number', data, 'subarray1_tracking_loss', 0);
	ssccall('data_set_number', data, 'subarray1_nameplate_loss', 0);
	ssccall('data_set_number', data, 'subarray2_rear_irradiance_loss', 0);
	ssccall('data_set_number', data, 'subarray2_mismatch_loss', 2);
	ssccall('data_set_number', data, 'subarray2_diodeconn_loss', 0.5);
	ssccall('data_set_number', data, 'subarray2_dcwiring_loss', 2);
	ssccall('data_set_number', data, 'subarray2_tracking_loss', 0);
	ssccall('data_set_number', data, 'subarray2_nameplate_loss', 0);
	ssccall('data_set_number', data, 'subarray3_rear_irradiance_loss', 0);
	ssccall('data_set_number', data, 'subarray3_mismatch_loss', 2);
	ssccall('data_set_number', data, 'subarray3_diodeconn_loss', 0.5);
	ssccall('data_set_number', data, 'subarray3_dcwiring_loss', 2);
	ssccall('data_set_number', data, 'subarray3_tracking_loss', 0);
	ssccall('data_set_number', data, 'subarray3_nameplate_loss', 0);
	ssccall('data_set_number', data, 'subarray4_rear_irradiance_loss', 0);
	ssccall('data_set_number', data, 'subarray4_mismatch_loss', 2);
	ssccall('data_set_number', data, 'subarray4_diodeconn_loss', 0.5);
	ssccall('data_set_number', data, 'subarray4_dcwiring_loss', 2);
	ssccall('data_set_number', data, 'subarray4_tracking_loss', 0);
	ssccall('data_set_number', data, 'subarray4_nameplate_loss', 0);
    
    %% Losses
    
	ssccall('data_set_number', data, 'dcoptimizer_loss', 0); %% dc power optimizer loss
	ssccall('data_set_number', data, 'acwiring_loss', 1); %% ac wiring loss - percentage
	ssccall('data_set_number', data, 'transmission_loss', 0); %% percentage
	ssccall('data_set_number', data, 'subarray1_mod_orient', 0); %%
    
    %% Shading and layout
    
	ssccall('data_set_number', data, 'subarray1_nmodx', 48); %% number of modules in row
	ssccall('data_set_number', data, 'subarray1_nmody', 2); %% number of modules in column
	ssccall('data_set_number', data, 'subarray1_backtrack', 0);
	ssccall('data_set_number', data, 'subarray2_enable', 0);
	ssccall('data_set_number', data, 'subarray2_modules_per_string', 0);
	ssccall('data_set_number', data, 'subarray2_nstrings', 0);
	ssccall('data_set_number', data, 'subarray2_mppt_input', 1);
	ssccall('data_set_number', data, 'subarray2_tilt', 20);
	ssccall('data_set_number', data, 'subarray2_tilt_eq_lat', 0);
	ssccall('data_set_number', data, 'subarray2_azimuth', 180);
	ssccall('data_set_number', data, 'subarray2_track_mode', 0);
	ssccall('data_set_number', data, 'subarray2_rotlim', 45);
	ssccall('data_set_number', data, 'subarray2_shade_mode', 0);
	ssccall('data_set_number', data, 'subarray2_gcr', 0.29999999999999999); %% Ground Coverage Ratio
	ssccall('data_set_number', data, 'subarray2_slope_tilt', 0); %% teraain slope (degrees)
	ssccall('data_set_number', data, 'subarray2_slope_azm', 0); %% terrain azimuth (degrees)
	subarray2_monthly_tilt =[ 40; 40; 40; 20; 20; 20; 20; 20; 20; 40; 40; 40 ];
	ssccall( 'data_set_array', data, 'subarray2_monthly_tilt', subarray2_monthly_tilt );
	subarray2_soiling =[ 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5 ];
	ssccall( 'data_set_array', data, 'subarray2_soiling', subarray2_soiling );
	ssccall('data_set_number', data, 'subarray2_mod_orient', 0);
	ssccall('data_set_number', data, 'subarray2_nmodx', 9);
	ssccall('data_set_number', data, 'subarray2_nmody', 2);
	ssccall('data_set_number', data, 'subarray2_backtrack', 0);
	ssccall('data_set_number', data, 'subarray3_enable', 0);
	ssccall('data_set_number', data, 'subarray3_modules_per_string', 0);
	ssccall('data_set_number', data, 'subarray3_nstrings', 0);
	ssccall('data_set_number', data, 'subarray3_mppt_input', 1);
	ssccall('data_set_number', data, 'subarray3_tilt', 20);
	ssccall('data_set_number', data, 'subarray3_tilt_eq_lat', 0);
	ssccall('data_set_number', data, 'subarray3_azimuth', 180);
	ssccall('data_set_number', data, 'subarray3_track_mode', 0);
	ssccall('data_set_number', data, 'subarray3_rotlim', 45);
	ssccall('data_set_number', data, 'subarray3_shade_mode', 0);
	ssccall('data_set_number', data, 'subarray3_gcr', 0.29999999999999999);
	ssccall('data_set_number', data, 'subarray3_slope_tilt', 0);
	ssccall('data_set_number', data, 'subarray3_slope_azm', 0);
	subarray3_monthly_tilt =[ 40; 40; 40; 20; 20; 20; 20; 20; 20; 40; 40; 40 ];
	ssccall( 'data_set_array', data, 'subarray3_monthly_tilt', subarray3_monthly_tilt );
	subarray3_soiling =[ 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5 ];
	ssccall( 'data_set_array', data, 'subarray3_soiling', subarray3_soiling );
	ssccall('data_set_number', data, 'subarray3_mod_orient', 0);
	ssccall('data_set_number', data, 'subarray3_nmodx', 9);
	ssccall('data_set_number', data, 'subarray3_nmody', 2);
	ssccall('data_set_number', data, 'subarray3_backtrack', 0);
	ssccall('data_set_number', data, 'subarray4_enable', 0);
	ssccall('data_set_number', data, 'subarray4_modules_per_string', 0);
	ssccall('data_set_number', data, 'subarray4_nstrings', 0);
	ssccall('data_set_number', data, 'subarray4_mppt_input', 1);
	ssccall('data_set_number', data, 'subarray4_tilt', 20);
	ssccall('data_set_number', data, 'subarray4_tilt_eq_lat', 0);
	ssccall('data_set_number', data, 'subarray4_azimuth', 180);
	ssccall('data_set_number', data, 'subarray4_track_mode', 0);
	ssccall('data_set_number', data, 'subarray4_rotlim', 45);
	ssccall('data_set_number', data, 'subarray4_shade_mode', 0);
	ssccall('data_set_number', data, 'subarray4_gcr', 0.29999999999999999);
	ssccall('data_set_number', data, 'subarray4_slope_tilt', 0);
	ssccall('data_set_number', data, 'subarray4_slope_azm', 0);
	subarray4_monthly_tilt =[ 40; 40; 40; 20; 20; 20; 20; 20; 20; 40; 40; 40 ];
	ssccall( 'data_set_array', data, 'subarray4_monthly_tilt', subarray4_monthly_tilt );
	subarray4_soiling =[ 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5 ];
	ssccall( 'data_set_array', data, 'subarray4_soiling', subarray4_soiling );
	ssccall('data_set_number', data, 'subarray4_mod_orient', 0);
	ssccall('data_set_number', data, 'subarray4_nmodx', 9);
	ssccall('data_set_number', data, 'subarray4_nmody', 2);
	ssccall('data_set_number', data, 'subarray4_backtrack', 0);
    
%% shading and layout

	ssccall('data_set_number', data, 'module_model', 1);
	ssccall('data_set_number', data, 'module_aspect_ratio', 1.7); %% module aspect ratio
	ssccall('data_set_number', data, 'spe_area', 0.74073999999999995);
	ssccall('data_set_number', data, 'spe_rad0', 200);
	ssccall('data_set_number', data, 'spe_rad1', 400);
	ssccall('data_set_number', data, 'spe_rad2', 600);
	ssccall('data_set_number', data, 'spe_rad3', 800);
	ssccall('data_set_number', data, 'spe_rad4', 1000);
	ssccall('data_set_number', data, 'spe_eff0', 13.5);
	ssccall('data_set_number', data, 'spe_eff1', 13.5);
	ssccall('data_set_number', data, 'spe_eff2', 13.5);
	ssccall('data_set_number', data, 'spe_eff3', 13.5);
	ssccall('data_set_number', data, 'spe_eff4', 13.5);
	ssccall('data_set_number', data, 'spe_reference', 4);
	ssccall('data_set_number', data, 'spe_module_structure', 0);
	ssccall('data_set_number', data, 'spe_a', -3.5600000000000001);
	ssccall('data_set_number', data, 'spe_b', -0.074999999999999997);
	ssccall('data_set_number', data, 'spe_dT', 3);
	ssccall('data_set_number', data, 'spe_temp_coeff', -0.5);
	ssccall('data_set_number', data, 'spe_fd', 1);
	ssccall('data_set_number', data, 'spe_vmp', 30);
	ssccall('data_set_number', data, 'spe_voc', 36);
	ssccall('data_set_number', data, 'spe_is_bifacial', 0);
	ssccall('data_set_number', data, 'spe_bifacial_transmission_factor', 0.012999999999999999);
	ssccall('data_set_number', data, 'spe_bifaciality', 0.65000000000000002);
	ssccall('data_set_number', data, 'spe_bifacial_ground_clearance_height', 1);
	ssccall('data_set_number', data, 'cec_area', 1.631);
	ssccall('data_set_number', data, 'cec_a_ref', 2.5776400000000002);
	ssccall('data_set_number', data, 'cec_adjust', 22.909172999999999);
	ssccall('data_set_number', data, 'cec_alpha_sc', 0.003735);
	ssccall('data_set_number', data, 'cec_beta_oc', -0.175619);
	ssccall('data_set_number', data, 'cec_gamma_r', -0.38600000000000001);
	ssccall('data_set_number', data, 'cec_i_l_ref', 6.0537280000000004);
	ssccall('data_set_number', data, 'cec_i_mp_ref', 5.6699999999999999);
	ssccall('data_set_number', data, 'cec_i_o_ref', 8.3604300000000002e-11);
	ssccall('data_set_number', data, 'cec_i_sc_ref', 6.0499999999999998);
	ssccall('data_set_number', data, 'cec_n_s', 96);
	ssccall('data_set_number', data, 'cec_r_s', 0.30812);
	ssccall('data_set_number', data, 'cec_r_sh_ref', 500.06892099999999);
	ssccall('data_set_number', data, 'cec_t_noct', 46);
	ssccall('data_set_number', data, 'cec_v_mp_ref', 54.700000000000003);
	ssccall('data_set_number', data, 'cec_v_oc_ref', 64.400000000000006);
	ssccall('data_set_number', data, 'cec_temp_corr_mode', 0);
	ssccall('data_set_number', data, 'cec_is_bifacial', 0);
	ssccall('data_set_number', data, 'cec_bifacial_transmission_factor', 0.012999999999999999);
	ssccall('data_set_number', data, 'cec_bifaciality', 0.65000000000000002);
	ssccall('data_set_number', data, 'cec_bifacial_ground_clearance_height', 1);
	ssccall('data_set_number', data, 'cec_standoff', 6);
	ssccall('data_set_number', data, 'cec_height', 0);
	ssccall('data_set_number', data, 'cec_mounting_config', 0);
	ssccall('data_set_number', data, 'cec_heat_transfer', 0);
	ssccall('data_set_number', data, 'cec_mounting_orientation', 0);
	ssccall('data_set_number', data, 'cec_gap_spacing', 0.050000000000000003); 
	ssccall('data_set_number', data, 'cec_module_width', 1); %% module
	ssccall('data_set_number', data, 'cec_module_length', 1.631); %% module
	ssccall('data_set_number', data, 'cec_array_rows', 1);
	ssccall('data_set_number', data, 'cec_array_cols', 10);
	ssccall('data_set_number', data, 'cec_backside_temp', 20);
	ssccall('data_set_number', data, 'cec_transient_thermal_model_unit_mass', 11.091900000000001);
	ssccall('data_set_number', data, '6par_celltech', 1);
	ssccall('data_set_number', data, '6par_vmp', 30);
	ssccall('data_set_number', data, '6par_imp', 6);
	ssccall('data_set_number', data, '6par_voc', 37);
	ssccall('data_set_number', data, '6par_isc', 7);
	ssccall('data_set_number', data, '6par_bvoc', -0.11);
	ssccall('data_set_number', data, '6par_aisc', 0.0040000000000000001);
	ssccall('data_set_number', data, '6par_gpmp', -0.40999999999999998);
	ssccall('data_set_number', data, '6par_nser', 60);
	ssccall('data_set_number', data, '6par_area', 1.3);
	ssccall('data_set_number', data, '6par_tnoct', 46);
	ssccall('data_set_number', data, '6par_standoff', 6);
	ssccall('data_set_number', data, '6par_mounting', 0);
	ssccall('data_set_number', data, '6par_is_bifacial', 0);
	ssccall('data_set_number', data, '6par_bifacial_transmission_factor', 0.012999999999999999);
	ssccall('data_set_number', data, '6par_bifaciality', 0.65000000000000002);
	ssccall('data_set_number', data, '6par_bifacial_ground_clearance_height', 1);
	ssccall('data_set_number', data, '6par_transient_thermal_model_unit_mass', 11.091900000000001);
	ssccall('data_set_number', data, 'snl_module_structure', 0);
	ssccall('data_set_number', data, 'snl_a', -3.6200000000000001);
	ssccall('data_set_number', data, 'snl_b', -0.074999999999999997);
	ssccall('data_set_number', data, 'snl_dtc', 3);
	ssccall('data_set_number', data, 'snl_ref_a', -3.6200000000000001);
	ssccall('data_set_number', data, 'snl_ref_b', -0.074999999999999997);
	ssccall('data_set_number', data, 'snl_ref_dT', 3);
	ssccall('data_set_number', data, 'snl_fd', 1);
	ssccall('data_set_number', data, 'snl_a0', 0.94045000000000001);
	ssccall('data_set_number', data, 'snl_a1', 0.052641);
	ssccall('data_set_number', data, 'snl_a2', -0.0093897000000000008);
	ssccall('data_set_number', data, 'snl_a3', 0.00072623000000000002);
	ssccall('data_set_number', data, 'snl_a4', -1.9938000000000001e-05);
	ssccall('data_set_number', data, 'snl_aimp', -0.00038000000000000002);
	ssccall('data_set_number', data, 'snl_aisc', 0.00060999999999999997);
	ssccall('data_set_number', data, 'snl_area', 1.244);
	ssccall('data_set_number', data, 'snl_b0', 1);
	ssccall('data_set_number', data, 'snl_b1', -0.0024380000000000001);
	ssccall('data_set_number', data, 'snl_b2', 0.00031030000000000001);
	ssccall('data_set_number', data, 'snl_b3', -1.2459999999999999e-05);
	ssccall('data_set_number', data, 'snl_b4', 2.11e-07);
	ssccall('data_set_number', data, 'snl_b5', -1.3600000000000001e-09);
	ssccall('data_set_number', data, 'snl_bvmpo', -0.13900000000000001);
	ssccall('data_set_number', data, 'snl_bvoco', -0.13600000000000001);
	ssccall('data_set_number', data, 'snl_c0', 1.0039);
	ssccall('data_set_number', data, 'snl_c1', -0.0038999999999999998);
	ssccall('data_set_number', data, 'snl_c2', 0.29106599999999999);
	ssccall('data_set_number', data, 'snl_c3', -4.7354599999999998);
	ssccall('data_set_number', data, 'snl_c4', 0.99419999999999997);
	ssccall('data_set_number', data, 'snl_c5', 0.0057999999999999996);
	ssccall('data_set_number', data, 'snl_c6', 1.0723);
	ssccall('data_set_number', data, 'snl_c7', -0.072300000000000003);
	ssccall('data_set_number', data, 'snl_impo', 5.25);
	ssccall('data_set_number', data, 'snl_isco', 5.75);
	ssccall('data_set_number', data, 'snl_ixo', 5.6500000000000004);
	ssccall('data_set_number', data, 'snl_ixxo', 3.8500000000000001);
	ssccall('data_set_number', data, 'snl_mbvmp', 0);
	ssccall('data_set_number', data, 'snl_mbvoc', 0);
	ssccall('data_set_number', data, 'snl_n', 1.2210000000000001);
	ssccall('data_set_number', data, 'snl_series_cells', 72);
	ssccall('data_set_number', data, 'snl_vmpo', 40);
	ssccall('data_set_number', data, 'snl_voco', 47.700000000000003);
	ssccall('data_set_number', data, 'snl_transient_thermal_model_unit_mass', 11.091900000000001);
	ssccall('data_set_number', data, 'sd11par_nser', 116);
	ssccall('data_set_number', data, 'sd11par_area', 0.71999999999999997);
	ssccall('data_set_number', data, 'sd11par_AMa0', 0.94169999999999998);
	ssccall('data_set_number', data, 'sd11par_AMa1', 0.065159999999999996);
	ssccall('data_set_number', data, 'sd11par_AMa2', -0.020219999999999998);
	ssccall('data_set_number', data, 'sd11par_AMa3', 0.0021900000000000001);
	ssccall('data_set_number', data, 'sd11par_AMa4', -9.1000000000000003e-05);
	ssccall('data_set_number', data, 'sd11par_glass', 0);
	ssccall('data_set_number', data, 'sd11par_tnoct', 44.899999999999999);
	ssccall('data_set_number', data, 'sd11par_standoff', 6);
	ssccall('data_set_number', data, 'sd11par_mounting', 0);
	ssccall('data_set_number', data, 'sd11par_Vmp0', 64.599999999999994);
	ssccall('data_set_number', data, 'sd11par_Imp0', 1.05);
	ssccall('data_set_number', data, 'sd11par_Voc0', 87);
	ssccall('data_set_number', data, 'sd11par_Isc0', 1.1799999999999999);
	ssccall('data_set_number', data, 'sd11par_alphaIsc', 0.000472001);
	ssccall('data_set_number', data, 'sd11par_n', 1.4507099999999999);
	ssccall('data_set_number', data, 'sd11par_Il', 1.1895100000000001);
	ssccall('data_set_number', data, 'sd11par_Io', 2.08522e-09);
	ssccall('data_set_number', data, 'sd11par_Egref', 0.73766799999999999);
	ssccall('data_set_number', data, 'sd11par_d1', 13.5504);
	ssccall('data_set_number', data, 'sd11par_d2', -0.0769735);
	ssccall('data_set_number', data, 'sd11par_d3', 0.23732700000000001);
	ssccall('data_set_number', data, 'sd11par_c1', 1930.1500000000001);
	ssccall('data_set_number', data, 'sd11par_c2', 474.63999999999999);
	ssccall('data_set_number', data, 'sd11par_c3', 1.48746);
    %% Inverter 
    
	ssccall('data_set_number', data, 'inverter_model', 0);
	ssccall('data_set_number', data, 'mppt_low_inverter', 545); %% iverter - table data
	ssccall('data_set_number', data, 'mppt_hi_inverter', 820); %% inverter table data
	ssccall('data_set_number', data, 'inv_num_mppt', 1); %% inverter
	ssccall('data_set_number', data, 'inv_snl_c0', -2.445577e-08); %% iverter
	ssccall('data_set_number', data, 'inv_snl_c1', 1.2e-05); %% inverter
	ssccall('data_set_number', data, 'inv_snl_c2', 0.0014610000000000001); %% inverter
	ssccall('data_set_number', data, 'inv_snl_c3', -0.000203); %% inverter
	ssccall('data_set_number', data, 'inv_snl_paco', 770000); %% max ac power
	ssccall('data_set_number', data, 'inv_snl_pdco', 791706.4375); %% max dc power
	ssccall('data_set_number', data, 'inv_snl_pnt', 231);%% power use at night
	ssccall('data_set_number', data, 'inv_snl_pso', 2859.5048830000001); 
	ssccall('data_set_number', data, 'inv_snl_vdco', 614); %% nominal dc voltage
	ssccall('data_set_number', data, 'inv_snl_vdcmax', 820); %% maximum mppt dc voltage
	ssccall('data_set_number', data, 'inv_cec_cg_c0', -3.0000000000000001e-06); %% inverter table
	ssccall('data_set_number', data, 'inv_cec_cg_c1', -5.1e-05); %% inverter table
	ssccall('data_set_number', data, 'inv_cec_cg_c2', 0.00098400000000000007); %% inveter table
	ssccall('data_set_number', data, 'inv_cec_cg_c3', -0.001508); %% inverter table
	ssccall('data_set_number', data, 'inv_cec_cg_paco', 3800); %% iverter table
	ssccall('data_set_number', data, 'inv_cec_cg_pdco', 3928.1100000000001); %% inverter table
	ssccall('data_set_number', data, 'inv_cec_cg_pnt', 0.98999999999999999); %% inverter table
	ssccall('data_set_number', data, 'inv_cec_cg_psco', 19.448399999999999); 
	ssccall('data_set_number', data, 'inv_cec_cg_vdco', 398.49700000000001); %% inverter table
	ssccall('data_set_number', data, 'inv_cec_cg_vdcmax', 600); %% inverter table
	ssccall('data_set_number', data, 'inv_ds_paco', 4000); %% inverter datasheet - maximium ac output power
	ssccall('data_set_number', data, 'inv_ds_eff', 96); %% inverter datasheet -  weighted effciency
	ssccall('data_set_number', data, 'inv_ds_pnt', 1); %% 
	ssccall('data_set_number', data, 'inv_ds_pso', 0);
	ssccall('data_set_number', data, 'inv_ds_vdco', 310); %% inverter datasheet - nominal dc voltage
	ssccall('data_set_number', data, 'inv_ds_vdcmax', 600); %% inverter data sheet - max dc voltage
	ssccall('data_set_number', data, 'inv_pd_paco', 4000); %% inverter part load - max av output power
	ssccall('data_set_number', data, 'inv_pd_pdco', 4210.5263157894742); %% 
    %%inverter part load % outer power
	inv_pd_partload =[ 0; 0.40400000000000003; 0.80800000000000005; 1.212; 1.6160000000000001; 2.02; 2.4239999999999999; 2.8279999999999998; 3.2320000000000002; 3.6360000000000001; 4.04; 4.444; 4.8479999999999999; 5.2519999999999998; 5.6559999999999997; 6.0599999999999996; 6.4640000000000004; 6.8680000000000003; 7.2720000000000002; 7.6760000000000002; 8.0800000000000001; 8.484; 8.8879999999999999; 9.2919999999999998; 9.6959999999999997; 10.1; 10.504; 10.907999999999999; 11.311999999999999; 11.715999999999999; 12.119999999999999; 12.523999999999999; 12.928000000000001; 13.332000000000001; 13.736000000000001; 14.140000000000001; 14.544; 14.948; 15.352; 15.756; 16.16; 16.564; 16.968; 17.372; 17.776; 18.18; 18.584; 18.988; 19.391999999999999; 19.795999999999999; 20.199999999999999; 20.603999999999999; 21.007999999999999; 21.411999999999999; 21.815999999999999; 22.219999999999999; 22.623999999999999; 23.027999999999999; 23.431999999999999; 23.835999999999999; 24.239999999999998; 24.643999999999998; 25.047999999999998; 25.452000000000002; 25.856000000000002; 26.260000000000002; 26.664000000000001; 27.068000000000001; 27.472000000000001; 27.876000000000001; 28.280000000000001; 28.684000000000001; 29.088000000000001; 29.492000000000001; 29.896000000000001; 30.300000000000001; 30.704000000000001; 31.108000000000001; 31.512; 31.916; 32.32; 32.723999999999997; 33.128; 33.531999999999996; 33.936; 34.340000000000003; 34.744; 35.148000000000003; 35.552; 35.956000000000003; 36.359999999999999; 36.764000000000003; 37.167999999999999; 37.572000000000003; 37.975999999999999; 38.380000000000003; 38.783999999999999; 39.188000000000002; 39.591999999999999; 39.996000000000002; 40.399999999999999; 40.804000000000002; 41.207999999999998; 41.612000000000002; 42.015999999999998; 42.420000000000002; 42.823999999999998; 43.228000000000002; 43.631999999999998; 44.036000000000001; 44.439999999999998; 44.844000000000001; 45.247999999999998; 45.652000000000001; 46.055999999999997; 46.460000000000001; 46.863999999999997; 47.268000000000001; 47.671999999999997; 48.076000000000001; 48.479999999999997; 48.884; 49.287999999999997; 49.692; 50.095999999999997; 50.5; 50.904000000000003; 51.308; 51.712000000000003; 52.116; 52.520000000000003; 52.923999999999999; 53.328000000000003; 53.731999999999999; 54.136000000000003; 54.539999999999999; 54.944000000000003; 55.347999999999999; 55.752000000000002; 56.155999999999999; 56.560000000000002; 56.963999999999999; 57.368000000000002; 57.771999999999998; 58.176000000000002; 58.579999999999998; 58.984000000000002; 59.387999999999998; 59.792000000000002; 60.195999999999998; 60.600000000000001; 61.003999999999998; 61.408000000000001; 61.811999999999998; 62.216000000000001; 62.619999999999997; 63.024000000000001; 63.427999999999997; 63.832000000000001; 64.236000000000004; 64.640000000000001; 65.043999999999997; 65.447999999999993; 65.852000000000004; 66.256; 66.659999999999997; 67.063999999999993; 67.468000000000004; 67.872; 68.275999999999996; 68.680000000000007; 69.084000000000003; 69.488; 69.891999999999996; 70.296000000000006; 70.700000000000003; 71.103999999999999; 71.507999999999996; 71.912000000000006; 72.316000000000003; 72.719999999999999; 73.123999999999995; 73.528000000000006; 73.932000000000002; 74.335999999999999; 74.739999999999995; 75.144000000000005; 75.548000000000002; 75.951999999999998; 76.355999999999995; 76.760000000000005; 77.164000000000001; 77.567999999999998; 77.971999999999994; 78.376000000000005; 78.780000000000001; 79.183999999999997; 79.587999999999994; 79.992000000000004; 80.396000000000001; 80.799999999999997; 81.203999999999994; 81.608000000000004; 82.012; 82.415999999999997; 82.819999999999993; 83.224000000000004; 83.628; 84.031999999999996; 84.436000000000007; 84.840000000000003; 85.244; 85.647999999999996; 86.052000000000007; 86.456000000000003; 86.859999999999999; 87.263999999999996; 87.668000000000006; 88.072000000000003; 88.475999999999999; 88.879999999999995; 89.284000000000006; 89.688000000000002; 90.091999999999999; 90.495999999999995; 90.900000000000006; 91.304000000000002; 91.707999999999998; 92.111999999999995; 92.516000000000005; 92.920000000000002; 93.323999999999998; 93.727999999999994; 94.132000000000005; 94.536000000000001; 94.939999999999998; 95.343999999999994; 95.748000000000005; 96.152000000000001; 96.555999999999997; 96.959999999999994; 97.364000000000004; 97.768000000000001; 98.171999999999997; 98.575999999999993; 98.980000000000004; 99.384; 99.787999999999997; 100.19199999999999; 100.596; 101 ];
	ssccall( 'data_set_array', data, 'inv_pd_partload', inv_pd_partload );
	%%inverter part load efficiency %
    inv_pd_efficiency =[ 0; 0; 34.420000000000002; 55.200000000000003; 65.590000000000003; 71.819999999999993; 75.969999999999999; 78.939999999999998; 81.170000000000002; 82.900000000000006; 84.280000000000001; 85.420000000000002; 86.359999999999999; 87.159999999999997; 87.840000000000003; 88.439999999999998; 88.950000000000003; 89.409999999999997; 89.819999999999993; 90.180000000000007; 90.510000000000005; 90.810000000000002; 91.079999999999998; 91.319999999999993; 91.549999999999997; 91.75; 91.950000000000003; 92.120000000000005; 92.290000000000006; 92.439999999999998; 92.579999999999998; 92.719999999999999; 92.840000000000003; 92.959999999999994; 93.069999999999993; 93.170000000000002; 93.269999999999996; 93.370000000000005; 93.450000000000003; 93.540000000000006; 93.620000000000005; 93.689999999999998; 93.760000000000005; 93.829999999999998; 93.900000000000006; 93.959999999999994; 94.019999999999996; 94.079999999999998; 94.129999999999995; 94.180000000000007; 94.230000000000004; 94.280000000000001; 94.329999999999998; 94.370000000000005; 94.420000000000002; 94.459999999999994; 94.5; 94.540000000000006; 94.569999999999993; 94.609999999999999; 94.640000000000001; 94.680000000000007; 94.709999999999994; 94.739999999999995; 94.769999999999996; 94.799999999999997; 94.829999999999998; 94.859999999999999; 94.890000000000001; 94.909999999999997; 94.939999999999998; 94.959999999999994; 94.980000000000004; 95.010000000000005; 95.030000000000001; 95.049999999999997; 95.069999999999993; 95.090000000000003; 95.109999999999999; 95.129999999999995; 95.150000000000006; 95.170000000000002; 95.189999999999998; 95.209999999999994; 95.230000000000004; 95.239999999999995; 95.260000000000005; 95.280000000000001; 95.290000000000006; 95.310000000000002; 95.319999999999993; 95.340000000000003; 95.349999999999994; 95.359999999999999; 95.379999999999995; 95.390000000000001; 95.400000000000006; 95.420000000000002; 95.430000000000007; 95.439999999999998; 95.450000000000003; 95.469999999999999; 95.480000000000004; 95.489999999999995; 95.5; 95.510000000000005; 95.519999999999996; 95.530000000000001; 95.540000000000006; 95.549999999999997; 95.560000000000002; 95.569999999999993; 95.579999999999998; 95.590000000000003; 95.599999999999994; 95.609999999999999; 95.620000000000005; 95.629999999999995; 95.640000000000001; 95.640000000000001; 95.650000000000006; 95.659999999999997; 95.670000000000002; 95.680000000000007; 95.680000000000007; 95.689999999999998; 95.700000000000003; 95.709999999999994; 95.709999999999994; 95.719999999999999; 95.730000000000004; 95.730000000000004; 95.739999999999995; 95.75; 95.75; 95.760000000000005; 95.769999999999996; 95.769999999999996; 95.780000000000001; 95.780000000000001; 95.790000000000006; 95.799999999999997; 95.799999999999997; 95.810000000000002; 95.810000000000002; 95.819999999999993; 95.819999999999993; 95.829999999999998; 95.829999999999998; 95.840000000000003; 95.840000000000003; 95.849999999999994; 95.849999999999994; 95.859999999999999; 95.859999999999999; 95.870000000000005; 95.870000000000005; 95.879999999999995; 95.879999999999995; 95.890000000000001; 95.890000000000001; 95.890000000000001; 95.900000000000006; 95.900000000000006; 95.909999999999997; 95.909999999999997; 95.909999999999997; 95.920000000000002; 95.920000000000002; 95.930000000000007; 95.930000000000007; 95.930000000000007; 95.939999999999998; 95.939999999999998; 95.939999999999998; 95.950000000000003; 95.950000000000003; 95.959999999999994; 95.959999999999994; 95.959999999999994; 95.969999999999999; 95.969999999999999; 95.969999999999999; 95.980000000000004; 95.980000000000004; 95.980000000000004; 95.980000000000004; 95.989999999999995; 95.989999999999995; 95.989999999999995; 96; 96; 96; 96.010000000000005; 96.010000000000005; 96.010000000000005; 96.010000000000005; 96.019999999999996; 96.019999999999996; 96.019999999999996; 96.019999999999996; 96.030000000000001; 96.030000000000001; 96.030000000000001; 96.030000000000001; 96.040000000000006; 96.040000000000006; 96.040000000000006; 96.040000000000006; 96.049999999999997; 96.049999999999997; 96.049999999999997; 96.049999999999997; 96.060000000000002; 96.060000000000002; 96.060000000000002; 96.060000000000002; 96.060000000000002; 96.069999999999993; 96.069999999999993; 96.069999999999993; 96.069999999999993; 96.069999999999993; 96.079999999999998; 96.079999999999998; 96.079999999999998; 96.079999999999998; 96.079999999999998; 96.090000000000003; 96.090000000000003; 96.090000000000003; 96.090000000000003; 96.090000000000003; 96.090000000000003; 96.099999999999994; 96.099999999999994; 96.099999999999994; 96.099999999999994; 96.099999999999994; 96.099999999999994; 96.109999999999999; 96.109999999999999; 96.109999999999999; 96.109999999999999; 96.109999999999999; 96.109999999999999; 96.120000000000005; 96.120000000000005; 96.120000000000005; 96.120000000000005; 96.120000000000005 ];
	ssccall( 'data_set_array', data, 'inv_pd_efficiency', inv_pd_efficiency );
	ssccall('data_set_number', data, 'inv_pd_pnt', 0);
	ssccall('data_set_number', data, 'inv_pd_vdco', 310); %% part 
	ssccall('data_set_number', data, 'inv_pd_vdcmax', 600);
	inv_tdc_cec_db =[ 800   28   -0.02   56   0 ; 600   52   -0.037499999999999999   60   0 ; 390   38   -0.012500000000000001   50   -0.025000000000000001 ];
	ssccall( 'data_set_matrix', data, 'inv_tdc_cec_db', inv_tdc_cec_db );
	inv_tdc_cec_cg =[ 800   28   -0.02   56   0 ; 600   52   -0.037499999999999999   60   0 ; 390   38   -0.012500000000000001   50   -0.025000000000000001 ];
	ssccall( 'data_set_matrix', data, 'inv_tdc_cec_cg', inv_tdc_cec_cg );
	inv_tdc_ds =[ 800   28   -0.02   56   0 ; 600   52   -0.037499999999999999   60   0 ; 390   38   -0.012500000000000001   50   -0.025000000000000001 ];
	ssccall( 'data_set_matrix', data, 'inv_tdc_ds', inv_tdc_ds );
	inv_tdc_plc =[ 800   28   -0.02   56   0 ; 600   52   -0.037499999999999999   60   0 ; 390   38   -0.012500000000000001   50   -0.025000000000000001 ];
	ssccall( 'data_set_matrix', data, 'inv_tdc_plc', inv_tdc_plc );
	ssccall('data_set_number', data, 'en_batt', 0);
	ssccall('data_set_number', data, 'adjust:constant', 0);
	ssccall('data_set_number', data, 'dc_adjust:constant', 0);
	ssccall('data_set_number', data, 'inv_snl_eff_cec', 97.586859621409602);
	ssccall('data_set_number', data, 'inv_pd_eff', 95);
	ssccall('data_set_number', data, 'inv_cec_cg_eff_cec', 96.60945631544223);
	ssccall('data_set_number', data, 'inflation_rate', 2.5);
	ppa_price_input =[ 0.10000000000000001 ];
	ssccall( 'data_set_array', data, 'ppa_price_input', ppa_price_input );
	ssccall('data_set_number', data, 'ppa_multiplier_model', 0);
    
    %% Revenues
    
	dispatch_factors_ts = csvread( 'C:/Users/jvjos/Desktop/System/dispatch_factors_ts.csv');
	ssccall( 'data_set_array', data, 'dispatch_factors_ts', dispatch_factors_ts );
	dispatch_tod_factors =[ 1; 1; 1; 1; 1; 1; 1; 1; 1 ]; %% TOD factors
	ssccall( 'data_set_array', data, 'dispatch_tod_factors', dispatch_tod_factors );
	%%weekday matrix 
    dispatch_sched_weekday =[ 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ];
	ssccall( 'data_set_matrix', data, 'dispatch_sched_weekday', dispatch_sched_weekday );
	%%weekend matrix
    dispatch_sched_weekend =[ 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ];
	ssccall( 'data_set_matrix', data, 'dispatch_sched_weekend', dispatch_sched_weekend );
	rate_escalation =[ 0 ];
	ssccall( 'data_set_array', data, 'rate_escalation', rate_escalation );
	ssccall('data_set_number', data, 'ur_metering_option', 4);
	ssccall('data_set_number', data, 'ur_nm_yearend_sell_rate', 0);
	ssccall('data_set_number', data, 'ur_nm_credit_month', 0);
	ssccall('data_set_number', data, 'ur_nm_credit_rollover', 0);
	ssccall('data_set_number', data, 'ur_monthly_fixed_charge', 0);
	ssccall('data_set_number', data, 'ur_monthly_min_charge', 0);
	ssccall('data_set_number', data, 'ur_annual_min_charge', 0);
	ssccall('data_set_number', data, 'ur_en_ts_sell_rate', 0);
	ur_ts_sell_rate =[ 0 ];
	ssccall( 'data_set_array', data, 'ur_ts_sell_rate', ur_ts_sell_rate );
	ssccall('data_set_number', data, 'ur_en_ts_buy_rate', 0);
	ur_ts_buy_rate =[ 0 ];
	ssccall( 'data_set_array', data, 'ur_ts_buy_rate', ur_ts_buy_rate );
	ur_ec_sched_weekday =[ 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ];
	ssccall( 'data_set_matrix', data, 'ur_ec_sched_weekday', ur_ec_sched_weekday );
	ur_ec_sched_weekend =[ 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ];
	ssccall( 'data_set_matrix', data, 'ur_ec_sched_weekend', ur_ec_sched_weekend );
	ur_ec_tou_mat =[ 1   1   9.9999999999999998e+37   0   0.044999999999999998   0 ];
	ssccall( 'data_set_matrix', data, 'ur_ec_tou_mat', ur_ec_tou_mat );
	ssccall('data_set_number', data, 'ur_dc_enable', 0);
	ur_dc_sched_weekday =[ 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ];
	ssccall( 'data_set_matrix', data, 'ur_dc_sched_weekday', ur_dc_sched_weekday );
	ur_dc_sched_weekend =[ 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ; 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 ];
	ssccall( 'data_set_matrix', data, 'ur_dc_sched_weekend', ur_dc_sched_weekend );
	ur_dc_tou_mat =[ 1   1   9.9999999999999998e+37   0 ];
	ssccall( 'data_set_matrix', data, 'ur_dc_tou_mat', ur_dc_tou_mat );
	ur_dc_flat_mat =[ 0   1   9.9999999999999998e+37   0 ; 1   1   9.9999999999999998e+37   0 ; 2   1   9.9999999999999998e+37   0 ; 3   1   9.9999999999999998e+37   0 ; 4   1   9.9999999999999998e+37   0 ; 5   1   9.9999999999999998e+37   0 ; 6   1   9.9999999999999998e+37   0 ; 7   1   9.9999999999999998e+37   0 ; 8   1   9.9999999999999998e+37   0 ; 9   1   9.9999999999999998e+37   0 ; 10   1   9.9999999999999998e+37   0 ; 11   1   9.9999999999999998e+37   0 ];
	ssccall( 'data_set_matrix', data, 'ur_dc_flat_mat', ur_dc_flat_mat );
	ssccall('data_set_number', data, 'ur_enable_billing_demand', 0);
	ssccall('data_set_number', data, 'ur_billing_demand_minimum', 100);
	ssccall('data_set_number', data, 'ur_billing_demand_lookback_period', 11);
	ur_billing_demand_lookback_percentages =[ 60   0 ; 60   0 ; 60   0 ; 60   0 ; 60   0 ; 95   1 ; 95   1 ; 95   1 ; 95   1 ; 60   0 ; 60   0 ; 60   0 ];
	ssccall( 'data_set_matrix', data, 'ur_billing_demand_lookback_percentages', ur_billing_demand_lookback_percentages );
	ur_dc_billing_demand_periods =[ 1   1 ];
	ssccall( 'data_set_matrix', data, 'ur_dc_billing_demand_periods', ur_dc_billing_demand_periods );
	ur_yearzero_usage_peaks =[ 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0 ];
	ssccall( 'data_set_array', data, 'ur_yearzero_usage_peaks', ur_yearzero_usage_peaks );
	grid_curtailment = csvread( 'C:/Users/jvjos/Desktop/System/grid_curtailment.csv'); %% read file
	ssccall( 'data_set_array', data, 'grid_curtailment', grid_curtailment );
	ssccall('data_set_number', data, 'enable_interconnection_limit', 0); 
	ssccall('data_set_number', data, 'grid_interconnection_limit_kwac', 100000); %% grid
	ssccall('data_set_number', data, 'en_electricity_rates', 0);
	degradation =[ 0 ];
	ssccall( 'data_set_array', data, 'degradation', degradation );
	ssccall('data_set_number', data, 'ppa_soln_mode', 0);
	ssccall('data_set_number', data, 'ppa_escalation', 1);
    
    %% financial parameters
	federal_tax_rate =[ 21 ]; %% federal tax rate
	ssccall( 'data_set_array', data, 'federal_tax_rate', federal_tax_rate ); 
	state_tax_rate =[ 7 ]; %% state tax rate
	ssccall( 'data_set_array', data, 'state_tax_rate', state_tax_rate );
	ssccall('data_set_number', data, 'property_tax_rate', 0);
	ssccall('data_set_number', data, 'prop_tax_cost_assessed_percent', 100); %% assessed oercentage of property taz
	ssccall('data_set_number', data, 'prop_tax_assessed_decline', 0); %% annual decline in property cosr
	ssccall('data_set_number', data, 'real_discount_rate', 6.4000000000000004); %% real discount rate
	ssccall('data_set_number', data, 'insurance_rate', 0.5); %% annual insurance rate - percentage
    
	%% Operating cost
    om_fixed =[ 0 ]; %%fixed annual cost
	ssccall( 'data_set_array', data, 'om_fixed', om_fixed ); 
	ssccall('data_set_number', data, 'om_fixed_escal', 0); %% escalation rate
	om_production =[ 0 ]; %% 
	ssccall( 'data_set_array', data, 'om_production', om_production );
	ssccall('data_set_number', data, 'om_production_escal', 0); %% escakation rate
	om_capacity =[ 17 ]; %% fixes cost by capacity
	ssccall( 'data_set_array', data, 'om_capacity', om_capacity );
	ssccall('data_set_number', data, 'om_capacity_escal', 0); %% escaltion rate
	ssccall('data_set_number', data, 'land_area', 64.976258135937485); %% land area estimate (acres)
	om_land_lease =[ 0 ]; %% lamd lease
	ssccall( 'data_set_array', data, 'om_land_lease', om_land_lease );
	ssccall('data_set_number', data, 'om_land_lease_escal', 0); %% land lease escalation
	ssccall('data_set_number', data, 'reserves_interest', 1.75); %% ine=terrest on reserves
	ssccall('data_set_number', data, 'equip1_reserve_cost', 0.25); %% equipment replacemnet reserve
	ssccall('data_set_number', data, 'equip1_reserve_freq', 12); %% replacemnet frequency - years
	ssccall('data_set_number', data, 'equip2_reserve_cost', 0);
	ssccall('data_set_number', data, 'equip2_reserve_freq', 15);
	ssccall('data_set_number', data, 'equip3_reserve_cost', 0);
	ssccall('data_set_number', data, 'equip3_reserve_freq', 3);
	ssccall('data_set_number', data, 'equip_reserve_depr_sta', 0);
	ssccall('data_set_number', data, 'equip_reserve_depr_fed', 0);
    
    %% incentives
    
	ssccall('data_set_number', data, 'itc_fed_amount', 0); %% investment tax credit - faderal 
	ssccall('data_set_number', data, 'itc_fed_amount_deprbas_fed', 1); %% reduces depreciation basis (check box)
	ssccall('data_set_number', data, 'itc_fed_amount_deprbas_sta', 1); %% reduces depreciation basis (check box)
	ssccall('data_set_number', data, 'itc_sta_amount', 0); %% investment tax credit - state 
	ssccall('data_set_number', data, 'itc_sta_amount_deprbas_fed', 0);
	ssccall('data_set_number', data, 'itc_sta_amount_deprbas_sta', 0);
	ssccall('data_set_number', data, 'itc_fed_percent', 26); %% federal percentage
	ssccall('data_set_number', data, 'itc_fed_percent_maxvalue', 9.9999999999999998e+37); %% maximum - written as 1*10^38
	ssccall('data_set_number', data, 'itc_fed_percent_deprbas_fed', 1); %% check box
	ssccall('data_set_number', data, 'itc_fed_percent_deprbas_sta', 1); %% check box
	ssccall('data_set_number', data, 'itc_sta_percent', 0); %% state percentage
	ssccall('data_set_number', data, 'itc_sta_percent_maxvalue', 9.9999999999999998e+37); %% maximum - written as 1*10^38
	ssccall('data_set_number', data, 'itc_sta_percent_deprbas_fed', 0); %% check box
	ssccall('data_set_number', data, 'itc_sta_percent_deprbas_sta', 0); %% check box
	ptc_fed_amount =[ 0 ]; %% PTC - fed amount
	ssccall( 'data_set_array', data, 'ptc_fed_amount', ptc_fed_amount ); %% fed amount - USD per kWh
	ssccall('data_set_number', data, 'ptc_fed_term', 10); %% term - years
	ssccall('data_set_number', data, 'ptc_fed_escal', 0); %% escelation - percent per year
	ptc_sta_amount =[ 0 ]; %% PTC - state amount
	ssccall( 'data_set_array', data, 'ptc_sta_amount', ptc_sta_amount ); 
	ssccall('data_set_number', data, 'ptc_sta_term', 10); %% term-  years
	ssccall('data_set_number', data, 'ptc_sta_escal', 0); %% escelation - percent per year
	
    %% Deprecation
    
    ssccall('data_set_number', data, 'depr_alloc_macrs_5_percent', 90);
	ssccall('data_set_number', data, 'depr_alloc_macrs_15_percent', 1.5);
	ssccall('data_set_number', data, 'depr_alloc_sl_5_percent', 0);
	ssccall('data_set_number', data, 'depr_alloc_sl_15_percent', 2.5);
	ssccall('data_set_number', data, 'depr_alloc_sl_20_percent', 3);
	ssccall('data_set_number', data, 'depr_alloc_sl_39_percent', 0);
	ssccall('data_set_number', data, 'depr_alloc_custom_percent', 0); %% last row int custom classes
	depr_custom_schedule =[ 0 ];
	ssccall( 'data_set_array', data, 'depr_custom_schedule', depr_custom_schedule );
	ssccall('data_set_number', data, 'depr_bonus_sta', 0);
	ssccall('data_set_number', data, 'depr_bonus_sta_macrs_5', 1); %% check box
	ssccall('data_set_number', data, 'depr_bonus_sta_macrs_15', 1); %% check box
	ssccall('data_set_number', data, 'depr_bonus_sta_sl_5', 0); %% check box
	ssccall('data_set_number', data, 'depr_bonus_sta_sl_15', 0); %% check box
	ssccall('data_set_number', data, 'depr_bonus_sta_sl_20', 0); %% check box
	ssccall('data_set_number', data, 'depr_bonus_sta_sl_39', 0); %% check box
	ssccall('data_set_number', data, 'depr_bonus_sta_custom', 0); %% checl box 
	ssccall('data_set_number', data, 'depr_bonus_fed', 0); 
	ssccall('data_set_number', data, 'depr_bonus_fed_macrs_5', 1); %% cehck box - row 1
	ssccall('data_set_number', data, 'depr_bonus_fed_macrs_15', 1); %% check box - row 2
	ssccall('data_set_number', data, 'depr_bonus_fed_sl_5', 0); %% check box - row 3
	ssccall('data_set_number', data, 'depr_bonus_fed_sl_15', 0); %% check box - row 4
	ssccall('data_set_number', data, 'depr_bonus_fed_sl_20', 0); %% check box - row 5
	ssccall('data_set_number', data, 'depr_bonus_fed_sl_39', 0); %% check box - row 6
	ssccall('data_set_number', data, 'depr_bonus_fed_custom', 0); %% check box - row 7
	ssccall('data_set_number', data, 'depr_itc_sta_macrs_5', 1); %% check box ITC - row 1
	ssccall('data_set_number', data, 'depr_itc_sta_macrs_15', 0); %% check box ITC  - ROW 2
	ssccall('data_set_number', data, 'depr_itc_sta_sl_5', 0); %% check box ITC  - ROW 3
	ssccall('data_set_number', data, 'depr_itc_sta_sl_15', 0); %% check box ITC  - ROW 4
	ssccall('data_set_number', data, 'depr_itc_sta_sl_20', 0); %% check box ITC  - ROW 5
	ssccall('data_set_number', data, 'depr_itc_sta_sl_39', 0); %% check box ITC  - ROW 6
	ssccall('data_set_number', data, 'depr_itc_sta_custom', 0); %% check box ITC  - ROW 7
	ssccall('data_set_number', data, 'depr_itc_fed_macrs_5', 1); %% check box ITC  - ROW 1
	ssccall('data_set_number', data, 'depr_itc_fed_macrs_15', 0); %% check box ITC  - ROW 2
	ssccall('data_set_number', data, 'depr_itc_fed_sl_5', 0); %% check box ITC  - ROW 3
	ssccall('data_set_number', data, 'depr_itc_fed_sl_15', 0); %% check box ITC  - ROW 4
	ssccall('data_set_number', data, 'depr_itc_fed_sl_20', 0); %% check box ITC  - ROW 5
	ssccall('data_set_number', data, 'depr_itc_fed_sl_39', 0); %% check box ITC  - ROW 6
	ssccall('data_set_number', data, 'depr_itc_fed_custom', 0); %% check box ITC  - ROW 7
    
    %% Incentives
    
	ssccall('data_set_number', data, 'ibi_fed_amount', 0); %% IBI fed amount
	ssccall('data_set_number', data, 'ibi_fed_amount_tax_fed', 1); %% check box IBI  - ROW 1
	ssccall('data_set_number', data, 'ibi_fed_amount_tax_sta', 1); %% check box IBI  - ROW 1
	ssccall('data_set_number', data, 'ibi_fed_amount_deprbas_fed', 0); %% check box IBI  - ROW 1
	ssccall('data_set_number', data, 'ibi_fed_amount_deprbas_sta', 0); %% check box IBI  - ROW 1
	ssccall('data_set_number', data, 'ibi_sta_amount', 0); %%IBI state amount
	ssccall('data_set_number', data, 'ibi_sta_amount_tax_fed', 1);%% check box IBI  - ROW 2
	ssccall('data_set_number', data, 'ibi_sta_amount_tax_sta', 1);%% check box IBI  - ROW 2
	ssccall('data_set_number', data, 'ibi_sta_amount_deprbas_fed', 0);%% check box IBI  - ROW 2
	ssccall('data_set_number', data, 'ibi_sta_amount_deprbas_sta', 0);%% check box IBI  - ROW 2
	ssccall('data_set_number', data, 'ibi_uti_amount', 0); %% IBI utitlity amount
	ssccall('data_set_number', data, 'ibi_uti_amount_tax_fed', 1); %% check box IBI  - ROW 3
	ssccall('data_set_number', data, 'ibi_uti_amount_tax_sta', 1); %% check box IBI  - ROW 3
	ssccall('data_set_number', data, 'ibi_uti_amount_deprbas_fed', 0); %% check box IBI  - ROW 3
	ssccall('data_set_number', data, 'ibi_uti_amount_deprbas_sta', 0); %% check box IBI  - ROW 3
	ssccall('data_set_number', data, 'ibi_oth_amount', 0); %% IBI other amount
	ssccall('data_set_number', data, 'ibi_oth_amount_tax_fed', 1); %% check box IBI  - ROW 4
	ssccall('data_set_number', data, 'ibi_oth_amount_tax_sta', 1); %% check box IBI  - ROW 4
	ssccall('data_set_number', data, 'ibi_oth_amount_deprbas_fed', 0); %% check box IBI  - ROW 4
	ssccall('data_set_number', data, 'ibi_oth_amount_deprbas_sta', 0); %% check box IBI  - ROW 4
	ssccall('data_set_number', data, 'ibi_fed_percent', 0); %% IBI federal percenatge - percentage
	ssccall('data_set_number', data, 'ibi_fed_percent_maxvalue', 9.9999999999999998e+37); %% IBI federal maximum amount - USD
 	ssccall('data_set_number', data, 'ibi_fed_percent_tax_fed', 1); %% check box IBI  - ROW 5
	ssccall('data_set_number', data, 'ibi_fed_percent_tax_sta', 1); %% check box IBI  - ROW 5
	ssccall('data_set_number', data, 'ibi_fed_percent_deprbas_fed', 0); %% check box IBI  - ROW 5
	ssccall('data_set_number', data, 'ibi_fed_percent_deprbas_sta', 0); %% check box IBI  - ROW 5
	ssccall('data_set_number', data, 'ibi_sta_percent', 0); %% IBI state percenatge - percentage
	ssccall('data_set_number', data, 'ibi_sta_percent_maxvalue', 9.9999999999999998e+37); %% IBI state maximum amount - USD
	ssccall('data_set_number', data, 'ibi_sta_percent_tax_fed', 1); %% check box IBI  - ROW 6
	ssccall('data_set_number', data, 'ibi_sta_percent_tax_sta', 1); %% check box IBI  - ROW 6
	ssccall('data_set_number', data, 'ibi_sta_percent_deprbas_fed', 0); %% check box IBI  - ROW 6
	ssccall('data_set_number', data, 'ibi_sta_percent_deprbas_sta', 0); %% check box IBI  - ROW 6
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
    
    %% Financial Parameters - Project term debt
    
	ssccall('data_set_number', data, 'term_tenor', 18);
	ssccall('data_set_number', data, 'term_int_rate', 7);
	ssccall('data_set_number', data, 'dscr', 1.3);
	ssccall('data_set_number', data, 'dscr_limit_debt_fraction', 0); %% chcek box
	ssccall('data_set_number', data, 'dscr_maximum_debt_fraction', 100); 
	ssccall('data_set_number', data, 'dscr_reserve_months', 6);
	ssccall('data_set_number', data, 'debt_percent', 60);
	ssccall('data_set_number', data, 'debt_option', 1);
	ssccall('data_set_number', data, 'payment_option', 0);
	ssccall('data_set_number', data, 'cost_debt_closing', 450000);
	ssccall('data_set_number', data, 'cost_debt_fee', 2.75);
    
    %% Financial Parameters - Reserve account
    
	ssccall('data_set_number', data, 'months_working_reserve', 6);
	ssccall('data_set_number', data, 'months_receivables_reserve', 0);
	ssccall('data_set_number', data, 'cost_other_financing', 0);
	ssccall('data_set_number', data, 'flip_target_percent', 11);
	ssccall('data_set_number', data, 'flip_target_year', 20);
	ssccall('data_set_number', data, 'pbi_fed_for_ds', 0);
	ssccall('data_set_number', data, 'pbi_sta_for_ds', 0);
	ssccall('data_set_number', data, 'pbi_uti_for_ds', 0);
	ssccall('data_set_number', data, 'pbi_oth_for_ds', 0);
	ssccall('data_set_number', data, 'loan_moratorium', 0);
	ssccall('data_set_number', data, 'dispatch_factor1', 1);
	ssccall('data_set_number', data, 'dispatch_factor2', 1);
	ssccall('data_set_number', data, 'dispatch_factor3', 1);
	ssccall('data_set_number', data, 'dispatch_factor4', 1);
	ssccall('data_set_number', data, 'dispatch_factor5', 1);
	ssccall('data_set_number', data, 'dispatch_factor6', 1);
	ssccall('data_set_number', data, 'dispatch_factor7', 1);
	ssccall('data_set_number', data, 'dispatch_factor8', 1);
	ssccall('data_set_number', data, 'dispatch_factor9', 1);
	ssccall('data_set_number', data, 'total_installed_cost', 51384533.201108113);
	ssccall('data_set_number', data, 'salvage_percentage', 0);
	ssccall('data_set_number', data, 'construction_financing_cost', 1027690.6640221623);
	ssccall('data_set_number', data, 'depr_stabas_method', 1);
	ssccall('data_set_number', data, 'depr_fedbas_method', 1);
	ssccall('data_set_number', data, 'cp_capacity_payment_esc', 0);
	ssccall('data_set_number', data, 'cp_capacity_payment_type', 0);
	cp_capacity_payment_amount =[ 0 ];
	ssccall( 'data_set_array', data, 'cp_capacity_payment_amount', cp_capacity_payment_amount );
	cp_capacity_credit_percent =[ 0 ];
	ssccall( 'data_set_array', data, 'cp_capacity_credit_percent', cp_capacity_credit_percent );
	ssccall('data_set_number', data, 'cp_system_nameplate', 50.002221779999999);
	ssccall('data_set_number', data, 'cp_battery_nameplate', 0);
	grid_curtailment_price =[ 0 ];
	ssccall( 'data_set_array', data, 'grid_curtailment_price', grid_curtailment_price );
	ssccall('data_set_number', data, 'grid_curtailment_price_esc', 0);
	ssccall('data_set_number', data, 'batt_salvage_percentage', 0);
	module = ssccall('module_create', 'pvsamv1'); 
	ok = ssccall('module_exec', module, data);
	if ~ok,
		disp('pvsamv1 errors:'); 
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
	module = ssccall('module_create', 'singleowner'); 
	ok = ssccall('module_exec', module, data);
	if ~ok,
		disp('singleowner errors:'); 
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
	performance_ratio = ssccall('data_get_number', data, 'performance_ratio' );
	disp(sprintf('%s = %g', 'Performance ratio (year 1)', performance_ratio));
	ppa = ssccall('data_get_number', data, 'ppa' );
	disp(sprintf('%s = %g', 'PPA price (year 1)', ppa));
	lppa_nom = ssccall('data_get_number', data, 'lppa_nom' );
	disp(sprintf('%s = %g', 'Levelized PPA price (nominal)', lppa_nom));
	lppa_real = ssccall('data_get_number', data, 'lppa_real' );
	disp(sprintf('%s = %g', 'Levelized PPA price (real)', lppa_real));
	lcoe_nom = ssccall('data_get_number', data, 'lcoe_nom' );
	disp(sprintf('%s = %g', 'Levelized COE (nominal)', lcoe_nom));
	lcoe_real = ssccall('data_get_number', data, 'lcoe_real' );
	disp(sprintf('%s = %g', 'Levelized COE (real)', lcoe_real));
	project_return_aftertax_npv = ssccall('data_get_number', data, 'project_return_aftertax_npv' );
	disp(sprintf('%s = %g', 'Net present value', project_return_aftertax_npv));
	flip_actual_irr = ssccall('data_get_number', data, 'flip_actual_irr' );
	disp(sprintf('%s = %g', 'Internal rate of return (IRR)', flip_actual_irr));
	flip_actual_year = ssccall('data_get_number', data, 'flip_actual_year' );
	disp(sprintf('%s = %g', 'Year IRR is achieved', flip_actual_year));
	project_return_aftertax_irr = ssccall('data_get_number', data, 'project_return_aftertax_irr' );
	disp(sprintf('%s = %g', 'IRR at end of project', project_return_aftertax_irr));
	cost_installed = ssccall('data_get_number', data, 'cost_installed' );
	disp(sprintf('%s = %g', 'Net capital cost', cost_installed));
	size_of_equity = ssccall('data_get_number', data, 'size_of_equity' );
	disp(sprintf('%s = %g', 'Equity', size_of_equity));
	size_of_debt = ssccall('data_get_number', data, 'size_of_debt' );
	disp(sprintf('%s = %g', 'Size of debt', size_of_debt));
	debt_fraction = ssccall('data_get_number', data, 'debt_fraction' );
	disp(sprintf('%s = %g', 'Debt Percent', debt_fraction));
	ssccall('data_free', data);
	ssccall('unload');
end