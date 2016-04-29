# filename: loading-and-profiling-lib.sh
#
# This file contains various functions for loading and profiling scripts.

# Variables =======================================================================================

# User-set variables. None should have spaces!
bin_dir="/home/accts/aas85/Workspace/cs438/final-project/geph-build/bin"
gprof_dir="/home/accts/aas85/Workspace/cs438/final-project/geph-build/data/gprof"
data_collection_dir="/tmp/cs438-afc33-aas85/data-collection"
data_sets_dir="/tmp/cs438-afc33-aas85/data-sets"
db="mygraph1"
tables=("nodes" "edges")

# Constructed variables
create_db="$bin_dir/createdb"
drop_db="$bin_dir/dropdb"
pg_restore="$bin_dir/pg_restore"
postgres="$bin_dir/postgres"
psql="$bin_dir/psql"
start_dir=$(pwd)

# Functions =======================================================================================

clean_up()
{
    mode=$1

    # Drop entire database if full-database mode
    if [[ $mode == "full" ]]; then
        $drop_db $db
        $create_db $db

    # Delete all entries in table if individual-table mode
    else if [[ ${tables[@]} =~ $mode ]] && [[ $mode != "" ]]; then
        $psql -c "TRUNCATE $mode RESTART IDENTITY" $db
    fi
    fi

    # Remove client gmon.out (if any)
    if [[ -f "gmon.out" ]]; then
        rm "gmon.out"
    fi

    # Remove server gmon.outs (if any)
    cd $gprof_dir
    if [[ $(ls .) ]]; then
        rm -r *
    fi
    cd $start_dir
}

psql_load()
{
    input_name=$1
    output_name=$1

    input_path="$data_sets_dir/$db/$db-$input_name.export"

    execute_sql_and_save $input_path $output_name
}

execute_sql_and_save()
{
    input_path=$1
    output_name=$2

    output_path="$data_collection_dir/$db/$db-$output_name.time"

    execute_sql $input_path $output_path
}

execute_sql()
{
    input_path=$1
    output_path=$2

    if [[ $output_path == "" ]]; then
        $psql $db < $input_path
    else
        ( time $psql $db < $input_path ) 2> $output_path
    fi
}

pg_restore_load()
{
    input_name=$1
    output_name=$2
    format_flag=$3
    job_flag=$4

    input_path="$data_sets_dir/$db/$db-$input_name.export"
    output_path="$data_collection_dir/$db/$db-$output_name.time"

    ( time $pg_restore -d $db $format_flag $job_flag $input_path ) 2> $output_path
}

copy_load()
{
    input_name=$1
    output_name=$2
    frontend_or_backend=$3
    format=$4

    input_path="$data_sets_dir/$db/$db-$input_name.export"
    output_path="$data_collection_dir/$db/$db-$output_name.time"
    cmd=""
    if      [[ $frontend_or_backend == "frontend" ]]; then cmd="\COPY"
    else if [[ $frontend_or_backend == "backend"  ]]; then cmd="COPY"
    fi
    fi

    ( time $psql -c "$cmd $table FROM '$input_path' WITH (FORMAT $format)" $db ) 2> \
                                      "$output_path"
}

profile()
{
    output_name=$1
    binary=$2

    output_path="$data_collection_dir/$db/$db-$output_name.profile"

    mkdir "$output_path"
    
    # Store and process client gmon.out
    mkdir "$output_path/client"
    if [[ -f "gmon.out" ]]; then
        cp "gmon.out" "$output_path/client/gmon.out"
        gprof $binary "$output_path/client/gmon.out" > "$output_path/client/analysis"
    fi
    
    # Store and process server gmon.outs
    mkdir "$output_path/server"
    cd $gprof_dir
    if [[ $(ls .) ]]; then
        cp -r * "$output_path/server"
    fi
    cd "$output_path/server"
    for dir in $(ls); do
        gprof $postgres "$dir/gmon.out" > "$dir/analysis" 
    done
    cd $start_dir
}
