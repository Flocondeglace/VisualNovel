extends Node2D

@export var current_dialog_id : int
@export_dir var folder_dialog : String
@export var dialog : Dialog

var uncountered_characters : Dictionary = {}
var dialog_data : DialogData
var current_character : Character

func _ready() -> void:
	change_dialog(current_dialog_id)
	
func find_action(a: ActionData)->Callable:
	match a.action:
		ActionData.Action.AUCUNE:
			return func():print_debug("aucune action")
		ActionData.Action.GO_TO:
			return func():change_dialog(a.params[0])
		ActionData.Action.MORE_LOVE:
			return func():current_character.more_love(a.params[0])
		_:
			return func():print_debug("action not found")

func set_character():
	var name : String = dialog_data.character.name
	if uncountered_characters.has(name):
		pass
	else :
		uncountered_characters[name] = Character.new(dialog_data.character)
		push_warning("New character had : "+ name)
	current_character = uncountered_characters.get(name)
	dialog.set_character(dialog_data.character, dialog_data.character_mood)

func change_dialog(id:int):
	dialog.remove_choices()
	dialog_data = load(folder_dialog+"/"+str(id)+".tres")
	
	# Character
	set_character()
	
	# Dialog
	dialog.set_text_dialog(dialog_data.text)
	
	# Choices
	for c in dialog_data.choices:
		var actions : Array[Callable] = []
		for a in c.actions:
			actions.append(find_action(a))
		dialog.add_choice(c.text, actions)
	if dialog_data.choices.size() == 0:
		dialog.add_choice("next", [func():change_dialog(dialog_data.next)])
