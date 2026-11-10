module messages

@[omitempty]
pub struct BasePayload[T] {
	opcode int @[json: op]
	data T		 @[json: d]
}

@[params]
pub struct PayloadOptions {
	has_name bool = false
	has_seq  bool = false
}

pub fn BasePayload.new[T](options PayloadOptions) BasePayload[T] {
	return BasePayload[T]{
		opcode: opcode
		data:   data
	}
}