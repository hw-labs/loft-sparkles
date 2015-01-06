SparkleFormation.build do

  set!('AWSTemplateFormatVersion', '2010-09-09')

  description 'My Stack Description'

  parameters do

    creator do
      default ENV.fetch('KNIFE_USER', ENV.fetch('USER', 'unknown'))
      description 'Creator of stack'
      type 'String'
    end

  end

  resources do
    stack_iam_user do
      type 'AWS::IAM::User'
      properties do
        path '/'
        policies array!(
          -> {
            policy_name 'stack_description_access'
            policy_document.statement array!(
              -> {
                effect 'Allow'
                action 'cloudformation:DescribeStackResource'
                resource '*'
              }
            )
          }
        )
      end
    end

    stack_iam_access_key do
      type 'AWS::IAM::AccessKey'
      properties do
        user_name ref!(:stack_iam_user)
        status 'Active'
      end
    end

  end

  outputs do
    stack_creator do
      description 'Stack creator'
      value ref!(:creator)
    end
  end

end
