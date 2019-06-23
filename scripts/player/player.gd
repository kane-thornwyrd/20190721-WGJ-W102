extends KinematicBody2D
class_name Player

var bullet_scene:PackedScene = preload("res://scripts/bullet.tscn")

const floor_normal:Vector2 = Vector2()

signal health_changed(amount, max_health)
signal max_health_changed(max_health)
signal dead

export var recoil:float = 0.1666 # ~360 fire per minute
export var max_health:int = 100 setget _set_max_health

# warning-ignore:unused_class_variable
onready var anim_player:AnimationPlayer = $animation_player
onready var damage_boost_timer = $damage_boost_timer
onready var damage_effects = $damage_effects
onready var health = max_health setget _set_health

var velocity:Vector2 = Vector2()
var move_direction:Vector2 = Vector2()
var speed:float = 700.0

func _ready() -> void:
  $recoil_timer.connect("timeout", self, "_shoot")
  $recoil_timer.start(recoil)

func _shoot() -> void:
  randomize()
  var bullet = bullet_scene.instance()
  bullet.global_position = $muzzle.global_position
  bullet.direction = Vector2(cos($muzzle.rotation), sin($muzzle.rotation))
  bullet.direction += Vector2(randf() / 10, randf() / 10)
  bullet.rotation = $muzzle.rotation
  add_child(bullet)

func get_reaction_time() -> float: return 10.0;

# warning-ignore:unused_argument
func _apply_velocity(delta: float) -> void:
  self.velocity.x = lerp(self.velocity.x, self.speed * self.move_direction.x, 0.2)
  self.velocity.y = lerp(self.velocity.y, self.speed * self.move_direction.y, 0.2)
  self.velocity = move_and_slide(self.velocity, Vector2(), true)

func damage(amount:int) -> void:
  if damage_boost_timer.is_stopped():
    damage_boost_timer.start()
    _set_health(self.health - amount)
    damage_effects.play("damage")
    damage_effects.queue("damage_boost")
    yield(damage_boost_timer, "timeout")
    damage_effects.play("rest")

func kill() -> void:
  $recoil_timer.stop()
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