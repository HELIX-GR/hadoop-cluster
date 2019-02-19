# README - Spark

## 1. Quickstart with Yarn

### 1.1. Upload Spark libraries to HDFS

Upload Spark libraries under HDFS to avoid uploading each time an application is submitted. 
See also: https://stackoverflow.com/questions/41112801/property-spark-yarn-jars-how-to-deal-with-it

First package libraries in a wrapper JAR:

    jar cv0f spark-libs.jar -C $SPARK_HOME/jars/ .

Upload to HDFS, e.g. under `/user/yarn/share/jars`

    hdfs dfs -copyFromLocal spark-libs.jar /user/yarn/share/jars/

Now, we can pass option `spark.yarn.archive` to Spark referencing the JAR archive we have just created (see next). 

### 1.2 Submit application

Submit to YARN, in `cluster` mode (or `client` mode):

    spark-submit --master yarn --deploy-mode cluster \
        --driver-memory 512m --executor-memory 512m --executor-cores 1 \
        --conf spark.yarn.archive=hdfs:///user/yarn/share/jars/spark-libs.jar \
        --class org.apache.spark.examples.SparkPi \
        $SPARK_HOME/examples/jars/spark-examples.jar 32


#### Notes

 1. Make sure the hostname does not map to a loopback address (in subnet `127.0.0.1/8`), because Spark
 will get confused when trying to bind addresses. It's better to have the hostname mapped to the address
 of the interface that connects to the Hadoop cluster.

