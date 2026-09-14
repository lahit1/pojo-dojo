class_name Characters

## We don't store these variables in @CharacterData class because this will cause cycling dependency which causes deadlock.
static var characters: Dictionary[int, CharacterData] = {
	CharacterData.Type.C12: CharacterData.new(
		preload("res://scenes/characters/c12.tscn"),
		preload("res://sprites/characters/c12.tres")
	),
	CharacterData.Type.CPUNPKIN: CharacterData.new(
		preload("res://scenes/characters/punpkin.tscn"),
		preload("res://sprites/characters/punpkin.tres")
	)
}

static func get_character_data(t: CharacterData.Type) -> CharacterData:
	return characters[t]
