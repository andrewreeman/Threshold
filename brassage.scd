(
s.boot;
~thisPath = thisProcess.nowExecutingPath.dirname;
~soundFilePath = ~thisPath.dirname +/+ "sounds";
)

(
~buff1_Left = Buffer.readChannel(s, ~soundFilePath +/+ "clean/squishy-clean.wav", channels: 1);
~controlBusMouseY = Bus.control(s); // try 2 channels for mouse
~controlBusMouseX = Bus.control(s); // try 2 channels for mouse
~ctlBus_ResetGrainPhases = Bus.control(s);

~resetPhase = Task({
	~ctlBus_ResetGrainPhases.value = 1;
	0.1.wait;
	~ctlBus_ResetGrainPhases.value = 0;
});


//reset phase needs to be a control signal....outputs a trigger....erm...derpy derp derp DERP!!!
SynthDef("grainPlayer", {
	arg out = 0, amp = 1, sndBuf = 0, dur = 0.5, jitter = 0, resetPhase = 0 ;
	var changedResetPhase, source, numChannels, trigger, rateAmt, rate, pos, pan, noise, recipDur;
	numChannels = 2;
	recipDur = 1/dur;
	noise = LFNoise1.kr(recipDur, dur, -0.5*dur);
	changedResetPhase = Changed.kr(resetPhase);
	trigger = TDuty.kr(dur + (noise*jitter), changedResetPhase);
	rateAmt = 0.5;
	rate = LFNoise1.kr(recipDur, rateAmt, 1-(rateAmt/2));
	pos = LFNoise1.kr(recipDur);
	pan = LFNoise1.kr(recipDur, 2, -1);
	source = GrainBuf.ar(numChannels, trigger, dur,sndBuf, rate, pos, pan: pan);
	Out.ar(out , source * amp);
}).send(s);

SynthDef("mouseControlY", {
	arg controlBus;
	Out.kr(controlBus, MouseY.kr(0.001, 1));
}).send(s);

SynthDef("mouseControlX", {
	arg controlBus;
	Out.kr(controlBus, MouseX.kr(0.001, 1));
}).send(s);

)

~mouseControlY = Synth(\mouseControlY, [\controlBus, ~controlBusMouseY.index]);
~mouseControlX = Synth(\mouseControlX, [\controlBus, ~controlBusMouseX.index]);

~grainArray = Array.fill(100, {Synth(\grainPlayer, [\sndBuf, ~buff1_Left])});
~grainArray.do({arg synth, i; synth.map(\jitter, ~controlBusMouseX);})
~grainArray.do({arg synth, i; synth.map(\dur, ~controlBusMouseY);})
~grainArray.do({arg synth, i; synth.map(\amp, ~controlBusMouseY);})
~grainArray.do({arg synth, i; synth.map(\resetPhase, ~ctlBus_ResetGrainPhases);})
(
~resetPhase.play;
~resetPhase.reset;
)
~grainArray.do({arg synth, i; synth.free;});

//Task that triggers an envelope. Envelope controls controlBusMouseY (for now). When it reaches it peak it sends a trigger (???).
// Then starts to drop. The trigger is used by...something....to trigger to ResetGrainphases.




~controlBusMouseY.free;
~controlBusMouseX.free;



// Recording
s.prepareForRecord(~thisPath +/+ "test.wav");
s.record;
s.stopRecording;
s.freeAll;
s.quit;

