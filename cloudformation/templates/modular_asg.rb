SparkleFormation.new(:modular).load(:base).overrides do

  parameters do

    asg_min_size do
      type 'Number'
      description 'Minimum size for Autoscaling group'
    end
    asg_max_size do
      type 'Number'
      description 'Maximum size for Autoscaling group'
    end

  end
  
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

  dynamic!(:autoscaling, :sparkle, :min_size => ref!(:asg_min_size), :max_size => ref!(:asg_max_size)) do
    properties.security_groups [ref!(:sparkle_security_group)]
    registry!(:nginx)
  end
           
end
