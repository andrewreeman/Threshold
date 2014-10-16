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
	arg gate = 0, newFreq = 440, durationToFreq = 1;
	var env,freqEnv, ampEnv, outSig;

	env = Env(times: [0.5, 0.5], curve:\welch); // one second in total
	freqEnv = EnvGen.kr(env, gate, newFreq, timeScale: durationToFreq);
	ampEnv = EnvGen.ar(env, gate, timeScale: durationToFreq);
	outSig = SinOsc.ar(freqEnv) * ampEnv;

	Out.ar(0, outSig);

}, [\tr]).writeDefFile();
)
