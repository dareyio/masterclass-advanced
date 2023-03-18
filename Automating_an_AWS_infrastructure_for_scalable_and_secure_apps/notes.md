
1. Introduce AWS CLI
    IAM and secrets configuration

[default]
aws_access_key_id = AKIAigg6AFPILQR7Y52KSU6
aws_secret_access_key = BWaLrPnsQ5FSW0tiMgfgfgNPI9UZ4jVu2EpUN8yB9hpPU

aws ec2 run-instances --image-id ami-0b0af3577fe5e3532 --count 1 --instance-type t2.micro --key-name mcc-key --region us-east-1 


aws ec2 describe-instances --region us-east-1 --filters "Name=instance-type,Values=t2.micro" --query "Reservations[].Instances[].InstanceId" | grep <Insert Instace ID here>


aws ec2 terminate-instances --region us-east-   1 --instance-ids i-0482209df889aeff7


2. Introduce IAC
    -- What is terraform? It is an “infrastructure as code” tool similar to AWS CloudFormation that allows you to create, update, and version your Amazon Web Services (AWS) infrastructure
    -- installing Terraform
    -- Installing an IDEA - Atom, and Visual Studio Code

3. Terraform Concepts - With Terraform you can have IaC with most cloud providers. So that your infrastructure can be versioned just like your application code. Hence you can also have CI/CD pipelines for your infrastructure.

code --> commit --> push --> build (plan) --> test(validate | lint) --> further tests [tfsec] (Static Code Analysis)  --> Tag and Release (Terraform apply)

How does Terrform work with different cloud providers

    -- Providers/Plugins

    The Terraform AWS provider is a plugin for Terraform that allows for the full lifecycle management of AWS resources

    Plugins is how you develop providers. For example, AWS provider is implemented as a plugin in go programming language into terraform

    So, as an end-user you are using AWS provider. But if you want to contribute to the provider, and implement or fix bugs in it, you will be doing this in in a context of a plugin in go language

    Source code of the AWS provider - https://github.com/hashicorp/terraform-provider-aws


    https://registry.terraform.io/search/providers
        terraform init
    -- Idempotency
    --  Modules
    -- Terraform documentation | Attributes | and Arguments
    
4. Begin terraform
   -- Leveraging AI in your day2day work - chatGPT
   -- Install Terraform (binary or with tfenv)
   -- set the AWS credentials to connect to AWS
   -- VPC and other Networking
   -- Interpolation
   -- All through to 15 - introduce variables
   -- Types and Values
   
   The result of an expression is a value. All values have a type, which dictates where that value can be used and what transformations can be applied to it.

    Data types 

   a)  string: a sequence of Unicode characters representing some text, like "hello".

   b)  number: a numeric value. The number type can represent both whole numbers like 15 and fractional values like 6.283185.

   c) bool: a boolean value, either true or false. bool values can be used in conditional logic.

   d) list (or tuple): a sequence of values, like ["us-west-1a", "us-west-1c"]. Elements in a list or tuple are identified by consecutive whole numbers, starting with zero.

   d) map (or object): a group of values identified by named labels, like {name = "Mabel", age = 52}

   storageProfile = {
        storage_mb                      = 102400
        backup_retention_days           = 15
        geo_redundant_backup_enabled    = false
        administrator_login             = "pgadmin1223"
        }


   -- introduce functions. e.g merge()
   -- refactoring

5. Modules
