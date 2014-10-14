s.boot;

(
{
    var changingSignal = LFNoise0.ar(1000);
    var changed = Changed.ar(changingSignal);
    [changingSignal, changed];
}.plot
)

(
SynthDef("resetImpulse", {
	arg resetPhase;
	var changed = Changed.kr(resetPhase);
	Out.ar(0, TDuty.ar(1, changed, 0.5));
}).send(s);
)


~synthTest = Synth(\resetImpulse);
~synthTest2 = Synth(\resetImpulse);

(
~synthTest.set(\resetPhase, 1);
~synthTest2.set(\resetPhase, 1);
)



s.quit;