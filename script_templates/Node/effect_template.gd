# meta-name: Effect
# meta-description: Create na effect which can be applied to a target.
class_name MyEffect
extends Effect

var member_var := 0


func execute(targets: Array[Node]) -> void:
	print("My effect targets them: %s" % targets)
	print("It does %s something" % member_var)
