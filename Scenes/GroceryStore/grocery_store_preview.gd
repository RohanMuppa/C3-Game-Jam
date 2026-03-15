extends Node2D

@export var is_active: bool = false
@export var connection_radius: float = 200.0
@export var cost: float = 25
@export var houses: Array[House] = []
@export var imports: Array[Import] = []
@export var gs_parent: Node

var first_store = true

@onready var GroceryStoreScene: PackedScene = preload("res://Scenes/GroceryStore/GroceryStore.tscn")
@onready var game_main: GameMain = get_tree().root.get_node("Main")
@onready var dialog_box: = $"../Dialog/CanvasLayer/DialogBox"

@onready var emilija_icon: CompressedTexture2D = preload("res://Sprites/mom.png")

# general idea:
# when active:
#	display at mouse cursor
#	draw lines connecting to other distribution points(?), farms, and houses in radius
# when inactive:
#	dont be visible :P
# if active && place_distribution_point():
#	instantiate new distribution point
#	connect to farms and houses in radius
#	also connect to other distribution points(?)
# 	become inactive

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("GS_Preview")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("place_gs"):
		is_active = !is_active
	if (Input.is_action_just_pressed("place_dp") || Input.is_action_just_pressed("escape")):
		is_active = false
	
	if !is_active:
		visible = false;
		return
	
	visible = true;
	global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("confirm_placement") && can_place():
		place_gs()
	
	queue_redraw()

func can_place() -> bool:
	return imports.size() > 0 && houses.filter(in_radius).size() > 0 && game_main.money >= cost

func _draw() -> void:
	if !is_active:
		return
	if can_place():
		draw_circle(
				Vector2.ZERO, connection_radius,
				Color(1.0, 1.0, 1.0, 0.35), true
			)
	else:
		draw_circle(
			Vector2.ZERO, connection_radius,
			Color(.6, .6, .6, 0.35), true
		)
	
	for house in houses:
		if !in_radius(house):
			continue
		draw_line(
			Vector2.ZERO,
			house.global_position - global_position,
			Color.CRIMSON
		)
	
	for import in imports:
		draw_line(
			Vector2.ZERO,
			import.global_position - global_position,
			Color.DARK_ORANGE
		)

func in_radius(node: Node2D):
	return node.global_position.distance_to(global_position) <= connection_radius

func place_gs():
	is_active = false
	
	if (first_store):
		var arr: Array[CustomText] =  [
			CustomText.create("Emilija: A new grocery store, how wonderful!", 10, emilija_icon)
		]
		dialog_box.set_text(arr)
		first_store = false
		
	
	game_main.money -= cost
	game_main.total_spent += cost
	game_main.gs_placed += 1
	cost *= 1.5
	
	var gs: GroceryStore = GroceryStoreScene.instantiate()
	gs.global_position = global_position
	gs.imports.append_array(imports)
	gs.houses.append_array(houses.filter(in_radius))
	gs_parent.add_child(gs)
	gs.ui = $"../Ui"
