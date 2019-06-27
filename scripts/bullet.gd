extends Area2D
class_name Bullet

var Player = load("res://scripts/player/player.gd")

export var speed:float = 3000
export var damage:float = 15
export var alive_duration:float = 1.0
export var skin:Texture
export var effect:int = 0

var direction:Vector2 = Vector2()

func _ready() -> void:
  set_as_toplevel(true)

  $lifetime.connect("timeout", self, "_on_screen_exited")
  $lifetime.start(alive_duration)

  $skin.texture = skin
  $skin.hframes = float(skin.get_width()) / 39.0
  $skin.frame = effect
  $audio_shoot.pitch_scale = rand_range(0.9, 1.3)
  $audio_shoot.play()

  $visibility_notifier_2d.connect("screen_exited", self, "_on_screen_exited")
  self.connect("body_entered", self, "_on_body_entered")

func _process(delta: float) -> void:
  position += direction * speed * delta

func _on_body_entered(body:Node) -> void:
  if body is Player: return;
  if body.has_method("damage"):
    $audio_hit.pitch_scale = rand_range(0.9, 1.2)
    $audio_hit.play()
    body.damage(damage, global_position)
  queue_free()

func _on_screen_exited() -> void:
  queue_free()
