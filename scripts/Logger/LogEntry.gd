class_name LogEntry

enum {
	TRIVIAL,
	GENERIC,
	VITAL,
	FATAL
}

var tag
var head
var body
var timestamp

func _init(head_, tag_, body_):
	head = head_
	tag = tag_
	body = body_
	timestamp = OS.get_time()
