extends Node

signal FighterDamaged(fighter : Fighter)
signal FighterDefeated(fighter : Fighter)

signal ReadyToSelectUpgrades()
signal UpgradeSelected(fighter : Fighter)
signal GoToNextRound(fighter : Fighter)

signal GameStateChanged(game_state : GameManager.GameState)
