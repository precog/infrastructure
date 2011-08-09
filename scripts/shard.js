db.runCommand( { addshard : "1/mongodb01.reportgrid.com:27018,mongodb02.reportgrid.com:27018" } );
db.runCommand( { addshard : "2/mongodb04.reportgrid.com:27018,mongodb05.reportgrid.com:27018" } );
db.runCommand( { addshard : "3/mongodb07.reportgrid.com:27018,mongodb08.reportgrid.com:27018" } );

db.runCommand( { enablesharding : "analytics0-3" } );

db.runCommand( { shardcollection : "analytics0-3.variable_value_series", key : { "id":1}});
db.runCommand( { shardcollection : "analytics0-3.variable_series", key : { "id":1}});
db.runCommand( { shardcollection : "analytics0-3.variable_values", key : { "id":1}});
db.runCommand( { shardcollection : "analytics0-3.variable_values_infinite", key : { "id":1}});
