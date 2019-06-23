extends "res://addons/kane-FSM/state_machine.gd"
class_name PlayerFSM

const STATE_DIR = "res://scripts/player/states"

var actions:Dictionary

func _init() -> void:
  for action in InputMap.get_actions():
    actions[action] = false

func _unhandled_input(event: InputEvent) -> void:
  for action in actions:
    if event.is_action_pressed(action):
      actions[action] = true
    elif event.is_action_released(action):
      actions[action] = false

func _ready() -> void:
  var states_dir = Directory.new()
  states_dir.open(STATE_DIR)
  states_dir.list_dir_begin(true, true)
  var state_file:String = states_dir.get_next()
  while state_file.length() > 0:
    self._register_state("%s/%s" % [STATE_DIR, state_file])
    var state_name = (state_file as String).replace(".gd", "")
    self.states[state_name].actions = actions
    state_file = states_dir.get_next()

  self.next_state = self.states.wait
  self.call_deferred("set_state", self.states.wait)

func _state_logic(delta: float) -> void:
  states[state.name].logic()

  parent._apply_velocity(delta)

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