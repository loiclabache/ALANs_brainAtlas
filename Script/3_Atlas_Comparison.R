################################################################################
# Written by Loïc Labache, Ph.D.                                               #
# Holmes Lab, Department of Psychiatry - Rutgers University                    #
# February 7, 2024                                                             #
################################################################################

# Packages......................................................................
#...............................................................................
packages <- c("here", "oro.nifti", "dplyr")
lapply(packages, require, character.only = T)

# Load Data.....................................................................
#...............................................................................
path_data = "Data"
aicha_atlas = readNIfTI(here(path_data, "AICHA_v2", "AICHA.nii"))
yan_atlas = readNIfTI(here(path_data, "Yan_2023_v0.29.5",
                           "1000Parcels_Yeo2011_7Networks_FSLMNI152_2mm.nii.gz"))
yan_descr = read.csv(here(path_data, "Yan_2023_v0.29.5",
                          "1000Parcels_Yeo2011_7Networks_LUT.txt"))
aicha_atlas
yan_atlas

# Atlases Comparison............................................................
#...............................................................................
aicha_array = aicha_atlas@.Data
yan_array = yan_atlas@.Data
aicha_vector = as.vector(aicha_array)
yan_vector = as.vector(yan_array)
combined_df = data.frame(yan = yan_vector, aicha = aicha_vector)
filtered_df = subset(combined_df, yan != 0 & aicha != 0)

count_df = filtered_df %>%
  group_by(yan, aicha) %>%
  summarise(nb_voxel = n(), .groups="drop") %>%
  arrange(aicha)
count_df = inner_join(count_df, yan_descr[, -c(1, 3, 5:8)],
                      by = c("yan" = "Region_Number"))[, -1]
count_df = count_df %>%
  group_by(aicha, Network_7) %>%
  summarise(total_nb_voxel = sum(nb_voxel), .groups="drop")
result_df = count_df %>%
  group_by(aicha) %>%
  filter(total_nb_voxel == max(total_nb_voxel))
result_df = result_df %>%
  mutate(aicha_surfice = if_else(aicha %% 2 == 0, 
                                 aicha / 2,
                                 (aicha + 1) / 2),
         hemisphere = if_else(aicha %% 2 == 0, "RH", "LH"))
result_df = result_df %>%
  mutate(Network_7_nb = case_when(Network_7 == "Default" ~ 7,
                                  Network_7 == "Cont" ~ 6,
                                  Network_7 == "Limbic" ~ 5,
                                  Network_7 == "DorsAttn" ~ 3,
                                  Network_7 == "SalVentAttn" ~ 4,
                                  Network_7 == "SomMot" ~ 2,
                                  Network_7 == "Vis" ~ 1,
                                  TRUE ~ 8))
result_df

write.csv(result_df, file=here(path_data,
                               "comparison_AICHA_Yan2023_10000_2mm.csv"))