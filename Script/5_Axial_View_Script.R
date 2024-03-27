################################################################################
# Written by Loïc Labache, Ph.D.                                               #
# Holmes Lab, Department of Psychiatry - Rutgers University                    #
# March 27, 2024                                                               #
################################################################################

#===============================================================================
# Packages......................................................................
#...............................................................................
packages <- c("here", "oro.nifti", "neurobase", "RNifti", "progress")
lapply(packages, require, character.only = T)

#===============================================================================
# Path..........................................................................
#...............................................................................
path_template = "/Atlas/template_ANTs_80tvs_on_MNI_1mm.nii.gz"
path_alans = "/Atlas/ALANs_MNI_ICBM_152_1mm.nii.gz"
path_dscrpt = "Atlas/ALANs_description.txt"

#===============================================================================
# Load Data.....................................................................
#...............................................................................
template = readnii(here(here(), path_template))
alans = readnii(here(here(), path_alans))
alans_dscrpt = read.csv(here(here(), path_dscrpt))

#===============================================================================
# Region of Interest............................................................
#...............................................................................
alans_dscrpt = alans_dscrpt[alans_dscrpt$Atlas_Homotopic == "Homotopic", ]
alans_dscrpt = alans_dscrpt[order(alans_dscrpt$Index), ]
alans[!alans %in% alans_dscrpt$Index] = 0

#===============================================================================
# Visualization: axial view.....................................................
#...............................................................................
affine_matrix = xform(template)
affine_matrix_inv = solve(affine_matrix)
slice_mni_coord = c(-10, 0, 10, 20, 30, 40, 50, 60)
slice_vxl_coord = rep(NA, length(slice_mni_coord))
for (i in 1:length(slice_mni_coord)){
  slice_vxl_coord[i] = round(affine_matrix_inv %*% c(0, 0, slice_mni_coord[i], 1))[3, 1]
}
new_index = c(1:95)
pb = progress_bar$new(format = "Progress: [:bar] :percent eta: :eta",
                      total = length(new_index))
for (r in 1:length(new_index)){
  pb$tick()
  alans[alans == alans_dscrpt$Index[r]] = new_index[r]
}
# rep_col = table(alans)[-1]
# slice_overlay(x = template,
#               y = alans,
#               z = slice_vxl_coord,
#               useRaster = TRUE,
#               bg = 'black',
#               NA.x = FALSE,
#               col.y = alans_dscrpt$HEXA)
#               # col.y = viridis::inferno(n=1000))
#               # col.y = rep(c("#00000000", alans_dscrpt$HEXA), rep_col))
#               # col.y = rep(alans_dscrpt$HEXA, rep_col))


ortho2(x = template,
       y = alans,
       crosshairs = FALSE,
       bg = 'black',
       NA.x = FALSE,
       # ybreaks = c(1:96),
       col.y = alans_dscrpt$HEXA,
       # col.y = randomcoloR::distinctColorPalette(95),
       # col.y = viridis::inferno(n=500),
       xyz = c(5, 5, 62),
       useRaster = TRUE,
       ycolorbar = FALSE,
       mfrow = c(1,3))


#===============================================================================
# Resampling with flsr..........................................................
#...............................................................................
# template@pixdim[2:4]
# alans@pixdim[2:4]
# template_2mm = fsl_resample(file = template,
#                             outfile = "/Users/loiclabache/Dropbox (GIN)/Published Paper - LL/GitHub/ALANs_brainAtlas/Atlas/template_ANTs_80tvs_on_MNI_2mm",
#                             voxel_size = 2)