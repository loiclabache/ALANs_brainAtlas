Atlas of Lateralized visuospatial Attentional Networks (ALANs)
================

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10655105.svg)](https://doi.org/10.5281/zenodo.10655105)

------------------------------------------------------------------------

In accordance with the
[SENSAAS](https://github.com/loiclabache/SENSAAS_brainAtlas),
[WMCA](https://github.com/loiclabache/WMCA_brainAtlas), and
[HAMOTA](https://github.com/loiclabache/HAMOTA_brainAtlas) atlases, this
repository introduces the **ALANs** atlas, which encompasses 95
specifically selected regions underpinning the **anatomical and
functional bases of visuo-spatial** attention in humans.

------------------------------------------------------------------------

## Reference

For usage of the ***manuscript***, please cite:

- **Labache, L.**, Petit, L., Joliot, & Zago, L. (2024). Atlas for the
  Lateralized Visuospatial Attention Networks (ALANs): Insights from
  fMRI and Network Analyses. DOI:
  [10.1101/2024.02.13.580164](https://doi.org/10.1101/2024.02.13.580164)

For usage of the associated ***code***, ***data***, or
***visualization***, please also cite:

- **Labache, L.**, (2024). loiclabache/ALANs_brainAtlas: Atlas for the
  Lateralized Visuospatial Attention Networks (ALANs)
  (Labache_2024_ALANs_240214). Zenodo.DOI:
  [10.5281/zenodo.10655105](https://doi.org/10.5281/zenodo.10655105)

------------------------------------------------------------------------

## Background

Hemispheric specialization is central to human evolution and fundamental
to human cognitive abilities. While being a defining feature of
functional brain architecture, hemispheric specialization is overlooked
to derive brain parcellations. Alongside language, which is typically
lateralized in the left hemisphere, visuospatial attention is set to be
its counterpart in the opposite hemisphere. However, it remains
uncertain to what extent the anatomical and functional underpinnings of
lateralized visuospatial attention mirror those supporting language.
*Building on our previous work*, which established a lateralized brain
atlas for language, we propose a comprehensive **cerebral lateralized
atlas delineating the anatomo-functional bases of visuospatial
attention**, ALANs. Combining task and resting-state functional
connectivity analyses, we identified **95 lateralized brain areas**
comprising **five networks** supporting visuospatial attention
processes. Among them, we can find two large-scale networks: the
ParietoFrontal and TemporoFrontal networks. We identify hubs playing a
pivotal role in the intra-hemispheric interaction within visuospatial
attentional networks. The rightward lateralized ParietoFrontal
encompasses one hub, the inferior frontal sulcus, while the
TemporoFrontal network encompasses two right hubs: the inferior frontal
cortex (pars triangularis and the anterior insula) and the posterior
part of the superior temporal sulcus. Together, these networks encompass
the **homotope** of the language network from the left hemisphere. This
atlas of visuospatial attention provides valuable insights for future
investigations into the variability of visuospatial attention and
hemispheric specialization research. Additionally, it facilitates more
**effective comparisons among different studies**, thereby enhancing the
**robustness** and **reliability** of research in the field of
attention.

<p align="center">
<img src="Image/ALANs_volume.gif" width="50%" height="50%" />
</p>

------------------------------------------------------------------------

## Data release

The `Atlas` folder contains 4 files:

- `read_me_ALANs.rtf`: README file containing information. about the
  atlas
- `ALANs_MNI_ICBM_152_2mm.nii.gz`: NIfTI file containing the 95 brain
  regions in the MNI space.

<p align="center">
<img src="Image/ALANs_networks.png" width="55%" height="55%" />
</p>

- `ALANs_description.txt`: text file containing a full description of
  each regions. The first column *Network* corresponds to which of the 5
  networks a region belongs. The second column *Abbreviation* is the
  abbreviation of a region. The third column *Region* is the full
  anatomical label of a region. *Hemisphere* refers to the cerebral
  hemisphere to which a region belongs. *Index* is the index of each
  region that is used in the NIfTI file. Finaly, the MNI coordinate
  (columns *Xmm*, *Ymm*, *Zmm*) of each regions centroid is provided.

- `template_ANTs_80tvs_on_MNI.nii.gz`: brain template used to align the
  atlas on, provided in MNI stereotaxic space (MNI ICBM 152, Template
  sampling size of 2x2x2 mm3 voxels; bounding box, x = -90 to 90 mm, y =
  -126 to 91 mm, z = -72 to 109 mm).

The `Data` folder contains 3 files and 2 sub-folders:

- `130_participants_BOLD_LBJ_BILGIN.txt`: brain activation of each
  participant for each region of the AICHA atlas during the LBJ (Line
  Bisection Judgment) task.

- `130_participants_BOLD_rs_BILGIN.Rds`: resting-state connectivity
  matrices of the 95 ALANs regions for each participant.

- `comparison_AICHA_Yan2023_400_2mm.csv`: assignment of each region of
  the [AICHA](https://doi.org/10.1016/j.jneumeth.2015.07.013) atlas to
  one of the seven canonical networks proposed by Yan and colleagues
  (2023, DOI:
  [10.1016/j.neuroimage.2023.120010](https://doi.org/10.1016/j.neuroimage.2023.120010)).

- the sub-folder `AICHA_v2` contains the file `AICHA.nii` corresponding
  to the version [2](https://www.gin.cnrs.fr/en/tools/aicha/) (June
  2021, MNI space, resolution of 2mm) of the AICHA atlas.

- the sub-folder `Yan_2023_v0.28.3` contains two files. The first one:
  `400Parcels_Yeo2011_7Networks_FSLMNI152_2mm.nii.gz` corresponding to
  the version
  [0.28.3](https://github.com/ThomasYeoLab/CBIG/blob/e9ae5776742f9e04afaeb6156aaf0085007bea41/stable_projects/brain_parcellation/Yan2023_homotopic/parcellations/MNI/yeo7/400Parcels_Yeo2011_7Networks_FSLMNI152_2mm.nii.gz)
  (MNI space, 400 parcels, 2mm) of the atlas proposed by Yan and
  colleagues (2023, DOI:
  [10.1016/j.neuroimage.2023.120010](https://doi.org/10.1016/j.neuroimage.2023.120010)).
  The second file: `400Parcels_Yeo2011_7Networks_LUT.txt` contains a
  full description of each regions of the atlas, including the
  assignment to the seven canonical networks proposed by Yeo and
  colleagues (2011, DOI:
  [10.1152/jn.00338.2011](https://doi.org/10.1152/jn.00338.2011)).

------------------------------------------------------------------------

## Code release

The `Script` folder includes 2 `R` scripts. The `R` scripts are designed
to facilitate the replication of results as detailed in the
`Method Section` of the **manuscript**.

- `1_ROI_Selection.R`: `R` script to select brain regions that are both
  significantly activated in the right hemisphere and rightward
  lateralized, and regions that are both significantly activated in the
  left hemisphere and leftward lateralized.
- `2_Rest_Classification_and_Metrics.R`: `R` script to perform
  Agglomerative Hierarchical Classification on the average intrinsic
  connectivity matrix, to select the appropriate number of clusters, and
  to compute, for each participant and region, the Degree and the
  Betweenness Centrality.
- `3_Atlas_Comparison.R`: `R` script for assigning each region of the
  [AICHA](https://doi.org/10.1016/j.jneumeth.2015.07.013) atlas to one
  of the seven networks proposed by Yan and colleagues (2023, DOI:
  [10.1016/j.neuroimage.2023.120010](https://doi.org/10.1016/j.neuroimage.2023.120010)).
  Version [2](https://www.gin.cnrs.fr/en/tools/aicha/) (June 2021, MNI
  space, resolution of 2mm) of the AICHA atlas was used in this study.
  For the atlas proposed by Yan and colleagues (2023), version
  [0.28.3](https://github.com/ThomasYeoLab/CBIG/blob/e9ae5776742f9e04afaeb6156aaf0085007bea41/stable_projects/brain_parcellation/Yan2023_homotopic/parcellations/MNI/yeo7/400Parcels_Yeo2011_7Networks_FSLMNI152_2mm.nii.gz),
  featuring 400 parcels within the MNI space at a resolution of 2mm, was
  used.
- `4_SurfIce_Script_Generator.R`: `R` script to generate a `GLS` file
  for use with [Surf Ice](https://www.nitrc.org/projects/surfice/) to
  visualize brain atlases (ALANs or AICHA).

------------------------------------------------------------------------

## Other papers and atlases that might interest you

- The seminal paper describing the Line Bisection Judgment task: Zago,
  L., et al. 2016. DOI:
  [10.1016/j.neuropsychologia.2015.11.018](https://doi.org/10.1016/j.neuropsychologia.2015.11.018)
- SEntence Supramodal Areas AtlaS:
  [SENSAAS](https://github.com/loiclabache/SENSAAS_brainAtlas)
- Language-and-Memory atlas:
  [L∪M](https://github.com/loiclabache/RogerLabache_2023_LanguAging/)
- Word-list Multimodal Cortical Atlas:
  [WMCA](https://github.com/loiclabache/WMCA_brainAtlas)
- HAnd MOtor Area atlas:
  [HAMOTA](https://github.com/loiclabache/HAMOTA_brainAtlas)
- Atlas of Intrinsic Connectivity of Homotopic Areas:
  [AICHA](https://www.gin.cnrs.fr/en/tools/aicha/)

------------------------------------------------------------------------

## Questions

Please contact me (Loïc Labache) as <loic.labache@yale.edu> and/or
<loic.labache@ensc.fr>
