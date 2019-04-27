HM_load_package;

[y_st,m_st] = ind2sub([100,12],num);
for yr = (1659+y_st):100:2014
    for mon = m_st
        ICOADS_Step_02_pre_QC(yr, mon);
    end
end
