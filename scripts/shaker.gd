extends Node2D
class_name Shaker

const TRANSITION = Tween.TRANS_QUINT
const EASE = Tween.EASE_OUT

export var amplitude:float = 0.2
export var frequency:float = 1.0
export var priority:int = 0
export var property_name:String = "position"
var _original_val

func start(duration:float=0.2, prio:int=0):
  if prio >= self.priority:
    $duration.wait_time = duration
    $frequency.wait_time = 1/frequency
    $duration.start()
    _original_val = self.get_parent().get(property_name)
    _new_shake()

func _new_shake():
  if self.get_parent():
    var rand = Vector2(
      rand_range(-amplitude, amplitude),
      rand_range(-amplitude, amplitude)
    )
    $shake_tween.interpolate_property(
      self.get_parent(), property_name, self.get_parent().get(property_name), rand, $frequency.wait_time, TRANSITION, EASE
    )
    $shake_tween.start()

func _on_frequency_timeout():
  _new_shake()

func _on_duration_timeout():
  $frequency.stop()
  $shake_tween.interpolate_property(self.get_parent(), property_name, self.get_parent().get(property_name), _original_val, 0.2, TRANSITION, EASE)
