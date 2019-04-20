function Trd_infill = HM_function_infill_and_trend(SST,key,key2,threshold,no_land);

    if ~exist('threshold','var'), threshold = 0.75; end
    if ~exist('no_land','var'), no_land = 1; end
    if isempty(threshold), threshold = 0.75; end

    % **********************
    % Compute annual mean **
    % **********************
    clear('SST_10_an_en','NUM_10_an_en','temp_sst')
    SST_an = squeeze(nanmean(SST,3));
    NUM_an = squeeze(nansum(~isnan(SST),3));
    SST_an(NUM_an < key) = nan;
    SST_an(SST_an < -key2 | SST_an > key2) = nan;

    % ********************
    % Compute the trend **
    % ********************
    SST_an_filled = HM_function_infill(SST_an,NUM_an,no_land);
    Trd_infill = HM_function_trend(SST_an_filled,threshold,[]);
    Trd_unfill = HM_function_trend(SST_an,threshold,[]);

    Trd_infill(isnan(Trd_unfill)) = nan;
end
