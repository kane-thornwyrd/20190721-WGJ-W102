extends Enemy
class_name Harpy

func target_acquisition(delta:float) -> void:
  if target and target.get_ref() != null:
    var _tru_target = target.get_ref()
    var target_dir = (_tru_target.global_position - global_position).normalized()
    var current_dir = Vector2(1, 0).rotated(global_rotation)
    global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * delta).angle()
    print_debug(current_dir.linear_interpolate(target_dir, 0.1).angle())
    if UTILS.float_crop(global_rotation, 3)  == \
       UTILS.float_crop(current_dir.linear_interpolate(target_dir, 0.1).angle(), 3) and \
        global_position.distance_to(_tru_target.global_position) < 800 :
      if recoil_timer.is_stopped():
        recoil_timer.start()
        shoot()