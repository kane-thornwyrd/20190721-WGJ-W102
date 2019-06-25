extends Button
class_name NavigationButton

export var to:String
export var transition_path:NodePath

onready var transitioner:CanvasLayer = self.get_node(transition_path)

func _ready() -> void:
  assert self.connect("pressed", self, "_goto") == 0
  assert self.connect("focus_entered", self, "_play_focus_sound") == 0

func _play_focus_sound() -> void:
  if $audio_stream_player:
    $audio_stream_player.play()

func _goto() -> void:
  scene_reg.transition_to(to, transitioner)
