extends Node

var _levels:Dictionary

func add_level(level_name:String, room:PackedScene) -> void:
  _levels[level_name] = room

func get_level(level_name:String) -> PackedScene:
  if not _levels.has(level_name): return null;
  return _levels[level_name]


