extends Node2D

var player = preload("res://scenes/player.tscn")
var box = preload("res://scenes/box.tscn")
var ball = preload("res://scenes/ball.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inst(Vector2(0,0),Vector2(-40,10),Vector2(20,20))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func inst(playerPos, boxPos, ballPos):
	var  playerInst = player.instantiate()
	var  boxInst = box.instantiate()
	var  ballInst = ball.instantiate()
	playerInst.position = playerPos
	boxInst.position = boxPos
	ballInst.position = ballPos
	add_child(playerInst)
	add_child(boxInst)
	add_child(ballInst)
