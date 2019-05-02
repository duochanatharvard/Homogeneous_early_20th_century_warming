#!/bin/sh

export partition_main="huce_intel"                # TODO
export group_account="huybers_lab"                  # TODO

mkdir -p logs

# ############################################################
# Pairing SSTs and screening pairs such that each measurement is only used once
# ############################################################
export JOB_pairing=$(sbatch << EOF | egrep -o -e "\b[0-9]+$"
#!/bin/sh
#SBATCH --account=${group_account}
#SBATCH -p ${partition_main}
#SBATCH -J Pairing
#SBATCH --array=1-600
#SBATCH -n 1
#SBATCH -t 1500
#SBATCH --mem-per-cpu=30000
#SBATCH -e logs/err_step_01_pairing.%A.%a
#SBATCH -o logs/log_step_01_pairing.%A.%a
matlab -nosplash -nodesktop -nojvm -nodisplay -r "HM_load_package; num=\$SLURM_ARRAY_TASK_ID; HM_Step_01_02_Run_Pairs_dup; quit;"
EOF
)
echo submitted job ${JOB_pairing} for pairing SSTs

# This step outputs 1,935 'IMMA1_R3.0.0_YYYY-MM_Bucket_Pairs_c_all_pairs.mat' files
# to $home_ICOADSb/HM_SST_Bucket/Step_01_Raw_Pairs/
# and outputs 1,935 'IMMA1_R3.0.0_YYYY-MM_Bucket_Screen_Pairs_c_*.mat' files
# to $home_ICOADSb/HM_SST_Bucket/Step_02_Screen_Pairs/


# ############################################################
# Combining pairs
# ############################################################
export JOB_combine_pairs=$(sbatch << EOF | egrep -o -e "\b[0-9]+$"
#!/bin/sh
#SBATCH --account=${group_account}
#SBATCH -p ${partition_main}
#SBATCH -J Combine_pairs
#SBATCH -n 1
#SBATCH -t 1500
#SBATCH --mem-per-cpu=100000
#SBATCH -e logs/err_step_02_combine_pairs
#SBATCH -o logs/log_step_02_combine_pairs
#SBATCH --dependency=afterok:${JOB_pairing}
matlab -nosplash -nodesktop -nojvm -nodisplay -r "HM_load_package; HM_Step_03_SUM_Pairs_dup; quit;"
EOF
)
echo submitted job ${JOB_combine_pairs} for combining pairs

# This step outputs 'SUM_HM_SST_Bucket_Screen_Pairs_c_once_*.mat' to $home_ICOADSb/HM_SST_Bucket/Step_03_SUM_Pairs/

# ############################################################
# LME analysis
# ############################################################
export JOB_LME=$(sbatch << EOF | egrep -o -e "\b[0-9]+$"
#!/bin/sh
#SBATCH --account=${group_account}
#SBATCH -p ${partition_main}
#SBATCH -J LME
#SBATCH -n 1
#SBATCH -t 3000
#SBATCH --mem-per-cpu=200000
#SBATCH -e logs/err_step_03_LME
#SBATCH -o logs/log_step_03_LME
#SBATCH --dependency=afterok:${JOB_combine_pairs}
matlab -nosplash -nodesktop -nojvm -nodisplay -r "HM_load_package; HM_Step_04_LME_cor_err_dup; quit;"
EOF
)
echo submitted job ${JOB_LME} for estimating groupwise offsets using LME

# This step outputs 'BINNED_HM_SST_Bucket_*.mat' and 'LME_HM_SST_Bucket_yr_*.mat'
# to $home_ICOADSb/HM_SST_Bucket/Step_04_run/

# ############################################################
# Correct for maximum likelihood estimates of offsets
# and offsets of individual groupings
# ############################################################
export JOB_cor_idv=$(sbatch << EOF | egrep -o -e "\b[0-9]+$"
#!/bin/sh
#SBATCH --account=${group_account}
#SBATCH -p ${partition_main}
#SBATCH -J cor_idv
#SBATCH --array=1-163
#SBATCH -n 1
#SBATCH -t 1500
#SBATCH --mem-per-cpu=20000
#SBATCH -e logs/err_step_04_cor_idv.%A.%a
#SBATCH -o logs/log_step_04_cor_idv.%A.%a
#SBATCH --dependency=afterok:${JOB_LME}
matlab -nosplash -nodesktop -nojvm -nodisplay -r "HM_load_package; num=\$SLURM_ARRAY_TASK_ID; HM_Step_05_Corr_Idv; quit;"
EOF
)
echo submitted job ${JOB_cor_idv} for correcting for maximum likelihood estimates of offsets

