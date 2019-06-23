extends Panel
class_name KeySelector

signal key_selected(config)

var _config:Dictionary

func _input(event:InputEvent):
  if event is InputEventKey and event.is_pressed() and _config.has("action"):
    var _ev:InputEventKey = event as InputEventKey
    _config.key = _ev.get_scancode_with_modifiers()
    emit_signal("key_selected", _config)
    close()

func open(config:Dictionary):
  _config = config
  self.grab_focus()
  self.set_process_input(true)
  show()

func close():
  self.set_process_input(false)
  hide()