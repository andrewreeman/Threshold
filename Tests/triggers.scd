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
~synthA.set(\t_trig, 1, \newFreq, rrand(500, 1000));

s.quit;