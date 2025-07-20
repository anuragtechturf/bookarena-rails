class User < ApplicationRecord
  has_secure_password validations: false

  # Associations
  belongs_to :referred_by_user, class_name: 'User', optional: true
  belongs_to :created_by_user, class_name: 'User', optional: true
  belongs_to :updated_by_user, class_name: 'User', optional: true

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :phone_number,
            uniqueness: true,
            format: { with: /\A\+91[6-9][0-9]{9}\z/, message: 'must be a valid Indian phone number with country code' },
            allow_blank: true,
            unless: -> { google_uid.blank? }

  validates :password, presence: true, unless: -> { google_uid.present? }

  validates :referral_code, uniqueness: true, allow_nil: true
  validates :google_uid, uniqueness: true, allow_nil: true

  # Scopes
  scope :active, -> { where(status: :active) }

  # Soft delete helper
  def soft_deleted?
    deleted_at.present?
  end
end
