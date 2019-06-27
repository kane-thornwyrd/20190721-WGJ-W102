extends "res://addons/kane-FSM/state_machine.gd"
class_name PlayerFSM

const STATE_DIR = "res://scripts/player/states"

var actions:Dictionary

func _unhandled_input(event: InputEvent) -> void:
  for action in actions:
    if event.is_action_pressed(action):
      actions[action] = true
    elif event.is_action_released(action):
      actions[action] = false
  set_moving_direction(parent)

func set_moving_direction(prt: Lifeform) -> void:
  if actions.size() == 0:
    for action in InputMap.get_actions():
      actions[action] = false
  prt.move_direction.x = \
    - int(actions[keymap_installer.ACTIONS[keymap_installer.ACTS.MOVE_LEFT]])\
    + int(actions[keymap_installer.ACTIONS[keymap_installer.ACTS.MOVE_RIGHT]])
  prt.move_direction.y = \
    - int(actions[keymap_installer.ACTIONS[keymap_installer.ACTS.MOVE_UP]])\
    + int(actions[keymap_installer.ACTIONS[keymap_installer.ACTS.MOVE_DOWN]])

func _ready() -> void:
  for action in InputMap.get_actions():
    actions[action] = false
#  var states_dir = Directory.new()
#  if states_dir.open(STATE_DIR) == OK:
#    states_dir.list_dir_begin(true, true)
#    var state_file:String = states_dir.get_next()
#    while state_file.length() > 0:
#      self._register_state("%s/%s" % [STATE_DIR, state_file])
#      var state_name:String = (state_file as String).replace(".gd", "").replace(".remap", "")
#      self.states[state_name].actions = actions
#      state_file = states_dir.get_next()
  var states_files = [
    load("res://scripts/player/states/fire_e.gd"),
    load("res://scripts/player/states/fire_ne.gd"),
    load("res://scripts/player/states/fire_n.gd"),
    load("res://scripts/player/states/fire_nw.gd"),
    load("res://scripts/player/states/fire_w.gd"),
    load("res://scripts/player/states/fire_sw.gd"),
    load("res://scripts/player/states/fire_s.gd"),
    load("res://scripts/player/states/fire_se.gd"),
  ]
  for i in range(states_files.size()):
    self.add_state(states_files[i].new().set_parent(parent).set_states(states)\
        .set_state_changer(funcref(self, "set_state")))
  self.next_state = self.states.fire_e
  self.call_deferred("set_state", self.states.fire_e)


func _physics_process(delta: float) -> void:
  if state != null:
    _state_logic(delta)
    var _transition = _get_transition()
    if _transition != null:
      set_state(_transition)

# warning-ignore:unused_argument
func _state_logic(delta: float) -> void: state.logic();

func _get_transition() -> State:
  var nxt_state = states[state.name].transitioning()
  if nxt_state != null:
    self.next_state = nxt_state

  if self.state != self.next_state and OS.get_ticks_msec() > self.next_state_time:
    return self.next_state

  return null

func _enter_state(new_state: State, old_state: State) -> void:
  self.next_state_time = OS.get_ticks_msec() + parent.get_reaction_time()
  states[new_state.name].entering(old_state)

func _exit_state(old_state: State, new_state: State) -> void:
  states[old_state.name].exiting(new_state);

