backup steps:
pg_dump -U postgres -d arcf_db -F p -f "C:\AI\backup_with_data.sql"



restore steps:
psql -U postgres -c "CREATE DATABASE restor_db_namee;"

psql -U postgres -d arcf_restore -f "C:\work\backup_with_data.sql"
