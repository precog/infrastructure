var dbs = db.getMongo().getDBNames()

for (var i in dbs) {
    if (dbs[i].match(/test.*/)) {
        print("Dropping " + dbs[i]);
	db.getSisterDB(dbs[i]).dropDatabase();
    }
}
