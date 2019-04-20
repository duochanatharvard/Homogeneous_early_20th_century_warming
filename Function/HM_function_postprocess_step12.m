function [Trd_infill,TS,PDO,PDO_int,TS_coastal] = HM_function_postprocess_step12(SST,SST_trd,MASK,env)

    if ~exist('env','var'),
        env = 1;                             % 1 means on odyssey
    end

    % ****************
    % Compute trend **
    % ****************
    if ~isempty(SST_trd),
        Trd_infill = HM_function_infill_and_trend(SST_trd,3,3,0.75);
    else
        Trd_infill = nan(size(SST,1),size(SST,2));
    end

    % **********************
    % Compute time series **
    % **********************
    clear('TS')
    for m = 1:max(MASK(:))
        [TS(:,:,m),~,~] = HM_function_mask_average...
                            (SST,[-87.5:5:87.5],MASK == m);
    end

    % ******************************************
    % Compute time series for coastal regions **
    % ******************************************
    MASK2 = HM_function_mask_coastal;
    clear('TS_coastal')
    for m = 1:max(MASK(:))
        [TS_coastal(:,:,m),~,~] = HM_function_mask_average...
                            (SST,[-87.5:5:87.5],MASK2 == m);
    end

    % **************
    % Compute PDO **
    % **************
    load([HM_OI('home',env),HM_OI('mis'),'internal_climate_patterns.mat'],'PDO_map');
    [PDO,PDO_int] = HM_function_pdo_index_gene(SST,CDC_smooth2(PDO_map),0);
end
