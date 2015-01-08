SparkleFormation.dynamic(:autoscaling) do |_name, _config|

  dynamic!(:instance_common, :sparkle, _name)

  resources do

    "#{_name}_autoscaling_group".to_sym do
      type 'AWS::AutoScaling::AutoScalingGroup'
      properties do
        availability_zones({ 'Fn::GetAZs' => '' })
        launch_configuration_name "#{_name}_launch_configuration".to_sym
        min_size _config[:min_size] || 1
        max_size _config[:max_size] || 2
        if _process_key(_config[:elb])
          load_balancer_names [ _config[:elb] ]
        end
      end
    end

    "#{_name}_launch_configuration".to_sym do
      type 'AWS::AutoScaling::LaunchConfiguration'
      properties do
        image_id ref!("#{_name}_image_id".to_sym)
        instance_type ref!("#{_name}_instance_type".to_sym)
        key_name ref!("#{_name}_key_name".to_sym)
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
              " -r #{_process_key("#{_name}_ec2_node".to_sym)} --access-key ",
              ref!(:stack_iam_access_key),
              ' --secret-key ',
              attr!(:stack_iam_access_key, :secret_access_key),
              "\n"
            )
          )
        )
      end
      registry!(_config[:registry])
    end

  end
end
