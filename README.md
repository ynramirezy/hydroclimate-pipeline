# AGH Repository of Local-scale Evapotranspiration Data

<img src="https://github.com/ynramirezy/AGH_Repository_Local-scale_EvapotranspirationData/blob/main/GIS_resources/facultad.png" />
Welcome to Poland's Local-Scale Evapotranspiration Data!<br>
Built-in the AGH University of Science and Technology of Kraków<br>
info at yyara@agh.edu.pl<br>

<h3>Main idea</h3>

The integration of remote sensing images of evapotranspiration in Poland through the GitHub repository offers two comparative advantages over other portals and models with evapotranspiration information. Firstly, evapotranspiration data are downloaded from the EUMETSAT (2024) with a daily temporal resolution, making it the web portal that offers the highest temporal resolution worldwide for free download of evapotranspiration images. Secondly, the EUMETSAT data model facilitates easy access and downloading of information using web scraping tools by automating tasks in Python using Anaconda virtual environments. These evapotranspiration data for Poland, available in the repository, serve as the first web portal for downloading specialized information for the country, thus becoming a crucial input for the estimation of runoff and prevention of natural disasters, leveraging the temporal and spatial resolution provided.<br>

The construction of the repository involved the creation of tools for the automatic extraction of data necessary for evapotranspiration analyses worldwide. In addition to evapotranspiration data, other data necessary for analyses of water run-off and water management locally were collected for Poland only. These included data on water precipitation, land infiltration and land use (EUMETSAT 2024; Czernecki et al. 2020; PGI-NRI 2024; Bergeson et al. 2022; Bi et al. 2014; Regüés et al. 2017; Hidayati et al. 2021; d'Obyrn 2012). Data integration in the repository, specific to Poland was developed in Anaconda (Mendez et al. 2019; Rolon-Mérette et al. 2020; Zampetti et al. 2021). It employs CI/CD pipelines to enhance code updates and versioning under its lifecycle through GitHub tools (Ramasamy et al. 2023; Wu et al. 2024; Oliveira et al. 2023; Wessel et al. 2023). Thereby establishing it as an indispensable and exclusive tool for accessing environmental data in Poland (the referenced repository focuses on a region north of the city of Lubin). It provides users with the capability to reparameterize the data according to their specific needs, such as defined areas in the country, temporal windows, spatial resolutions, among others, using built-in functions available in the repository.

<h3>Evapotranspiration data</h3>
This information originates from various sources. Through code automation tools for massively download dataset (code hosted in the GitHub repository), it has been standardized to the same temporal and spatial resolution (pixel size of 30 meters), reference system, and units of measurement (mm/h). This ensures that the data in the repository can be utilized for future analyses such as trend analysis, map algebra, principal component analysis, among others.<br><br>

<b>Data gathering </b><br>
The repository for local-scale evapotranspiration comprises data on evapotranspiration (ET) and precipitation (P), the parameter K for water infiltration according to the soil features (Ks) and land use (Kl). The spatial coverage of the repository data depends on the nature and availability of the information. For example, the variables of evapotranspiration and precipitation have spatial coverage for the whole of Poland (the repository contains ready-to-download images of precipitation and evapotranspiration for five counties located in the northern part of Lower Silesia (Dolnośląskie): Polkowice, Lubin, Wołów, Legnica, and the city of Legnica. Additionally, the repository includes code that allows users to configure and generate images for various geographic areas, ranging from municipalities (Gminy) to counties (Powiaty), states (Województwa), and even the entire country. This transforms the repository into not only a centralized hub for evapotranspiration information but also a dynamic portal for generating new data on demand), while the parameter K of soil infiltration, according to land use and soil conditions, is available in the repository only for the city of Lubin.<br>

<b>Datasets </b><be>
<ul>
  <li>Evapotranspiration data, measured in milimeters per hour (mm/h), is sourced from EUMETSAT (2024), utilizing the second generation of MSG satellites. These satellites, operating in synchronized pairs, provide real-time quantification of evapotranspiration worldwide, capturing the flux of water vapor and heat release from the ground to the atmosphere. Python code was automated for web scraping to acquire this information for Poland’s land extent (the repository includes a sample of the country's counties; however, users can generate their own images by configuring parameters based on their geographic region of interest, ranging from municipalities to the entire country), for projecting to the coordinate system for Poland EPSG 2180 and for resampling to a local scale resolution of 30-meter pixel (code hosted in the GitHub repository). The evapotranspiration accuracy is ± 0,25 mm/h.</li>
  <li>Poland precipitation data was obtained by utilizing the climate R library (Czernecki et al. 2020). Daily accumulated precipitation data from synoptic stations across the country were downloaded (code available in the repository), (Figure 1). These tabular data were then processed using geostatistics to create interpolation surfaces, employing an ordinary kriging exponential model.<br><br>
<img src="https://github.com/ynramirezy/AGH_Repository_Local-scale_EvapotranspirationData/blob/main/GIS_resources/Figure1.jpg" alt="Figure 1" width="600"/><br>
  Figure 1. Map of the meteorological stations in Poland are displayed in red triangle symbol (IMGW-PIB 2024), states are displayed in black border and countries in grey border</li>
  <li>For soil Ks infiltration, detailed studies were conducted by the National Geological Institute (PGI-NRI 2024) across Poland provides access to comprehensive information on water infiltration rates based on soil composition and characteristics (Figure 2). The geological map of 1:50000 scale was digitized for the study area. The raster map resolution was high of 1 meter. Following the assumption about data unification, the vectorised map was generalized to the map with the resolution of 30 meters. After georeferencing and digitizing the cartography of the geological web map, a raster is generated to represent the infiltration rate of water into the soil. <br><br>
  <img src="https://github.com/ynramirezy/AGH_Repository_Local-scale_EvapotranspirationData/blob/main/GIS_resources/Figure2.jpg" alt="Figure 2" width="600"/><br>
  Figure 2. Detailed geological map of Poland (PGI-NRI 2024). </li>
  <li>The cartography of land use incorporates the rate of water infiltration into the soil based on the type of land cover. These infiltration rates are determined according to values established in a comprehensive study of soil infiltration worldwide.</li>
</ul>


🌐 Downloading Runoff Data from Google Earth Engine (JavaScript)
You can download runoff data manually using the GEE Code Editor.

Steps:
Open the script:
Go to pipeline/gee_scripts/download_runoff_from_gee.js.

Copy-paste into GEE Editor:
Visit https://code.earthengine.google.com/
and paste the script.

Set parameters:
Edit the start, end, and region variables in the script.

Run and export:

Click Run.

Export the table using Export.table.toDrive().

🔒 You must have access to Google Earth Engine and be signed in.


<h3>References</h3>
<ul>
  <li>Bergeson CB, Martin KL, Doll B, Cutts BB (2022) Soil infiltration rates are underestimated by models in an urban watershed in central North Carolina, USA. J Environ Manage. 313. 15004. https://doi.org/10.1016/j.jenvman.2022.115004.</li>
  <li>Bi Y, Zou H, Zhu C (2014) Dynamic monitoring of soil bulk density and infiltration rate during coal mining in sandy land with different vegetation. Int J Coal Sci Technol. 1. 198–206. https://doi.org/10.1007/s40789-014-0025-2.</li>
  <li>Czernecki B, Głogowski A, Nowosad J (2020) Climate: An R Package to Access Free In-Situ Meteorological and Hydrological Datasets For Environmental Assessment. Sustainability. 12(1). 394. https://doi.org/10.3390/su12010394.</li>
  <li>d'Obyrn K (2012) The analysis of destructive water infiltration into the Wieliczka Salt Mine – a unique UNESCO site. GEOL Q. 56(1). 85-94. https://gq.pgi.gov.pl/article/view/7669.</li>
  <li>Hidayati IK, Suhardjono HD, Suharyanto A (2021) Ponding time in infiltration process for different land use. IOP. 930. 12-54. https://dx.doi.org/10.1088/1755-1315/930/1/012054.</li>
  <li>Mendez KM, Pritchard L, Reinke SN, Broadhurst DI (2019) Toward collaborative open data science in metabolomics using Jupyter Notebooks and cloud computing. J. Metabolomics. 15. 125. https://doi.org/10.1007/s11306-019-1588-0.</li>
  <li>Oliveira GP, Moura AFC, Batista NA, Brandão M, Hora A, Moro M (2023) How do developers collaborate? Investigating GitHub heterogeneous networks. Software Qual J. 31. 211–241. https://doi.org/10.1007/s11219-022-09598-x.</li>
  <li>Ramasamy D, Sarasua C, Bacchelli A, Bernstein A (2023) Workflow analysis of data science code in public GitHub repositories. Empir Software Eng. 28. 7. https://doi.org/10.1007/s10664-022-10229-z.</li>
  <li>Regüés D, Badía D, Echeverría M, Gispert M, Lana-Renault N, León J, Nadal M, Pardini G, Serrano-Muela P (2017) Analysing the effect of land use and vegetation cover on soil infiltration in three contrasting environments in northeast Spain. CIG. 43(1). 141-169. https://doi.org/10.18172/cig.3164.</li>
  <li>Rolon-Mérette D, Ross M, Rolon-Mérette T, Church K (2020) Introduction to Anaconda and Python: Installation and setup. Quant. Meth. Psych. 16. S3-S11. https://doi.org/10.20982/tqmp.16.5.S003.</li>
  <li>The European Organisation for Meteorological Satellites EUMETSAT (2024) Daily evapotranspiration MDMET. Available online: https://datalsasaf.lsasvcs.ipma.pt/PRODUCTS/MSG/MDMET/. Accessed on 5 September 2024.</li>
  <li>The Polish Geological Institute - National Research Institute PGI-NRI (2024) Geological cartographic webmap. Available online: https://geologia.pgi.gov.pl/karto_geo/. Accessed on 5 September 2024.</li>
  <li>Wessel M, Vargovich J, Gerosa MA, Treude C (2023) GitHub Actions: The Impact on the Pull Request Process. Empir Software Eng. 28. 131. https://doi.org/10.1007/s10664-023-10369-w.</li>
  <li>Wu J, He H, Gao K, Xiao W, Li J, Zhou M (2024) A comprehensive analysis of challenges and strategies for software release notes on GitHub. Empir Software Eng. 29. 104. https://doi.org/10.1007/s10664-024-10486-0.</li>
  <li>Zampetti F, Geremia S, Bavota G, Di Penta M (2021) CI/CD Pipelines evolution and restructuring: a qualitative and quantitative study. ICSME. 471-482. https://doi.org/10.1109/ICSME52107.2021.00048.</li>
</ul>
