module Rpush
  module Client
    module ActiveModel
      module Gcm
        module Notification
          def self.included(base)
            base.instance_eval do
              validates :registration_ids, presence: true

              validates_with Rpush::Client::ActiveModel::PayloadDataSizeValidator, limit: 4096
              validates_with Rpush::Client::ActiveModel::RegistrationIdsCountValidator, limit: 1000

              validates_with Rpush::Client::ActiveModel::Gcm::ExpiryCollapseKeyMutualInclusionValidator
            end
          end

          def as_json
            json = {
              'token' => registration_ids.first,
              'data' => data
            }
            json['notification'] = notification if notification
            json['collapse_key'] = collapse_key if collapse_key

            { 'message' => json }
          end
        end
      end
    end
  end
end
