[
  {
    "Classification": "spark-env",
    "Configurations": [
      {
        "Classification": "export",
        "Properties": {
          "PYSPARK_PYTHON": "/usr/bin/python3",
          "AWS_DEFAULT_REGION": "${aws_region}"
        }
      }
    ]
  },
  {
    "Classification": "hadoop-env",
    "Configurations": [
      {
        "Classification": "export",
        "Properties": {
          "AWS_DEFAULT_REGION": "${aws_region}"
        }
      }
    ],
    "Properties": {}
  }
]