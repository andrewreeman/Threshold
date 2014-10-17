s.boot;

(
~envListener.free;
~envListener = OSCFunc({
	~loopMe = Synth(\sinTrig_test);
}, \tr, s.addr);
~loopMe = Synth(\sinTrig_test);
)

(
~envListener.free;
s.freeAll;
)


~synthA = Synth(\retrigSin_test);
~synthA.set(\gate, 1, \newFreq, rrand(300, 1100), \durationToFreq, 5);
~synthA.set(\gate, -10); // fade out in (10-1) seconds! awesome
~synthA.release(1); // same as above but release is more understandable!
~synthA.free; // remember to still free the synth!
s.freeAll;

s.quit;