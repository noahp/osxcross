# 🐧 cross build osx on linux 🐧

Adds a Dockerfile suitable for building mac os gcc/g++ software from linux.

It's based on ubuntu:bionic, but could easily be adapted for other debians. You
would have to rebuild the image, though, which can take a while (~15-30minutes).

## Usage

See [README.original.md](README.original.md) for general usage.

Example using this to build some mac software:

```bash
# use the published version of this image.
# just echo a small c program into o64-clang stdin (`-x -c -`)
docker run -i -v"$(pwd):/mnt/workspace" -t noahpendleton/osxcross \
  bash -c \
    "cd /tmp && echo -e '#include <stdio.h>\nint main(){printf(\"hello from mac\\\n\");return 0;}' | \
    o64-clang -x c - && file a.out && x86_64-apple-darwin17-otool -L a.out"
a.out: Mach-O 64-bit x86_64 executable, flags:<NOUNDEFS|DYLDLINK|TWOLEVEL|PIE>
a.out:
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1252.0.0)

# for a make-based build:
docker run -i -v"$(pwd):/mnt/workspace" -t noahpendleton/osxcross \
  bash -c "cd /mnt/workspace && CC=o64-clang CXX=o64-clang++ make -j6"

# for automake build (untested but you get the idea):
docker run -i -v"$(pwd):/mnt/workspace" -t noahpendleton/osxcross \
  bash -c "cd /mnt/workspace && CC=o64-clang CXX=o64-clang++ ./configure --host=i386-apple-darwinXX && make -j6"
```
