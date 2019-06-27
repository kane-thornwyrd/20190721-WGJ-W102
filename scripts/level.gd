extends Node
class_name Level

# warning-ignore:unused_class_variable
var Formation = preload("res://scripts/enemies/formation.gd")
var Player = preload("res://scripts/player/player.tscn")
# warning-ignore:unused_class_variable
var sine_attack_formation:PackedScene = load("res://scripts/enemies/sine_attack_formation.tscn")

const ENEMIES = [
  preload("res://scripts/enemies/beholder/beholder.tscn")
]

enum ENEMY_TYPES { BEHOLDER }

export var entry_duration:int = 3
export var level_duration:float = 60 * 2

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

  setup()
  tween_maker()
  start_waves()

func setup() -> void: pass;

func tween_maker() -> void:

  var _unit_offset_part:float
  var _dur:float = level_duration / float(formations.size())
  for i in range(formations.size()):
    var current_formation:Formation = formations[i]
    current_formation.duration = _dur
    var tw:Tween = Tween.new()
    tw.repeat = true
    assert tw.interpolate_property(
      current_formation, "unit_offset", 0, 1,
      _dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT
    )
    assert tw.connect("tween_all_completed", current_formation, "queue_free") == 0
    current_formation.tween_inside = tw
    var _dur_enemy:float = _dur / float(current_formation.get_children().size())
    for j in range(current_formation.get_children().size()):
      var cur_seat = current_formation.get_child(j)
      _unit_offset_part = 0.5/float(current_formation.get_children().size())
      var cur_seat_offset:float = j * _unit_offset_part
      var tw2:Tween = Tween.new()
      tw2.repeat = true
      assert tw2.interpolate_property(
        cur_seat, "unit_offset", cur_seat_offset, 1 + cur_seat_offset,
        _dur_enemy, 0, 0
      )
      cur_seat.add_child(tw2, true)
    current_formation.add_child(tw, true)
    enemy_wagon.add_child(current_formation)

func _move_node2d(target:Node2D, from:Node, to:Node) -> void:
  var glob_pos = target.global_position
  from.remove_child(target)
  to.add_child(target)
  target.global_position = glob_pos

func start_waves() -> void:
  for i in range(formations.size()):
    var current_formation:Formation = formations[i]
    assert current_formation.tween_inside.start()
    for j in range(current_formation.get_children().size()):
      var current_seat = current_formation.get_child(j)
      if current_seat.get_children().size() > 0:
        var _tween_maybe = current_seat.get_child(1)
        if _tween_maybe is Tween:
          assert _tween_maybe.start()




