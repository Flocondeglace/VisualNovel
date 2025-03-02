extends Node2D
class_name Dialog

var STATE : Dictionary = {
	HAPPY = "happy",
	SAD = "sad",
	ANGRY = "angry",
	OTHER = "other",
}


@export var character_data: CharacterData
@export var mood: DialogData.CharacterMood

@export_category("Nodes")
@export var sprite: TextureRect
@export var label: Label
@export var dialog: VBoxContainer
@export var text_dialog: RichTextLabel
@export var background_dialog : ColorRect


func set_character(c:CharacterData, m:DialogData.CharacterMood):
	character_data = c
	mood = m
	update_character()
	
func mood_to_string(m:DialogData.CharacterMood)->String:
	match m:
		DialogData.CharacterMood.HAPPY:
			return "happy"
		DialogData.CharacterMood.SAD:
			return "sad"
		DialogData.CharacterMood.ANGRY:
			return "angry"
		DialogData.CharacterMood.OTHER:
			return "other"
	print_debug("Error : mood unknown")
	return "unknown"
	
func update_character():
	if character_data:
		sprite.texture = load(character_data.spriteFolder +"/"+ mood_to_string(mood) +".png")
		label.text = character_data.name
		label.add_theme_color_override("font_color", character_data.color)
		background_dialog.color = character_data.color
	else:
		print_debug("Character Data missing")

func remove_choices():
	for c in dialog.get_children():
		if c.is_class("Button"):
			dialog.remove_child(c)

func set_text_dialog(t:String):
	text_dialog.text = t

func add_choice(text:String, actions:Array[Callable]):
	var c : Choice = Choice.new(text, actions)
	dialog.add_child(c)
