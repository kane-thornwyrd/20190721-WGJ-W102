extends Lifeform
class_name Player

# warning-ignore:unused_class_variable
onready var anim_player:AnimationPlayer = $animation_player
onready var shield = $body/shield

func _ready() -> void:
  bullet_scene = preload("res://scripts/bullet.tscn")
  assert recoil_timer.connect("timeout", self, "shoot") == 0
  recoil_timer.start()

func shoot() -> void:
  .shoot()
  $body/turret/Shaker.start(recoil)

func get_reaction_time() -> float: return 10.0;

func energy_field_perturbations() -> void: shield.modulate = Color(1.0, 0.0, 0.0, rand_range(0.0, 1.0));

# warning-ignore:unused_argument
func control(delta:float) -> void:
  self.velocity.x = lerp(self.velocity.x, self.speed * self.move_direction.x, 0.2)
  self.velocity.y = lerp(self.velocity.y, self.speed * self.move_direction.y, 0.2)
  self.velocity = move_and_slide(self.velocity, Vector2(), true)
