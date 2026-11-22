# Runtime tests

AOSP's ART run-tests, run on this tree's `dalvikvm` the way the iPhone will run it: interpreter
only (no JIT), no boot image, no dex2oat (`[run]` in `corpus.toml`). Each test is a small
Java/smali program with an `expected.txt`; it
passes when the VM exits 0 and prints exactly that output (stdout and stderr merged), as in
upstream `run-test`.

This directory is the suite: what to run and what to expect. The engine that fetches, builds,
runs and grades it lives in the dine superproject (`tests/harness/`, see its README), because it
uses dine's build environment.

```sh
# from the dine superproject, after tools/dine linux build art
tools/dine test runtime                       # fetch + build (incremental) + run; exit 1 = regression
tools/dine test runtime -f '^00[0-9]-'        # subset by regex
tools/dine test runtime run                   # rerun existing builds (e.g. after rebuilding ART)
tools/dine test runtime --update-expectations # after a fix: rewrite expectations/, then commit it here
```

On 16 cores: cold (fetch + build all + run) ~5.5 min, warm ~65 to 100 s. Editing `[run]` or
`[timeouts]` doesn't rebuild anything; bumping `[upstream]` rebuilds everything.

## Corpus

- **Upstream:** `art/test` from `android-security-10.0.0_r75`, the tag this tree's ART is
  based on (`corpus.toml`). Fetched as a sparse clone into dine's `out/tests/runtime/upstream/`.
  **Bump the tag in the same commit that moves ART to another AOSP tag**, then rebaseline.
- **Authored:** `authored/<name>/`, same layout as upstream (`src/Main.java`, `expected.txt`,
  `info.txt`, optional `run`/`build`/`check`). Name them `dine-NNNN-<what>`.
  - JNI code includes only `jni.h` and registers its natives in `JNI_OnLoad`. The test's `build`
    compiles it into a `.so` next to the jar, and its `run` puts `${DEX_LOCATION}` on
    `java.library.path` (`dine-0002-jni-args`).
  - A test of ART's embedder API (`art_embedder.h`, `dine-0005-embedder-tag`) also links `-lart`:
    the shim linker that loads the `.so` resolves no libart symbol otherwise.
  - On the phone Dine's art screen runs seven of them in one VM, reruns included (`dbg smoke art`):
    0001 to 0004, 0006, 0008 and 0010. A test that runs there takes nothing from the command line
    (`java.class.path` is "."). JNI code is linked into Dine's dev builds through the superproject's
    `native/dev/runtimetests` (only `dine-0002-jni-args`'s is). `dine-0005-embedder-tag` isn't
    there: it moves the calling thread into another group and sets the VM's default attach group
    once, which the reruns would see. `dine-0007-native-libs` and `dine-0009-no-dex2oat` are
    Linux-only too (the superproject's `notes/general-todo.md` TOOL-14).

Current result (2026-11-15, 851 tests): **586 pass**, 20 expected failures, 245 skipped
(130 jvmti, 100 need libarttest, 14 custom run scripts, 1 needs network).

## Expectations

`expectations/linux-x86_64.json` lists every test that doesn't pass yet, with what it does
(`fail`, `crash`, `timeout`, `build-fail`, `flaky`) and why; `linux-x86_64.tests.txt` lists the
tests a whole run executes. The rules for both, and for `--update-expectations`, are in the
superproject's `tests/harness/README.md` "Baselines".

Notable entries: the older libcore (8.1/9) lacks APIs ART 10's tests use (VarHandles, `DelegateLastClassLoader`, in-memory `DexFile`, …). A few
tests need dex2oat prebuild or AOSP host tools.
