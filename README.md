# More homogeneous early 20th century warming

<br>

Matlab and shell scripts associated with the paper "Correcting datasets leads to more homogeneous early 20th century sea surface warming " by Duo Chan, Elizabeth C. Kent, David I. Berry, and Peter Huybers.

Most of these codes are .m files and should be run in [Matlab](https://www.mathworks.com/products/matlab.html).  We provide a [quick start function](Quick_start.m) for fast reproduction of Figures and Table in the main text.  If you are reproducing the [full analysis](), which takes more computational resources and time to run, we provide two Shell template scripts that runs these Matlab codes on clusters.  The provided Shell template is for submitting jobs on the Harvard [Odyssey Cluster](https://www.rc.fas.harvard.edu/odyssey/) that uses a [SLURM workload manager](https://slurm.schedmd.com/documentation.html).    

Though we have made our best to comment codes and provide all dependencies, and tested these codes on a clean computer, we are unlikely to be 100% successful.  If you are trying to use these codes to reproduce our results and have identified missing files or dependencies, please contact [Duo Chan](duochan@g.harvard.edu).

<br>

## Get started:
Run [Chan_et_al_init.m](Chan_et_al_init.m) to initialize the analysis.  This script will add all codes in this package to Matlab path and set up directories structured following the below figure.  The default path will be the directory of this package; so make sure that enough disk space is available (~XGB for simply reproducing figures and tables and ~70GB for full reproduction), otherwise, specify another directory to store the data:

`Chan_et_al_init($home_data)`

![image](Directories_2.png)

<br>

## Quick start

After initialization, run [Quick_start.m](Quick_start.m), a rapper that run scripts to generate Fig. 1-4 and Table 1, as well as numbers reported in the main text.

__[Prerequisite]__ Please make sure that you have the following dependency files downloaded and placed in corresponding directories.

* __SUM_corr_idv_HM_SST_Bucket_GC_*.mat__: key statistics for ICOADSa and ICOADSb, which can be downloaded from [here]() and should be placed in `$home_ICOADSb/HM_SST_Bucket/`.  Key statistics include the spatial pattern of 1908-1941 trends, monthly SSTs over the North Pacific and North Atlantic, monthly SSTs near East Asia and the Eastern U.S., and PDO indices.

* __SUM_corr_rnd_HM_SST_Bucket_GC_*.mat__: as above but for 1,000 ICOADSb correction members.

* __1908_1941_Trd_TS_and_pdo_from_all_existing_datasets_20190424.mat__: key statistics for existing major SST estimates, which can be downloaded from [here]() and should be placed in `$home_ICOADSb/Miscellaneous/`.  Major SST estimates are ERSST5, COBESST2, HadISST2, and HadSST3.  We have a copy [here]() for raw data used in our analysis.  All of these datasets are regridded to 5-degree resolution, which can be downloaded from [here]().

* __Stats_HM_SST_Bucket_deck_level_1.mat__: statistics of numbers of measurements for each nation-deck group, which can be downloaded from [here]() and should be placed in `$home_ICOADSb/HM_SST_Bucket/`.

* __LME_HM_SST_Bucket_*.mat__: groupwise offset estimates for bucket SSTs, which can be downloaded from [here]() and should be placed in `$home_ICOADSb/HM_SST_Bucket/Step_04_run/`.

* __CRUTEM.4.6.0.0.anomalies.nc__: CRUTEM4 dataset. We have a copy [here]() and one should place it in `$home_ICOADSb/Miscellaneous/`.

* __Matlab [m_map](https://www.eoas.ubc.ca/~rich/map.html) toolbox__ is used to plot maps, and its path should be specified in [HM_load_package.m](HM_load_package.m).


<br>
<br>
________________________________

For users interested in reproducing our full analysis, we provide the following guidance to run the codes.

<br>

## Overview and system requirements:

Below is the flow chart of the full analysis.

![image](Flow_chart.png)

Several steps in processing are memory and computationally intensive.  Our analysis was run on Harvard Research Computing clusters and uses 200 cpus and 150GB memory per cpu, and requires 5,000 core-hours of computation and 70GB of disk space.  

For purposes of facilitating reproduction we have also provided files resulting from our computation at various stages of the analysis (indicated by red arrows).

<br>

## A. Preprocess:
This folder contains scripts for downloading and preprocessing the ICOADS3.0 data. ICOADS3.0 is 28GB and can be downloaded from [RDA dataset 548.0](https://rda.ucar.edu/datasets/ds548.0/#!description).  We have also archived a version [here]().  Because the whole preprocessing takes more than a month to finish on a Macbook pro with a 3.1Ghz Intel Core i7 Processor,  this step can be skipped by downloading the [preprocessed .mat files]() and place them in `$home_ICOADS3/ICOADS_QCed/`.   If you would like to reproduce these steps,  we provide [Submit_preprocess.sh](Preprocess/Submit_preprocess.sh) that wraps these steps and runs scripts on the Harvard [Odyssey Cluster](https://www.rc.fas.harvard.edu/odyssey/) that uses a [SLURM workload manager](https://slurm.schedmd.com/documentation.html).   If you are using a different machinery, please make necessary changes.

__[Prerequisite]__ please make sure the following metadata are downloaded from [here]() and placed in `$home_ICOADS3/ICOADS_Mis/`:

 * __OI_clim_1982_2014.mat__: 33-year [OI-SST](https://www.esrl.noaa.gov/psd/data/gridded/data.noaa.oisst.v2.highres.html) daily climatology,

 * __ERA_interim_AT2m_1985_2014_daily_climatology.mat__: 30-year [ERA-interim](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era-interim) 2m-air temperature daily climatology,

 * __Dif_DMAT_NMAT_1929_1941.mat__: Mean daytime and nighttime marine air temperature difference in 1929-1941,

 * __Dif_DMAT_NMAT_1947_1956.mat__: Mean daytime and nighttime marine air temperature difference in 1947-1956,

 * __Buddy_std_SST.mat__:  Output from step [A.4],

 * __Buddy_std_NMAT.mat__:  Output from step [A.4].

<br>
 To run preprocessing using the shell script, simply run (the command may vary on different machineries):

```
sbatch Preprocess/Submit_preprocess.sh
```

---

The preprocessing contains a downloading step and five processing steps (see below).  Among which, step __A.2__ follows [Chan et al., submitted]() for SST and [Kent et al. (2013)](https://agupubs.onlinelibrary.wiley.com/doi/full/10.1002/jgrd.50152) for nighttime marine air temperature, and steps __A.3-A.5__ follow [Rayner et al. (2006)](https://journals.ametsoc.org/doi/full/10.1175/JCLI3637.1) in performing buddy check.

__A.0.__ [ICOADS_Step_00_download.csh](Preprocess/ICOADS_Step_00_download.csh) downloads raw ICOADS3.0 data to folder `$home_ICOADS3/ICOADS_00_raw_zip/` and [ICOADS_Step_00_unzip.sh](Preprocess/ICOADS_Step_00_unzip.sh) unzips the data files.  Unzipped files are stored in `$home_ICOADS3/ICOADS_00_raw/`.

__A.1.__ [ICOADS_Step_01_ascii2mat.m](Preprocess/ICOADS_Step_01_ascii2mat.m)  converts ICOADS data from ASCII file to .mat files and stores them in `$home_ICOADS3/ICOADS_01_mat_files/`.

__A.2.__ [ICOADS_Step_02_pre_QC.m](Preprocess/ICOADS_Step_02_pre_QC.m) assigns missing country information and measurement method and outputs files to
`$Home_ICOADS3.O/ICOADS_02_pre_QC/`.

__A.3.__ [ICOADS_Step_03_WM.m](Preprocess/ICOADS_Step_03_WM.m) generates winsorized mean of 5-day SST at 1 degree resolution.  These gridded data are stored in `$home_ICOADS3/ICOADS_03_WM/`.

__A.4.__ [ICOADS_Step_04_Neighbor_std.m](Preprocess/ICOADS_Step_04_Neighbor_std.m) computes between neighbor standard deviation of SST for each month.

__A.5.__ [ICOADS_Step_05_Buddy_check.m](Preprocess/ICOADS_Step_05_Buddy_check.m) performs buddy check and other quality controls.  Outputs are preprocessed files stored in `$home_ICOADS3/ICOADS_QCed/`.


<br>

## B. Main Code:

As shown in the [flow chart](), this step contains [pairing SST measurements](), [estimating offsets using LME](), [correcting groupwise offsets and gridding](), and [merging with common bucket corrections]().  These main steps can be accessed without preprocessing ICOADS3.0 by downloading the [preprocessed .mat files]() and place them in `$home_ICOADS3/ICOADS_QCed/`.   

Again, the whole analysis takes substantial amount of computational resources to run, including several steps that process more than 2,000 files and one step that takes 150GB memory.  We recommend you to reproduce these steps on clusters and provide [Submit_main.sh](Submit_main.sh) that wraps these steps and runs scripts on the Harvard [Odyssey Cluster](https://www.rc.fas.harvard.edu/odyssey/) that uses a [SLURM workload manager](https://slurm.schedmd.com/documentation.html).   If you are using a different machinery, please make necessary changes.

 To run the main analysis using the shell script, simply run (the command may vary on different machineries):

```
sbatch Submit_main.sh
```

We strongly encourage you to go through the following documentation for prerequisites of individual steps and details of the workflow.

---

__B.1.__ __Pairs__ folder contains functions that pair SST measurements.

  __[Prerequisite]__ please make sure the following metadata files are downloaded from [here]() and placed in `$home_ICOADSb/Miscellaneous/`.  These files are diurnal cycle estimates based on ICOADS3.0 buoy data.

   * __DA_SST_Gridded_BUOY_sum_from_grid.mat__

   * __Diurnal_Shape_SST.mat__

First, run [HM_Step_01_Run_Pairs_dup.m](HM_Step_01_Run_Pairs_dup.m) to pair SST measurements following [Chan and Huybers (2019)](https://journals.ametsoc.org/doi/pdf/10.1175/JCLI-D-18-0562.1).  This script first calls [HM_pair_01_Raw_Pairs_dup.m](Pairs/HM_pair_01_Raw_Pairs_dup.m) to pair SST measurements within 300km and 2days of one another and then calls [HM_pair_02_Screen_Pairs_dup.m](Pairs/HM_pair_02_Screen_Pairs_dup.m) to screen pairs such that each measurement is used at most once.  Output files are stored in `$home_ICOADSb/HM_SST_Bucket/Step_01_Raw_Pairs/` and `$home_ICOADSb/HM_SST_Bucket/Step_02_Screen_Pairs/`.  

Second, run [HM_Step_02_SUM_Pairs_dup.m](HM_Step_02_SUM_Pairs_dup.m) to combine screened pairs into one file, which will be used in following steps.  The combined file, __SUM_HM_SST_Bucket_Screen_Pairs_*.mat__, is in `$home_ICOADSb/HM_SST_Bucket/Step_03_SUM_Pairs/`.  One can also download this file from [here]() and skip the pairing step.

---

__B.2.__ __LME__ folder contains scripts that compute offsets among nation-deck groups of SST measurements using a linear-mixed-effect model ([Chan and Huybers., 2019](https://journals.ametsoc.org/doi/pdf/10.1175/JCLI-D-18-0562.1)).  

__[Prerequisite]__ please make sure the following metadata file is downloaded from [here]() and placed in `$home_ICOADSb/Miscellaneous/`.  This file contains SST covariance structures estimated from the 33-year [OI-SST](https://www.esrl.noaa.gov/psd/data/gridded/data.noaa.oisst.v2.highres.html) dataset.

  * __OI_SST_inter_annual_decorrelation_20180316.mat__.

Run, [HM_Step_03_LME_cor_err_dup.m](HM_Step_03_LME_cor_err_dup.m) to perform the offset estimation.  This script first calls [HM_lme_bin_dup.m](LME/HM_lme_bin_dup.m) to aggregate SST pairs according to combinations of groupings, years, and regions, which reduces the number of SST differences from 17.8 million to 71,973.  This step will output __BINNED_HM_SST_Bucket__ to directory `$home_ICOADSb/HM_SST_Bucket/Step_04_run/`.

[HM_Step_03_LME_cor_err_dup.m](HM_Step_03_LME_cor_err_dup.m) then calls [HM_lme_fit_hierarchy.m](LME/HM_lme_fit_hierarchy.m) to fit the LME regression model and output groupwise offset estimates.  The output file, __LME_HM_SST_Bucket_*.mat__, will also be placed in `$home_ICOADSb/HM_SST_Bucket/Step_04_run/`.  Note that fitting the LME model involves inversion of a big matrix (~70,000 x 70,000) and takes 150GB of memory to run.

Data generated in this step can be downloaded from [here]().  Again, one can skip this step by downloading __LME_HM_SST_Bucket_*.mat__.

---

__B.3.__ __Correct__ folder contains scripts that apply groupwise corrections and generates 5x5-degree gridded SST estimates.  Groupwise corrections are applied to each SST measurement by removing offset estimated in step __B.2__ according to grouping, year, and region.   

__[Prerequisite]__ please make sure that you have the following data or metadata placed in corresponding directories.

  * __IMMA1_R3.0.0_YYYY-MM_QCed.mat__: preprocessed ICOADS3.0 .mat files from running step __A.1 - A.5__.  They should be placed in `$home_ICOADS3/ICOADS_QCed/` and can be downloaded from [here]().

  * __internal_climate_patterns.mat__: spatial pattern of PDO in SST.  It can be downloaded from [here]() and should be placed in `$home_ICOADSb/Miscellaneous/`.

  * __nansum.mat__: a function that compute summation but returns NaN when all inputs are NaN.  As reference, the default Matlab [nansum.m](https://www.mathworks.com/help/stats/nansum.html) function will return zero.  Our [nansum.m](Function/nansum.m) is in `$home_Code/Function/`.  Please __make sure__ that your Matlab calls our [nansum.m](Function/nansum.m) because SST trends in data sparse regions are sensitive.  

First, run [HM_Step_04_Corr_Idv.m](HM_Step_04_Corr_Idv.m) to perform corrections using the maximum likelihood estimates of offsets and generate gridded SST estimates.  [HM_Step_04_Corr_Idv.m](HM_Step_04_Corr_Idv.m) also generates gridded SST estimates that correct for only one group at a time.  This step generates SST datasets that only have groupwise corrections, i.e., __corr_idv_HM_SST_Bucket_*.mat__.  These files can be downloaded from [here]() and should be placed in `$home_ICOADSb/HM_SST_Bucket/Step_05_corr_idv/`.

Then, run [HM_Step_05_Corr_Rnd.m](HM_Step_05_Corr_Rnd.m) to generate a 1000-member ensemble of gridded SSTs, which can be used to estimate uncertainties of groupwise corrections.  For each correction member, offsets to be corrected are drawn from a multivariate normal distribution that centers on the maximum likelihood estimates [see appendix in [Chan and Huybers., (2019)](https://journals.ametsoc.org/doi/pdf/10.1175/JCLI-D-18-0562.1)].   This step generates SST datasets that only have randomized groupwise corrections, i.e., __corr_rnd_HM_SST_Bucket_*.mat__.  These files can be downloaded from [here]() and should be placed in `$home_ICOADSb/HM_SST_Bucket/Step_06_corr_rnd/`.

As the last part of this step __B.3__, run [HM_Step_06_SUM_Corr.m](HM_Step_06_SUM_Corr.m) to compute statistics of gridded SST estimates.  These statistics include the spatial pattern of 1908-1941 trends, monthly SSTs over the North Pacific and North Atlantic, monthly SSTs near East Asia and the Eastern U.S., and PDO indices.  This step will output __SUM_corr_idv_HM_SST_Bucket_*.mat__ (central estimates) and __SUM_corr_rnd_HM_SST_Bucket_*.mat__ (uncertainty estimates) in `$home_ICOADSb/HM_SST_Bucket/`.  Again, one can skip step __B.3.__ by downloading these two files from [here](https://github.com/duochanatharvard/SST_Bucket_Model).

---

__B.4.__ __Global__ folder contains scripts that merge large-scale common bucket corrections to raw ICOADS3.0 and ICOADS3.0 with groupwise corrections.  The resulting datasets are called ICOADSa and ICOADSb, respectively.  

__[Prerequisite]__ please make sure to download the following file from [here]() and place it in `$home_ICOADSb/Miscellaneous/`.

  * __Global_Bucket_Correction_start_ratio_35_mass_small_0.65_mass_large_1.7_start_ratio_35.mat__: our reproduced 1850-2014 common bucket bias correction.  The reproduction follows [Kennedy et al., (2012)](https://agupubs.onlinelibrary.wiley.com/doi/abs/10.1029/2010jd015220) and details can be found in Extended Data Fig.8 and Supplemental Information Table 2 in Chan et al., submitted.  These corrections involve running two bucket models, which can be accessed from [here](https://github.com/duochanatharvard/SST_Bucket_Model).

Run [HM_Step_07_Merge_GC.m](HM_Step_07_Merge_GC.m) to run step __B.4__.  The script first calls [GC_Step_01_SST_merge_GC_to_ICOADSb.m](Global/GC_Step_01_SST_merge_GC_to_ICOADSb.m) to generate ICOADSa and ICOADSb and then calls [GC_Step_02_add_GC_to_ICOADSa_statistics.m](GC_Step_02_add_GC_to_ICOADSa_statistics.m) to incorporate key statistics associated with common bucket corrections to __SUM_corr_idv_HM_SST_Bucket_*.mat__ and __SUM_corr_rnd_HM_SST_Bucket_*.mat__.  

This step will generate the following files in `$home_ICOADSb/HM_SST_Bucket/`, which will be used to generate Tables and Figures and can be downloaded from [here]().

  * __ICOADS_a_b.mat__: 5x5-degree gridded bucket SST datasets. ICOADSa contains only common bucket corrections, whereas ICOADSb contains both common bucket corrections and groupwise corrections.

  * __SUM_corr_idv_HM_SST_Bucket_GC_*.mat__: key statistics for ICOADSa and ICOADSb, see step __B.3__.

  * __SUM_corr_rnd_HM_SST_Bucket_GC_*.mat__: key statistics for 1,000 ICOADSb correction members.

---

__B.5.__ This step will be the same as the quick start that generates Fig. 1-4 and Table 1, as well as numbers reported in the main text.


<br>
<br>

Acknowledgement:  We thank [Parkard Chan](https://github.com/PackardChan) for his helps on developing this page and checking scripts using his machinery.

Maintained by __Duo Chan__ (duochan@g.harvard.edu)

Last Update: April 30, 2019
