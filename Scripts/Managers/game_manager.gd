class_name GameManager
extends Node

enum GameState
{
	LOADING,
	COUNTDOWN,
	PLAYING,
	UPGRADESELECT,
	ENDED
}

@onready var countdown_anim : AnimationPlayer = $CountdownCanvasLayer/CountdownAnimation
@onready var countdown_timer : Timer = $CountdownTimer

@onready var endgame_text : Label = $CountdownCanvasLayer/EndgameText
@onready var endgame_timer : Timer = $EndgameTimer

var current_game_state : GameState

func _ready() -> void:
	GlobalEvents.FighterDefeated.connect(_on_fighter_defeated)
	_change_game_state(GameState.COUNTDOWN)
	
func _change_game_state(game_state : GameState):
	current_game_state = game_state
	
	if game_state == GameState.COUNTDOWN:
		# play start countdown
		countdown_anim.play("countdown")
		countdown_timer.start()
	elif game_state == GameState.ENDED:
		# game over timer
		endgame_timer.start()
		
	GlobalEvents.GameStateChanged.emit(current_game_state)
	
func _on_fighter_defeated(fighter : Fighter):
	_change_game_state(GameState.ENDED)
	
	# show player win text
	endgame_text.visible = true
	if fighter.player_id == 0:
		endgame_text.text = "Player 2 wins"
	elif fighter.player_id == 1:
		endgame_text.text = "Player 1 wins"
	
	
func _on_countdown_timer_timeout() -> void:
	_change_game_state(GameState.PLAYING)

func _on_endgame_timer_timeout() -> void:
	print("go to menu")
