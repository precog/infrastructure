db.chunks.find().forEach(function(x) { print(x.min.accountTokenId + "," + x.min.path + "," + x.min.timestamp + "," + x.shard); });
