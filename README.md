### standalone "dalvikvm" (actually art)

This is a (somewhat WIP) frankenstain of the dalvik branch with art (and dependencies) shoehorned in. Most shoehorned stuff was taken from the `android-6.0.1_r46` tag.  
Some edits with varying levels of hackiness were needed to make this compile, but it does seem to work.  
While it would be nice to not use random old branches, it won't be trivial to figure out a plan for updating to and keeping up with the master branches of art and it's dependencies.  
For now, this should work as means to have a dalvikvm-compatible setup on 64bit architectures. see __alternatives__ for possible endgame solution

UPDATE: this tree now contains modifications and additional code for the purposes of https://gitlab.com/Mis012/android_translation_layer_PoC/
the bionic linker under `bionic_translation/linker/` is taken from https://github.com/Cloudef/android2gnulinux and partly modified for our purposes  
the pthread wrapper under `bionic_translation/pthread_wrapper/` is taken from the same place, and augmented with additional missing wrapper functions  
same with `bionic_translation/libc/`  
`bionic_translation/wrapper/` is a helper for these, also from android2gnulinux  
`bionic_translation/libstdc++_standalone` is taken from bionic sources and coerced to compile; it's just "a minimum implementation of libc++ functionality not provided by compiler",
and things break when it's not linked in and android libs try to call into it and instead end up in the glibc or llvm c++ implementations  

NOTE: most of the .git folders that should be present in the subdirs were removed in order to make this repository several gigabytes leaner that it would be with them included.  
also, it really fucks with git if you leave them in  
this shouldn't be *that* much of an inconvenience, and is far from the most notable issue with being a downstream of a random subset of AOSP repositories.

after compilation, the output is in `out/host/linux-x86/`, bionic\_translation output is in `out/bio_build` ; `out/host/linux-x86/{gen,obj}` can and should be discarded, as it only contains intermediates  
aarch64 build currently also places the build output in `out/host/linux-x86/`; additionally, it seems that compiling with javac newer than 1.8 might cause weird breakage in libcore (observed on aarch64 alpine linux)

### compile

`make` (see Makefile for documentation on options which you might want to override)

A command to test if the build was successful:

`LD_LIBRARY_PATH=$PWD/out/bio_build/:$PWD/out/host/linux-x86/lib64/ ANDROID_ROOT=$PWD/out/host/linux-x86/ ANDROID_DATA=/tmp/dalvik-data out/host/linux-x86/bin/dalvikvm[64] -Xbootclasspath:$PWD/out/host/linux-x86/framework/apache-xml-hostdex.jar:$PWD/out/host/linux-x86/framework/core-junit-hostdex.jar:$PWD/out/host/linux-x86/framework/hamcrest-hostdex.jar:$PWD/out/host/linux-x86/framework/core-libart-hostdex.jar --help`  
resp.
`LD_LIBRARY_PATH=$PWD/out/bio_build/:$PWD/out/host/linux-x86/lib64/ ANDROID_ROOT=$PWD/out/host/linux-x86/ ANDROID_DATA=/tmp/dalvik-data out/host/linux-x86/bin/dalvikvm[64] -Xbootclasspath:$PWD/out/host/linux-x86/framework/apache-xml-hostdex.jar:$PWD/out/host/linux-x86/framework/core-junit-hostdex.jar:$PWD/out/host/linux-x86/framework/hamcrest-hostdex.jar:$PWD/out/host/linux-x86/framework/core-libart-hostdex.jar -cp path-to-dex class-that-implements-a-main-method`  
for a proper test (TODO: check in an example dex?)

### install

`make install` (see Makefile for documentation on options which you might want to override)

after installation, it should be possible to execute dalvikvm as such: `[ANDROID_DATA=/tmp/dalvik-data] dalvikvm[64] --help`, resp. `[ANDROID_DATA=/tmp/dalvik-data] dalvikvm[64] -cp path-to-dex class-that-implements-a-main-method`

### alternatives

Eventually, it would be nice to not be dependent on things that are a massive PITA to fix up for use outside AOSP.  
There was some work done on running dex files on GraalVM with Truffle, but sadly this was never completed
or even released publicly. The information that it even exists comes from a publicly avaliable dissertation
paper: https://studentnet.cs.manchester.ac.uk/resources/library/thesis_abstracts/MSc16/FullText/Salim-Salim-diss.pdf,
which says to "contact these professors \[names, not contact information\] for source code access"
