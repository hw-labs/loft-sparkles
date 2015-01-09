SfnRegistry.register(:user_data_nginx) do |_name, _config|
  base64!(
    join!(
      "#!/bin/bash\n",
      "yum -q -y install python-setuptools nginx\n",
      "apt-get update\n",
      "apt-get -q -y install python-setuptools nginx\n",
      "easy_install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz\n",
      '/usr/local/bin/cfn-init -v --region ',
      ref!('AWS::Region'),
      ' -s ',
      ref!('AWS::StackName'),
      " -r #{_process_key(_name.to_sym)} --access-key ",
      ref!(:stack_iam_access_key),
      ' --secret-key ',
      attr!(:stack_iam_access_key, :secret_access_key),
      "\n"
    )
  )
end
