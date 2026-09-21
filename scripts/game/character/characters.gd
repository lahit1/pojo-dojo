class_name Characters

## We don't store these variables in @CharacterData class because this will cause cycling dependency which causes deadlock.
static var characters: Dictionary[int, CharacterData] = {
	CharacterData.Type.C12: CharacterData.new(
		preload("res://scenes/characters/c12.tscn"),
		preload("res://sprites/characters/c12.tres"),
		"Kod Adı 12"
	),
	CharacterData.Type.CPUNPKIN: CharacterData.new(
		preload("res://scenes/characters/punpkin.tscn"),
		preload("res://sprites/characters/punpkin.tres"),
		"Punpkin"
	),
	CharacterData.Type.CALIEN: CharacterData.new(
		preload("res://scenes/characters/alien.tscn"),
		preload("res://sprites/characters/alien.tres"),
		"Alien"
	),
	CharacterData.Type.CBANDITO: CharacterData.new(
		preload("res://scenes/characters/bandito.tscn"),
		preload("res://sprites/characters/bandito.tres"),
		"Bandito"
	),
	CharacterData.Type.CBEETLE_JUIX: CharacterData.new(
		preload("res://scenes/characters/beetle_juix.tscn"),
		preload("res://sprites/characters/beetle_juix.tres"),
		"Beetle Juix"
	),
	CharacterData.Type.CDRACULA: CharacterData.new(
		preload("res://scenes/characters/dracula.tscn"),
		preload("res://sprites/characters/dracula.tres"),
		"Dracula"
	),
	CharacterData.Type.CFREDDY_K: CharacterData.new(
		preload("res://scenes/characters/freddy_k.tscn"),
		preload("res://sprites/characters/freddy_k.tres"),
		"FREDDY K"
	),
	CharacterData.Type.CGANDAL: CharacterData.new(
		preload("res://scenes/characters/gandal.tscn"),
		preload("res://sprites/characters/gandal.tres"),
		"GANDAL"
	),
	CharacterData.Type.CJOKE: CharacterData.new(
		preload("res://scenes/characters/joke.tscn"),
		preload("res://sprites/characters/joke.tres"),
		"JOKE"
	),
	CharacterData.Type.CHARLEY_QUEEN: CharacterData.new(
		preload("res://scenes/characters/harley_queen.tscn"),
		preload("res://sprites/characters/harley_queen.tres"),
		"Harley Queen"
	),
	CharacterData.Type.CJODA: CharacterData.new(
		preload("res://scenes/characters/joda.tscn"),
		preload("res://sprites/characters/joda.tres"),
		"JODA"
	),
	CharacterData.Type.CMARTY_MC: CharacterData.new(
		preload("res://scenes/characters/marty_mc.tscn"),
		preload("res://sprites/characters/marty_mc.tres"),
		"Marty MC"
	),
	CharacterData.Type.CSICARIO: CharacterData.new(
		preload("res://scenes/characters/sicario.tscn"),
		preload("res://sprites/characters/sicario.tres"),
		"Sicario"
	),
	CharacterData.Type.CSUORA: CharacterData.new(
		preload("res://scenes/characters/suora.tscn"),
		preload("res://sprites/characters/suora.tres"),
		"Suora"
	),
	CharacterData.Type.CTERMINX: CharacterData.new(
		preload("res://scenes/characters/terminx.tscn"),
		preload("res://sprites/characters/terminx.tres"),
		"Terminx"
	),
	CharacterData.Type.CTREEP_WOO: CharacterData.new(
		preload("res://scenes/characters/treep_woo.tscn"),
		preload("res://sprites/characters/treep_woo.tres"),
		"Treep Woo"
	)
}

static func get_character_data(t: CharacterData.Type) -> CharacterData:
	return characters[t]
