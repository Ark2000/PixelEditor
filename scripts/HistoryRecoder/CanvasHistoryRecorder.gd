class_name CanvasHistoryRecorder

var history_pointer
var max_history_cache = 100
var mementos := []

func clear():
	history_pointer = -1
	mementos = []

func record(memento):
	#单分支记录，剪去多余的分支
	if mementos.size() != (history_pointer + 1):
		for i in range(mementos.size() - 1, history_pointer, -1):
			mementos.remove(i)
	if mementos.size() >= max_history_cache:
		mementos.remove(0)
		history_pointer -= 1
	mementos.append(memento)
	history_pointer += 1
	
func get_next():
	if not has_next(): return null
	history_pointer += 1
	return mementos[history_pointer]
	
func get_previous():
	if not has_previous(): return null
	history_pointer -= 1
	return mementos[history_pointer]

func has_next():
	return history_pointer+1 != mementos.size()
	
func has_previous():
	return history_pointer > 0

