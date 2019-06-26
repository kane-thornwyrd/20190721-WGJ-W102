extends Node
class_name Level

#var Player = preload("res://scripts/player/player.tscn")
var sine_attack_formation:PackedScene = preload("res://scripts/enemies/sine_attack_formation.tscn")

const ENEMIES = [
  preload("res://scripts/enemies/beholder/beholder.tscn")
]

enum ENEMY_TYPES { BEHOLDER }

export var entry_duration:int = 3

# warning-ignore:unused_signal
signal lose
# warning-ignore:unused_signal
signal win

# warning-ignore:unused_signal
signal player_available(player)

onready var enemy_wagon = $game/enemy_path/enemy_wagon

var player:Player
var formations:Array = []

func _ready() -> void:
  initialize()

func initialize() -> void:
  var tractor:PathFollow2D = $game/entry_path/player_tractor
  player = Player.instance()

  assert player.connect("ready", self, "emit_signal", ["player_available", player]) == 0
  tractor.add_child(player)
  var tween_entry = Tween.new()
  add_child(tween_entry)
  assert tween_entry.connect("tween_all_completed", player, "set", ["control_paused", false]) == 0
  assert tween_entry.connect("tween_all_completed", self, "_move_node2d", [player, tractor, self]) == 0
  tween_entry.interpolate_property(tractor, "unit_offset", 0, 1, entry_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
  tween_entry.start()

  print_debug(formations)

func _move_node2d(target:Node2D, from:Node, to:Node) -> void:
  var glob_pos = target.global_position
  from.remove_child(target)
  to.add_child(target)
  target.global_position = glob_pos

func _process(delta: float) -> void:
  for i in range(formations.size()):
    var current_formation = formations[i]
    print("cool")



