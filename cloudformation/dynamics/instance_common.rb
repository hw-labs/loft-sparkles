SparkleFormation.dynamic(:instance_common) do |_name|
  parameters do

    image_id do
      default 'ami-ad42009d'
      allowed_values ['ami-ad42009d', 'ami-c7d092f7']
      description 'AMI Image ID'
      type 'String'
    end

    instance_type do
      default 'm1.small'
      description 'Size of instance'
      type 'String'
    end

    key_name do
      default 'sparkle-key'
      description 'EC2 SSH key name'
      type 'String'
    end
  end
end
