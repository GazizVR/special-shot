extends Node

var selected_team: Team

enum Team {
	ZERO,
	UNIT,
	UNKNOWN
}

var zero_team_spawn: Vector3 = Vector3.ZERO
var unit_team_spawn: Vector3 = Vector3.ZERO
