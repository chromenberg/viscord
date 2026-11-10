module events

pub struct Event {
	data   voidptr
	name   Events
	opcode EventOps
}