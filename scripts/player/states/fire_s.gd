extends "res://scripts/player/player_state.gd"
class_name FireS

func get_name() -> String: return "fire_s";

func transitioning() -> State:
  return direction_switch_state(get_fire_angle())
