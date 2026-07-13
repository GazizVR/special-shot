extends Node

var selected_team: Team = Team.UNKNOWN
var camera_sensitivity: float = 0.001

enum Team {
	ZERO = 0,
	UNIT = 1,
	UNKNOWN = 2
}

var zero_team_spawn: Vector3 = Vector3.ZERO
var unit_team_spawn: Vector3 = Vector3.ZERO

var zero_team_score: int = 0
var unit_team_score: int = 0
