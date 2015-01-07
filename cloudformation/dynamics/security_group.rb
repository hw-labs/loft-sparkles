SparkleFormation.dynamic(:security_group) do |_name, _config={}|

  resources("{_name}_security_group".to_sym) do
    type 'AWS::EC2::SecurityGroup'
    properties do
      group_description "Instance security group (SparkleFormation Example)"
    end
  end

  _config[:ingress].each do |rule, settings|
    resources("#{_name}_ingress_#{rule}".to_sym) do
      type 'AWS::EC2::SecurityGroupIngress'
      properties do
        group_name "#{_name}_security_group".to_sym
        ip_protocol settings[:protocol]
        from_port settings[:port]
        to_port settings[:port]
        if settings[:source_security_group]
          source_security_group settings[:source_security_group]
        else
          cidr_ip settings[:cidr] || '0.0.0.0/0'
        end
      end
    end
  end

end
