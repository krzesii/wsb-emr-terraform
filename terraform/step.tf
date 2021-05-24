resource "aws_sfn_state_machine" "example-stepfunction" {
  name     = "${local.project_name}-example-emr-sfn"
  role_arn = aws_iam_role.iam_emr_service_role.arn

  definition = <<EOF
  {
  "Comment": "Example step function to provision EMR cluster and run PySpark job",
  "StartAt": "CreateEMR",
  "States": {
    "CreateEMR": {
      "Type": "Task",
      "Resource": "arn:aws:states:::elasticmapreduce:createCluster.sync",
      "Parameters": {
        "Name": "${local.project_name}-example-emr-cluster",
        "ServiceRole": "${aws_iam_role.iam_emr_service_role.arn}",
        "JobFlowRole": "${aws_iam_instance_profile.emr_profile.arn}",
        "ReleaseLabel": "emr-6.0.0",
        "Applications": [
          {
            "Name": "Spark"
          },
          {
            "Name": "Hadoop"
          }
        ],
        "LogUri": "${local.emrlogslocation}",
        "Configurations": [
       {
          "Classification": "spark-env",
          "Configurations": [
          {
            "Classification": "export",
            "Properties": {
              "PYSPARK_PYTHON": "/usr/bin/python3",
              "AWS_DEFAULT_REGION": "${var.aws_region}"
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
             "AWS_DEFAULT_REGION": "${var.aws_region}"
            }
         }
         ],
         "Properties": {}
        },
        {
         "Classification": "yarn-env",
         "Configurations": [
         {
           "Classification": "export",
           "Properties": {
             "AWS_DEFAULT_REGION": "${var.aws_region}"
            }
         }
         ],
         "Properties": {}
        }
        ],
        "BootstrapActions": [ 
        { 
         "Name": "BootstrapScript",
         "ScriptBootstrapAction": { 
            "Path": "${local.emrbootscriptlocation}"
          }
        }
        ],
        "VisibleToAllUsers": true,
        "Instances": {
          "EmrManagedMasterSecurityGroup": "${var.master_sg}",
          "EmrManagedSlaveSecurityGroup": "${var.worker_sg}",
          "ServiceAccessSecurityGroup": "${var.service_access_sg}",
          "Ec2SubnetId": "TestSubnetId",
          "AdditionalMasterSecurityGroups": [ "" ],
          "AdditionalSlaveSecurityGroups": [ "" ],
          "KeepJobFlowAliveWhenNoSteps": true,
          "InstanceFleets": [
            {
              "InstanceFleetType": "MASTER",
              "Name": "Master",
              "TargetOnDemandCapacity": 1,
              "InstanceTypeConfigs": [
                {
                  "InstanceType": "m5.4xlarge"
                }
              ]
            },
            {
              "InstanceFleetType": "CORE",
              "Name": "Core",
              "TargetOnDemandCapacity": 8,
              "InstanceTypeConfigs": [
                {
                  "InstanceType": "m5.4xlarge"
                }
              ]
            }
          ]
        }
      },
      "ResultPath": "$.cluster",
      "Next": "AddEMRStep"
    },
    "AddEMRStep": {
      "Type": "Task",
      "Resource": "arn:aws:states:::elasticmapreduce:addStep.sync",
      "Parameters": {
        "ClusterId.$": "$.cluster.ClusterId",
        "Step": {
          "Name": "Extract report",
          "HadoopJarStep": {
            "Jar": "command-runner.jar",
            "Args": [
                      "spark-submit",
                      "--deploy-mode",
                      "cluster",
                      "--master",
                      "yarn-cluster",
                      "--driver-memory",
                      "20g",
                      "--executor-memory",
                      "20g",
                      "${local.emrjarlocation}",
                      "${var.aws_region}"
      ]
          }
        }
      },
      "ResultPath": "$.emrStep",
      "Next": "TerminateEMR"
    },
    "TerminateEMR": {
      "Type": "Task",
      "Resource": "arn:aws:states:::elasticmapreduce:terminateCluster.sync",
      "Parameters": {
        "ClusterId.$": "$.cluster.ClusterId"
      },
      "End": true
    }
  }
}
EOF

}

