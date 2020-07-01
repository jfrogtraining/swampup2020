{
    "files": [
      {
          "aql": {
            "items.find": {
                "type":"file",
                "size":{"$gt":"100000000"}, 
                "stat.downloads":{"$lte":"1"}
            }
          }
        }
    ]
}
