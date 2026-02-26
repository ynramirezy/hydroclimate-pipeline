

<h3>Welcome to Poland’s First Open-Source Automated Terrain-Based Runoff Modeling Pipeline!</h3>
Built-in the AGH University of Science and Technology of Kraków<br>
<img src="pipeline/assets/media/logo.svg" alt="Pipeline Diagram" width="300" />

Ⓜ️ yyara@agh.edu.pl<br><br>

<h3>🚀 New Update</h3>
Version 3 of the pipeline is now available! <br><br>
⚡<strong>Automated terrain-based runoff generation (first of its kind in Poland 🇵🇱): </strong> This is the first open and fully automated pipeline in Poland that generates daily runoff estimates based on terrain-derived features using the SCS-CN methodology. The framework integrates topographic controls, soil properties, and land cover information to produce physically consistent runoff simulations at high spatial resolution. Additionally, the generated runoff is systematically validated against ERA5-based runoff presence, ensuring methodological robustness and scientific reliability.<br><br>
⚡<strong>Validation framework:</strong> Comparison between SCS-CN runoff estimates and ERA5-derived runoff presence.  <br><br>
⚡<strong>New explanatory variables incorporated:</strong>  🆕 Hydrological Soil Groups (HSG) 🆕 CORINE Land Cover.  <br><br>
⚡<strong>Antecedent Moisture Condition (AMC): </strong> Calculation as a proxy for spatio-temporal soil moisture variability in runoff estimation.  <br><br>
⚡<strong>Additional terrain features:</strong> 🆕 Topographic Wetness Index (TWI) 🆕 Surface roughness.  <br><br>
⚡<strong>Updated pipeline resolution and coverage:</strong> <br>
   - Spatial resolution: 200 m pixel size.  <br>
   - Spatial extent: Entire Poland (380 powiats) + user-defined vector areas. <br> 
   - Temporal coverage: Daily time series from 1 January 1960 to one week before the current date.  <br><br>
⚡<strong>Pipeline refactoring:</strong>  <br>
   - Improved modular structure.  <br>
   - Enhanced scalability and usability. <br>  
   - More reproducible and standardized functions.  <br>
   - Optimized processing workflow.  <br><br>

🚀 This version significantly strengthens the physical consistency, reproducibility, and operational capacity of the runoff modeling framework.


<h3>Introduction</h3>


Based on user-defined parameters, such as a specific date range and a region (either by powiat name or a custom shapefile), this R-based framework produces terrain-driven runoff estimates using the SCS-CN methodology. The system integrates topographic features, hydrological soil groups, CORINE land cover, and antecedent moisture conditions to ensure physically consistent outcomes. Runoff outputs are systematically validated against ERA5-based runoff presence, strengthening the scientific robustness of the framework. Designed with modularity, scalability, and reproducibility in mind, this pipeline supports applications in hydrology, climate research, environmental monitoring, hazard assessment, and data-driven modeling.<br>

📢 An article based on this repository will be submitted to a peer-reviewed, indexed scientific journal. Stay tuned for updates!<br>

<h3>Key Features of the Repository</h3>
✔ Daily hydroclimatic runoff raster data for Poland at county (powiat) level.<br>
✔ Variables: DEM, Topographic Wet Index, Corine Land Cover, Hydrological Soil Group, Evapotranspiration, Precipitation, Antecedent Moisture, Superficial Runoff (Table 1). <br>
✔ Functions: Automated Data Acquisition, Terrain & Environmental Characterization, Advanced Geospatial Processing, Hydrological Modeling (SCS-CN), Cloud-Native Integration, Statistics Validation Suite, and Optimized Pipeline Architecture. <br>
✔ User inputs: start date, end date, region.<br>
✔ Outputs: GeoTIFF time series rasters of the pipeline variables, ready for GIS (Image 1).<br>
✔ Built in R, modular and open-source.<br><br>

