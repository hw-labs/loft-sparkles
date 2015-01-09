SparkleFormation.new(:backend_asg).load(:base).overrides do

  parameters do

    public_load_balancer_id do
      description 'ID of public load balancer for ASG'
      type 'String'
    end
    public_load_balancer_security_name do
      description 'Security group name for load balancer'
      type 'String'
    end
    public_load_balancer_security_id do
      description 'Security group ID for load balancer'
      type 'String'
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
      },
      :elb => {
        :protocol => 'tcp',
        :port => 80,
        :source_security_group => ref!(:public_load_balancer_security_name),
        :source_security_group_id => ref!(:public_load_balancer_security_id)
      }
    }
  )

  dynamic!(:autoscaling, :sparkle,
    :user_data => :user_data_nginx,
    :registry => :metadata_nginx
  )

  resources.sparkle_autoscaling_group do
    properties do
      security_groups [ref!(:sparkle_security_group)]
      load_balancer_ids [ref!(:public_load_balancer_id)]
    end
  end

end
