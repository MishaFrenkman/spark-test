library(sparklyr)

spark_version <- Sys.getenv('SPARK_VERSION')
spark_url <- Sys.getenv('SPARK_URL')

conf <- spark_config()
conf$spark.executor.memory <- Sys.getenv('EXECUTOR_MEMORY')
conf$spark.memory.fraction <- 0.9

spark_home <- spark_install_find(version=spark_version)$sparkVersionDir
sc <- spark_connect(master = spark_url, conf = conf, spark_home = spark_home)

library(dplyr)
flights_tbl <- copy_to(sc, nycflights13::flights, "flights")
flights_tbl %>% filter(dep_delay == 2)
spark_disconnect(sc)