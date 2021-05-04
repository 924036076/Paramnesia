extends Control

var key = "Menu"

var hair: int = 1
var max_hair: int = 1
var outfit: int = 1
var max_outfit: int = 1

onready var body_sprite = get_node("BaseSprite")
onready var hair_sprite = get_node("HairSprite")
onready var brow_sprite = get_node("BrowsSprite")
onready var pupil_sprite = get_node("PupilsSprite")
onready var outfit_sprite = get_node("OutfitSprite")
onready var animation_player = get_node("AnimationPlayer")
onready var skin_palette = get_node("SkinPalette")
onready var hair_palette = get_node("HairPalette")
onready var brow_palette = get_node("EyebrowPalette")
onready var pupil_palette = get_node("PupilPalette")

func _ready():
	body_sprite.modulate = skin_palette.get_node("Color0").modulate
	hair_sprite.modulate = hair_palette.get_node("Color3").modulate
	brow_sprite.modulate = brow_palette.get_node("Color3").modulate
	pupil_sprite.modulate = pupil_palette.get_node("Color0").modulate
	update_sprites()

func _input(_event):
	if Input.is_action_just_pressed("inventory_main"):
		var cursor_pos: Vector2 = get_global_mouse_position()
		if skin_palette.get_global_rect().has_point(cursor_pos):
			var color: Color = skin_palette.get_node("Color" + str(int((cursor_pos.x - skin_palette.rect_global_position.x) / 20))).modulate
			body_sprite.modulate = color
		if hair_palette.get_global_rect().has_point(cursor_pos):
			var color: Color = hair_palette.get_node("Color" + str(int((cursor_pos.x - hair_palette.rect_global_position.x) / 20))).modulate
			hair_sprite.modulate = color
		if brow_palette.get_global_rect().has_point(cursor_pos):
			var color: Color = brow_palette.get_node("Color" + str(int((cursor_pos.x - brow_palette.rect_global_position.x) / 20))).modulate
			brow_sprite.modulate = color
		if pupil_palette.get_global_rect().has_point(cursor_pos):
			var color: Color = pupil_palette.get_node("Color" + str(int((cursor_pos.x - pupil_palette.rect_global_position.x) / 20))).modulate
			pupil_sprite.modulate = color

func back():
	Global.switch_scene("WorldSettings", false)

func _on_BackButton_pressed():
	back()

func _on_NextButton_pressed():
	Global.switch_scene("Supplies", false)

func _on_HairMinus_pressed():
	hair -= 1
	if hair < 0:
		hair = max_hair
	update_sprites()

func _on_HairPlus_pressed():
	hair += 1
	if hair > max_hair:
		hair = 0
	update_sprites()

func _on_OutfitMinus_pressed():
	outfit -= 1
	if outfit < 0:
		outfit = max_outfit
	update_sprites()

func _on_OutfitPlus_pressed():
	outfit += 1
	if outfit > max_outfit:
		outfit = 0
	update_sprites()
	
func update_sprites():
	hair_sprite.texture = load("res://Player/Parts/hair" + str(hair) + ".png")
	outfit_sprite.texture = load("res://Player/Parts/outfit" + str(outfit) + ".png")

func _on_WalkButton_toggled(button_pressed):
	if button_pressed:
		animation_player.play("Walk")
	else:
		animation_player.stop()
