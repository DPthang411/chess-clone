extends Node2D

@onready var piece_img: Sprite2D = $piece_img

var pwn = 1
var knight = 2
var bip = 3
var rook = 4
var queen = 5
var king = 6
var type
var cell_pos
var available_move_vecs : Array
var first_avail_move_vec
var is_first_move = true
var cap_vecs 

func _ready() -> void:
	pass

func setup(_type):
	type = _type
	cell_pos = Vector2(floor(position.x/64), floor(position.y/64))

	if _type < 0:
		_type = abs(_type)
		if _type == pwn:
			piece_img.frame = 11
		elif _type == knight:
			piece_img.frame = 9
		elif _type == bip:
			piece_img.frame = 8
		elif _type == rook:
			piece_img.frame = 10
		elif _type == king:
			piece_img.frame = 6
		elif _type == queen:
			piece_img.frame = 7
			
	elif _type > 0:
		if _type == pwn:
			piece_img.frame = 5
		elif _type == knight:
			piece_img.frame = 3
		elif _type == bip:
			piece_img.frame = 2
		elif _type == rook:
			piece_img.frame = 4
		elif _type == king:
			piece_img.frame = 0
		elif _type == queen:
			piece_img.frame = 1	
	
func get_piece_available_moves():
	if type == 1 or type == -1:
		available_move_vecs = [[Vector2(0+cell_pos.x, type+cell_pos.y)]]
		first_avail_move_vec = Vector2(0+cell_pos.x, type*2+cell_pos.y)
		cap_vecs = [Vector2(type+cell_pos.x, type+cell_pos.y), Vector2(-type+cell_pos.x, type+cell_pos.y)]
		
	if type == 2 or type == -2:
		available_move_vecs = [
			#up 2 squares
			[Vector2(1+cell_pos.x, 2+cell_pos.y)], 
			[Vector2(1+cell_pos.x, -2+cell_pos.y)],
			[Vector2(-1+cell_pos.x, 2+cell_pos.y)], 
			[Vector2(-1+cell_pos.x, -2+cell_pos.y)],
			#up 1 square
			[Vector2(2+cell_pos.x, 1+cell_pos.y)], 
			[Vector2(2+cell_pos.x, -1+cell_pos.y)],
			[Vector2(-2+cell_pos.x, 1+cell_pos.y)], 
			[Vector2(-2+cell_pos.x, -1+cell_pos.y)],
		]
		
	if type == 6 or type == -6:
		available_move_vecs = [
			#upper 3 squares
			[Vector2(1+cell_pos.x, 1+cell_pos.y)],
			[Vector2(0+cell_pos.x, 1+cell_pos.y)],
			[Vector2(-1+cell_pos.x, 1+cell_pos.y)],
			
			#middle 3 squares
			[Vector2(1+cell_pos.x, 0+cell_pos.y)],
			[Vector2(-1+cell_pos.x, 0+cell_pos.y)],
			
			#down 3 squares
			[Vector2(1+cell_pos.x, -1+cell_pos.y)],
			[Vector2(0+cell_pos.x, -1+cell_pos.y)],
			[Vector2(-1+cell_pos.x, -1+cell_pos.y)],
		]
		
	if type == 4 or type == -4:
		available_move_vecs = [
			[],[],[],[]
		]
		
		for i in range(1,8):
			available_move_vecs.append([])
			available_move_vecs.append([])
			available_move_vecs.append([])
			available_move_vecs.append([])
			available_move_vecs[0].append(Vector2(i*1+cell_pos.x, 0+cell_pos.y))
			available_move_vecs[1].append(Vector2(i*-1+cell_pos.x, 0+cell_pos.y))
			available_move_vecs[2].append(Vector2(0+cell_pos.x, i*1+cell_pos.y))
			available_move_vecs[3].append(Vector2(0+cell_pos.x, i*-1+cell_pos.y))
	
	if type == 3 or type == -3:
		available_move_vecs = [
			[],[],[],[]
		]
		
		for i in range(1,8):
			available_move_vecs[0].append(Vector2(i*1+cell_pos.x, i*1+cell_pos.y))
			available_move_vecs[1].append(Vector2(i*-1+cell_pos.x, i*1+cell_pos.y))
			available_move_vecs[2].append(Vector2(i*1+cell_pos.x, i*-1+cell_pos.y))
			available_move_vecs[3].append(Vector2(i*-1+cell_pos.x, i*-1+cell_pos.y))
	
	if type == 5 or type == -5:
		available_move_vecs = [
			[],[],[],[],[],[],[],[]
		]
		
		for i in range(1,8):
			available_move_vecs[0].append(Vector2(i*1+cell_pos.x, 0+cell_pos.y))
			available_move_vecs[1].append(Vector2(i*-1+cell_pos.x, 0+cell_pos.y))
			available_move_vecs[2].append(Vector2(0+cell_pos.x, i*1+cell_pos.y))
			available_move_vecs[3].append(Vector2(0+cell_pos.x, i*-1+cell_pos.y))
			available_move_vecs[4].append(Vector2(i*1+cell_pos.x, i*1+cell_pos.y))
			available_move_vecs[5].append(Vector2(i*-1+cell_pos.x, i*1+cell_pos.y))
			available_move_vecs[6].append(Vector2(i*1+cell_pos.x, i*-1+cell_pos.y))
			available_move_vecs[7].append(Vector2(i*-1+cell_pos.x, i*-1+cell_pos.y))
	
	return available_move_vecs
	
func _process(delta: float) -> void:
	pass
