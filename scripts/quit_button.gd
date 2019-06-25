extends "res://scripts/nav_button.gd"
class_name QuitButton

func _ready() -> void:
  assert self.connect("pressed", self, "_please_get_out") == 0

func _please_get_out() -> void:
  transitioner.out_trans(funcref(self, "_kthxbye"))

func _kthxbye() -> void:
  self.get_tree().quit()
