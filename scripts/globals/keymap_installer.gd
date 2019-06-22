tool
extends Node
class_name KeymapInstaller

const SETTINGS_FOLDER:String = "user://settings"
const KEYMAPPING_FILE:String = "user://settings/keymapping.json"

enum ACTS {
  MOVE_LEFT,
  MOVE_RIGHT,
  MOVE_UP,
  MOVE_DOWN,
  SPRINT,
  ACTIVATE
}

const ACTIONS:Array = [
  "move_left",
  "move_right",
  "move_up",
  "move_down",
  "sprint",
  "activate"
]

const REQUIRED_ACTS:Dictionary = {
  ACTIONS[ACTS.MOVE_LEFT]: KEY_A,
  ACTIONS[ACTS.MOVE_RIGHT]: KEY_D,
  ACTIONS[ACTS.MOVE_UP]: KEY_W,
  ACTIONS[ACTS.MOVE_DOWN]: KEY_S,
  ACTIONS[ACTS.SPRINT]: KEY_SHIFT,
  ACTIONS[ACTS.ACTIVATE]: KEY_E
}

func _ready() -> void:
  persist_actions_keymaps()
  var config:Dictionary = load_actions_keymaps()
  for act_name in config:
      save_an_action_keymap(act_name, config[act_name])

static func load_actions_keymaps() -> Dictionary:
  var save_file = File.new()
  save_file.open(KEYMAPPING_FILE, File.READ)
  return JSON.parse(save_file.get_as_text()).result

static func persist_actions_keymaps(settings = false) -> void:
  var dir = Directory.new()
  if !dir.dir_exists(SETTINGS_FOLDER):
    dir.open("user://")
    dir.make_dir(SETTINGS_FOLDER)

  var save_file = File.new()
  if !save_file.file_exists(KEYMAPPING_FILE):
    save_file.open(KEYMAPPING_FILE, File.WRITE)
    save_file.store_line(JSON.print(REQUIRED_ACTS, " ", true))
  elif settings != false:
    save_file.open(KEYMAPPING_FILE, File.WRITE)
    save_file.store_line(JSON.print(settings, " ", true))
  save_file.close()


static func save_an_action_keymap(action:String, key:int, save:bool = false) -> void:
  var reg_acts = InputMap.get_actions()
  var input = InputEventKey.new()
  input.scancode = key

  if reg_acts.find(action) > -1:
    InputMap.erase_action(action)

  InputMap.add_action(action)
  InputMap.action_add_event(action, input)

  if save:
    var config:Dictionary = load_actions_keymaps()
    config[action] = key
    persist_actions_keymaps(config)
