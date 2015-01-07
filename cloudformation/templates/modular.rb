SparkleFormation.new(:modular).load(:base) do

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

  dynamic!(:ec2_node, :sparkle)

  resources.sparkle_ec2_node.properties do
    security_groups [_ref!(:sparkle_security_group)]
    registry!(:nginx)
  end

end
