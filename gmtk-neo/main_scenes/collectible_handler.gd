class_name CollectibleHandler
extends Node

@export var rich_text_label: RichTextLabel
@export var rich_text_label_2: RichTextLabel

var props_collected := 0
var instruments_collected := 0


func _ready() -> void:
	Events.collectible_found.connect(_collectibe_found)


func _collectibe_found(idx):
	if idx == 0: instruments_collected += 1
	elif idx == 1: props_collected += 1
	_update_ui()


func _update_ui():
	rich_text_label.text = str(instruments_collected) + " / 5 Instruments collected"
	rich_text_label_2.text = str(props_collected) + " / 10 Props collected"
