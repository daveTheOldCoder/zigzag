# Demonstrates contraining user-specified movement to multiple of 90 degrees.
#
# Input can be a touch, a mouse left-click (emulated), or a directional input
# action such as an arrow keypress or a joystick input.

extends Node2D

# Object that moves.
@onready var mover: Area2D = $Mover

# Target whose position is designated by touch or mouse left-click.
@onready var target: Area2D = $Target

const SPEED: float = 25.0
const TIMER_PERIOD: float = 0.5

var movement_timer: Timer


func _ready() -> void:

	movement_timer = Timer.new()
	movement_timer.one_shot = false
	movement_timer.autostart = false
	movement_timer.wait_time = TIMER_PERIOD
	movement_timer.timeout.connect(_on_movement_timer_timeout)
	add_child(movement_timer)

	mover.show()
	target.hide()


func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventScreenTouch:

		# Set target position to input event position.
		target.position = event.position
		target.show()

		# Start movement toward target.
		movement_timer.start()

	else:

		# Check for directional input action.
		var vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if not vector.is_zero_approx():

			# Move in computed direction.
			move(vector)


func _on_movement_timer_timeout() -> void:

	# Get vector to target.
	var vector: Vector2 = target.position - mover.position

	# If close to target, stop movement.
	if vector.length() < SPEED:
		movement_timer.stop()
		target.hide()

	# Otherwise, move toward target.
	else:
		move(vector)


func move(vector: Vector2) -> void:

	# Round vector's direction to nearest multiple of 90 degrees.
	const HALF_PI: float = PI / 2.0
	var new_vector: Vector2 = Vector2.from_angle((roundf(vector.angle() / HALF_PI)) * HALF_PI)

	# Move toward target.
	mover.position += new_vector.normalized() * SPEED
