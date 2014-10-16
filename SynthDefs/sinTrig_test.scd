(
SynthDef(\sinTrig_test, {
	// This synth will send a trigger at the trigger time. FreeSelf is used to free the synth just after
	// the envelopes duration so SendTrig can send if trigger time == envelopesDuration
	var env, trigTime, envGen, freq, dcOne;
	env = Env([0, 0.3, 0.5, 0.6, 1, 0],[0.5, 0.5, 1, 0.5, 0.1], \sin);
	trigTime = env.duration;
	envGen = EnvGen.kr(env, doneAction: 0);
	freq = Rand(100, 800);
	dcOne = DC.kr(1);

	Out.ar(0, SinOsc.ar(freq) * envGen * 0.5);
	SendTrig.kr(TDelay.kr(dcOne, trigTime));
	FreeSelf.kr(TDelay.kr(dcOne, env.duration + 0.001));
}).writeDefFile();
)

(
SynthDef(\retrigSin_test, {
	arg newFreq, durationTofreq, t_trig;
	var env,freqEnv, ampEnv, outSig;

	env = Env();
	freqEnv = EnvGen.kr(env, t_trig, newFreq);
	ampEnv = EnvGen.ar(env, t_trig);
	outSig = SinOsc.ar(freqEnv) * ampEnv;

	Out.ar(0, outSig);

}).writeDefFile();
)
