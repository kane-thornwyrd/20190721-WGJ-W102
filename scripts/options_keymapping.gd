extends Control

onready var _key_selector:KeySelector = $ui/key_selector
onready var _action_list:ActionList = $ui/center_container/v_box_container/scroll_container/v_box_container

func _ready() -> void:
  $transition_layer.in_trans()
  yield($transition_layer, "animation_finished")
  $ui/center_container/v_box_container/back.grab_focus()

  var config = KeymapInstaller.load_actions_keymaps()
  for action in config:
    var line = _action_list.add_input_line(action, config[action])
    line.connect("change_button_pressed", self, "_on_InputLine_change_button_pressed",\
      [{"action": action, "key": config[action]}])


func _on_InputLine_change_button_pressed(config:Dictionary, old_config:Dictionary):
  _key_selector.open(config)
  var conf = yield(_key_selector, "key_selected")
  if conf.action == old_config.action and conf.key == old_config.key: return;
  KeymapInstaller.save_an_action_keymap(conf.action, conf.key, true)
  rebuild()

func rebuild():
  var config = KeymapInstaller.load_actions_keymaps()
  _action_list.clear()
  print_debug(config)
  for input_action in config:
    var line = _action_list.add_input_line(input_action, config[input_action])
    line.connect("change_button_pressed", self, "_on_InputLine_change_button_pressed",\
      [{"action": input_action, "key": config[input_action]}])