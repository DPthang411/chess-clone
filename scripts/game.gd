extends Node2D

@onready var board: Node2D = $board
@onready var label: Label = $label
var color_list = [Color.WHITE, Color.BLACK]
var select_piece
var selected_piece
var color
var turn = 0
var current_board_state = [
	[4,2,3,5,6,3,2,4],
	[1,1,1,1,1,1,1,1],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[-1,-1,-1,-1,-1,-1,-1,-1],
	[-4,-2,-3,-5,-6,-3,-2,-4],
	
]
var piece_scn = preload("res://scenes/piece.tscn")
#pwn = 1
#knight = 2
#bip = 3
#rook = 4
#queen = 5
#king = 6
func _ready() -> void:
	draw_pieces()
	
func _draw():
	for i in range(0, 8):
		for j in range(0, 8):
			color = color_list[(i+j)% 2]
			draw_rect(Rect2(i*64, j*64, 64, 64), color)
func draw_pieces():
	for row_idx in range(current_board_state.size()):
		var row = current_board_state[row_idx]
		for col_idx in range(row.size()):
			var col = row[col_idx]
			if col != 0: 
				var piece = piece_scn.instantiate()
				board.add_child(piece)
				piece.position = Vector2(col_idx*64+32, row_idx*64+32)
				piece.setup(col)

func capturing_piece(piece, cell_x, cell_y):
	for pjece in board.get_children():
		if current_board_state[cell_y][cell_x] == 0:
			return
		if pjece.cell_pos == Vector2(cell_x, cell_y):
			pjece.queue_free()

func moving_piece(piece, cell_x, cell_y):
	if piece.type == current_board_state[cell_y][cell_x]:
		return

	#capturing_piece(piece, cell_x, cell_y)
	piece.position = Vector2(cell_x * 64 +32, cell_y * 64 + 32)
	piece.cell_pos = Vector2(floor(piece.position.x/64), floor(piece.position.y/64))
	
	if turn == 0:
		turn = 1
	elif turn == 1:
		turn = 0
	
	current_board_state[cell_y][cell_x] = piece.type
	current_board_state[selected_piece.y][selected_piece.x] = 0
	
func get_mouse_pos_in_cell_pos():
	var cell_x = floor(get_global_mouse_position().x / 64)
	var cell_y = floor(get_global_mouse_position().y / 64)
	return [cell_x, cell_y]

func limit_movement(piece, cell_x, cell_y):
	var avail_mov_vecs = piece.get_piece_available_moves()
	var avail_cap_vecs: Array
	for dir in avail_mov_vecs:
		for vec in dir:
			if vec.x < 8 and vec.y < 8:
				if current_board_state[vec.y][vec.x] != 0:
					avail_cap_vecs.append(vec)
					break			
			if (cell_x == vec.x) and (cell_y == vec.y):
				moving_piece(piece, cell_x, cell_y)
			if piece.type == 1 or piece.type == -1 and piece.is_first_move == true:
				if (cell_x == vec.x or cell_x == piece.first_avail_move_vec.x) and (cell_y == vec.y or cell_y == piece.first_avail_move_vec.y):
					moving_piece(piece, cell_x, cell_y)
					piece.is_first_move = false
					
	if piece.type != 1 and piece.type != -1:
		for i in avail_cap_vecs:
			if (cell_x == i.x) and (cell_y==i.y):
				capturing_piece(piece, cell_x, cell_y)
				moving_piece(piece, cell_x, cell_y)
				
	elif piece.type == 1 or piece.type == -1:
		for i in piece.cap_vecs:
			if (cell_x == i.x) and (cell_y==i.y):
				if current_board_state[i.y][i.x] != 0:
					capturing_piece(piece, cell_x, cell_y)
					moving_piece(piece, cell_x, cell_y)

func selecting_piece(cell_x, cell_y):
	if selected_piece and select_piece:
		for piece in board.get_children():
			if piece.cell_pos == selected_piece:
				
				if turn == 0 and piece.type > 0 or turn == 1 and piece.type < 0:
					select_piece = false
					return

				limit_movement(piece, cell_x, cell_y)
				
		select_piece = false
		selected_piece = null
	else:
		var idk = current_board_state[cell_y][cell_x]
		if idk == 0:
			return

		selected_piece = Vector2(cell_x, cell_y)
		select_piece = true		

func handle_everything():
	var glob_mouse_pos = get_global_mouse_position()
	
	if 0 > glob_mouse_pos.x or glob_mouse_pos.x > 504 or glob_mouse_pos.y < 0 or glob_mouse_pos.y > 504:
		return
	var mouse_pos_in_cell = get_mouse_pos_in_cell_pos()
	var cell_x = mouse_pos_in_cell[0]
	var cell_y = mouse_pos_in_cell[1]
	selecting_piece(cell_x, cell_y)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			handle_everything()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if turn == 1:
		label.text = "Black turn"
		label.modulate = Color.BLACK
		
	else: 
		label.text = "White turn"
		label.modulate = Color.WHITE
