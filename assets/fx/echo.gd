extends Sprite
class_name Echo

const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT

export var sprite_path: NodePath
export var gradient: Gradient

onready var echo_timer:Timer = $echo_timer
onready var alpha_tween:Tween = $alpha_tween
onready var echoing_sprite:Sprite = get_node(sprite_path)
onready var echoing_parent:Node2D = self.get_parent()

var duration:float

func echo_start(delay:float, duration:float) -> void:
  self.duration = duration
# warning-ignore:return_value_discarded
  echo_timer.connect("timeout", self, "echo")
  echo_timer.start(delay)

func echo_stop() -> void:
  echo_timer.stop()

func echo() -> void:
  var echo = self.duplicate()
  echo.position = echoing_parent.position
  echo.texture = echoing_sprite.texture
  echo.vframes = echoing_sprite.vframes
  echo.hframes = echoing_sprite.hframes
  echo.frame = echoing_sprite.frame
  echo.scale = echoing_sprite.scale
  echo.flip_h = echoing_sprite.flip_h
  echo.flip_v = echoing_sprite.flip_v
# warning-ignore:return_value_discarded
  alpha_tween.interpolate_property(echo, "modulate", gradient.get_color(0), gradient.get_color(gradient.get_point_count()-1), self.duration, SHIFT_TRANS, SHIFT_EASE)
# warning-ignore:return_value_discarded
  alpha_tween.start()
  echoing_parent.get_parent().add_child(echo)
  var t = Timer.new()
  t.set_wait_time(duration)
  t.set_one_shot(true)
  echo.add_child(t)
  t.start()
  yield(t, "timeout")
  t.queue_free()
  echo.queue_free()