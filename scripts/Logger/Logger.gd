extends Node

signal add_new_line
signal add_new_line_pure

const colors = [
	"#80ff80",
	"#ffffff",
	"#ff9900",
	"#ff3300",
]

var entries = []

func _ready():
	call_deferred("Log", "Logger Loaded", LogEntry.TRIVIAL)
	
func Log(head_:String, tag_:=LogEntry.GENERIC, body_:=""):
	var entry = LogEntry.new(head_, tag_, body_)
	entries.push_back(entry)
	emit_signal("add_new_line", _entry_to_string(entry), entry.tag)
	emit_signal("add_new_line_pure", entry.head + " " + entry.body, entry.tag)
	
func _entry_to_string(e:LogEntry):
	var s = e.head
	if e.body != "":
		s += ", " + e.body
	s = "[color=%s]"%colors[e.tag] + s + "[/color]"
	var t = "[%02d:%02d:%02d] " % [e.timestamp.hour, e.timestamp.minute, e.timestamp.second]
	return t + s
