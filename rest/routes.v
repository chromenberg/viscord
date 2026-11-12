module rest

import structs { Snowflake }

pub const channels = '/channels'

pub fn message_channel_url(id string) string {
	return '${channels}/${id}/messages'
}