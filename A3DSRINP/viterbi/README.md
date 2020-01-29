# viterbi

This package builds two executables, `voxelizer` and `viterbi`

`voxelizer` will turn any set of PDB files into a 3D voxelized representation, rendered as a stack of PNGs.

`viterbi` is a test executable that solves a contrived 2D HMM system, reports the amount of processor cycles used, and dumps the execution cache for inspection. This is a proof of concept to demonstrate the algorithm runs efficiently.

To build, you must have libpng16 installed on your system (later version than what is in the Ubuntu repos by default), as well as zlib and libjson-c

Then run,

```
$ ./configure
$ make
$ make install
```

## voxelizer usage

To voxelize a PDB file, you must decide on what the dimensions of your voxel space should be (default 128), what the base radius (in voxels) of each atom should be (default 1), what densities (values between 0-255) each PDB file should represent (default 100), and what the base filename should be for the output.

Example:
Construct a 64x64x64 cube from a single PDB file with voxel value 100 and radius 2.
```
$ voxelizer -d64 -r2 -o out mypdb.pdb:100
```

The density of each PDB should be appended after a colon to each corresponding filename. The `-o` flag tells voxelizer that it should output images, and in this case it will output 64 PNG files "out1.png" "out2.png" "out3.png" ... "out64.png" to the current directory.

You can also use voxelizer to calculate an A matrix for each face of the cube, using (state, duration) tuples as states, by using the `--a-matrix` flag. The output will be in JSON and be sent to stdout. Example:

```
$ voxelizer -d64 mypdb.pdb --a-matrix
```

## viterbi usage

This is a simple test binary used while developing the higher-dimensional Viterbi algorithm. Currently it will generate a test grayscale PNG to take statistics on and solve a 2D version of the Viterbi algorithm, reporting the amount of processor cycles used and dumping the execution cache. You can generate larger PNGs to see how the process scales with time.

To generate a 512x512 PNG, use

```
$ viterbi generate 512
```

This will generate a file called "out.png" in the current directory. Then you can run

```
$ viterbi solve 
```

This will solve the problem, dump the cache, and report the processor cycles used.

## Notes

If you plan to inspect the codebase, the important code can be found in `core.cc` under `MultiPDBVoxelizer::Voxelize` and in `hmm.c` under `viterbi2d`. `pdbplugin.c` and associated files are taken directly from the VMD codebase and built statically into the executables.
