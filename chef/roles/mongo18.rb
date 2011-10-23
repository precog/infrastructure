name "mongo18"
description "Force mongodb to install using the mongodb18-10gen package"
default_attributes({
  "mongodb" => {
    "package" => "mongodb18-10gen"
  }
})
