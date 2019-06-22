extends Control

const InputLine = preload("res://scripts/input_line.tscn")

func clear(): for child in get_children(): child.free();

func add_input_line(action_name, key, is_customizable=false):
  var line = InputLine.new(action_name, key, is_customizable)
  add_child(line)
  return line