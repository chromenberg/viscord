module gateway

import rand { f64_in_range }
import x.async
import time { sleep }
import context
import messages as msg

@[heap]
pub struct Heartbeater {
	interval int
	jitter   f64
	ctx      context.Context
	cancel   context.CancelFn

	parent Gateway
	mut:
	 period   &async.PeriodicHandle = unsafe { nil}
}

pub fn Heartbeater.new(parent Gateway, interval int) Heartbeater {
	ctx, cancel := async.with_cancel()
	return Heartbeater{
		interval: interval
		jitter:   f64_in_range(0, 1) or {
			panic('Jitter minimum is less than jitter maximum, terminating.')
		}

		ctx:    ctx
		cancel: cancel

		parent: parent
	}
}

pub fn (mut h Heartbeater) send_heartbeat() {
	payload := Payload{
		opcode: events.EventOps.heartbeat
		data:   h.parent.seq
	}
	h.parent.send[Payload](payload) or {
		eprintln('Failed to send heartbeat')
	}
}

fn (h &Heartbeater) loop(mut ctx context.Context) ! {
	// send heartbeat every interval
	h.send_heartbeat()

}

pub fn (mut h Heartbeater) start() {
	// new thread that sends heartbeat every interval
	// because if we wait then we block EVERYTHING
	// and we cant just use the event system because we dont have nbio
	trd := spawn fn [mut h] () {
		println('First heartbeat, waiting for ${h.interval * h.jitter * 1000 * 1000}s')
		sleep(time.Duration{(h.interval * h.jitter)*1000*1000})
		h.send_heartbeat()
	}()

	h.period = async.start_every(h.ctx, time.Duration{h.interval*1000*1000}, h.loop) or {
		panic("Failed to start heartbeat loop")
	}
}

pub fn (mut h Heartbeater) stop() {
	println('Stopping heartbeat loop')
	h.period.stop()
	h.cancel()
}
