extends Bullet
class_name EnemyBullet

var Enemy = load("res://scripts/enemies/enemy.gd")


func _on_body_entered(body:Node) -> void:
  if body is Enemy: return;
  if body.has_method("damage"):
    $audio_hit.pitch_scale = rand_range(0.7, 1.3)
    $audio_hit.play()
    body.damage(damage, global_position)
  queue_free()