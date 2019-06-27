extends RigidBody2D
class_name Item

func _ready() -> void:
  var tim:SceneTreeTimer = get_tree().create_timer(5.0)
  tim.connect("timeout", self, "queue_free")
# warning-ignore:unused_argument
func _process(delta: float) -> void:
  var bodies = $detector.get_overlapping_bodies()
  for i in range(bodies.size()):
    if not bodies[i] is Player: return;
    bodies[i].heal(10)
    queue_free()
