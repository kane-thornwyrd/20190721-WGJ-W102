extends Node

var _rooms:Dictionary

var _to_room_name:String

func add_room(room_name:String, room:PackedScene) -> void:
  _rooms[room_name] = room

func get_room(room_name:String) -> PackedScene:
  if not _rooms.has(room_name): return null;
  return _rooms[room_name]

func transition_to(to_room_name:String, transitionner:CanvasLayer = null) -> void:
  _to_room_name = to_room_name
  if transitionner:
    transitionner.out_trans(funcref(self, "_move"))
  else:
    _move()

func _move() -> void:
  var error:int = self.get_tree().change_scene(self.get_room(_to_room_name).resource_path)
  assert error == 0


