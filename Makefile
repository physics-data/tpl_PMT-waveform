.PHONY: all
all: waveform.h5 ideal-waveform.png noise.png waveform.png

# 下面各个绘图程序中使用的 Channel 和 Event 编号
CHANNEL := 23
EVENT_ID := 3

# SPE 是 single photoelectron 即单光电子。
# 为每一个 channel 生成理想波形
ideal-waveform.h5: data/PE-info.h5 data/SPE.h5
	python3 superimpose.py $^ $@

# 绘制单光子波形和某一个 channel 的理想波形
ideal-waveform.png: ideal-waveform.h5 data/SPE.h5 
	python3 plot-ideal.py $(CHANNEL) $(EVENT_ID) $^ $@

# 为每一个 channel 生成指定分布的噪音
noise.h5: data/noise-level.csv data/PE-info.h5
	python3 noise-sample.py $^ $@

# 绘制某一个 channel 的噪音
noise.png: noise.h5
	python3 plot-noise.py $(CHANNEL) $(EVENT_ID) $^ $@

# waveform.h5 是最终的光电倍增管波型输出
waveform.h5: ideal-waveform.h5 noise.h5
	python3 add-noise.py $^ $@
 
# 绘制某个 channel 的波形（添加噪声前后）
waveform.png: ideal-waveform.h5 waveform.h5
	python3 plot-real.py $(CHANNEL) $(EVENT_ID) $^ $@
