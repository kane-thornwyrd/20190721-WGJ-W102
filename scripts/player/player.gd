extends KinematicBody2D
class_name Player

var bullet_scene:PackedScene = preload("res://scripts/bullet.tscn")

const floor_normal:Vector2 = Vector2()

signal health_changed(amount, max_health)
signal max_health_changed(max_health)
signal dead

export var recoil:float = 0.17 # ~360 fire per minute
export var max_health:int = 100 setget _set_max_health
export var control_paused:bool = true setget _change_control_paused

# warning-ignore:unused_class_variable
onready var anim_player:AnimationPlayer = $animation_player
onready var damage_boost_timer = $damage_boost_timer
onready var damage_effects = $damage_effects
onready var health = max_health setget _set_health
onready var turret = $body/turret
onready var shield = $body/shield

var velocity:Vector2 = Vector2()
var move_direction:Vector2 = Vector2()
var speed:float = 700.0

onready var recoil_timer = $recoil_timer

func _shoot() -> void:
  randomize()
  var bullet = bullet_scene.instance()
  bullet.global_position = $muzzle.global_position
  bullet.direction = Vector2(cos($muzzle.rotation), sin($muzzle.rotation))
  bullet.direction += Vector2(randf() / 10, randf() / 10)
  bullet.rotation = $muzzle.rotation
  bullet.speed *= rand_range(0.8, 1.2)
  add_child(bullet)
  $body/turret/Shaker.start(recoil)

func get_reaction_time() -> float: return 10.0;

# warning-ignore:unused_argument
func _apply_velocity(delta: float) -> void:
  if not control_paused:
    self.velocity.x = lerp(self.velocity.x, self.speed * self.move_direction.x, 0.2)
    self.velocity.y = lerp(self.velocity.y, self.speed * self.move_direction.y, 0.2)
    self.velocity = move_and_slide(self.velocity, Vector2(), true)
    if Input.is_key_pressed(KEY_X):
      damage(10)

func damage(amount:int) -> void:
  if damage_boost_timer.is_stopped():
    damage_boost_timer.start()
    _set_health(self.health - amount)
    damage_effects.play("damage")
    damage_effects.queue("damage_boost")
    yield(damage_boost_timer, "timeout")
    damage_effects.play("rest")

func kill() -> void:
  recoil_timer.stop()
  pass

func _set_health(amount:int) -> void:
  var prev_health:int = self.health
  health = clamp(amount, 0, max_health)
  if prev_health != health:
    emit_signal("health_changed", health, max_health)
    if health == 0:
      kill()
      emit_signal("dead")

func _set_max_health(new_max_health:int) -> void:
  emit_signal("max_health_changed", new_max_health)
  max_health = new_max_health

func _change_control_paused(ctrl_sd:bool) -> void:
  if control_paused and not ctrl_sd:
    recoil_timer.connect("timeout", self, "_shoot")
    recoil_timer.start(recoil)
  elif not control_paused and ctrl_sd:
    recoil_timer.stop()

  control_paused = ctrl_sd
