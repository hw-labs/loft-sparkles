SfnRegistry.register(:metadata_nginx) do |_name, _config|
  metadata('AWS::CloudFormation::Init') do
    _camel_keys_set(:auto_disable)
    config do
      services.sysvinit.nginx do
        enabled true
        ensureRunning true
      end
    end
  end

end
