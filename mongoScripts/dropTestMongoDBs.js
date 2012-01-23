var dbs = db.getMongo().getDBNames()

for (var i in dbs) {
    if (dbs[i].match("test")) {
	db.getSisterDB(dbs[i]).dropDatabase();
    }
}