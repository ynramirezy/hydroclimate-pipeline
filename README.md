# AGH Repository of Local-scale Evapotranspiration Data

Welcome to An Open R Pipeline for Daily High-Resolution Hydroclimatic Raster Data Processing over Poland!<br>
Built-in the AGH University of Science and Technology of Kraków<br>
Wydział Geodezji Górniczej i Inżynierii Środowiska

info at yyara@agh.edu.pl<br><br>

<h3>Introduction</h3>

Welcome to the first open-source repository in Poland dedicated to the generation and processing of daily high-resolution hydroclimatic raster data, including evapotranspiration, precipitation, and runoff. This R-based pipeline allows users to generate and download raster datasets, discretized by powiaty (counties), ensuring 100% geographical coverage across the country. The data is processed on a daily basis and designed to support applications in hydrology, climate research, environmental monitoring, and more.

Features of the structured time indexed daily raster output from the pipeline.
| Hydroclimate Variable     | Format   | Data Type              | Temporal Window  | Spatial Resolution*  | Geoprocessing Method                   |
|---------------------------|----------|------------------------|------------------|----------------------|----------------------------------------|
| Evapotranspiration (mm/d) | .GeoTIFF | Dynamic time indexed   | Daily            | 30-meter pixel       | Multidimensional reduction             |
| Precipitation (mm/d)      | .GeoTIFF | Dynamic time indexed   | Daily            | 30-meter pixel       | Interpolation using Ordinary Kriging   |
| Runoff (mm/d)             | .GeoTIFF | Dynamic time indexed   | Daily            | 30-meter pixel       | Interpolation using Ordinary Kriging   |

Evapotranspiration, precipitation and runoff data are downloaded and generated from the EUMETSAT (2025), collected from synoptic meteorological stations operated by the Polish Institute of Meteorology and Water Management (Czernecki, et al., 202; IMGW-PIB, 2025) and downloaded using Google Earth Engine (GEE) from the ECMWF/ERA5_LAND/DAILY_AGGR dataset (ECMWF, 2025) respectively with a daily temporal resolution. 

<h3>Repository structure</h3>

pipeline/<br>
├── assets/ # Static input data<br>
│ ├── runoff_backup/ # Backup rasters of runoff<br>
│ ├── coords/ # Coordinates files<br>
│ ├── powiaty/ # County-level shapefiles<br>
│ └── zero raster/ # Blank base rasters<br>
│<br>
├── modules/ # Main callable pipeline functions<br>
│ ├── precipitation_data() # Generate precipitation rasters<br>
│ ├── evapotranspiration_data() # Generate evapotranspiration rasters<br>
│ └── runoff_data() # Generate runoff rasters<br>
│<br>
├── functions/ # Internal supporting R scripts<br>
│ ├── dimension_reduction.R<br>
│ ├── environment_settings.R<br>
│ ├── evapotranspiration_webscraping.R<br>
│ ├── geostatistical_interpolation.R<br>
│ ├── harmonization.R<br>
│ ├── precipitation_webscraping.R<br>
│ ├── runoff_gee.js<br>
│ └── runoff_webscraping.R<br>
│<br>
└── global.R # Loads all modules and dependencies<br>


<h3>References</h3>
<ul>
  <li>Czernecki, B., Głogowski, A., & Nowosad, J. (2020). Climate: An R package to access free in-situ meteorological and hydrological datasets for environmental assessment. Sustainability, 12(1), 394. https://doi.org/10.3390/su12010394.</li>
  <li>European Centre for Medium-Range Weather Forecasts (ECMWF). (2025). ERA5-Land daily aggregated data from 1981 to present. Copernicus Climate Change Service (C3S) via Google Earth Engine. Retrieved June 6, 2025, from https://developers.google.com/earth-engine/datasets/catalog/ECMWF_ERA5_LAND_DAILY_AGGR.</li>
  <li>Polish Institute of Meteorology and Water Management - National Research Institute, Department of Measuring and Observation Service (IMGW-PIB). (2025). State of the art of the Polish meteorological service. Retrieved June 6, 2025, from https://www.imgw.pl/instytut/imgw-pib.</li>
  <li>The European Organisation for Meteorological Satellites (EUMETSAT). (2025). Daily evapotranspiration MDMET. Retrieved June 6, 2025, from https://datalsasaf.lsasvcs.ipma.pt/PRODUCTS/MSG/MDMET/.</li>  
</ul>
