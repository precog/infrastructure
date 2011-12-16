/* Remove all current collections other than token-related */
print("Dropping collections");
db.hierarchy_children.drop();
db.path_children.drop();
db.path_tags.drop();
db.variable_children.drop();
db.variable_series.drop();
db.variable_value_series.drop();
db.variable_values.drop();

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
print("Sharding collections");
adminDB = db.getSisterDB("admin");
adminDB.runCommand({ shardCollection : "analytics1.variable_series", key : { "accountTokenId" : 1, "path" : 1, "id" : 1 }});
adminDB.runCommand({ shardCollection : "analytics1.variable_value_series", key : { "accountTokenId" : 1, "path" : 1, "id" : 1 }});
adminDB.runCommand({ shardCollection : "analytics1.variable_values", key : { "accountTokenId" : 1, "path" : 1, "id" : 1 }});

// pre-split collections
var splitPoints = [
    "1000000000000000000000000000000000000000",
    "2000000000000000000000000000000000000000",
    "3000000000000000000000000000000000000000",
    "4000000000000000000000000000000000000000",
    "5000000000000000000000000000000000000000",
    "6000000000000000000000000000000000000000",
    "7000000000000000000000000000000000000000",
    "8000000000000000000000000000000000000000",
    "9000000000000000000000000000000000000000",
    "a000000000000000000000000000000000000000",
    "b000000000000000000000000000000000000000",
    "c000000000000000000000000000000000000000",
    "d000000000000000000000000000000000000000",
    "e000000000000000000000000000000000000000"
]

print("Pre-splitting collections")
for (splitkey in splitPoints) {
    adminDB.runCommand({ split : "analytics.variable_series", middle : { "id" : splitkey } });
    adminDB.runCommand({ split : "analytics.variable_values", middle : { "id" : splitkey } });
}

print("Complete")