extends Level
class_name Level0

func setup() -> void:

# warning-ignore:unused_variable
  for i in range(10):
    var wave:Formation = sine_attack_formation.instance()
    wave.seat_number = 10
    wave.enemy_types = [
      Level.ENEMY_TYPES.BEHOLDER
    ]
    wave.setup()

    formations.append(wave)
