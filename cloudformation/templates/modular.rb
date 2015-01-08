SparkleFormation.new(:modular).load(:base).overrides do

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

end
