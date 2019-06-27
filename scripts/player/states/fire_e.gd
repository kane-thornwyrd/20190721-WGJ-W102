extends "res://scripts/player/player_state.gd"
class_name FireE

func get_name() -> String: return "fire_e";

func transitioning() -> State:
  return direction_switch_state(get_fire_angle())