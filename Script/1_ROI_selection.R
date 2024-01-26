################################################################################
# Written by Loïc Labache, Ph.D.
# Holmes Lab, Department of Psychiatry - Rutgers University
# January 26, 2024
################################################################################

# Packages:
#...............................................................................
packages <- c("here", "dplyr")
lapply(packages, require, character.only = T)

# Load Data:
#...............................................................................
path_data = "Data"
activation = read.csv(here(path_data, "130_participants_BOLD_LBJ_BILGIN.txt"))

# Selection of Significant Regions:
#...............................................................................
results = data.frame(Abbreviation = character(), Hemisphere = character(),
                     Avg_L = numeric(), P_Value_L = numeric(), T_Value_L = numeric(), 
                     CI_L = character(), Avg_R = numeric(),P_Value_R = numeric(), 
                     T_Value_R = numeric(), CI_R = character(), Avg_Asym = numeric(), 
                     P_Value_Asym = numeric(), T_Value_Asym = numeric(), 
                     CI_Asym = character(), stringsAsFactors = FALSE)
region = unique(activation$Abbreviation)
num_tests = length(region)
bonferroni_threshold = 0.05 / num_tests

for (abbr in region) {
  activation_subset = filter(activation, Abbreviation == abbr)
  
  # Perform test:
  test_L = t.test(activation_subset$L)
  test_R = t.test(activation_subset$R)
  test_Asym = t.test(activation_subset$Asym)
  
  # Check criteria:
  is_signif_L = (test_L$estimate > 0) && (test_L$p.value < bonferroni_threshold)
  is_signif_R = (test_R$estimate > 0) && (test_R$p.value < bonferroni_threshold)
  is_signif_Asym = test_Asym$p.value < bonferroni_threshold
  selection_criteria = ""
  if (is_signif_L && is_signif_Asym && test_Asym$estimate > 0) {
    selection_criteria = "L"
  }
  if (is_signif_R && is_signif_Asym && test_Asym$estimate < 0) {
    selection_criteria = "R"
  }
  
  # Add to result:
  if (selection_criteria != "") {
    results = rbind(results, data.frame(Abbreviation = abbr, 
                                        Hemisphere = selection_criteria,
                                        Avg_L = test_L$estimate, 
                                        P_Value_L = test_L$p.value,
                                        T_Value_L = test_L$statistic, 
                                        CI_L = paste(test_L$conf.int[1],
                                                     test_L$conf.int[2]),
                                        Avg_R = test_R$estimate, 
                                        P_Value_R = test_R$p.value, 
                                        T_Value_R = test_R$statistic, 
                                        CI_R = paste(test_R$conf.int[1],
                                                     test_R$conf.int[2]),
                                        Avg_Asym = test_Asym$estimate,
                                        P_Value_Asym = test_Asym$p.value, 
                                        T_Value_Asym = test_Asym$statistic, 
                                        CI_Asym = paste(test_Asym$conf.int[1],
                                                        test_Asym$conf.int[2])))
  }
}
rownames(results) = seq(nrow(results))

# "results" contains the selected brain regions.