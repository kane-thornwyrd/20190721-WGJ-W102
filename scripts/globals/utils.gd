extends Node

enum OPERATION {FLOOR, ROUND, CEIL}

static func float_crop(number:float, length:int, operation:int = OPERATION.ROUND ) -> float:
  var number_strings = String(number).split(".")
  var integer_part = number_strings[0]
  var floating_part = number_strings[1]
  if floating_part.length() <= length: return number;

  var rest:float
  match operation:
    OPERATION.FLOOR:
      rest = floor(float(floating_part.right(length - 1).insert(1, ".")))
    OPERATION.ROUND:
      rest = round(float(floating_part.right(length - 1).insert(1, ".")))
    OPERATION.CEIL:
      rest = ceil(float(floating_part.right(length - 1).insert(1, ".")))

  return float(str(integer_part,".", floating_part.left(length - 1), rest))