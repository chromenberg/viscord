module messages

pub struct Hello {
	pub heartbeat_interval int
}

pub fn (h Hello) str() string {
	return 'Hello{\n	heartbeat_interval: ${h.heartbeat_interval} \n    }'
}