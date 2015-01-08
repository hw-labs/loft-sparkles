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

  dynamic!(:autoscaling, :sparkle,
    :user_data => :user_data_nginx,
    :registry => :metadata_nginx
  )

  resources.sparkle_autoscaling_group do
    properties.security_groups [ref!(:sparkle_security_group)]
  end

  parameters.sparkle_asg_min_size.default 5
  parameters.sparkle_asg_max_size.default 5

end
