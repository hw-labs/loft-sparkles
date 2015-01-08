SparkleFormation.new(:builtin_dynamics).load(:base).overrides do

  # Using custom defined dynamic
  dynamic!(:instance_common, :sparkle)

  # Using builtin dynamic
  dynamic!(:ec2_security_group, :sparkle) do
    properties do
      ingress_rules array!(
        -> {
          ip_protocol 'TCP'
          from_port 22
          to_port 22
          cidr_ip '0.0.0.0/0'
        },
        -> {
          ip_protocol 'HTTP'
          from_port 80
          to_port 80
          cidr_ip '0.0.0.0/0'
        }
      )
    end
  end

  # Using builtin dynamic
  dynamic!(:ec2_instance, :sparkle) do
    properties do
      security_groups [ref!(:sparkle_ec2_security_group)]
      user_data registry!(:user_data_nginx, :sparkle_ec2_instance)
    end
    registry!(:metadata_nginx)
  end

  outputs.sparkle_ec2_instance do
    description 'Public address of SparkleEc2Instance'
    value attr!(:sparkle_ec2_instance, 'PublicIp')
  end

end
