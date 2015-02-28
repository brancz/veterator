module API
  module V1
    class Records < Grape::API
      namespace :sensors do
        helpers do
          def authenticate!
            unauthenticated! unless current_user
          end

          def unauthenticated!
            error!({ message: '401 Unauthenticated' }, 401)
          end

          def current_user
            return unless authentication_token
            User.find_by_raw_token authentication_token
          end

          def authentication_token
            env['HTTP_AUTHORIZATION']
          end
        end

        # Create a new record for a sensor
        post ':id/records' do
          authenticate!
          sensor = Sensor.find params[:id]
          sensor.records.create value: params[:value]
        end
      end
    end
  end
end

