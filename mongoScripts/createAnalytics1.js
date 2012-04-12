// Ensure indices
print("Indexing collections");
db.path_children.ensureIndex({"accountTokenId" : 1,"path" : 1,  "child" : 1}, {"name" : "path_child_query_index"});
db.variable_children.ensureIndex({"accountTokenId" : 1,"path" : 1,  "variable" : 1}, {"name" : "variable_query_index"});

// Shard collections
print("Sharding database and collections");
adminDB = db.getSisterDB("admin");
adminDB.runCommand({ enablesharding : "analytics1" });

print("Complete")
