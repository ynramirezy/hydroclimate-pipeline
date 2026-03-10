// Setting the area
var poland = ee.FeatureCollection('projects/ee-ynryara-cpsys/assets/Poland');
var poland_geom = poland.geometry();

// Defining time range
var startYear = 1960;
var endYear = 2025;

// Main function to generate the runoff stacks
for (var year = startYear; year <= endYear; year++) {
  var start_date = ee.Date.fromYMD(year, 1, 1);
  var end_date   = ee.Date.fromYMD(year, 12, 31).advance(1, 'day');
  var runoff_annual = ee.ImageCollection('ECMWF/ERA5_LAND/DAILY_AGGR')
    .filterDate(start_date, end_date)
    .select('surface_runoff_sum')
    .map(function(img) {
      var dateStr = img.date().format('YYYYMMdd');
      return img.multiply(1000) 
                .multiply(100)  
                .round()
                .toUint16()     
                .rename(dateStr)
                .clip(poland_geom);
    });

// Creating the stack 
var annual_stack = runoff_annual.toBands();
var final_stack =annual_stack.rename(runoff_annual.aggregate_array('system:index'));

// Export as tiff
Export.image.toDrive({
    image: annual_stack,
    description: 'Runoff_Poland_Stack_' + year,
    folder: 'ERA5_Runoff_Poland_Full', 
    fileNamePrefix: 'runoff_poland_' + year + '_stack',
    region: poland_geom,
    scale: 10000,
    crs: 'EPSG:2180',
    fileFormat: 'GeoTIFF',
    formatOptions: {
      cloudOptimized: true
    },
    maxPixels: 1e13
  });
}
