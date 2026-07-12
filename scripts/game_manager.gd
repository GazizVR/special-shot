extends Node

signal changed_sensitivity(sense: float)

var selected_team: Team = Team.UNKNOWN
var camera_sensitivity: float = 0.001:
	set(value):
		camera_sensitivity = value
		changed_sensitivity.emit(value)

enum Team {
	ZERO = 0,
	UNIT = 1,
	UNKNOWN = 2
}

var zero_team_spawn: Vector3 = Vector3.ZERO
var unit_team_spawn: Vector3 = Vector3.ZERO
