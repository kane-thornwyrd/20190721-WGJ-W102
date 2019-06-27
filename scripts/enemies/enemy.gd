extends Lifeform
class_name Enemy

export var detection_radius:float = 500
export var turret_speed:float

onready var parent = get_parent()
onready var detection:Area2D = $detect_radius

var target = null

func _ready():
  $detect_radius/collision_shape_2d.shape.radius = detection_radius
  assert detection.connect("body_entered", self, "_on_detect_radius_body_entered") == 0
  assert detection.connect("body_exited", self, "_on_detect_radius_body_exited") == 0

# warning-ignore:unused_argument
func control(delta:float) -> void:
  if parent is PathFollow2D:
    return
  else:
    # other movement code
    pass

func _process(delta:float) -> void:
  if target:
    var target_dir = (target.global_position - global_position).normalized()
    var current_dir = Vector2(1, 0).rotated(global_rotation)
    global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * delta).angle()

func _on_detect_radius_body_entered(body: PhysicsBody2D) -> void:
  if body is Player: target = body;

func _on_detect_radius_body_exited(body: PhysicsBody2D) -> void:
  if body == target:
    yield(get_tree().create_timer(2.0), "timeout")
    target = null;