extends Node
@export_file("*.json") var char_json:Array[String]
@export_dir var char_save_path
@export_file("*.json") var dialog_json:Array[String]
@export_dir var dialog_save_path


func _ready():
	# convertir_char_json_en_tres()
	convertir_dialog_json_en_tres()

func read_json(path):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("Erreur : Impossible de lire le fichier JSON.")
		return

	var json_string = file.get_as_text()
	var json_data = JSON.parse_string(json_string)

	if json_data == null:
		print("Erreur : JSON invalide.")
		return
	return json_data

func convertir_dialog_json_en_tres():
	for d in dialog_json:
		var json_data = read_json(d)
		if json_data==null:
			return
		var res : DialogData = DialogData.new()
		res.character = load(char_save_path + "/" + json_data.get("character", "Inconnu") + ".tres")
		var mood_name :String = json_data.get("character_mood", "happy").to_upper()
		res.character_mood = DialogData.CharacterMood.find_key(DialogData.CharacterMood.get(mood_name))
		res.id = int(d.trim_suffix(".json"))
		res.next = json_data.get("next", 0)
		res.text = json_data.get("text", "")
		var json_choices = json_data.get("choices", [])
		for c in json_choices:
			var choice_data : ChoiceData = ChoiceData.new()
			choice_data.text = c.get("text")
			var actions_json = c.get("actions")
			for a in actions_json:
				var action : ActionData = ActionData.new()
				var action_name :String = a.get("action", "aucune").to_upper()
				action.action = ActionData.Action.find_key(ActionData.Action.get(action_name))
				action.params = a.get("params",[])
				choice_data.actions.append(action)
			res.choices.append(choice_data)
		res.choices
		var save_path = dialog_save_path + "/" + str(res.id) + ".tres"
		ResourceSaver.save(res, save_path)
		print("Resource sauvegardée en : " + save_path)

func convertir_char_json_en_tres():
	for c in char_json:
		var json_data = read_json(c)
		if json_data==null:
			return

		var res : CharacterData = CharacterData.new()
		res.name = json_data.get("name", "Inconnu")
		res.color = Color.from_string(json_data.get("color", "#FFFFFF"), Color.WHITE)
		res.love = json_data.get("love", 0)

		var save_path = char_save_path + "/" + res.name + ".tres"
		ResourceSaver.save(res, save_path)
		print("Resource sauvegardée en : " + save_path)
