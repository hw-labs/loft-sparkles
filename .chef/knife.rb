# AWS credentials
knife[:aws_access_key_id] = ENV['AWS_ACCESS_KEY_ID']
knife[:aws_secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']
knife[:region] = ENV['AWS_REGION']

# Cloudformation configuration
knife[:cloudformation][:options][:disable_rollback] = true
knife[:cloudformation][:ssh_attempt_users] = ['ubuntu']
knife[:cloudformation][:identity_file] = ENV['DEFAULT_SSH_IDENTITY_FILE']
knife[:cloudformation][:ignore_parameters] = ['Environment', 'Creator']

knife[:cloudformation][:options][:capabilities] = ['CAPABILITY_IAM']
knife[:cloudformation][:credentials] = Mash.new(
  :aws_access_key_id => knife[:aws_access_key_id],
  :aws_secret_access_key => knife[:aws_secret_access_key],
  :aws_region => knife[:region],
  :aws_bucket_region => knife[:region]
)

knife[:cloudformation][:ssh_attempt_users] = ['ubuntu']

if(ENV['CLOUDFORMATION_IDENTITY_FILE'])
  knife[:cloudformation][:identity_file] = ENV['CLOUDFORMATION_IDENTITY_FILE']
end
