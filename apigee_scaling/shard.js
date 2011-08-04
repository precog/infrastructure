db.runCommand( { addshard : "4/rgm-012.reportgrid.com:27018,rgm-013.reportgrid.com:27018" } );
db.runCommand( { addshard : "5/rgm-015.reportgrid.com:27018,rgm-016.reportgrid.com:27018" } );
db.runCommand( { addshard : "6/rgm-018.reportgrid.com:27018,rgm-017.reportgrid.com:27018" } );
db.runCommand( { addshard : "7/rgm-021.reportgrid.com:27018,rgm-022.reportgrid.com:27018" } );

db.runCommand( { enablesharding : "analytics0-3" } );

db.runCommand( { shardcollection : "analytics0-3.variable_value_series", key : { "id":1}});
db.runCommand( { shardcollection : "analytics0-3.variable_series", key : { "id":1}});
db.runCommand( { shardcollection : "analytics0-3.variable_values", key : { "id":1}});
db.runCommand( { shardcollection : "analytics0-3.variable_values_infinite", key : { "id":1}});
