db.runCommand( { addshard : "5/rgm-013.reportgrid.com:27018,rgm-014.reportgrid.com:27018" } );
db.runCommand( { addshard : "6/rgm-016.reportgrid.com:27018,rgm-017.reportgrid.com:27018" } );
db.runCommand( { addshard : "7/rgm-019.reportgrid.com:27018,rgm-018.reportgrid.com:27018" } );
db.runCommand( { addshard : "8/rgm-022.reportgrid.com:27018,rgm-023.reportgrid.com:27018" } );
db.runCommand( { addshard : "9/rgm-025.reportgrid.com:27018,rgm-026.reportgrid.com:27018" } );
db.runCommand( { addshard : "10/rgm-028.reportgrid.com:27018,rgm-029.reportgrid.com:27018" } );

db.runCommand( { enablesharding : "analytics0-3" } );

db.runCommand( { shardcollection : "analytics0-3.variable_value_series", key : { "id":1}});
db.runCommand( { shardcollection : "analytics0-3.variable_series", key : { "id":1}});
db.runCommand( { shardcollection : "analytics0-3.variable_values", key : { "id":1}});
db.runCommand( { shardcollection : "analytics0-3.variable_values_infinite", key : { "id":1}});
