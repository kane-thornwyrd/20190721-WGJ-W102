extends Control

onready var level_container = $level/level_container
onready var transition_screen = $transition_layer

var levels = [
  level_reg.get_level("level0")
#  level_reg.get_level("level1")
#  level_reg.get_level("level2")
]

var level_number:int = 0

var prev_level:Level

func _ready() -> void:
  load_level()
  transition_screen.in_trans()
  yield(transition_screen, "animation_finished")

func _on_level_win() -> void:
  call_deferred("_disappear_mofo")
  transition_screen.out_trans()
  yield(transition_screen, "animation_finished")
  level_number += 1
  load_level()

func _on_level_lose() -> void:
  call_deferred("_disappear_mofo")
  transition_screen.out_trans()
  yield(transition_screen, "animation_finished")
  load_level()

func load_level() -> void:
  var level:Level = levels[level_number].instance()
  if !prev_level:
    prev_level = level
    level.connect("win", self, "_on_level_win")
    level.connect("lose", self, "_on_level_lose")
    level.connect("player_available", self, "_bind_player_and_healthbar", [$gui/Healthbar])

  level_container.add_child(prev_level)
  prev_level.raise()
  print_debug("LOADING Level%s" % level_number)
  transition_screen.in_trans()
  yield(transition_screen, "animation_finished")

func _bind_player_and_healthbar(player:Player, healthbar:Healthbar) -> void:
  healthbar.player = player

func _disappear_mofo() -> void :
  prev_level.disconnect("win", self, "_on_level_win")
  prev_level.disconnect("lose", self, "_on_level_lose")
  prev_level.disconnect("player_available", self, "_bind_player_and_healthbar")
  prev_level.visible = false
  prev_level.modulate = Color(0.0,0.0,0.0,0.0)
  prev_level.queue_free()
  prev_level = null
