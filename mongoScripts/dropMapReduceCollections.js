var colls = db.getCollectionNames();

for (var i in colls) {
    if (colls[i].match(/mapreduce.*/)) {
        print("Dropping " + colls[i]);
	db.getCollection(colls[i]).drop();
    }
}
