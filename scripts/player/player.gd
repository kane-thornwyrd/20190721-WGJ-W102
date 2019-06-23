extends KinematicBody2D
class_name Player

const floor_normal:Vector2 = Vector2()

signal health_changed(amount)
signal dead

export var recoil:float = 0.33333 # 180 fire per minute
export var max_health:int = 100

# warning-ignore:unused_class_variable
onready var anim_player:AnimationPlayer = $animation_player
onready var damage_boost_timer = $damage_boost_timer
onready var damage_effects = $damage_effects
onready var health = max_health setget _set_health

var velocity:Vector2 = Vector2()
var move_direction:Vector2 = Vector2()
var speed:float = 500.0

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
  pass

func _set_health(amount:int) -> void:
  var prev_health:int = self.health
  self.health = clamp(amount, 0, max_health)
  if prev_health != self.health:
    emit_signal("health_changed", self.health)
    if self.health == 0:
      kill()
      emit_signal("dead")







