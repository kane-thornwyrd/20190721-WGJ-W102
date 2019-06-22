extends Button
class_name QuitButton

export var transition_path:NodePath

onready var transitioner:TextureRect = self.get_node(transition_path)

func _ready() -> void:
  assert self.connect("pressed", self, "_please_get_out") == 0

func _please_get_out() -> void:
  transitioner.out_trans(funcref(self, "_kthxbye"))

func _kthxbye() -> void:
  self.get_tree().quit()
