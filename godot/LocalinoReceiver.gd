extends Node

export var pos_axis = 0
export var pos_center = 4.0
export var pos_spread = 4.0
export var pos_invert = false

var udp_stream = PacketPeerUDP.new()

func _ready():
	udp_stream.listen(10001, "127.0.0.1")
	print("Started UDP receiver")

func _process(delta):
	#print(udp_stream.get_available_packet_count())
	if udp_stream.get_available_packet_count() > 0:
		var bytes = udp_stream.get_packet()
		var msg = bytes.get_string_from_utf8()
		var cols = msg.split(",")
		if len(cols) < 5:
			return
		var tag_id = cols[1]
		var pos = Vector3(cols[2], cols[3], cols[4])
		print("Received message, tag: " + tag_id + ", pos: " + str(pos))
		var node = get_node("/root/World/PlayerScene")
		# needs to be adapted according to playfield position and size
		var pos_component = pos.x if pos_axis == 0 else pos.y
		var joy_pos = ((pos_component - pos_center) / (pos_spread / 2.0)) - 1.0
		if pos_invert:
			joy_pos = -joy_pos
		print("joy", joy_pos)
		node.localinoPosition = clamp(joy_pos, -1.0, 1.0)