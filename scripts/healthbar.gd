extends Control
class_name Healthbar

# Code gladly provided in (large) part by Game Endeavor

# warning-ignore:unused_signal
signal pulse

const FLASH_RATE = 0.05
const N_FLASHES = 4

export (Color) var healthy_color = Color.darkgreen
export (Color) var caution_color = Color.darkorange
export (Color) var danger_color = Color.darkred
# warning-ignore:unused_class_variable
export (Color) var pulse_color = Color.red
export (Color) var flash_color = Color.darkred

export (float, 0, 1, 0.05) var caution_zone = 0.45
export (float, 0, 1, 0.05) var danger_zone = 0.2

export var will_pulse:bool = true


onready var health_over:TextureProgress = $top_bar
onready var health_under:TextureProgress = $under_bar
# warning-ignore:unused_class_variable
onready var update_tween:Tween = $update_tween
onready var pulse_tween:Tween = $pulse_tween
# warning-ignore:unused_class_variable
onready var flash_tween:Tween = $flash_tween

var _prev_health
var player:Player setget _player_added
var _tru_player:WeakRef

func _on_health_changed(health, max_health) -> void:
  if _prev_health == null: _prev_health = health
  var amount = clamp(_prev_health - health, -max_health, max_health)

  health_over.value = health
  update_tween.interpolate_property(health_under, "value", health_under.value, health, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
  update_tween.start()
  _assign_color(health)
  if amount < 0:
    _flash_damage()


func _assign_color(health:int) -> void:
  if health == 0: pulse_tween.set_active(false);
  elif health < health_over.max_value * danger_zone:
    if will_pulse:
      if not pulse_tween.is_active():
        pulse_tween.interpolate_property(
          health_over, "tint_progress", pulse_color, danger_color, 0.3, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
        pulse_tween.interpolate_callback(self, 0.0, "emit_signal", "pulse")
        pulse_tween.start()
    else:
      health_over.tint_progress = danger_color
  else:
    pulse_tween.set_active(false)
    if health < health_over.max_value * caution_zone:
      health_over.tint_progress = caution_color
    else:
      health_over.tint_progress = healthy_color

func _on_max_health_updated(max_health:int) -> void:
  health_over.max_value = max_health
  health_under.max_value = max_health

func _flash_damage() -> void:
  for i in range(N_FLASHES * 2):
    var color = health_over.tint_progress if i % 2 == 1 else flash_color
    var time = FLASH_RATE * i + FLASH_RATE
    flash_tween.interpolate_callback(health_over, time, "set", "tint_progress", color)
  flash_tween.start()

func _player_added(ply:Player) -> void:
  if not ply is Player: return;
  _tru_player = weakref(ply)
  player = ply

  if _tru_player.get_ref() != player:
    player = _tru_player.get_ref()
    player.disconnect("health_changed", self, "_on_health_changed")
    self.disconnect("pulse", player, "energy_field_perturbations")
  player.connect("health_changed", self, "_on_health_changed")
  self.connect("pulse", player, "energy_field_perturbations")
  _on_health_changed(player.health, player.max_health)


