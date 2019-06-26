extends Level
class_name Level0

func _ready() -> void:
  var first_wave:SineAttackFormation = sine_attack_formation.instance()
  first_wave.seat_number = 10
  first_wave.enemy_types = [
    Level.ENEMY_TYPES.BEHOLDER
  ]
  first_wave.duration = 20.0
  first_wave.setup()

  formations.append(first_wave)