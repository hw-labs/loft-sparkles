SparkleFormation.new(:public_endpoint) do

  dynamic!(:load_balancer, :public) do
    properties.listeners array!(
      -> {
        protocol 'HTTP'
        instance_protocol 'HTTP'
        port 80
        instance_port 80
      }
    )
  end

  outputs do
    public_load_balancer_id do
      description 'ID of public load balancer resource'
      value ref!(:public_load_balancer)
    end
    public_load_balancer_security_name do
      description 'Load balancer security group name'
      value attr!(:public_load_balancer, '')
    end
    public_load_balancer_security_id do
      description 'Load balancer security group ID'
      value attr!(:public_load_balancer, '')
    end
  end

end
