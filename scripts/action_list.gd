extends Control
class_name ActionList

const InputLine = preload("res://scripts/input_line.tscn")

func clear(): for child in get_children(): child.queue_free();

func add_input_line(action_name, key) -> InputLine:
  var line = InputLine.instance()
  line.initialize(action_name, key)
  add_child(line)
  return line