extends Control

func update_loading_bar(progress):
	
	$Tween.interpolate_property($LoadingBar, "value", $LoadingBar.value, progress, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
	yield($Tween, "tween_completed")
	
	if progress >= $LoadingBar.max_value:
		$AnimationPlayer.play("Hide")

func update_message(message):
	$UpdateText.text = message
