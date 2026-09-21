class_name SceneManager
extends Object

static var current_scene: Node
static var current_scene_type: SceneT
static var queued_scene: Node
static var queued_scene_type: SceneT

static var INSTANCE: SceneManager = new()

signal scene_changed(previous_scene: Node, current_scene)

static func connect_to_scene_changed_signal(c: Callable, flags: int = 0):
	INSTANCE.scene_changed.connect(c, flags)

static func disconnect_to_scene_changed_signal(c: Callable, flags: int = 0):
	INSTANCE.scene_changed.disconnect(c)

static func emit_to_scene_changed_signal(...args: Array):
	INSTANCE.scene_changed.emit.callv(args)


static var CACHED_SELECTOR_SCENE_INSTANCE: Node
static var CACHED_GAME_OVER_SCENE_INSTANCE: Node
# Don't cache game screen

static func set_scene(s: SceneT):
	if queued_scene != null: return

	match s:
		SceneT.Selector:
			if CACHED_SELECTOR_SCENE_INSTANCE == null:
				CACHED_SELECTOR_SCENE_INSTANCE = preload("res://scenes/selector.tscn").instantiate()
			queued_scene = CACHED_SELECTOR_SCENE_INSTANCE
			queued_scene_type = SceneT.Selector
		SceneT.Game:
			queued_scene = preload("res://scenes/game.tscn").instantiate()
			queued_scene_type = SceneT.Game
		SceneT.GameOver:
			if CACHED_GAME_OVER_SCENE_INSTANCE == null:
				CACHED_GAME_OVER_SCENE_INSTANCE = preload("res://scenes/game_over.tscn").instantiate()
			queued_scene = CACHED_GAME_OVER_SCENE_INSTANCE
			queued_scene_type = SceneT.Selector
		_:
			push_error("Unkown screen type")


enum SceneT {
	Selector,
	Game,
	GameOver
}
