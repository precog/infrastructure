db.tokens.update({ tokenId: "8E680858-329C-4F31-BEE3-2AD15FB67EED"}, {"tokenId" : "8E680858-329C-4F31-BEE3-2AD15FB67EED", "parentTokenId" : null, "accountTokenId" : "8E680858-329C-4F31-BEE3-2AD15FB67EED", "path" : "/", "permissions" : { "read" : true, "write" : true, "share" : true, "explore" : true }, "expires" : NumberLong("9223372036854775807"), "limits" : { "order" : NumberLong(100), "limit" : NumberLong(100), "depth" : NumberLong(100), "tags" : NumberLong(100), "lossless" : true, "rollup" : NumberLong(100) } }, true, false);
db.tokens.update({ tokenId: "A3BC1539-E8A9-4207-BB41-3036EC2C6E6D"}, {"accountTokenId" : "A3BC1539-E8A9-4207-BB41-3036EC2C6E6D", "expires" : NumberLong("9223372036854775807"), "limits" : { "depth" : NumberLong(3), "limit" : NumberLong(20), "lossless" : true, "order" : NumberLong(2), "rollup" : NumberLong(<%= @node[:reportgrid][:tokens][:test][:rollup] %>), "tags" : NumberLong(2) }, "parentTokenId" : "8E680858-329C-4F31-BEE3-2AD15FB67EED", "path" : "/test-account-root/", "permissions" : { "read" : true, "write" : true, "share" : true, "explore" : true }, "tokenId" : "A3BC1539-E8A9-4207-BB41-3036EC2C6E6D" }, true, false);
