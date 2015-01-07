SparkleFormation.dynamic(:ec2_node) do |_name, _config|

  dynamic!(:instance_common, :sparkle)

  resources do
    "#{_name}_ec2_node".to_sym do
      type 'AWS::EC2::Instance'
      properties do
        image_id ref!(:image_id)
        instance_type ref!(:instance_type)
        key_name ref!(:key_name)
        user_data(
          base64!(
            join!(
              "#!/bin/bash\n",
              "yum -q -y install python-setuptools nginx\n",
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
    end
  end

  outputs do
    "#{_name}_ec2_node_address".to_sym do
      description 'Public address of #{_name} node'
      value attr!("#{_name}_ec2_node".to_sym, 'PublicIp')
    end
  end

end
