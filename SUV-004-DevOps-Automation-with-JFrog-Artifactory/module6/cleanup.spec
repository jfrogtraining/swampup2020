{
    "files": [
      {
          "aql": {
            "items.find": {
                "type":"file",
                "stat.downloads":{"$lte":"10"},
                "stat.downloaded":{"$before":"1d"},
                "repo":{"$nmatch":"*dev*"}
            }
          }
        }
    ]
}
