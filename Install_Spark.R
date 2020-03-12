library(sparklyr)

spark_version <- Sys.getenv('SPARK_VERSION')
spark_version

cat("Installing Spark in the directory:", spark_install_dir())
spark_install(version = spark_version)