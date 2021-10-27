### standalone dalvikvm

This is pretty close to the minimum of android 4.4 source tree needed to build 
dalvik (and it's dependencies) for a Linux host.  
After compilation, the output is in `out/host/linux-x86/` (`out/host/linux-x86/obj` can be discarded)

### compile

```
make clean

make -j8 libdvm dalvikvm dexopt libjavacore core-hostdex bouncycastle-hostdex conscrypt-hostdex okhttp-hostdex apache-xml-hostdex apachehttp-hostdex hamcrest-hostdex apache-harmony-tests-hostdex core-junit-hostdex
```
