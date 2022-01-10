### standalone dalvikvm

This is pretty close to the minimum of android 4.4 source tree needed to build 
dalvik (and it's dependencies) for a Linux host.  
Some fixes were made to make it compile on the latest gcc (instead of using it's own prebuilt gcc), and other modifications were made to make it compile for an arm host.  

UPDATE: this tree now contains modifications and additional code for the purposes of [https://gitlab.com/Mis012/android_translation_layer_PoC/](https://gitlab.com/Mis012/android_translation_layer_PoC/)  
the bionic linker under `bionic_translation/linker/` is taken from [https://github.com/Cloudef/android2gnulinux](https://github.com/Cloudef/android2gnulinux) and partly modified for our purposes

After compilation, the output is in `out/host/linux-x86/`; `out/host/linux-x86/obj` can and should be discarded, as it only contains intermediates

If you compile for arm instead, output will be in `out/host/linux-arm/`.


### compile

note: replace `/usr/lib64/jvm/java-1.8.0/` with wherever you have 1.8 JDK; also make sure that `javac` is the 1.8 one  
(you can also patch out the check if you wish to try your luck with / fix compilation on a newer version of Java)

```
function javac(){
        command javac -source 1.5 "$@"
}

export -f javac

make clean

cd bionic_translation
make
cd ..

LIBRARY_PATH=$PWD/bionic_translation/ LD_LIBRARY_PATH=$PWD/bionic_translation/ ANDROID_JAVA_HOME=/usr/lib64/jvm/java-1.8.0/ make -j8 libdvm dalvikvm dexopt libjavacore core-hostdex bouncycastle-hostdex conscrypt-hostdex okhttp-hostdex apache-xml-hostdex apachehttp-hostdex hamcrest-hostdex apache-harmony-tests-hostdex core-junit-hostdex

cp bionic_translation/libdl_bio.so out/host/linux-x86/
```
