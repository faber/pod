require 'pod'
require 'fog'

module Pod

  Fog = Pod.extension do
    
    # conf[:fog] = { mock: true }
    # conf[:aws] = {
    #   access: 'aws access key',
    #   secret: 'aws secret key'
    # }
    
    
    def_service :fog do |conf|
      ::Fog.mock! if conf.get(:fog, :mock)
      ::Fog
    end
    
    def_service :fog_rds do |conf|
      conf.require!({aws: [:access, :secret]})
      get_service(:fog, conf)::AWS::RDS.new({
        aws_access_key_id: conf[:aws][:access],
        aws_secret_access_key: conf[:aws][:secret]
      })
    end
    
    def_service :fog_compute do |conf|
      conf.require!({aws: [:access, :secret]})
      get_service(:fog, conf)::Compute::AWS.new({
        aws_access_key_id: conf[:aws][:access],
        aws_secret_access_key: conf[:aws][:secret]
      })
    end
    
    def_service :fog_storage do |conf|
      conf.require!({aws: [:access, :secret]})
      get_service(:fog, conf)::Storage::AWS.new({
        aws_access_key_id: conf[:aws][:access],
        aws_secret_access_key: conf[:aws][:secret]
      })
    end
    
    def_service :fog_aws_elb do |conf|
      conf.require!({aws: [:access, :secret]})
      get_service(:fog, conf)::AWS::ELB.new({
        aws_access_key_id: conf[:aws][:access],
        aws_secret_access_key: conf[:aws][:secret]
      })
    end

    def_service :fog_aws_auto_scaling do |conf|
      conf.require!({aws: [:access, :secret]})
      get_service(:fog, conf)::AWS::AutoScaling.new({
        aws_access_key_id: conf[:aws][:access],
        aws_secret_access_key: conf[:aws][:secret]
      })
    end

    def_service :fog_aws_cloud_watch do |conf|
      conf.require!({aws: [:access, :secret]})
      get_service(:fog, conf)::AWS::CloudWatch.new({
        aws_access_key_id: conf[:aws][:access],
        aws_secret_access_key: conf[:aws][:secret]
      })
    end

  end
end
