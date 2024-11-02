extends CharacterBody3D


@export var move_speed := 5.0
@export var look_speed := -0.01

@onready var camera: Camera3D = $Camera3D

var rot_x := 0.0
var rot_y := 0.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:# and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# modify accumulated mouse rotation
		rot_x += event.relative.x * look_speed
		rot_y += event.relative.y * look_speed
		transform.basis = Basis() # reset rotation
		rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
		rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate in X
