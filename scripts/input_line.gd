extends HBoxContainer
class_name InputLine

signal change_button_pressed(config)

var config = {
  "action": "",
  "key": 0
}

func initialize(action_name:String, key:int) -> void:
  $action.text = action_name.capitalize()
  $key.text = OS.get_scancode_string(key)
  config.action = action_name
  config.key = key
  $change.connect("pressed", self, "_on_button_pressed", [config])

func _on_button_pressed(config) -> void:
  emit_signal('change_button_pressed', config)
