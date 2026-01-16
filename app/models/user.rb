class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :rewards
  
  after_create :grant_founding_reward

  def grant_founding_reward
    # I don't love the way this is built but there's bigger fish to fry
    return if User.count > 100

    rewards.create!(
      name: "Founding Member",
      description: "First 100 Pickled Pirates Racing members"
    )
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
