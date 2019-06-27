extends KinematicBody2D
class_name Lifeform

signal health_changed(amount, max_health)
signal max_health_changed(max_health)
signal dead

export var recoil:float = 0.17 # ~360 fire per minute
export var max_health:float = 100 setget _set_max_health
export var control_paused:bool = false setget _change_control_paused

export var bullet_scene:PackedScene
# warning-ignore:unused_class_variable
export (int) var speed
# warning-ignore:unused_class_variable
export (float) var rotation_speed

# warning-ignore:unused_class_variable
var can_shoot = true
var alive = true
# warning-ignore:unused_class_variable
var velocity:Vector2 = Vector2()
# warning-ignore:unused_class_variable
var move_direction:Vector2 = Vector2()

onready var damage_boost_timer:Timer = $damage_boost_timer
onready var damage_effects:AnimationPlayer = $damage_effects
onready var health:float = max_health setget _set_health
onready var recoil_timer:Timer = $recoil_timer
onready var muzzle:Position2D = $muzzle
onready var puffs_node:Particles2D = $puffs
onready var explosion:Particles2D = $explosion

var puffs

func _ready() -> void:
  recoil_timer.wait_time = recoil
  puffs = puffs_node
  remove_child(puffs_node)

# warning-ignore:unused_argument
func control(delta:float): pass;

func _physics_process(delta:float):
  if not alive or control_paused: return;
  control(delta)
  for i in get_slide_count():
      var collision:KinematicCollision2D = get_slide_collision(i)
      if collision.collider.get_class() != "StaticBody2D":
        damage(1, collision.position)

func spawn_puffs(position:Vector2) -> void:
  var tmp_puffs:Particles2D = puffs.duplicate()
  add_child(tmp_puffs)
  tmp_puffs.show()
  tmp_puffs.global_position = position
  tmp_puffs.emitting = true
  yield(get_tree().create_timer(2.0), "timeout")
  tmp_puffs.queue_free()

func _change_control_paused(ctrl_sd:bool) -> void:
  if control_paused and not ctrl_sd:
    assert recoil_timer.connect("timeout", self, "shoot") == 0
    recoil_timer.start(recoil)
  elif not control_paused and ctrl_sd:
    recoil_timer.stop()
  control_paused = ctrl_sd

func damage(amount:int, dmg_pos:Vector2) -> void:
  if damage_boost_timer.is_stopped():
    damage_boost_timer.start()
    spawn_puffs(dmg_pos)
    _set_health(self.health - amount)
    damage_effects.play("damage")
    damage_effects.queue("damage_boost")
    yield(damage_boost_timer, "timeout")
    damage_effects.play("rest")

func heal(amount:float) -> void:
  _set_health(self.health + amount)
  damage_effects.play("heal")
  damage_effects.queue("rest")

func _set_health(new_health:float) -> void:
  var prev_health:float = health
  health = clamp(new_health, 0.0, max_health)
  if prev_health != health  or health == 0.0:
    emit_signal("health_changed", health, max_health)
    if health <= 0.0:
      kill()

func _set_max_health(new_max_health:float) -> void:
  emit_signal("max_health_changed", new_max_health)
  max_health = new_max_health

func kill() -> void:
  emit_signal("dead")
  alive = false
  control_paused = true
  explosion.show()
  explosion.play()
  $body.hide()
  yield(get_tree().create_timer(0.5), "timeout")
  queue_free()

func shoot() -> void:
  randomize()
  var bullet = bullet_scene.instance()
  bullet.global_position = muzzle.global_position
  bullet.direction = Vector2(cos(muzzle.rotation), sin(muzzle.rotation))
  bullet.direction += Vector2(randf() / 10, randf() / 10)
  bullet.rotation = muzzle.rotation
  bullet.speed *= rand_range(0.8, 1.2)
  add_child(bullet)

