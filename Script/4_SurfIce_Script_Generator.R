################################################################################
# Written by Loïc Labache, Ph.D.                                               #
# Holmes Lab, Department of Psychiatry - Rutgers University                    #
# January 30, 2024                                                             #
################################################################################

# Packages......................................................................
#...............................................................................
packages <- c("here")
lapply(packages, require, character.only = T)

# Load Data.....................................................................
#...............................................................................
path_comp_res = "Data"
comp_res = read.csv(here(path_comp_res, 
                         "comparison_AICHA_Yan2023_10000_2mm.csv"))[, -1]

# Region of Interest............................................................
#...............................................................................
# The original AICHA region numbers:
regions_aicha = comp_res[comp_res$hemisphere == "LH", ]$aicha # Insert your AICHA regions number here
# Convert region numbers to Surf Ice (if necessary):
# regions_surfice = regions_aicha
regions_surfice = (regions_aicha + 1)/2
# Color for each region (same order than "regions_aicha"):
color_region = comp_res[comp_res$hemisphere == "LH", ]$Network_7_nb  # Insert value of the regions here

# Surf Ice Parameters...........................................................
#...............................................................................
atlas = "AICHAhr.lh.mz3" # AICHAhr.lh.mz3 | AICHAhr.rh.mz3
shaderName = "Phong_Matte"
colorOverlay_region = "Viridis" # Choose color of AICHA regions here
colorOverlay_template = "Grayscale" # Choose brain template color here
brain_template = "my_template.white"

# Write & Save GLS Script.......................................................
#...............................................................................
sciptName = "my_surfice_script.gls"
writeLines(c("import gl", "gl.resetdefaults()", 
             paste0(paste0("gl.atlasstatmap('/Surfice/atlas/",
                           atlas, "','',("), paste(regions_surfice, 
                                                   collapse=", "),
                    "),(", paste(color_region, collapse=", "), "))"),
             paste0("gl.shadername('", shaderName, "')"), 
             "gl.shaderxray(0, 0)", "gl.shaderforbackgroundonly(0)",
             paste0("gl.overlaycolorname(1, '", colorOverlay_region, "')"),
             "gl.overlayminmax(1, 1, 8)",
             paste0("gl.overlayload('", brain_template, "')"),
             paste0("gl.overlaycolorname(2, '", colorOverlay_template, "')")),
           file(sciptName))
