extends Path2D
class_name Formation

var Level = load("res://scripts/level.gd")

export var seat_number:int
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
    cur_seat.add_child(Level.ENEMIES[cur_enemy].instance())
    add_child(cur_seat, true)