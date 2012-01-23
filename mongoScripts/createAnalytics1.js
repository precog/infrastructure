// Ensure indices
print("Indexing collections");
db.hierarchy_children.ensureIndex({ "accountTokenId" : 1, "path" : 1, "tagName" : 1 });
db.path_children.ensureIndex({"path" : 1, "accountTokenId" : 1, "child" : 1}, {"name" : "path_child_query_index"});
db.path_children.ensureIndex({"path" : 1, "accountTokenId" : 1}, {"name" : "path_query_index"});
db.path_tags.ensureIndex({ "accountTokenId" : 1, "path" : 1 });
db.variable_children.ensureIndex({"path" : 1, "accountTokenId" : 1, "variable" : 1}, {"name" : "variable_query_index"});
db.variable_series.ensureIndex({ "accountTokenId" : 1, "path" : 1, "id" : 1 }, {"unique" : true, "name" : "var_series_id_index"});
db.variable_value_series.ensureIndex({ "accountTokenId" : 1, "path" : 1, "id" : 1 }, {"name" : "var_val_series_index"});
db.variable_values.ensureIndex({ "accountTokenId" : 1, "path" : 1, "id" : 1 }, {"unique" : true, "name" : "var_val_id_index"});

// Shard collections
print("Sharding database and collections");
adminDB = db.getSisterDB("admin");
adminDB.runCommand({ enablesharding : "analytics1" });
adminDB.runCommand({ shardCollection : "analytics1.variable_series", key : { "accountTokenId" : 1, "path" : 1, "id" : 1 }});
adminDB.runCommand({ shardCollection : "analytics1.variable_value_series", key : { "accountTokenId" : 1, "path" : 1, "id" : 1 }});
adminDB.runCommand({ shardCollection : "analytics1.variable_values", key : { "accountTokenId" : 1, "path" : 1, "id" : 1 }});

print("Complete")