# GEPH

Graph Enhanced PostgreSQL Handler, or GEPH (pronounced Jeff), is a modified version of PostgreSQL optimized to load large graph datasets quickly. The project builds off of Postgres relase 9.5.2.

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

## Useful Commands

All of the information in this section comes from Postgres's documentation.
I'm just including this brief list of commands for convenience.

```
# Initialize a new database server.
initdb -D <data directory>

# Start the initialized database server.
pg_ctl -D <data directory> -l <logfile> start

# Create a database.
createdb <database name>

# Connect to the database and start an interactive Postgres terminal.
psql <database name>

# [ Inside the Postgres terminal. ] List the databases on the server.
\l

# [ Inside the Postgres terminal. ] Connect to a different database on the
# server.
\c <database name>

# [ Inside the Postgres terminal. ] List the tables in the current database.
\dt OR \dt+

# Stop the database server.
pg_ctl -D <data directory> stop
```

## Modifications to Configuration Files

To allow non-local clients to send requests to a Postgres server, two configuration files in the server's data directory need to be modified.
Working versions of these two files have been placed in the project's `sample-config-files/` directory.
The modifications / additions have been marked with aggressive comments that look something like this:
```
# ADDED =======================================================================
...
# ADDED =======================================================================

# MODIFIED ====================================================================
...
# MODIFIED ====================================================================
```
