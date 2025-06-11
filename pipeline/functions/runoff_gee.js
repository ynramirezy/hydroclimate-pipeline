// ----------------------------------------------------------
// 🛈 This script downloads raw runoff data as intermediate
// information for generating high-resolution runoff rasters.
//
// 👉 Please only set the start and end dates below.

var start_date= ee.Date('2023-12-28');
var end_date= ee.Date('2023-12-29');

// 📝 After running the script, go to the "Tasks" tab ain the right panel nd click "Run".
// 📁 The raw runoff table will be saved to your Google Drive.
// ⬇️ Once exported, download the file named `runoff_raw.csv`and place it into the folder:
//    `hydroclimate-pipeline/runoff_startdate_enddate/runoff_raw`
// ----------------------------------------------------------


//runoff raw generator
var powiat = ee.FeatureCollection('projects/ee-ynryara-cpsys/assets/Poland');
var extended_end = end_date.advance(2, 'day');
var n_days = extended_end.difference(start_date, 'day').toInt();
var dateList = ee.List.sequence(0, n_days.subtract(1)).map(function(dayOffset) {
  return start_date.advance(dayOffset, 'day').format('YYYY-MM-dd');
});
var runoff_query = ee.FeatureCollection([]);
for (var i = 0; i < n_days.subtract(1).getInfo(); i++) {
  var currentDate = ee.String(dateList.get(i));
  var nextDate = ee.String(dateList.get(i + 1));
  var runoff = ee.ImageCollection('ECMWF/ERA5_LAND/DAILY_AGGR')
    .filterDate(currentDate, nextDate) 
                .select('surface_runoff_sum')
                .filterBounds(powiat)
                .first()
                .clip(powiat);
  var runoffValue = runoff.sampleRegions({
    collection: powiat, 
    geometries: true
  });
  var latLonRunoff = runoffValue.map(function(feature) {
    var coordinates = feature.geometry().coordinates(); 
    var lat = coordinates.get(1); 
    var lon = coordinates.get(0);  
    var runoffSum = feature.get('surface_runoff_sum'); 
    var date= currentDate; 
    return feature.set({'latitude': lat, 'longitude': lon, 'runoff_sum': runoffSum, 'date': date}); 
  });
  runoff_query= runoff_query.merge(latLonRunoff);
};
Export.table.toDrive({
  collection: runoff_query, 
  description: "runoff_raw",
  fileFormat: "CSV",
  selectors: ['latitude', 'longitude', 'surface_runoff_sum', 'date'],
  folder: 'RO_points'
});