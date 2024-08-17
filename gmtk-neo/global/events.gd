extends Node

# Player
signal ability_executed(ability_idx: int)
signal ability_cancelled(ability_idx: int)

# Game
signal toggle_pause_requested
