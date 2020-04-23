# Cython Protoc Prototype

Prototype of using cython to bind to proto's C++ output instead of using the native Python one.

## Usage

```bash
brew install protobuf
make benchmark
```

## Latest Results

```
***** Benchmark Results *****

1 Items per proto:
	*** Compute ***
	json.loads:                	5523.34ns
	Baseline ParseFromString:  	3137.24ns
	Cython   ParseFromString:  	593.77ns (5.28 X Speedup)
	json.dumps:                	6205.02ns
	Baseline SerializeToString:	3859.92ns
	Cython   SerializeToString:	493.48ns (7.82 X Speedup)
	Baseline MessageToJson:    	70919.05ns
	Cython   MessageToJson:    	13534.82ns (5.24 X Speedup)
	Baseline Iterate:          	1173.72ns
	Cython   Iterate:          	580.10ns (2.02 X Speedup)
	Baseline Field Access:	227.92ns
	Cython   Field Access:	188.35ns (1.21 X Speedup)

	*** Memory ***
	Baseline Memory for 5k protos:	0.91MB
	Cython   Memory for 5k protos:	2.15MB  (135.47% Increase)

10 Items per proto:
	*** Compute ***
	json.loads:                	27005.73ns
	Baseline ParseFromString:  	24380.85ns
	Cython   ParseFromString:  	3011.20ns (8.10 X Speedup)
	json.dumps:                	35984.81ns
	Baseline SerializeToString:	31816.53ns
	Cython   SerializeToString:	2127.45ns (14.96 X Speedup)
	Baseline MessageToJson:    	464530.34ns
	Cython   MessageToJson:    	35742.75ns (13.00 X Speedup)
	Baseline Iterate:          	4190.12ns
	Cython   Iterate:          	1903.86ns (2.20 X Speedup)
	Baseline Field Access:	232.86ns
	Cython   Field Access:	202.65ns (1.15 X Speedup)

	*** Memory ***
	Baseline Memory for 5k protos:	19.47MB
	Cython   Memory for 5k protos:	15.72MB  (19.26% Decrease)

100 Items per proto:
	*** Compute ***
	json.loads:                	216325.74ns
	Baseline ParseFromString:  	252977.44ns
	Cython   ParseFromString:  	27400.56ns (9.23 X Speedup)
	json.dumps:                	319972.21ns
	Baseline SerializeToString:	322218.42ns
	Cython   SerializeToString:	17019.60ns (18.93 X Speedup)
	Baseline MessageToJson:    	4309062.26ns
	Cython   MessageToJson:    	273435.04ns (15.76 X Speedup)
	Baseline Iterate:          	29327.30ns
	Cython   Iterate:          	14746.19ns (1.99 X Speedup)
	Baseline Field Access:	239.71ns
	Cython   Field Access:	213.38ns (1.12 X Speedup)

	*** Memory ***
	Baseline Memory for 5k protos:	227.46MB
	Cython   Memory for 5k protos:	179.20MB  (21.22% Decrease)

1000 Items per proto:
	*** Compute ***
	json.loads:                	3050759.79ns
	Baseline ParseFromString:  	2272761.07ns
	Cython   ParseFromString:  	270068.01ns (8.42 X Speedup)
	json.dumps:                	3304042.09ns
	Baseline SerializeToString:	2847558.55ns
	Cython   SerializeToString:	171730.59ns (16.58 X Speedup)
	Baseline MessageToJson:    	42342659.00ns
	Cython   MessageToJson:    	2142533.59ns (19.76 X Speedup)
	Baseline Iterate:          	269217.47ns
	Cython   Iterate:          	132916.15ns (2.03 X Speedup)
	Baseline Field Access:	223.23ns
	Cython   Field Access:	185.20ns (1.21 X Speedup)

	*** Memory ***
	Baseline Memory for 5k protos:	2404.88MB
	Cython   Memory for 5k protos:	1804.46MB  (24.97% Decrease)
```
