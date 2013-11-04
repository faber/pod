require 'pod'
require 'fog'

module Pod

  Fog = Pod.extension do
    
    # pod.conf[:fog] = { mock: true }
    # pod.conf[:aws] = {
    #   access: 'aws access key',
    #   secret: 'aws secret key'
    # }
    
    
    def_service :fog do |pod|
      ::Fog.mock! if pod.conf.get(:fog, :mock)
      ::Fog
    end
    
    def_service :fog_rds do |pod|
      pod.conf.require!({aws: [:access, :secret]})
      get_service(:fog, pod)::AWS::RDS.new({
        aws_access_key_id: pod.conf[:aws][:access],
        aws_secret_access_key: pod.conf[:aws][:secret],
        region: pod.conf[:aws][:region]
      })
    end
    
    def_service :fog_compute do |pod|
      pod.conf.require!({aws: [:access, :secret]})
      get_service(:fog, pod)::Compute::AWS.new({
        aws_access_key_id: pod.conf[:aws][:access],
        aws_secret_access_key: pod.conf[:aws][:secret],
        region: pod.conf[:aws][:region]
      })
    end
    
    def_service :fog_storage do |pod|
      pod.conf.require!({aws: [:access, :secret]})
      get_service(:fog, pod)::Storage::AWS.new({
        aws_access_key_id: pod.conf[:aws][:access],
        aws_secret_access_key: pod.conf[:aws][:secret],
        region: pod.conf[:aws][:region]
      })
    end
    
    def_service :fog_aws_elb do |pod|
      pod.conf.require!({aws: [:access, :secret]})
      get_service(:fog, pod)::AWS::ELB.new({
        aws_access_key_id: pod.conf[:aws][:access],
        aws_secret_access_key: pod.conf[:aws][:secret],
        region: pod.conf[:aws][:region]
      })
    end

    def_service :fog_aws_auto_scaling do |pod|
      pod.conf.require!({aws: [:access, :secret]})
      get_service(:fog, pod)::AWS::AutoScaling.new({
        aws_access_key_id: pod.conf[:aws][:access],
        aws_secret_access_key: pod.conf[:aws][:secret],
        region: pod.conf[:aws][:region]
      })
    end

    def_service :fog_aws_cloud_watch do |pod|
      pod.conf.require!({aws: [:access, :secret]})
      get_service(:fog, pod)::AWS::CloudWatch.new({
        aws_access_key_id: pod.conf[:aws][:access],
        aws_secret_access_key: pod.conf[:aws][:secret],
        region: pod.conf[:aws][:region]
      })
    end

  end
end
