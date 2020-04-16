# Cython Protoc Prototype

Prototype of using cython to bind to proto's C++ output instead of using the native Python one.

# Usage

```bash
brew install protobuf
make benchmark
```

# Latest Results

```
***** Benchmark Results *****

1 Items per proto:

	*** Compute ***
	Baseline ParseFromString:	2870.65ns
	Cython   ParseFromString:	615.02ns (4.67 X Speedup)
	Baseline SerializeToString:	3837.12ns
	Cython   SerializeToString:	500.12ns (7.67 X Speedup)
	Baseline Iterate:	1014.38ns
	Cython   Iterate:	548.48ns (1.85 X Speedup)
	Baseline Field Access:	220.77ns
	Cython   Field Access:	189.79ns (1.16 X Speedup)

	*** Memory ***
	Baseline Memory for 5k protos:	1.08MB
	Cython   Memory for 5k protos:	2.41MB  (123.55% Increase)

10 Items per proto:
	*** Compute ***
	Baseline ParseFromString:	26299.42ns
	Cython   ParseFromString:	3158.57ns (8.33 X Speedup)
	Baseline SerializeToString:	34008.04ns
	Cython   SerializeToString:	2692.73ns (12.63 X Speedup)
	Baseline Iterate:	3914.49ns
	Cython   Iterate:	1861.20ns (2.10 X Speedup)
	Baseline Field Access:	230.28ns
	Cython   Field Access:	183.11ns (1.26 X Speedup)

	*** Memory ***
	Baseline Memory for 5k protos:	17.65MB
	Cython   Memory for 5k protos:	15.82MB  (10.40% Decrease)

100 Items per proto:
	*** Compute ***
	Baseline ParseFromString:	278487.29ns
	Cython   ParseFromString:	35349.57ns (7.88 X Speedup)
	Baseline SerializeToString:	317073.74ns
	Cython   SerializeToString:	18100.18ns (17.52 X Speedup)
	Baseline Iterate:	30122.12ns
	Cython   Iterate:	17323.38ns (1.74 X Speedup)
	Baseline Field Access:	232.05ns
	Cython   Field Access:	190.38ns (1.22 X Speedup)

	*** Memory ***
	Baseline Memory for 5k protos:	225.34MB
	Cython   Memory for 5k protos:	174.75MB  (22.45% Decrease)

1000 Items per proto:
	*** Compute ***
	Baseline ParseFromString:	2534954.29ns
	Cython   ParseFromString:	384580.89ns (6.59 X Speedup)
	Baseline SerializeToString:	3001547.79ns
	Cython   SerializeToString:	198863.96ns (15.09 X Speedup)
	Baseline Iterate:	288295.03ns
	Cython   Iterate:	148888.22ns (1.94 X Speedup)
	Baseline Field Access:	233.74ns
	Cython   Field Access:	191.92ns (1.22 X Speedup)

	*** Memory ***
	Baseline Memory for 5k protos:	2388.67MB
	Cython   Memory for 5k protos:	1803.18MB  (24.51% Decrease)
```