#executable = /bin/bash
dbname={{backup.dbname}}
password={{backup.password}}

pg_dump -U deployer $dbname > $dbname.sql
zip --password $password $dbname.zip $dbname.sql
rm $dbname.sql