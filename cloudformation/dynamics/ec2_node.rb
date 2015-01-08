SparkleFormation.dynamic(:ec2_node) do |_name, _config={}|

  dynamic!(:instance_common, :sparkle)

  ec2_instance = nil

  resources do

    ec2_instance = set!("#{_name}_ec2_node".to_sym) do
      type 'AWS::EC2::Instance'
      properties do
        image_id ref!("#{_name}_image_id".to_sym)
        instance_type ref!("#{_name}_instance_type".to_sym)
        key_name ref!("#{_name}_key_name".to_sym)
        if(_config[:user_data])
          user_data registry!(_config[:user_data], "#{_name}_ec2_node".to_sym)
        end
      end
    end

  end

  outputs do
    set!("#{_name}_ec2_node_address".to_sym) do
      description "Public address of #{_name} node"
      value attr!("#{_name}_ec2_node".to_sym, 'PublicIp')
    end
  end

  ec2_instance

end
