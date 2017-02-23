class PatientNote < ApplicationRecord
  attr_encrypted_options.merge!(:encode => true)

  # Encrypt data
  attr_encrypted :note, key: Rails.application.secrets.encr_key

  belongs_to :patient
end
