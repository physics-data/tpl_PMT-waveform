
# PE 是 photoelectron 即光电子。
# SPE 是 single PE 即单光电子。
ideal-waveform.h5: data/PE-info.h5 data/SPE.h5
	python3 superimpose.py $^ $@

noise.h5: data/noise-level.csv
	python3 noise-sample.py $^ $@

waveform.h5: ideal-waveform.h5 noise.h5
	python3 add-noise.py $^ $@

