################################################################################
# Written by Loïc Labache, Ph.D.                                               #
# Holmes Lab, Department of Psychiatry - Rutgers University                    #
# March 28, 2024                                                               #
################################################################################

# Packages......................................................................
#...............................................................................
packages <- c("here", "psych", "progress", "circlize", "ggplot2",
              "ComplexHeatmap")
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

# Visualization Average Correlation.............................................
#...............................................................................
df_visu = data.frame(from = sapply(strsplit(rownames(res_cor), "_"), `[`, 1), 
                     to = sapply(strsplit(rownames(res_cor), "_"), `[`, 2), 
                     value = res_cor$correlation, 
                     p_value = ifelse(res_cor$p_value <= 0.005, 
                                      "significant", "unsignificant"))
network_order = c("PosteriorMedial", "TemporoFrontal", "ParietoFrontal", 
                  "Visu", "SomatoMotor")
chordDiagram(df_visu,
             symmetric = F,
             group = structure(c(1, 2, 3, 4, 5),
                               names = network_order),
             annotationTrack = c("grid", "name"),
             grid.col = structure(c("#fe7340","#e6e01e","#fd1da2","#32bff9", 
                                    "#2fef0e"), names = network_order), 
             transparency = 0,
             order = network_order,
             link.visible = df_visu$p_value == "significant",
             col = colorRamp2(c(min(df_visu$value), 0, max(df_visu$value)),
                              c("blue", "lightgray", "red")))
circos.clear()
lgd_r = Legend(at = c(min(df_visu$value), 0, max(df_visu$value)),
               col_fun = colorRamp2(c(min(df_visu$value), 0, max(df_visu$value)),
                                    c("blue", "lightgray", "red")),
               title_position = "topleft",
               title = "R")
lgd_list_vertical = packLegend(lgd_r)
draw(lgd_list_vertical, 
     x = unit(8, "mm"), 
     y = unit(8, "mm"), 
     just = c("left", "bottom"))
