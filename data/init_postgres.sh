if [[ "$OPENSHIFT_APP_UUID" == "" ]]
then
    export PGHOST=localhost             
    export PGPORT=5432
    export PGDATABASE=siteipyme
    export PGPASSWORD=postgres
    export PGUSER=postgres
else
    export PGHOST=$OPENSHIFT_POSTGRESQL_DB_HOST             
    export PGPORT=5432
    export PGDATABASE=$OPENSHIFT_GEAR_NAME
    export PGPASSWORD=$OPENSHIFT_POSTGRESQL_DB_PASSWORD
    export PGUSER=$OPENSHIFT_POSTGRESQL_DB_USERNAME
fi

#psql -f entities_postgres.sql
psql -f $1