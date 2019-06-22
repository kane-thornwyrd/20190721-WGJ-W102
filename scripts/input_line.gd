extends HBoxContainer

signal change_button_pressed

func _init(action_name:String, key:int, can_change:bool) -> void:
  $action.text = action_name.capitalize()
  $key.text = OS.get_scancode_string(key)
  $change.disabled = not can_change
  $change.connect("pressed", self, "_on_button_pressed")

func update_key(scancode:int) -> void:
  $key.text = OS.get_scancode_string(scancode)

func _on_button_pressed() -> void:
  emit_signal('change_button_pressed')
