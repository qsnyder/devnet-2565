locals {

  list_of_maps = [
    {
      "name": "Item1",
      "values": ["A", "B"]
    },
    {
      "name": "Item2",
      "values": ["B", "C"]
    }
  ]

  squashed = flatten([
    for entry in local.list_of_maps: [
      for thing in entry.values: {
        item_name = thing,
        item_value = entry.name
      }
    ]
  ])

}