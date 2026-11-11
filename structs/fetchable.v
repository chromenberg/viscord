module structs
import rest
pub struct Fetchable {
	id Snowflake
	route string
}

pub fn (f &Fetchable) fetch() {
	
}