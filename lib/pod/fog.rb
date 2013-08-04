require 'pod'
require 'fog'

module Pod

  Fog = Pod.extension do
    
    conf[:fog] = { mock: true }
    conf[:aws] = {
      access: 'aws access key',
      secret: 'aws secret key'
    }
    
    
    def_service :fog do |conf|
      ::Fog.mock! if conf[:fog][:mock]
      ::Fog
    end
    
    def_service :rds do |conf|
      get_service(:fog, conf)::AWS::RDS.new({
        aws_access_key_id: 'conf[:aws][:access]',
        aws_secret_access_key: 'conf[:aws][:secret]'
      })
    end
    
    def_service :compute do |conf|
      get_service(:fog, conf)::Compute::AWS.new({
        aws_access_key_id: conf[:aws][:access],
        aws_secret_access_key: conf[:aws][:secret]
      })
    end
    
  end
end
