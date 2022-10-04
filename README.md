### standalone "dalvikvm" (actually art)

This is a (somewhat WIP) frankenstain of the dalvik branch with art (and dependencies) shoehorned in. Most shoehorned stuff was taken from the `android-6.0.1_r46` tag.  
Some edits with varying levels of hackiness were needed to make this compile, but it does seem to work.  
While it would be nice to not use random old branches, it won't be trivial to figure out a plan for updating to and keeping up with the master branches of art and it's dependencies.  
For now, this should work as means to have a dalvikvm-compatible setup on 64bit architectures.

UPDATE: this tree now contains modifications and additional code for the purposes of https://gitlab.com/Mis012/android_translation_layer_PoC/
the bionic linker under bionic_translation/linker/ is taken from https://github.com/Cloudef/android2gnulinux and partly modified for our purposes
the pthread wrapper under bionic_translation/pthread_wrapper/ is taken from the same place, and augmented with additional missing wrapper functions; LD_PRELOAD this to fix annoying segfaults

NOTE: most of the .git folders that should be present in the subdirs were removed in order to make this repository several gigabytes leaner that it would be with them included.  
this shouldn't be *that* much of an inconvenience, and is far from the most notable issue with being a downstream of a random subset of AOSP repositories.

after compilation, the output is in `out/host/linux-x86/`; `out/host/linux-x86/{gen,obj}` can and should be discarded, as it only contains intermediates
aarch64 build currently also places the build output in `out/host/linux-x86/`; additionally, it seems that the aarch64 build currently produces broken hostdex libraries,
so as a workaround, you should use hostdex libraries from the x86_64 build


### compile

note: \[FIXME: is `ANDROID_JAVA_HOME=/usr/lib64/jvm/java-1.8.0/` still needed with art?\] replace `/usr/lib64/jvm/java-1.8.0/` with wherever you have 1.8 JDK; also make sure that `javac` is the 1.8 one  
(you can also patch out the check if you wish to try your luck with / fix compilation on a newer version of Java)

```
make clean

cd bionic_translation
make
cd ..

LIBRARY_PATH=$PWD/bionic_translation/ LD_LIBRARY_PATH=$PWD/bionic_translation/ ANDROID_JAVA_HOME=/usr/lib64/jvm/java-1.8.0/ ANDROID_COMPILE_WITH_JACK=false LOCAL_MULTILIB=none WITHOUT_CLANG=true WITHOUT_LIBCOMPILER_RT=true make liblog dalvikvm art dex2oat libjavacore libcore dex-host core-libart-hostdex apache-xml-hostdex hamcrest-hostdex core-junit-hostdex

cp bionic_translation/*.so out/host/linux-x86/
```

A command to test if the build was successful:

`BIONIC_LD_LIBRARY_PATH=/tmp LD_PRELOAD=/usr/lib64/libcrypto.so.1.0.0 LD_LIBRARY_PATH=$PWD/bionic_translation/:$PWD/out/host/linux-x86/lib64/ ANDROID_ROOT=$PWD/out/host/linux-x86/ ANDROID_DATA=/tmp/dalvik-data out/host/linux-x86/bin/dalvikvm -Xbootclasspath:$PWD/out/host/linux-x86/framework/apache-xml-hostdex.jar:$PWD/out/host/linux-x86/framework/dx.jar:$PWD/out/host/linux-x86/framework/core-junit-hostdex.jar:$PWD/out/host/linux-x86/framework/hamcrest-hostdex.jar:$PWD/out/host/linux-x86/framework/core-libart-hostdex.jar:$PWD/out/host/linux-x86/framework/jarjar.jar:$PWD/out/host/linux-x86/framework/dex-host.jar --help`

### alternatives

Eventually, it would be nice to not be dependent on things that are a massive PITA to fix up for use outside AOSP.  
There was some work done on running dex files on GraalVM with Truffle, but sadly this was never completed
or even released publicly. The information that it even exists comes from a publicly avaliable dissertation
paper: https://studentnet.cs.manchester.ac.uk/resources/library/thesis_abstracts/MSc16/FullText/Salim-Salim-diss.pdf,
which says to "contact these professors \[names, not contact information\] for source code access"
