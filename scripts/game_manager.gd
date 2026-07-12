extends Node

var selected_team: Team = Team.UNKNOWN

enum Team {
	ZERO = 0,
	UNIT = 1,
	UNKNOWN = 2
}

var zero_team_spawn: Vector3 = Vector3.ZERO
var unit_team_spawn: Vector3 = Vector3.ZERO
