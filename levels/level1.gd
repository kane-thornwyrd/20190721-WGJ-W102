extends Level
class_name Level1

func setup() -> void:
  var wave:Formation = sine_attack_formation.instance()
  wave.seat_number = 1
  wave.enemy_types = [
    Level.ENEMY_TYPES.BEHOLDER
  ]
  wave.setup()

  formations.append(wave)