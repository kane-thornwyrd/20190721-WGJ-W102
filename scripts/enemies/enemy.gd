extends KinematicBody2D
class_name Enemy

export var agility = 1
export var detect_radius = 400

var player:Player

func _ready() -> void:
  $detect_radius/collision_shape_2d.shape.radius = detect_radius

func _process(delta: float) -> void:
  if player is Player:
    var target_dir = (player.global_position - global_position).normalized()
    var current_dir = Vector2(1, 0).rotated(global_rotation)
    global_rotation = current_dir.linear_interpolate(target_dir, agility * delta).angle()