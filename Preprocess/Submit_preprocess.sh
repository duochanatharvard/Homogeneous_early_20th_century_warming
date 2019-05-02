#!/bin/sh

# ICOADS3.0 is 28GB. ICOADS_Step_00_download.csh is the script we use to
# download from RDA dataset 548.0. Please download files to
# $home_ICOADS3/ICOADS_00_raw_zip/. After downloading,
# run ICOADS_Step_00_unzip.sh to unzip files,
# which are placed in $home_ICOADS3/ICOADS_00_raw/.

export partition_preprocess="huce_intel"          # TODO
export group_account="huybers_lab"                  # TODO

mkdir logs

# ############################################################
# Convert ICOADS3.0 data from ASCII format to .mat files
# ############################################################
export JOB_ascii2mat=$(sbatch << EOF | egrep -o -e "\b[0-9]+$"
#!/bin/sh
#SBATCH --account=${group_account}
#SBATCH -p ${partition_preprocess}
#SBATCH -J ASCII2mat
#SBATCH --array=1-1200
#SBATCH -n 1
#SBATCH -t 1500
#SBATCH --mem-per-cpu=20000
#SBATCH -e logs/err_step_01_ascii2mat.%A.%a
#SBATCH -o logs/log_step_01_ascii2mat.%A.%a
matlab -nosplash -nodesktop -nojvm -nodisplay -r "HM_load_package; num=\$SLURM_ARRAY_TASK_ID; ICOADS_Step_01_ascii2mat_sub; quit;"
EOF
)
echo submitted job ${JOB_ascii2mat} for converting ICOADS3.0 data from ASCII format to .mat files

# This step outputs 3,234 'IMMA1_R3.0.0_YYYY-MM.mat' files to $home_ICOADS3/ICOADS_01_mat_files/


# ############################################################
# Assign missing country information and measurement method
# ############################################################
export JOB_assign_missing=$(sbatch << EOF | egrep -o -e "\b[0-9]+$"
#!/bin/sh
#SBATCH --account=${group_account}
#SBATCH -p ${partition_preprocess}
#SBATCH -J Assign_missing
#SBATCH --array=1-1200
#SBATCH -n 1
#SBATCH -t 500
#SBATCH --mem-per-cpu=10000
#SBATCH -e logs/err_step_02_preQC.%A.%a
#SBATCH -o logs/log_step_02_preQC.%A.%a
#SBATCH --dependency=afterok:${JOB_ascii2mat}
matlab -nosplash -nodesktop -nojvm -nodisplay -r "HM_load_package; num=\$SLURM_ARRAY_TASK_ID; ICOADS_Step_02_pre_QC_sub; quit;"
EOF
)
echo submitted job ${JOB_assign_missing} for assigning missing country information and measurement method

# This step outputs 3,234 'IMMA1_R3.0.0_YYYY-MM_preQC.mat files to $home_ICOADS3/ICOADS_02_pre_QC/

# ############################################################
# Compute winsorized mean of 5-day SST at 1 degree resolution
# ############################################################
export JOB_winsorize=$(sbatch << EOF | egrep -o -e "\b[0-9]+$"
#!/bin/sh
#SBATCH --account=${group_account}
#SBATCH -p ${partition_preprocess}
#SBATCH -J Winsorize
#SBATCH --array=1-1200
#SBATCH -n 1
#SBATCH -t 500
#SBATCH --mem-per-cpu=5000
#SBATCH -e logs/err_step_03_winsorize.%A.%a
#SBATCH -o logs/log_step_03_winsorize.%A.%a
#SBATCH --dependency=afterok:${JOB_assign_missing}
matlab -nosplash -nodesktop -nojvm -nodisplay -r "HM_load_package; num=\$SLURM_ARRAY_TASK_ID; ICOADS_Step_03_WM_sub; quit;"
EOF
)
echo submitted job ${JOB_winsorize} for computing winsorized mean of 5-day SST at 1 degree resolution

# This step outputs 3234 'IMMA1_R3.0.0_YYYY-MM_WM_SST.mat' files and
# 3234 'IMMA1_R3.0.0_YYYY-MM_WM_NMAT.mat' files to $home_ICOADS3/ICOADS_03_WM/

# ############################################################
# Computes between-neighbor standard deviation
# ############################################################
export JOB_neighbor_sigma=$(sbatch << EOF | egrep -o -e "\b[0-9]+$"
#!/bin/sh
#SBATCH --account=${group_account}
#SBATCH -p ${partition_preprocess}
#SBATCH -J neighbor_sigma
#SBATCH -n 1
#SBATCH -t 500
#SBATCH --mem-per-cpu=10000
#SBATCH -e logs/err_step_04_neighbor_sigma.%A.%a
#SBATCH -o logs/log_step_04_neighbor_sigma.%A.%a
#SBATCH --dependency=afterok:${JOB_winsorize}
matlab -nosplash -nodesktop -nojvm -nodisplay -r "HM_load_package; ICOADS_Step_04_Neighbor_std_sub; quit;"
EOF
)
echo submitted job ${JOB_neighbor_sigma} for computing between-neighbor standard deviation

# This step outputs 'Buddy_std_SST.mat' and 'Buddy_std_NMAT.mat' to $home_ICOADS3/ICOADS_Mis/

# ############################################################
# Perform buddy check and other quality controls
# ############################################################
export JOB_buddy=$(sbatch << EOF | egrep -o -e "\b[0-9]+$"
#!/bin/sh
#SBATCH --account=${group_account}
#SBATCH -p ${partition_preprocess}
#SBATCH -J Buddy
#SBATCH --array=1-1200
#SBATCH -n 1
#SBATCH -t 500
#SBATCH --mem-per-cpu=5000
#SBATCH -e logs/err_step_05_buddy.%A.%a
#SBATCH -o logs/log_step_05_buddy.%A.%a
#SBATCH --dependency=afterok:${JOB_assign_missing}
matlab -nosplash -nodesktop -nojvm -nodisplay -r "HM_load_package; num=\$SLURM_ARRAY_TASK_ID; ICOADS_Step_05_Buddy_check_sub; quit;"
EOF
)
echo submitted job ${JOB_neighbor_sigma} for performing buddy check and other quality controls

# This step outputs 3234 'IMMA1_R3.0.0_YYYY-MM_QCed.mat' files to $home_ICOADS3/ICOADS_QCed/
