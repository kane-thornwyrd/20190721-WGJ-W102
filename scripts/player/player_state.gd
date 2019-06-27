extends "res://addons/kane-FSM/state.gd"
class_name PlayerState

# warning-ignore:unused_class_variable
var fsm:PlayerFSM

func logic() -> void:
  parent.anim_player.play(self.get_name());

func direction_switch_state(angle:float) -> State:
  var output_state:State

  if angle > 180.0 - 45.0/2.0 or angle < -180.0 + 45.0/2.0:
    output_state = states.fire_e
  elif angle < 180.0 - 45.0/2.0 and angle > 180.0 - 45.0 - 45.0/2.0:
    output_state = states.fire_ne
  elif angle < 90.0 + 45.0/2.0 and angle > 90.0 - 45.0/2.0:
    output_state = states.fire_n
  elif angle < 90.0 - 45.0/2.0 and angle > 45.0/2.0:
    output_state = states.fire_nw
  elif angle < 45.0/2.0 and angle > -45.0/2.0:
    output_state = states.fire_w
  elif angle < -45.0/2.0 and angle > -45.0 - 45.0/2.0:
    output_state = states.fire_sw
  elif angle < -45.0 - 45.0/2.0 and angle > -90.0 - 45.0/2.0:
    output_state = states.fire_s
  elif angle < -90.0 - 45.0/2.0 and angle > -180.0 + 45.0/2.0:
    output_state = states.fire_se

  return output_state

func get_fire_angle() -> float:
  return rad2deg(parent.position.angle_to_point(parent.get_viewport().get_mouse_position()))