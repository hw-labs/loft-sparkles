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
    properties.security_groups [ref!(:sparkle_security_group)]
    registry!(:nginx)
  end

end
