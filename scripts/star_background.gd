extends ParallaxBackground

var offset_loc = 1
export var speed:int = -150
var scrl_off = Vector2()

func _physics_process(delta: float) -> void:
  offset_loc += speed * delta
  scrl_off.x = offset_loc
  scroll_offset = scrl_off