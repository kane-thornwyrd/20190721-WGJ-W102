extends Area2D
class_name Bullet

export var speed:float = 2000
export var damage:float = 15
export var skin:Texture
export var effect:int = 2

var direction:Vector2 = Vector2()

func _ready() -> void:
  set_as_toplevel(true)
  $skin.texture = skin
  $skin.hframes = skin.get_width() / 39
  $skin.frame = effect

  $visibility_notifier_2d.connect("screen_exited", self, "_on_screen_exited")
  self.connect("body_entered", self, "_on_body_entered")

func _process(delta: float) -> void:
#  $skin.rotation_degrees = rotation
  position += direction * speed * delta

func _on_body_entered(body:Node) -> void:
  if body.is_a_parent_of(self): return;
  if not body.is_in_group("destroyable"): return;
  if body.has_method("damage"):
    body.damage(damage)
  queue_free()

func _on_screen_exited() -> void:
  yield(get_tree().create_timer(2.0),"timeout")
  queue_free()