tool
extends Node
class_name Level

signal lose
signal win
signal player_available(player)

export var player_path:NodePath
onready var player = get_node(player_path)

func _enter_tree() -> void:
  var player:Player = Player.new()
  player.connect("ready", self, "emit_signal", ["player_available"])
  self.add_child(player)
  pass

func _ready() -> void:
  pass

