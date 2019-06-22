extends Button
class_name NavigationButton

export var to:String
export var transition_path:NodePath

onready var transitioner:CanvasLayer = self.get_node(transition_path)

func _ready() -> void:
  assert self.connect("pressed", self, "_goto") == 0

func _goto() -> void:
  scene_reg.transition_to(to, transitioner)
