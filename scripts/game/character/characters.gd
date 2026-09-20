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
	),
	CharacterData.Type.CALIEN: CharacterData.new(
		preload("res://scenes/characters/alien.tscn"),
		preload("res://sprites/characters/alien.tres")
	),
	CharacterData.Type.CBANDITO: CharacterData.new(
		preload("res://scenes/characters/bandito.tscn"),
		preload("res://sprites/characters/bandito.tres")
	),
	CharacterData.Type.CBEETLE_JUIX: CharacterData.new(
		preload("res://scenes/characters/beetle_juix.tscn"),
		preload("res://sprites/characters/beetle_juix.tres")
	),
	CharacterData.Type.CDRACULA: CharacterData.new(
		preload("res://scenes/characters/dracula.tscn"),
		preload("res://sprites/characters/dracula.tres")
	),
	CharacterData.Type.CFREDDY_K: CharacterData.new(
		preload("res://scenes/characters/freddy_k.tscn"),
		preload("res://sprites/characters/freddy_k.tres")
	),
	CharacterData.Type.CGANDAL: CharacterData.new(
		preload("res://scenes/characters/gandal.tscn"),
		preload("res://sprites/characters/gandal.tres")
	),
	CharacterData.Type.CJOKE: CharacterData.new(
		preload("res://scenes/characters/joke.tscn"),
		preload("res://sprites/characters/joke.tres")
	),
	CharacterData.Type.CHARLEY_QUEEN: CharacterData.new(
		preload("res://scenes/characters/harley_queen.tscn"),
		preload("res://sprites/characters/harley_queen.tres")
	),
	CharacterData.Type.CJODA: CharacterData.new(
		preload("res://scenes/characters/joda.tscn"),
		preload("res://sprites/characters/joda.tres")
	),
	CharacterData.Type.CMARTY_MC: CharacterData.new(
		preload("res://scenes/characters/marty_mc.tscn"),
		preload("res://sprites/characters/marty_mc.tres")
	),
	CharacterData.Type.CSICARIO: CharacterData.new(
		preload("res://scenes/characters/sicario.tscn"),
		preload("res://sprites/characters/sicario.tres")
	),
	CharacterData.Type.CSUORA: CharacterData.new(
		preload("res://scenes/characters/suora.tscn"),
		preload("res://sprites/characters/suora.tres")
	),
	CharacterData.Type.CTERMINX: CharacterData.new(
		preload("res://scenes/characters/terminx.tscn"),
		preload("res://sprites/characters/terminx.tres")
	),
	CharacterData.Type.CTREEP_WOO: CharacterData.new(
		preload("res://scenes/characters/treep_woo.tscn"),
		preload("res://sprites/characters/treep_woo.tres")
	)
}

static func get_character_data(t: CharacterData.Type) -> CharacterData:
	return characters[t]
