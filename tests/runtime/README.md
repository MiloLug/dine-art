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

On 16 cores: cold (fetch + build all + run) ~5.5 min, warm ~52 s. Editing `[run]` or
`[timeouts]` doesn't rebuild anything; bumping `[upstream]` rebuilds everything.

## Corpus

- **Upstream:** `art/test` from `android-security-10.0.0_r75`, the tag this tree's ART is
  rebased on (`corpus.toml`). Fetched as a sparse clone into dine's `out/tests/runtime/upstream/`.
  **Bump the tag in the same commit as an ART rebase**, then rebaseline.
- **Authored:** `authored/<name>/`, same layout as upstream (`src/Main.java`, `expected.txt`,
  `info.txt`, optional `run`/`build`/`check`). Name them `dine-NNNN-<what>`.
  - JNI code includes only `jni.h` and registers its natives in `JNI_OnLoad`. The test's `build`
    compiles it into a `.so` next to the jar, and its `run` puts `${DEX_LOCATION}` on
    `java.library.path` (`dine-0002-jni-args`).
  - On iOS the same file is linked into Dine's dev builds through the superproject's
    `native/dev/runtimetests`.

Current result (2026-10-20, 845 tests): **580 pass**, 20 expected failures, 245 skipped
(130 jvmti, 100 need libarttest, 14 custom run scripts, 1 needs network).

## Expectations

`expectations/linux-x86_64.json` lists every test that doesn't pass yet, with what it does
(`fail`, `timeout`, `build-fail`, `flaky`) and why. A test that isn't listed must pass.
- **regression:** a result differs from its expectation (a new failure, or a different kind of
  failure). The run exits 1.
- **fixed:** a listed test now passes. It's reported, and `--update-expectations` drops it.

Notable entries: StrictMath returns wrong results (082, 123), and the older libcore (8.1/9) lacks
APIs ART 10's tests use (VarHandles, `DelegateLastClassLoader`, in-memory `DexFile`, …). A few
tests need dex2oat prebuild or AOSP host tools.

## Known runtime issue

art_standalone's libcore (8.1/9) aborted in `JNI_OnUnload` at every VM shutdown under ART 10
(`JavaVM::GetEnv() failed`, exit 134). It's fixed here
(`libcore/luni/src/main/native/Register.cpp`). On a tree without the fix, the harness strips
that crash dump when it comes from the runtime's "Shutdown thread" after the test's output, and
counts it in the summary; `--strict` fails those tests instead.
