# README - HttpFS

The REST API of `HttpFS` is the same exposed by `WebHDFS` service. Their basic difference is that the later needs access to the entire cluster to directly communicate to datanodes, while `HttpFS` can act as a gateway (without exposing cluster internal setup).

For details, see documentation on [WebHDFS API](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/WebHDFS.html)

## 1. Basic examples on REST operations

In all the following examples, the user `hadoop` (who started `HttpFS` service) is impersonating the HDFS user `baz` (using the `user.name` parameter). 
Note that user `baz` must belong to our group `httpfs` (on namenode and datanodes) for this to be allowed (see configuration for user-proxying in `core-site.xml`). 

List HDFS directory `/user/baz`:

    curl -v -X GET \
        'http://httpfs-c1-n1.hadoop.internal:14000/webhdfs/v1/user/baz?op=LISTSTATUS&user.name=baz' 

Create a directory at `/usr/baz/data-1`:

    curl -v -X PUT \
        'http://httpfs-c1-n1.hadoop.internal:14000/webhdfs/v1/user/baz/data-1?op=MKDIRS&user.name=baz&permission=0775'

Upload a local file under `/tmp/1.txt` to `/user/baz/data-1/1.txt`:

    curl -v -X PUT -H 'Content-Type: application/octet-stream' -T /tmp/1.txt \
        'http://httpfs-c1-n1.hadoop.internal:14000/webhdfs/v1/user/baz/data-1/1.txt?op=CREATE&user.name=baz&overwrite=false&data=true'

Download file `/user/baz/data-1/1.txt` (note that also `offset` and `length` parameters are supported and somehow emulate range requests):
    
    curl -v -X GET \
        'http://httpfs-c1-n1.hadoop.internal:14000/webhdfs/v1/user/baz/data-1/1.txt?op=OPEN&user.name=baz&buffersize=1024' 

Delete file `/user/baz/data-1/1.txt`:

    curl -v -X DELETE \
        'http://httpfs-c1-n1.hadoop.internal:14000/webhdfs/v1/user/baz/data-1/1.txt?op=DELETE&user.name=baz&recursive=false'

