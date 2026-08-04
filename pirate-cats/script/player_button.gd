extends Button

func _shortcut_input(event):
	if !visible:
		accept_event() # Ignore shortcut while hidden
