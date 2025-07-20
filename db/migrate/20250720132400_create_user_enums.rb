class CreateUserEnums < ActiveRecord::Migration[8.0]
  def up
    create_enum :user_status_enum, %w[active inactive suspended]
    create_enum :gender_enum, %w[male female other undisclosed]
  end

  def down
    drop_enum :user_status_enum
    drop_enum :gender_enum
  end
end
