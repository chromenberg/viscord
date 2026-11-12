module structs

pub struct APIChannel {
	
}

pub enum ChannelType {
	text
}

pub struct Channel {
pub:
	id Snowflake
	guild Guild
pub mut:
	name string
	type ChannelType
}

pub fn (c &Channel) fetch() {

}

// pub fn (c &Channel) send(msg MessageOptions) {

// }