Table 1. Features of the pipeline variables.
| Pipeline Variable | Units | Source | Data Type | Temporal Window | Spatial Resolution | Pipeline Functions |
| --- | --- | --- | --- | --- | --- | --- |
| **DEM** | m | European Space Agency (2024) | Static | - | 200 m *| `environment_settings()`, `clipping()` |
| **Topographic Wetness Index** | Dimensionless | Pipeline derivated | Static | - | 200 m | `environment_settings()`, `topo_wet_index()` |
| **Roughness** | Dimensionless | Pipeline derivated | Static | - | 200 m | `normalized_roughness()` |
| **Land Cover** | Class ID (CLC) | Copernicus CLMS (2018) | Static | - | 200 m * | `environment_settings()`, `clipping()` |
| **Hydrological Soil Group** | Class (A-D) | Simons, et al (2020) | Static | - | 200 m | `environment_settings()`, `clipping()` |
| **Evapotranspiration** | mm/d | EUMETSAT (2025) | Dynamic | Daily | 200 m * | `evapotranspiration_webscraping()`, `dimension_reduction()`, `harmonization()` |
| **Precipitation** | mm/d | Czernecki, et al (2020) | Dynamic | Daily | 200 m * | `precipitation_webscraping()`, `geostatistical_interpolation()`, `harmonization()` |
| **Antecedent Moisture** | mm | Pipeline derivated | Dynamic | Daily | 200 m | `antecedent_moisture_condition()` |
| **Pipeline Runoff** | mm/d | Pipeline derivated (SCS-CN) | Dynamic | Daily | 200 m | `runoff_CNSCS()` |
| **Runoff for validation** | mm/d | ECMWF (ERA5-Land) | Dynamic | Daily | 10 km * | `validation_runoff()`, `validation_statistics()` |

** Resampled/Interpolated to match pipeline resolution.*<br><br>

<h3>How to Use This Repository</h3>
Follow these steps to generate high-resolution daily rasters of precipitation, evapotranspiration, and runoff for any powiat in Poland.<br>
<br>
1️⃣ Clone the Repository<br>
Open a terminal and run:<br><br>

<pre>git clone https://github.com/ynramirezy/hydroclimate-pipeline.git
cd hydroclimate-pipeline</pre>

2️⃣ Open the Main Script<br>
Open the file hydroclimate-pipeline.R in RStudio or your preferred R environment and customize your inputs. This script is your entry point to the pipeline: 

<pre>r

#Welcome to the Hydroclimate Data Pipeline for Runoff!
#This tool generates runoff rasters based on terrain features and SCS-CN methodology

# Please set the following parameters before running:
start_date <- as.Date("2020-06-15")
end_date <- as.Date("2020-06-25")

# Set the powiaty name or the shapefile path
pipeline_polygon <- c("Łęczyński", "Chełmski", "Włodawski")
#pipeline_polygon <- "../user_polygon.shp"

#And load the pipeline modules and functions
source("pipeline/global.R")

#Then, run the functions one by one and wait while the results are generated!
dem_data() 
topographicWet_index_data()
land_cover_data()
hydrological_soil_data()
evapotranspiration_data()
precipitation_data()
antecedent_moisture_data()
runoff_data()
validation_data()
 </pre>
⚠️ Important!!<br>
Every time you modify the input parameters (start_date, end_date, or powiat_name), you must reload the global.R file.<br>

3️⃣ Pipeline Output<br>

| 2020-06-20 | 2020-06-21 | 2020-06-22 | 2020-06-23 | 2020-06-24 | 2020-06-25 |
| --- | --- | --- | --- | --- | --- |
| <img src="pipeline/assets/media/Validation_Runoff_20200620.png" width="500" /> | <img src="pipeline/assets/media/Validation_Runoff_20200621.png" width="500" /> | <img src="pipeline/assets/media/Validation_Runoff_20200622.png" width="500" /> | <img src="pipeline/assets/media/Validation_Runoff_20200623.png" width="500" /> | <img src="pipeline/assets/media/Validation_Runoff_20200624.png" width="500" /> | <img src="pipeline/assets/media/Validation_Runoff_20200625.png" width="500" /> |

---
Image 1. Output sample of the runoff pipeline repository data for the Łęczyński, Chełmski, and Włodawski counties for the date ranges 2020-06-20 to 2020-06-25.<br>

