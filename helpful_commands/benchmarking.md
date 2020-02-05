## Mysql

**Via mysqlslap**
```shell script
database=mysqlslap
query="/tmp/file.sql || SELECT * FROM table WHERE 1=1"
mysqlslap --create-schema="${database}" \
    --delimiter=";" \
    --query="${query}" \
    --concurrency=${concurrency:-10} \
    --iterations=${iterations:-100} \
    --no-drop
```
