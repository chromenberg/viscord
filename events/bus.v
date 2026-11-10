module events
import eventbus

// Core event loop for the gateway and stuff
pub const eb = eventbus.new[Events]()

type EventFn = fn(rec voidptr, data voidptr, loc voidptr)

pub fn on_event(event Events, cb EventFn) {
	mut sub := eb.subscriber
	sub.subscribe(event, cb)
}