When visualizing the validation maps, the spatial overlap between the model and the reference data is represented as follows:

* **Grey Zones:** Areas where **ERA5-Land** does not detect runoff (Background/Baseline).
* **Dark Green Zones:** Areas where **ERA5-Land** confirms the presence of runoff.
* **Red Points/Areas:** **Pipeline (SCS-CN)** estimates where no runoff was expected by the reference (Potential false alarms or localized detections).
* **Green Points/Areas:** **Pipeline (SCS-CN)** estimates that correctly coincide with the presence of runoff in the reference data (Hits).

After processing the time series for the selected Powiats, the framework evaluates the spatial consistency between the terrain-based model and the global reference:

> **🎯 The overall accuracy of the Pipeline Runoff presence is: 85.28%**

This high accuracy level indicates a strong spatial agreement in the detection of runoff events, confirming the reliability of the **SCS-CN** approach at a 200m resolution when compared to the **ERA5-Land** 10km baseline.


<h3>Repository structure</h3>

pipeline/<br>
├── assets/ # Static input data<br>
│ ├── gis_meta/ <br>
│ ├── runoff_GEE/ <br>
│ ├── media/ <br>
│<br>
├── modules/ # Main callable pipeline functions<br>
│ ├── dem_data.R <br>
│ ├── topographicWet_index_data.R <br>
│ ├── land_cover_data.R <br>
│ ├── hydrological_soil_data.R <br>
│ ├── evapotranspiration_data.R <br>
│ ├── precipitation_data.R <br>
│ ├── antecedent_moisture_data.R <br>
│ ├── runoff_data.R <br>
│ ├── validation_data.R <br>
│<br>
├── functions/ # Internal supporting R scripts<br>
│ ├── antecedent_moisture_condition.R <br>
│ ├── cleanup.R <br>
│ ├── clipping.R <br>
│ ├── dimension_reduction.R <br>
│ ├── environment_settings.R <br>
│ ├── evapotranspiration_webscraping.R <br>
│ ├── geostatistical_interpolation.R <br>
│ ├── harmonization.R <br>
│ ├── normalized_roughness.R <br>
│ ├── pipeline_output.R <br>
│ ├── precipitation_webscraping.R <br>
│ ├── runoff_CNSCS.R <br>
│ ├── runoff_GEE.js <br>
│ ├── topo_wet_index.R <br>
│ ├── validation_runoff.R <br>
│ ├── validation_statistics.R <br>
│<br>
└── global.R # Loads all modules and functions<br><br>


<h3>References</h3>
<ul>
  <li>Copernicus Land Monitoring Service. (2018). CORINE Land Cover (CLC) 2018. European Environment Agency. https://land.copernicus.eu/en/products/corine-land-cover/clc2018.</li>
  <li>Czernecki, B., Głogowski, A., & Nowosad, J. (2020). Climate: An R package to access free in-situ meteorological and hydrological datasets for environmental assessment. Sustainability, 12(1), 394. https://doi.org/10.3390/su12010394.</li>
  <li>European Centre for Medium-Range Weather Forecasts (ECMWF). (2025). ERA5-Land daily aggregated data from 1981 to present. Copernicus Climate Change Service (C3S) via Google Earth Engine. https://developers.google.com/earth-engine/datasets/catalog/ECMWF_ERA5_LAND_DAILY_AGGR.</li>
  <li>European Space Agency. (2024). Copernicus Global Digital Elevation Model. Distributed by OpenTopography. https://doi.org/10.5069/G9028PQB</li>
  <li>Simons, G. W. H., Koster, R., & Droogers, P. (2020). HiHydroSoil v2.0: A high resolution soil map of global hydraulic properties (FutureWater Report 213). FutureWater. https://www.futurewater.eu/projects/hihydrosoil-v2-0-global-maps-of-soil-hydraulic-properties-at-250m-resolution/.</li>
  <li>The European Organisation for Meteorological Satellites (EUMETSAT). (2025). Daily evapotranspiration MDMET. Retrieved June 6, 2025, from https://datalsasaf.lsasvcs.ipma.pt/PRODUCTS/MSG/MDMET/.</li>  
</ul>
