#### __Matlab scripts for regional bucket corrections in Chan et. al. 2019__

----------------

1. __Preprocess__:
This folder contains scripts for downloading and preprocessing the ICAODS3.0 data. The proprocessing contains five steps:
 1. convert ICOADS data from ascii file to mat files.
 2. Assign missing country information using ID information, and missing measurement methods using assumptions, WMO47 metadata, country, source ID, platform, and deck information.
 3. Generate winsorized mean of 5-day SST at 1 degree resolution.
 4. Compute between neighbor standard deviation of SST in each month.  
 5. Perform Buddy check and quality control.

 Step 3-5 are scripts for buddy check following Rayner et al, 2006.  Because this part used to be an independent ICOADS toolbox, you need to change directories in ```ICOADS_OI.m``` for functions to find target files.

--------------

From now on, the estimation and correction of regional offset begin.  You need to change directories in ```HM_OI.m``` to run the following scripts.  Also, please make sure that you have functions starting with ```CDC_``` and ```CDF_``` placed in path that Matlab can find.

2. __Pairs__:
This folder contains scripts that pair and screen SST measurements within 300km and 2days of one another.  It also contains a function that reads data and a look up table of groups that contribute more or less.
To run these script, diurnal cycle of estimates based on ICOADS buoy data are required, which can be found in the ```Metadata``` folder.

  A sample script is provided in the main folder ```HM_Step_01_Run_Pairs_dup.m``` to run these functions.  ```HM_Step_02_SUM_Pairs_dup``` is another function to pull screened pairs from individual months into one big file.

3. __LME__:
This folder is a toolbox that compute relative offsets amongst groups of SST measurements based on a linear-mixed-effect model.  

 A sample script is provided in the main folder ```HM_Step_03_LME_cor_err_dup.m``` to run the LME analysis.

4. __Correct__:
This folder contains script to apply regional correction to individual ICOADS3.0 SSTs based on their groupings and generate gridded SST estimates.

 Sample scripts in the main folder ```HM_Step_04_Corr_Idv.m``` is to correct the mean offset estimates and offsets of individual groupings, and ```HM_Step_05_Corr_Rnd.m``` is to correct using random samples drawn based on error estimates of offsets, i.e., 1,000 correction members.  Finally, ```HM_Step_06_SUM_Corr.m``` summarizes the statistics of corrections, e.g., trends from 1908-1941, average time series over NP and NA, and PDO indices.  All related functions are placed in the ```Correct``` folder.

5. __Global__:
This folder contains scripts that merges global correction to raw ICOADS and ICOADS with only regional bucket corrections.  Running ```GC_Step_01_SST_merge_GC_to_ICOADSb.m``` generates ICOADSa and ICOADSb.  Another script ```GC_Step_02_add_GC_to_ICOADSa_statistics.m``` merges key statistics, including those from random ICOADSb members, to generate figures and tables.

6. __Stats__:
Contains a set of scripts that generate statistics reported in the texts as well as some tables.  Should better to run these lines before generating tables and figures.

7. __Figure__:
Contains scripts to plot figure in the main text.  We do not recommend modifying any parameters in these scripts unless you know well what each parameter stands for.  I have placed functions starting with ```CDC_``` or ```CDF_``` placed in the External folder.  They are scripts required to generate figures.

-------------
#### Data and metadata


Because pre-processing ICOADS take substantial amount of time to run, and also to guarantee the full reproduction of our results,  we provide __pre-processed ICOADS 3.0 dataset__ we used in ```.mat``` format ().  You can choose to start from here, which is step 2, pairing of SSTs.

However, the whole pairing step is also time consuming, and we provide sum of all pairs with setup used in the main text in the following file, which can be found in the ```Data``` folder.
```
SUM_HM_SST_Bucket_Screen_Pairs_c_once_1850_2014_NpD_1_rmdup_0_rmsml_0_fewer_first_0.mat
```

We also provide the following data as check point of the whole analysis, which can all be found in the ```Data``` folder.

__Binned pairs__:
```
BINNED_HM_SST_Bucket_yr_start_1850_deck_level_1_cor_err_rmdup_0_rmsml_0_fewer_first_0_correct_kobe_0_connect_kobe_1.mat
```
__LME results__:
```
LME_HM_SST_Bucket_yr_start_1850_deck_level_1_cor_err_rmdup_0_rmsml_0_fewer_first_0_correct_kobe_0_connect_kobe_1.mat
```
__ICOADSa and ICOADSb__:
```
ICOADS_a_b.mat
```
__Statistics reported__:
```
SUM_corr_idv_HM_SST_Bucket_deck_level_1_GC_do_rmdup_0_correct_kobe_0_connect_kobe_1_yr_start_1850.mat
```
__Statistics based on 1,000 correction members__:
```
SUM_corr_rnd_HM_SST_Bucket_deck_level_1_GC_do_rmdup_0_correct_kobe_0_connect_kobe_1_yr_start_1850.mat
```
__Statistics for bucket records__:
```
Stats_HM_SST_Bucket_deck_level_1.mat
```

Assess to individual regional correction members are available upon request.

Metadata is required to run the whole analysis.  These files are placed in folder ```Metadata```.  Please make sure to put them in the right directory such that ```HM_OI.m``` and ```ICOADS_OI.m```, two output/input controlling functions, can find these files.
