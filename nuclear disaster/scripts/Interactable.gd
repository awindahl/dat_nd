extends Spatial

func _on_ClickSpace_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.get_action_strength("lmb") == 1:
			print("A")
			#$MeshInstance/InteractSpace/CollisionShape.disabled = false
			var list = $InteractSpace.get_overlapping_bodies()
			print(list)
			for item in list:
				if item.get("TYPE") == "PLAYER":
					print("interact true!")
					get_parent().get_node("World/Cubio").look_at($ClickSpace.transform.origin, Vector3.UP)
					get_parent().get_node("World/Cubio").rotation.x = 0
					get_parent().get_node("World/Cubio").velocity *= 0
					get_parent().get_node("World/Cubio").target = null
					get_parent().get_node("World/Cubio").get_node("WinText").visible = true
					$InteractTimer.start()
					get_parent().get_node("World/Cubio").busy = true

func _on_InteractTimer_timeout():
	get_parent().get_node("World/Cubio").busy = false
	get_parent().get_node("World/Cubio").get_node("WinText").visible = false
