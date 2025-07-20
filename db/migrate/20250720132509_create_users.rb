class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone_number, null: false
      t.text :password_digest
      t.string :otp_secret
      t.boolean :is_phone_verified, default: false
      t.string :referral_code
      t.references :referred_by_user, type: :uuid, foreign_key: { to_table: :users }, null: true
      t.enum :status, enum_type: :user_status_enum, default: 'active', null: false
      t.date :date_of_birth
      t.enum :gender, enum_type: :gender_enum
      t.text :profile_picture_url
      t.datetime :last_login_at
      t.datetime :deleted_at
      t.references :created_by_user, type: :uuid, foreign_key: { to_table: :users }, null: true
      t.references :updated_by_user, type: :uuid, foreign_key: { to_table: :users }, null: true
      t.string :google_uid

      t.timestamps

      # Indian phone number format check
      t.check_constraint "phone_number ~ '^\\+91[6-9][0-9]{9}$'", name: 'phone_number_india_format'
    end

    # Indexes
    add_index :users, :email, unique: true
    add_index :users, :phone_number, unique: true
    add_index :users, :google_uid, unique: true, where: "google_uid IS NOT NULL"
    add_index :users, :referral_code, unique: true
    add_index :users, :status
    add_index :users, :referred_by_user_id, name: 'idx_users_referred_by'
    add_index :users, :created_by_user_id, name: 'idx_users_created_by'
    add_index :users, :updated_by_user_id, name: 'idx_users_updated_by'
  end
end