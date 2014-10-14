(
s.boot;
~thisPath = thisProcess.nowExecutingPath.dirname;
~soundFilePath = ~thisPath.dirname +/+ "sounds";
)

~buff1 = Buffer.read(s, ~soundFilePath +/+ "clean/squishy.wav");
~buff2 = Buffer.read(s, ~soundFilePath +/+ "test.wav");

(
~soundFilePlayer = SynthDef("soundFilePlayer", {
	arg out = 0, effectBus = 0, direct = 1, bufNum;
	var source;
	source = PlayBuf.ar(2, bufNum, BufRateScale.kr(bufNum));
	Out.ar(out, source * direct );
	Out.ar(effectBus, source * (1-direct));

});
)
~soundFilePlayer.play(s, [\bufNum, ~buff1.bufnum]);
~soundFilePlayer.play(s, [\bufNum, ~buff2.bufnum]);

(
~reverb = SynthDef("cheapReverb", {arg out =0, inBus;
	var input;
	input = In.ar(inBus, 2);
	16.do({ input = AllpassC.ar(input, 0.04, { Rand(0.001,0.04) }.dup, 3)});
	Out.ar(out, input);
});
)

~bus = Bus.audio(s, 2);
~test = Synth.new("cheapReverb", [\inBus, ~bus.index]);


(
~soundFilePlayer.play(s, [\bufNum, ~buff1.bufnum, \effectBus, ~bus.index, \direct, 0.1]);
)
s.prepareForRecord(~relPath +/+ "test.wav");
s.record;
s.stopRecording;
s.quit;
s.freeAll;