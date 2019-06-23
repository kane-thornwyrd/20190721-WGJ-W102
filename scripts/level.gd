extends Node
class_name Level

var Player = preload("res://scripts/player/player.tscn")

signal lose
signal win
# warning-ignore:unused_signal
signal player_available(player)

func _enter_tree() -> void:
  var player:Player = Player.new()
  assert player.connect("ready", self, "emit_signal", ["player_available"]) == 0
  self.add_child(player)

func _ready() -> void:
  pass

