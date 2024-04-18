extends Marker2D

var arr_of_bodyes: Array

func _on_area_2d_body_entered(body):
	arr_of_bodyes.append(body)

func _on_area_2d_body_exited(body):
	arr_of_bodyes.remove_at(arr_of_bodyes.find(body))
