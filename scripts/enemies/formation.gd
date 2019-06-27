extends Path2D
class_name Formation

var Level = load("res://scripts/level.gd")

export var seat_number:int
export var unit_offset:float setget _set_unit_offset
export (Array, int) var enemy_types
# warning-ignore:unused_class_variable
export var duration:float

# warning-ignore:unused_class_variable
var tween_inside:Tween

func setup() -> void:
  var seat:PathFollow2D = $seat
  remove_child($seat)
  for i in range(seat_number):
    var cur_seat:PathFollow2D = seat.duplicate()
    var cur_enemy = i % enemy_types.size()
    var enemy_instance = Level.ENEMIES[cur_enemy].instance()
    if int(rand_range(0.0, 10.0)) % 5 == 0:
      enemy_instance.get_node("body").modulate = Color.red
      enemy_instance.connect("dead", self, "_spawn_health")
    cur_seat.add_child(enemy_instance)
    add_child(cur_seat, true)

func _spawn_health(pos:Vector2) -> void:
  var itm:Item = load("res://scripts/item.tscn").instance()
  itm.global_position = pos
  get_parent().get_parent().get_parent().add_child(itm)

func _set_unit_offset(offst:float) -> void:
  if get_parent():
    get_parent().unit_offset = offst
    unit_offset = offst