### standalone "dalvikvm" (actually art)

This is a frankenstain of the dalvik branch with art (and dependencies) shoehorned in. Most shoehorned stuff was taken from the `android-6.0.1_r46` tag.  
The subprojects art and libcore are currently on the state of `android-8.1.0_r81`.
Some edits with varying levels of hackiness were needed to make this compile, but it does seem to work.  
While it would be nice to not use random old branches, it won't be trivial to figure out a plan for updating to and keeping up with the master branches of art and it's dependencies.  
For now, this should work as means to have a dalvikvm-compatible setup on 64bit architectures. see __alternatives__ for possible endgame solution

UPDATE: `bionic_translation` is now a separate repo; `meson install` it before building this (TODO: make `libdl_bio` an optional dependency)  

NOTE: most of the .git folders that should be present in the subdirs were removed in order to make this repository several gigabytes leaner that it would be with them included.  
also, it really fucks with git if you leave them in  
this shouldn't be *that* much of an inconvenience, and is far from the most notable issue with being a downstream of a random subset of AOSP repositories.

after compilation, the output is in `out/host/linux-x86/`; `out/host/linux-x86/{gen,obj}` can and should be discarded, as it only contains intermediates  
aarch64 build currently also places the build output in `out/host/linux-x86/`; additionally, it seems that compiling with javac newer than 1.8 might cause weird breakage in libcore (observed on aarch64 alpine linux)

### dependencies

debian based distros:
`sudo apt install default-jdk python-is-python3 meson libegl-dev pkg-config libbsd-dev libunwind-dev libelf-dev valgrind libicu-dev libssl-dev libexpat1-dev zip liblz4-dev liblzma-dev`
The libwolfssl needs to be installed from source with the --enable-jni configuration, because this option is disabled in debian package. A known working configuration for libwolfssl is:
`./configure --enable-shared --disable-opensslall --disable-opensslextra --enable-aescbc-length-checks --enable-curve25519 --enable-ed25519 --enable-ed25519-stream --disable-oldtls --enable-base64encode --enable-tlsx --enable-scrypt --disable-examples --enable-crl --with-rsa --enable-certs --enable-session-certs --enable-encrypted-keys --enable-cert-gen --enable-cert-ext --enable-clr-monitor --enable-jni`

### compile

`make ____LIBDIR=[XXX]` where `[XXX]` is (in most cases) either lib or lib64 (see Makefile for documentation on other options which you might want to override)

### install

`make ____LIBDIR=[XXX] install` (see above)

after installation, it should be possible to execute dalvikvm as such: `[ANDROID_DATA=/tmp/dalvik-data] dalvikvm[64] --help`, resp. `[ANDROID_DATA=/tmp/dalvik-data] dalvikvm[64] -cp path-to-dex class-that-implements-a-main-method`

### alternatives

Eventually, it would be nice to not be dependent on things that are a massive PITA to fix up for use outside AOSP.  
There was some work done on running dex files on GraalVM with Truffle, but sadly this was never completed
or even released publicly. The information that it even exists comes from a publicly avaliable dissertation
paper: https://studentnet.cs.manchester.ac.uk/resources/library/thesis_abstracts/MSc16/FullText/Salim-Salim-diss.pdf,
which says to "contact these professors \[names, not contact information\] for source code access"
