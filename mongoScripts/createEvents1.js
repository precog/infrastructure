print("Indexing collections");
db.events.ensureIndex({ "accountTokenId" : 1, "path" : 1, "timestamp" : 1 }, { "name" : "raw_events_query_index" });

print("Sharding collections");
adminDB = db.getSisterDB("admin");
adminDB.runCommand({ enablesharding : "events1" });
adminDB.runCommand({ shardCollection : "events1.events", key : { "accountTokenId" : 1, "path" : 1, "timestamp" : 1 }});
