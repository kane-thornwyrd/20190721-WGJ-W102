extends KinematicBody2D
class_name Enemy

var player:Player

func _process(delta: float) -> void:
  if player:
    self.rotation = position.angle_to(player.position)