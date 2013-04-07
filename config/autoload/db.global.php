<?php
$sPrefix = getenv('OPENSHIFT_APP_UUID') ? 'OPENSHIFT_' : '';
return array(
    'db' => array(
        'username'         => getenv($sPrefix.'POSTGRESQL_DB_USERNAME'),
        'password'         => getenv($sPrefix.'POSTGRESQL_DB_PASSWORD'),
        'driver'         => 'Pdo',
        'dsn'            => 'pgsql:dbname=postgres;host='.getenv($sPrefix.'POSTGRESQL_DB_HOST').';port='.getenv($sPrefix.'POSTGRESQL_DB_PORT'),
    ),
);
?>