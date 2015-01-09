SparkleFormation.new(:full) do

  set!('AWSTemplateFormatVersion', '2010-09-09')

  description 'My Stack Description'

  parameters do

    creator do
      default ENV.fetch('KNIFE_USER', ENV.fetch('USER', 'unknown'))
      description 'Creator of stack'
      type 'String'
    end

    image_id do
      default 'ami-ad42009d'
      allowed_values ['ami-ad42009d', 'ami-c7d092f7']
      description 'AMI Image ID'
      type 'String'
    end

    instance_type do
      default 'm1.small'
      description 'Size of instance'
      type 'String'
    end

    key_name do
      default 'sparkle-key'
      description 'EC2 SSH key name'
      type 'String'
    end

  end

  resources do
    stack_iam_user do
      type 'AWS::IAM::User'
      properties do
        path '/'
        policies array!(
          -> {
            policy_name 'stack_description_access'
            policy_document.statement array!(
              -> {
                effect 'Allow'
                action 'cloudformation:DescribeStackResource'
                resource '*'
              }
            )
          }
        )
      end
    end

    stack_iam_access_key do
      type 'AWS::IAM::AccessKey'
      properties do
        user_name ref!(:stack_iam_user)
        status 'Active'
      end
    end

    sparkle_security_group do
      type 'AWS::EC2::SecurityGroup'
      properties do
        group_description "Instance security group (SparkleFormation Example)"
        security_group_ingress array!(
          -> {
            ip_protocol 'tcp'
            from_port '22'
            to_port '22'
            cidr_ip '0.0.0.0/0'
          },
          -> {
            ip_protocol 'tcp'
            from_port '80'
            to_port '80'
            cidr_ip '0.0.0.0/0'
          }
        )
      end
    end

    sparkle_ec2_node do
      type 'AWS::EC2::Instance'
      properties do
        image_id ref!(:image_id)
        instance_type ref!(:instance_type)
        key_name ref!(:key_name)
        security_groups [ref!(:sparkle_security_group)]
        user_data(
          base64!(
            join!(
              "#!/bin/bash\n",
              "yum -q -y install python-setuptools nginx\n",
              "apt-get update\n",
              "apt-get -q -y install python-setuptools nginx\n",
              "easy_install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz\n",
              '/usr/local/bin/cfn-init -v --region ',
              ref!('AWS::Region'),
              ' -s ',
              ref!('AWS::StackName'),
              " -r #{_process_key(:sparkle_ec2_node)} --access-key ",
              ref!(:stack_iam_access_key),
              ' --secret-key ',
              attr!(:stack_iam_access_key, :secret_access_key),
              "\n"
            )
          )
        )
      end
      metadata('AWS::CloudFormation::Init') do
        _camel_keys_set(:auto_disable)
        config do
          services.sysvinit.nginx do
            enabled true
            ensureRunning true
          end
        end
      end
    end

  end

  outputs do
    stack_creator do
      description 'Stack creator'
      value ref!(:creator)
    end
    sparkle_ec2_node_address do
      description 'Public address of sparkle node'
      value attr!(:sparkle_ec2_node, 'PublicIp')
    end
  end

end
