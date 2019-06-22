extends Node

var _scenes:Dictionary

var _to_scene_name:String

func add_scene(scene_name:String, scene:PackedScene) -> void:
  _scenes[scene_name] = scene

func get_scene(scene_name:String) -> PackedScene:
  if not _scenes.has(scene_name): return null;
  return _scenes[scene_name]

func transition_to(to_scene_name:String, transitionner:CanvasLayer = null) -> void:
  _to_scene_name = to_scene_name
  if transitionner:
    transitionner.out_trans(funcref(self, "_move"))
  else:
    _move()

func _move() -> void:
  var error:int = self.get_tree().change_scene(self.get_scene(_to_scene_name).resource_path)
  assert error == 0


