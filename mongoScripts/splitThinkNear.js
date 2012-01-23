adminDB = db.getSisterDB("admin");


var splitId = "7fffffffffffffffffffffffffffffffffffffff"

print("Pre-splitting collections")

for (testId = 25; testId < 200; testId = testId + 25) {
    adminDB.runCommand({ split : "analytics1.variable_series", find : { "accountTokenId" : "A0930C79-40BF-4356-B1FF-3DDE89BBEFC8", "path" : ("/thinknear/campaign/" + testId), "id" : splitId } });
    adminDB.runCommand({ split : "analytics1.variable_value_series", find : { "accountTokenId" : "A0930C79-40BF-4356-B1FF-3DDE89BBEFC8", "path" : ("/thinknear/campaign/" + testId), "id" : splitId } });
    adminDB.runCommand({ split : "analytics1.variable_values", find : { "accountTokenId" : "A0930C79-40BF-4356-B1FF-3DDE89BBEFC8", "path" : ("/thinknear/campaign/" + testId), "id" : splitId } });
}
