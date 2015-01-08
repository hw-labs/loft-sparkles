SparkleFormation.new(:conditional_resources).load(:base).overrides do

  parameters do
    enable_extra_sparkle do
      description 'Enable extra sparkle resource'
      type 'String'
      default 'no'
      allowed_values ['yes', 'no']
    end
  end

  conditions.more_sparkles equals!(ref!(:enable_extra_sparkle), 'yes')

  dynamic!(:security_group, :sparkle,
    :ingress => {
      :ssh => {
        :protocol => 'tcp',
        :port => 22
      },
      :web => {
        :protocol => 'tcp',
        :port => 80
      }
    }
  )

  dynamic!(:ec2_node, :sparkle) do
    properties do
      security_groups [ref!(:sparkle_security_group)]
      user_data registry!(:user_data_nginx, :sparkle_ec2_node)
    end
    registry!(:metadata_nginx)
  end

  dynamic!(:ec2_node, :more_sparkle) do
    properties do
      security_groups [ref!(:sparkle_security_group)]
      user_data registry!(:user_data_nginx, :sparkle_ec2_node)
    end
    registry!(:metadata_nginx)
    on_condition! :more_sparkles
  end

end
