extends Node

# Player
signal ability_executed(ability_idx: int)
signal ability_cancelled(ability_idx: int)
signal scale_changed(new_scale: float)

# Game
signal toggle_pause_requested
signal on_restart_game
signal on_exit_game

# Collectibles
signal collectible_found(type: int)
