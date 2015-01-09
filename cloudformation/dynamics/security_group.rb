SparkleFormation.dynamic(:security_group) do |_name, _config={}|

  resources do

    set!("#{_name}_security_group".to_sym) do
      type 'AWS::EC2::SecurityGroup'
      properties do
        group_description "Instance security group (SparkleFormation Example)"
      end
    end

    _config[:ingress].each do |rule, settings|

      set!("#{_name}_ingress_#{rule}".to_sym) do
        type 'AWS::EC2::SecurityGroupIngress'
        properties do
          group_name ref!("#{_name}_security_group".to_sym)
          ip_protocol settings[:protocol]
          from_port settings[:port]
          to_port settings[:port]
          if(settings[:source_security_group])
            source_security_group settings[:source_security_group]
            if(settings[:source_security_group_id])
              source_security_group_id settings[:source_security_group_id]
            end
          else
            cidr_ip settings[:cidr] || '0.0.0.0/0'
          end
        end
      end
    end

  end

end
