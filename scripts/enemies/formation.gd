extends Path2D
class_name Formation

export var seat_number:int
export (Array, int) var enemy_types
export var duration:float = 10

var _unit_offset_part:float

func setup() -> void:
  var seat:PathFollow2D = $seat
  _unit_offset_part = 1/float(seat_number)
  remove_child($seat)
  for i in range(seat_number):
    var cur_seat:PathFollow2D = seat.duplicate()
    var cur_enemy = i % enemy_types.size()
    cur_seat.unit_offset = i * _unit_offset_part
    cur_seat.add_child(Level.ENEMIES[cur_enemy])
    add_child(cur_seat)