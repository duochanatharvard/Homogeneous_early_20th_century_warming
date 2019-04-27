HM_load_package;

[y_st,m_st] = ind2sub([100,12],num);
for yr = (1659+y_st):100:2014
    for mon = m_st
        ICOADS_Step_03_WM(yr, mon,'SST');
        ICOADS_Step_03_WM(yr, mon,'NMAT');
    end
end