# This step outputs 163 'corr_idv_HM_SST_Bucket_*.mat' files to $home_ICOADSb/HM_SST_Bucket/Step_05_corr_idv/


# ############################################################
# Correct for randomized of offsets
# ############################################################
export JOB_cor_rnd=$(sbatch << EOF | egrep -o -e "\b[0-9]+$"
#!/bin/sh
#SBATCH --account=${group_account}
#SBATCH -p ${partition_main}
#SBATCH -J cor_rnd
#SBATCH --array=1-200
#SBATCH -n 1
#SBATCH -t 1500
#SBATCH --mem-per-cpu=20000
#SBATCH -e logs/err_step_05_cor_rnd.%A.%a
#SBATCH -o logs/log_step_05_cor_rnd.%A.%a
#SBATCH --dependency=afterok:${JOB_LME}
matlab -nosplash -nodesktop -nojvm -nodisplay -r "HM_load_package; num=\$SLURM_ARRAY_TASK_ID; HM_Step_06_Corr_Rnd; quit;"
EOF
)
echo submitted job ${JOB_cor_rnd} for correcting for maximum likelihood estimates of offsets

# This step outputs 163 'corr_rnd_HM_SST_Bucket_*.mat' files to $home_ICOADSb/HM_SST_Bucket/Step_06_corr_rnd/


# ############################################################
# Compute statistics of corrections
# ############################################################
export JOB_cor_stats=$(sbatch << EOF | egrep -o -e "\b[0-9]+$"
#!/bin/sh
#SBATCH --account=${group_account}
#SBATCH -p ${partition_main}
#SBATCH -J cor_stats
#SBATCH --array=1-2
#SBATCH -n 1
#SBATCH -t 1500
#SBATCH --mem-per-cpu=30000
#SBATCH -e logs/err_step_06_cor_stats.%A.%a
#SBATCH -o logs/log_step_06_cor_stats.%A.%a
#SBATCH --dependency=afterok:${JOB_cor_idv}:${JOB_cor_rnd}
matlab -nosplash -nodesktop -nojvm -nodisplay -r "HM_load_package; num=\$SLURM_ARRAY_TASK_ID; HM_Step_07_SUM_Corr; quit;"
EOF
)
echo submitted job ${JOB_cor_stats} for computing statistics of computations

# This step outputs 'SUM_corr_idv_HM_SST_Bucket_*.mat' and
# 'SUM_corr_rnd_HM_SST_Bucket_*.mat' to $home_ICOADSb/HM_SST_Bucket/


# ############################################################
# Combine with Global correction
# ############################################################
export JOB_cor_glb=$(sbatch << EOF | egrep -o -e "\b[0-9]+$"
#!/bin/sh
#SBATCH --account=${group_account}
#SBATCH -p ${partition_main}
#SBATCH -J cor_glb
#SBATCH --array=1-4
#SBATCH -n 1
#SBATCH -t 1500
#SBATCH --mem-per-cpu=30000
#SBATCH -e logs/err_step_07_cor_glb.%A.%a
#SBATCH -o logs/log_step_07_cor_glb.%A.%a
#SBATCH --dependency=afterok:${JOB_cor_stats}
matlab -nosplash -nodesktop -nojvm -nodisplay -r "HM_load_package; num=\$SLURM_ARRAY_TASK_ID; HM_Step_08_Merge_GC; quit;"
EOF
)
echo submitted job ${JOB_cor_glb} for merging common bucket bias corrections

# This step outputs the following to $home_ICOADSb/HM_SST_Bucket/
# * 'SUM_corr_idv_HM_SST_Bucket_GC_*.mat'
# * 'SUM_corr_rnd_HM_SST_Bucket_GC_*.mat'
# * 'ICOADS_a_b.mat'
# It also outputs 1000 ICOADSb members 'ICOADSb_ensemble_*.mat' in $ICOADSb/HM_SST_Bucket/ICOADSb_ensemble/
