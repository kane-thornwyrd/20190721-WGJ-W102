extends Lifeform
class_name Enemy

var Player = load("res://scripts/player/player.gd")

export var detection_radius:float = 500
export var turret_speed:float

onready var parent = get_parent()
# warning-ignore:unused_class_variable
onready var detection:Area2D = $detect_radius

var target = null

func _ready():
  $detect_radius/collision_shape_2d.shape.radius = detection_radius
  detection.connect("body_entered", self, "_on_detect_radius_body_entered")
  detection.connect("body_exited", self, "_on_detect_radius_body_exited")

# warning-ignore:unused_argument
func control(delta:float) -> void:
  if parent is PathFollow2D:
    return
  else:
    # other movement code
    pass

func _process(delta:float) -> void:
  target_acquisition(delta)

func target_acquisition(delta:float) -> void:
  if target and target.get_ref() != null:
    var _tru_target = target.get_ref()
    var target_dir = (_tru_target.global_position - global_position).normalized()
    var current_dir = Vector2(1, 0).rotated(global_rotation)
    global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * delta).angle()
    if UTILS.float_crop(global_rotation, 3)  == \
       UTILS.float_crop(current_dir.linear_interpolate(target_dir, 0.2).angle(), 3) and \
        global_position.distance_to(_tru_target.global_position) < 1000 :
      if recoil_timer.is_stopped():
        recoil_timer.start()
        shoot()



func _on_detect_radius_body_entered(body: PhysicsBody2D) -> void:
  if body is Player: target = weakref(body);

func _on_detect_radius_body_exited(body: PhysicsBody2D) -> void:
  if body == target:
    yield(get_tree().create_timer(2.0), "timeout")
    force_resume()
    target = null;

func _on_visibility_notifier_screen_exited() -> void:
  yield(get_tree().create_timer(2.0), "timeout")
  force_resume()
  queue_free()
