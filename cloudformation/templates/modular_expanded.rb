SparkleFormation.new(:modular_expanded).load(:base).overrides do

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

  5.times do |i|
    dynamic!(:ec2_node, "sparkle#{i}") do
      properties.security_groups [ref!(:sparkle_security_group)]
      registry!(:nginx)
    end
  end

end
