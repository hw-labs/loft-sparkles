# SparkleFormation @ AWS Loft

This repository contains the examples used for
the AWS Loft presentation. The slides are available
online here:

* https://hw-ops.com/slides/loft-sparkles

To run the examples, you will need to:

* Install the bundle
* Set AWS credentials in your environment

### Installing the bundle

Clone this repository and from within it run:

```bash
$> bundle install
```

Once this completes, confirm a working installation:

```bash
$> bundle exec knife cloudformation --help
```

### Set AWS credentials

The configuration for the `knife-cloudformation` CLI
is found within the `.chef/knife.rb` file. It uses
environment variables by default. The required variables:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_REGION (set to us-west-2 for examples)

## Usage

### List existing stacks

```bash
$> bundle exec knife cloudformation list
```

### Create stack using JSON template

```bash
$> bundle exec knife cloudformation create my-json-stack --file raw/full.json
```

### Create stack using SparkleFormation template

```
$> bundle exec knife cloudformation create my-sfn-stack --file cloudformation/template/full.rb --processing
```

### View stack events

```
$> bundle exec knife cloudformation events my-stack --poll
```

### View stack resources and outputs

```
$> bundle exec knife cloudformation describe my-stack
```

### Inspect the stack

Stack data:

```
$> bundle exec knife cloudformation inspect my-stack
```

Template:

```
$> bundle exec knife cloudformation inspect my-stack -a template
```

EC2 instance addresses within stack:

```
$> bundle exec knife cloudformation inspect my-stack -N
```

### Delete stack

```
$> bundle exec knife cloudformation destroy my-stack
```
