extends Node

signal FighterDamaged(fighter : Fighter)
signal FighterDefeated(fighter : Fighter)

signal ReadyToSelectUpgrades(fighter : Fighter)
signal BeginSelectingUpgrades(option_1 : UpgradeData, 
							option_2 : UpgradeData, 
							option_3 : UpgradeData)
signal UpgradeSelected(fighter : Fighter, upgrade : UpgradeData)

signal GoToNextRound(fighter : Fighter)

signal GameStateChanged(game_state : GameManager.GameState)
