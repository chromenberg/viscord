module store

import structs as types
import cache
import time

@[heap]
pub struct ClientCache {
pub mut:
	messages cache.Ttl[types.Snowflake, types.Message]
	users    cache.Ttl[types.Snowflake, types.User]
	members  cache.Ttl[types.Snowflake, types.Member]
	guilds   cache.Ttl[types.Snowflake, types.Guild]
	channels cache.Ttl[types.Snowflake, types.Channel]
	roles    cache.Ttl[types.Snowflake, types.Role]
}

pub fn ClientCache.new(expires_in ?time.Duration) &ClientCache {
	ttl := expires_in or { 4 * time.hour }
	return &ClientCache{
		messages: cache.new_ttl(ttl)
		users:    cache.new_ttl(ttl)
		members:  cache.new_ttl(ttl)
		guilds:   cache.new_ttl(ttl)
		channels: cache.new_ttl(ttl)
		roles:    cache.new_ttl(ttl)
	}
}