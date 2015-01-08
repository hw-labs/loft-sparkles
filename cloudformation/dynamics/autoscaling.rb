SparkleFormation.dynamic(:autoscaling) do |_name, _config={}|

  dynamic!(:instance_common, :sparkle, _name)

  asg_resource = nil

  parameters do
    set!("#{_name}_asg_min_size") do
      description 'Minimum size for ASG'
      type 'Number'
      default 1
    end
    set!("#{_name}_asg_max_size") do
      description 'Maximum size for ASG'
      type 'Number'
      default 2
    end
  end

  resources do

    set!("#{_name}_autoscaling_group".to_sym) do
      type 'AWS::AutoScaling::AutoScalingGroup'
      properties do
        availability_zones azs!
        launch_configuration_name ref!("#{_name}_launch_configuration".to_sym)
        min_size ref!("#{_name}_asg_min_size".to_sym)
        max_size ref!("#{_name}_asg_max_size".to_sym)
      end
    end

    set!("#{_name}_launch_configuration".to_sym) do
      type 'AWS::AutoScaling::LaunchConfiguration'
      properties do
        image_id ref!("#{_name}_image_id".to_sym)
        instance_type ref!("#{_name}_instance_type".to_sym)
        key_name ref!("#{_name}_key_name".to_sym)
        if(_config[:user_data])
          user_data registry!(_config[:user_data], "#{_name}_launch_configuration".to_sym)
        end
      end
    end

  end

  asg_resource
end
