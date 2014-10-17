(
s.boot;
~thisPath = thisProcess.nowExecutingPath.dirname;
//~soundFilePath = ~thisPath.dirname +/+ "sounds";
~soundFilePath = ~thisPath.dirname.dirname +/+ "sounds"; // up 2 levels due to Test folder
)

(
~buff1_Left = Buffer.readChannel(s, ~soundFilePath +/+ "clean/squishy-clean.wav", channels: 1);


// Pass envelope dynamically

//Reset phase needs to be a simple trigger!
SynthDef("grainPlayer", {
	arg gate = 1, out = 0, amp = 1, sndBuf = 0, dur = 0.5, jitter = 0, resetPhase = 0, newLvl = 1 ;
	var changedResetPhase, source, numChannels, trigger, rateAmt, rate, pos, pan, noise, recipDur, ampDurEnv;

	numChannels = 2;

	rateAmt = 0.5;

	ampDurEnv = EnvGen.kr(Env([0, 1], [1]), gate, newLvl);
	dur = pow(ampDurEnv, 3) + 0.01;
	recipDur = 1/dur;
	noise = LFNoise1.kr(recipDur, dur, -0.5*dur);

	changedResetPhase = Changed.kr(resetPhase);
	trigger = TDuty.kr(dur + (noise*jitter), changedResetPhase);
	rate = LFNoise1.kr(recipDur, rateAmt, 1-(rateAmt/2));
	pos = LFNoise1.kr(recipDur);
	pan = LFNoise1.kr(recipDur, 2, -1);


	source = GrainBuf.ar(numChannels, trigger, dur,sndBuf, rate, pos, pan: pan);
	Out.ar(out , source * amp * ampDurEnv);
}, [\tr]).send(s);

)

a = Synth(\grainPlayer);
a.set(\gate, 1);
a.free;



~grainArray = Array.fill(100, {Synth(\grainPlayer, [\sndBuf, ~buff1_Left])});
(
~grainArray.do({
	arg synth;
	synth.set(\gate, 1);
	synth.set(\newLvl, 0.5);
});
)
~grainArray.do({arg synth, i; synth.free;});

//Task that triggers an envelope. Envelope controls controlBusMouseY (for now). When it reaches it peak it sends a trigger (???).
// Then starts to drop. The trigger is used by...something....to trigger to ResetGrainphases.


s.freeAll;
s.quit;

