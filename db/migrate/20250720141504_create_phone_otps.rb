class CreatePhoneOtps < ActiveRecord::Migration[8.0]
  def change
    create_table :phone_otps do |t|
      t.string :phone_number
      t.string :otp_code
      t.datetime :expires_at
      t.boolean :verified

      t.timestamps
    end
  end
end
