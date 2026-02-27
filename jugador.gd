extends CharacterBody3D

const SPEED = 5.0

@onready var modelo_visual = $"character-employee2"

func _physics_process(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var direction = Vector3(-input_dir.x, 0, -input_dir.y).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		var look_target = modelo_visual.global_position + direction
		modelo_visual.look_at(look_target, Vector3.UP)
		modelo_visual.rotate_y(PI)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
