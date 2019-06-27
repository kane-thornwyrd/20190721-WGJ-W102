tool
extends KinematicBody2D
class_name Debris

export (SpriteFrames) var sprite_frames setget _set_sprite_frames
export var velocity:Vector2 = Vector2()
export var sprite_path:NodePath = "sprite"

onready var sprite:AnimatedSprite = get_node(sprite_path)

func _ready() -> void:
  sprite.connect("ready", sprite, "set_sprite_frames", [sprite_frames])
  sprite.connect("ready", sprite, "play")

func _process(delta: float) -> void:
  if Engine.editor_hint:
    # Code to execute in editor.
    if sprite and not sprite.frames: sprite.set_sprite_frames(sprite_frames);
    if sprite and not sprite.playing: sprite.play();

  if not Engine.editor_hint:
    # Code to execute in game.
    pass

func _on_visibility_notifier_screen_exited() -> void:
  yield(get_tree().create_timer(2.0),"timeout")
  queue_free()

func _set_sprite_frames(spr_frms:SpriteFrames) -> void:
  sprite_frames = spr_frms
  sprite.set_sprite_frames(sprite_frames)
  sprite.play()
  print_debug("sprite_frames set")