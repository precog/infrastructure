/* Remove all current collections other than token-related */
print("Dropping collections");
db.path_children.drop();
db.variable_children.drop();
db.variable_series.drop();
db.variable_value_series.drop();
db.variable_values.drop();

// Ensure indices
print("Indexing collections");
db.path_children.ensureIndex({"path" : 1, "accountTokenId" : 1, "child" : 1}, {"name" : "path_child_query_index"});
db.path_children.ensureIndex({"path" : 1, "accountTokenId" : 1}, {"name" : "path_query_index"});
db.variable_children.ensureIndex({"path" : 1, "accountTokenId" : 1, "variable" : 1}, {"name" : "variable_query_index"});
db.variable_series.ensureIndex({"id" : 1}, {"unique" : true, "name" : "var_series_id_index"});
db.variable_value_series.ensureIndex({"id" : 1}, {"unique" : true, "name" : "var_val_series_id_index"});
db.variable_values.ensureIndex({"id" : 1}, {"unique" : true, "name" : "var_val_id_index"});

// Shard collections
print("Sharding collections");
adminDB = db.getSisterDB("admin");
adminDB.runCommand({ shardCollection : "analytics1.variable_series", key : { "id" : 1 }});
adminDB.runCommand({ shardCollection : "analytics1.variable_value_series", key : { "id" : 1 }});
adminDB.runCommand({ shardCollection : "analytics1.variable_values", key : { "id" : 1 }});