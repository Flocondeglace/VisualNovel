extends Resource
class_name DialogData

enum CharacterMood {HAPPY=0, SAD=1, ANGRY=2, OTHER=3}

@export var id: int
@export var next: int
@export var character: CharacterData
@export var character_mood : CharacterMood
@export_multiline var text: String

@export_category("Choices")
@export var choices : Array[ChoiceData]
