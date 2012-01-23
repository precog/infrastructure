/* Remove all current collections other than token-related */
print("Dropping collections");
db.hierarchy_children.drop();
db.path_children.drop();
db.path_tags.drop();
db.variable_children.drop();
db.variable_series.drop();
db.variable_value_series.drop();
db.variable_values.drop();
