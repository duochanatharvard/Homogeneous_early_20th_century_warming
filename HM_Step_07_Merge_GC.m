HM_load_package;

if num == 1,
    
    GC_Step_01_SST_merge_GC_to_ICOADSb;
    
elseif num == 2 || num == 3,
    
    GC_Step_02_add_GC_to_ICOADSa_statistics;
    
else
    
    % Generate 1850-1941 ICOADSb ensemble 
    GC_Step_03_SST_merge_GC_to_ICOADSb_rnd;
    
end