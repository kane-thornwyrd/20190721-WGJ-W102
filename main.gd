extends Control

export var loading_scene:PackedScene

var all_loaded:Array = [false,false]

func _ready() -> void:
  scene_reg.add_scene("loading_screen", loading_scene)
  var loading_i = scene_reg.get_scene("loading_screen").instance()
  self.add_child(loading_i)
  assert load_data(loading_i) == 0

func load_data(loading_screen:Node) -> int:
  var scenes_dir = Directory.new()
  scenes_dir.open("res://scenes")
  scenes_dir.list_dir_begin(true, true)
  var scene_file:String = scenes_dir.get_next()
  while scene_file.length() > 0:
    if scene_file.ends_with(".tscn"):
      var node = load("res://scenes/%s" % scene_file)
      var scene_name = (scene_file as String).replace(".tscn", "")
      scene_reg.add_scene(scene_name, node)
    scene_file = scenes_dir.get_next()
  print_debug(scene_reg._scenes.keys())
  all_loaded[0] = true

  var levels_dir = Directory.new()
  levels_dir.open("res://levels")
  levels_dir.list_dir_begin(true, true)
  var level_file:String = levels_dir.get_next()
  while level_file.length() > 0:
    if level_file.ends_with(".tscn"):
      var node = load("res://levels/%s" % level_file)
      var level_name = (level_file as String).replace(".tscn", "")
      level_reg.add_level(level_name, node)
    level_file = levels_dir.get_next()
  print_debug(level_reg._levels.keys())
  all_loaded[1] = true

  _refresh_loading_state(loading_screen)
  return 0

func _refresh_loading_state(loading_i:Node) -> void:
  loading_i.is_loading = all_loaded.has(false)
