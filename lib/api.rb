require 'api/v1/records'

module API
  class API < Grape::API
    version 'v1', using: :path

    mount V1::Records
  end
end

