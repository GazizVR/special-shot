extends Node

signal team_score_changed(team: Team)

var selected_team: Team = Team.UNKNOWN
var camera_sensitivity: float = 0.001

enum Team {
	ZERO = 0,
	UNIT = 1,
	UNKNOWN = 2
}

var zero_team_spawn: Vector3 = Vector3.ZERO
var unit_team_spawn: Vector3 = Vector3.ZERO

var zero_team_score: int = 0:
	set(value):
		zero_team_score = value
		team_score_changed.emit(Team.ZERO)
var unit_team_score: int = 0:
	set(value):
		unit_team_score = value
		team_score_changed.emit(Team.UNIT)
