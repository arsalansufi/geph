# GEPH

Graph Optimized PostgreSQL Handler, or GEPH (pronounced Jeff), is a modified version of PostgreSQL optimized to load large graph datasets quickly. The project builds off of Postgres relase 9.5.2.

## Zoo Build Instructions

### Initial Build

Clone the GEPH repo onto the Zoo. Then run the following:
```
cd <path to GEPH repo>

# You can specify where you want your GEPH binaries installed at this step. You
# need to specify a directory in your user folder because we don't have write
# permissions elsewhere on the Zoo.
./configure --prefix=<absolute path to directory in your user folder>

gmake

# This just tests your build files. It isn't necessary.
gmake check

gmake install
```

Providing an example for the configure step, I ran the following command:
```
./configure --prefix=/home/accts/aas85/Workspace/cs438/final-project/geph-build
```
My git repo is located at: ```/home/accts/aas85/Workspace/cs438/final-project/geph```.

### Subsequent Builds

For subsequent builds, you just need to run:
```
gmake
gmake install
```
