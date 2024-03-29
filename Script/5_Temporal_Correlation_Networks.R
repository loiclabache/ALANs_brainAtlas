################################################################################
# Written by Loïc Labache, Ph.D.                                               #
# Holmes Lab, Department of Psychiatry - Rutgers University                    #
# March 28, 2024                                                               #
################################################################################

# Packages......................................................................
#...............................................................................
packages <- c("here", "psych", "progress")
lapply(packages, require, character.only = T)

# Load Data.....................................................................
#...............................................................................
cor_mat = read.csv(here("Data/130_participants_BOLD_rs_networks_BILGIN.csv"))
colnames(cor_mat)[1] = "Participant"

# Test Average Correlation......................................................
#...............................................................................
cor_mat[, -1] = fisherz(cor_mat[, -1])
means_cor = round(fisherz2r(sapply(cor_mat[,-1], mean)), 2)
sign_tests_results_pos = sapply(cor_mat[,-1], function(column) {
  test = binom.test(sum(column > 0),
                    length(column),
                    p = 0.5,
                    alternative = "greater",
                    conf.level = 0.95)
  
  return(c(p.value = test$p.value))
})
sign_tests_results_neg = sapply(cor_mat[,-1], function(column) {
  test = binom.test(sum(column < 0),
                    length(column),
                    p = 0.5,
                    alternative = "greater",
                    conf.level = 0.95)
  
  return(c(p.value = test$p.value))
})
res_cor = data.frame(correlation = means_cor)
res_cor$p_value = ifelse(res_cor$correlation >= 0, 
                         sign_tests_results_pos,
                         sign_tests_results_neg)
res_cor