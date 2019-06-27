extends Node2D
class_name Level

# warning-ignore:unused_signal
signal shake

# warning-ignore:unused_class_variable
var Formation = preload("res://scripts/enemies/formation.gd")
var PlayerScene = preload("res://scripts/player/player.tscn")
# warning-ignore:unused_class_variable
var Player = preload("res://scripts/player/player.gd")
# warning-ignore:unused_class_variable
var sine_attack_formation:PackedScene = load("res://scripts/enemies/sine_attack_formation.tscn")

const ENEMIES = [
  preload("res://scripts/enemies/beholder/beholder.tscn")
]

enum ENEMY_TYPES { BEHOLDER }

export var entry_duration:int = 3
export var level_duration:float = 60

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

# warning-ignore:unused_argument
func _player_dead(pos:Vector2) -> void:
  emit_signal("lose")

func initialize() -> void:
  var tractor:PathFollow2D = $game/entry_path/player_tractor
  player = PlayerScene.instance()

  player.connect("ready", self, "emit_signal", ["player_available", player])
  player.connect("dead", self, "_player_dead")
  tractor.add_child(player)
  var tween_entry = Tween.new()
  add_child(tween_entry)
  tween_entry.connect("tween_all_completed", player, "set", ["control_paused", false])
  tween_entry.connect("tween_all_completed", self, "_move_node2d", [player, tractor, self])
  tween_entry.interpolate_property(tractor, "unit_offset", 0, 1, entry_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
  tween_entry.start()

  if $star_background and $star_background/Shaker:
    self.connect("shake", $star_background/Shaker , "start")

  setup()
  tween_maker()
  start_waves()
  player.control_paused = false
  $music.play()

func setup() -> void: pass;

# warning-ignore:unused_argument
func _start_shake(pos:Vector2) -> void:
  emit_signal("shake");

func tween_maker() -> void:
  var _unit_offset_part:float
  var _dur:float = level_duration / float(formations.size())
  for i in range(formations.size()):
    var current_formation:Formation = formations[i]
    current_formation.duration = _dur
    var tw:Tween = Tween.new()
    tw.repeat = true
    tw.interpolate_property(
      current_formation, "unit_offset", 0, 1,
      _dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT
    )
    current_formation.tween_inside = tw
    for j in range(current_formation.get_children().size()):
      var cur_seat = current_formation.get_child(j)
      for z in range(cur_seat.get_children().size()):
        if cur_seat.get_child(z) is Lifeform:
          cur_seat.get_child(z).connect("dead", self, "_start_shake")
      _unit_offset_part = 0.5/float(current_formation.get_children().size())
      var cur_seat_offset:float = j * _unit_offset_part
      var tw2:Tween = Tween.new()
      tw2.repeat = true
      tw2.interpolate_property(
        cur_seat, "unit_offset", cur_seat_offset, 1 + cur_seat_offset,
        _dur, 0, 0
      )
      cur_seat.add_child(tw2, true)
    current_formation.add_child(tw, true)

func _move_node2d(target:Node2D, from:Node, to:Node) -> void:
  var glob_trs = target.global_transform
  from.remove_child(target)
  to.add_child(target)
  target.global_transform = glob_trs

func start_waves() -> void:
  for i in range(formations.size()):
    var current_formation:Formation = formations[i]
    enemy_wagon.add_child(current_formation, true)
    current_formation.tween_inside.start()
    for j in range(current_formation.get_children().size()):
      var current_seat = current_formation.get_child(j)
      if current_seat.get_children().size() > 1:
        var _tween_maybe = current_seat.get_child(1)
        if _tween_maybe is Tween:
          _tween_maybe.start()
    yield(get_tree().create_timer(current_formation.duration),"timeout")




