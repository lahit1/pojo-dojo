class_name WorldNode
extends Node2D

@export var spawn_points: Array[Marker2D] = []

@export_group("Camera Limits", "camera_limit_")
@export var camera_limit_left: float = -999999
@export var camera_limit_top: float = -999999
@export var camera_limit_right: float = 999999
@export var camera_limit_bottom: float = 999999
