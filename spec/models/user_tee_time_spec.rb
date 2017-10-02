require 'rails_helper'

RSpec.describe UserTeeTime, type: :model do

  let(:attributes) do {
      username: "tylerB",
      email: "tyler@gmail.com",
      password: "123456",
      password_confirmation: "123456"
    }
  end

  it "belongs to a User" do
    user_tee_time = UserTeeTime.create(tee_time_id: 1)
    user = User.create(attributes)
    user_tee_time.user = user
    expect(user_tee_time.user).to eq(user)
  end
end
