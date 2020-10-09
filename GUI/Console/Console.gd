extends Control

onready var output = get_node("Output")
onready var input = get_node("Input")
onready var command_processor = get_node("Commands")

var command_history_line = CommandHistory.history.size()

func _ready():
	input.grab_focus()
	output.add_color_region("-", "-", Color(1, 0, 0), true)
	output.add_color_region("~", "~", Color(0, 1, 0), true)

func _input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo:
				if event.scancode == KEY_ESCAPE or event.scancode == KEY_TAB:
					get_tree().paused = false
					queue_free()
				elif event.scancode == KEY_UP:
					goto_command_history(-1)
				elif event.scancode == KEY_DOWN:
					goto_command_history(1)

func goto_command_history(step):
	command_history_line += step
	command_history_line = clamp(command_history_line, 0, CommandHistory.history.size())
	if command_history_line < CommandHistory.history.size() and CommandHistory.history.size() > 0:
		input.text = CommandHistory.history[command_history_line]
		input.call_deferred("set_cursor_position", 999999)

func output_text(new_text):
	if output.rect_size.y < 120:
		output.rect_size.y += 12
		output.rect_global_position.y -= 6
	if output.text.length() != 0:
		output.text += "\n"
	else:
		output.rect_size.y += 3
		output.rect_global_position.y -= 2
	output.text = output.text + new_text
	output.scroll_vertical = INF
	output.scroll_horizontal = 0

func _on_Input_text_entered(new_text):
	input.clear()
	output_text(new_text)
	process_command(new_text)

func process_command(text):
	var words = text.split(" ")
	words = Array(words)
	
	for _i in range(words.count("")):
		words.erase("")
	
	if words.size() > 0:
		
		CommandHistory.history.append(text)
		command_history_line = CommandHistory.history.size()
		
		var command = words.pop_front()
		command = command.to_lower()
		var parameters = words.size()
		for test_command in command_processor.command_words:
			if test_command[0] == command:
				if test_command[1].find(parameters) < 0:
					var parameter_string = str(test_command[1][0])
					if test_command[1].size() > 1:
						for i in range(1, test_command[1].size()):
							parameter_string += " or " + str(test_command[1][i])
					output_text("-invalid number of parameters (" + parameter_string + " required)-")
					return
				else:
					if parameters == 0:
						output_text(command_processor.call(command))
						return
					else:
						output_text(command_processor.callv(command, words))
						return
		output_text('-Command "' + str(command) + '" does not exist-')
