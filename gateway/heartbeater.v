module gateway

import rand { f64_in_range }
import x.async
import time { sleep }
import context
import messages as msg

enum HeartbeatState {
	running
	paused
	restart
	stop
}

@[heap]
pub struct Heartbeater {
	interval int
	jitter   f64
	ctx      context.Context
	cancel   context.CancelFn // Ignore compiler notice, this fn is always initialized
	mut:
		state chan HeartbeatState
		beat_thread thread
}

pub fn Heartbeater.new(interval int) Heartbeater {
	mut bg := context.background()
	mut ctx, cancel := context.with_cancel(mut bg)
	return Heartbeater{
		interval: interval
		jitter:   f64_in_range(0, 1) or {
			panic('Jitter minimum is less than jitter maximum, terminating.')
		}
		ctx:      ctx
		cancel:   cancel
	}
}


// pauses the heartbeat thread for `interval` seconds
// 
// @param `should_jitter` - if true then the thread sleeps for `interval` * `jitter` seconds
fn (h &Heartbeater) sleep(should_jitter bool) {
	if should_jitter {
		sleep(time.Duration{((h.interval / time.microsecond) * h.jitter)*time.second})
	} else {
		sleep(time.Duration{h.interval * time.second})
	}
}

pub fn (mut h Heartbeater) start(gate &Gateway) {
	// new thread that sends heartbeat every interval
	// because if we wait then we block EVERYTHING
	// and we cant just use the event system because we dont have nbio

	// "CLOSE", "RESTART" and "PAUSE" are signalled when this has a value
	// otherwise we just dont do anything

	h.beat_thread = spawn fn [mut h, gate] (mut ctx context.Context) {
		println('First heartbeat, waiting for ${(h.interval / time.microsecond) * h.jitter}s')

		h.sleep(true)
		h.send_heartbeat(gate)

		ch := ctx.done()

		println("[Heartbeat] Passed first heartbeat, beating every ${h.interval / time.microsecond} seconds")

		for { // continuously check
			select {
				_ := <-ch {
					println("[Heartbeat] Closing heartbeat thread in 5ms")
					sleep(5*time.millisecond)
					return
				}
				
				h.interval*time.millisecond*100 {
					h.send_heartbeat(gate)
				}
			}
		}
	}(mut h.ctx)
}

pub fn (mut h Heartbeater) stop() {
	println('Stopping heartbeat loop')
	h.cancel()
	h.beat_thread.wait() // wait for the thread to close, which is why theres a delay of 5ms so the program cant end before that
}

pub fn (mut h Heartbeater) send_heartbeat(gate &Gateway) {
	payload := Payload{
		opcode: events.EventOps.heartbeat
		data:   gate.seq
	}
	gate.send[Payload](payload) or {
		eprintln('Failed to send heartbeat')
	}
}