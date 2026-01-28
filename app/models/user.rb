class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :rewards
  has_many :orders

  after_create :grant_founding_reward, :grant_early_access_reward, :grant_hidden_reward

  def grant_founding_reward
    # I don't love the way this is built but there's bigger fish to fry
    return if User.count > 100

    rewards.create!(
      name: "Founding Member",
      description: "First 100 Pickled Pirates Racing members"
    )
  end

  def grant_early_access_reward
    cutoff = Date.new(2026, 8, 15)

    return if created_at.to_date >= cutoff

    rewards.find_or_create_by!(
      name: "Early Member"
    ) do |r|
      r.description = "Account created before Estranged Drags 2026"
    end
  end

  def grant_hidden_reward
    cutoff = Date.new(2026, 3, 1)

    return if created_at.to_date > cutoff

    rewards.find_or_create_by!(
      name: "Whoa, how'd you find this"
    ) do |r|
      r.description = "Involuntary site tester"
    end
  end

  def claim_estranged_drags_2026_reward(code)
    reward_code = "ESTRANGED2026tnine"

    return false unless code.casecmp?(reward_code)

    rewards.find_or_create_by!(
      name: "Estranged Drags 2026 Attendee"
    ) do |r|
      r.description = "Got Pickled at Estranged Drags 2026"
    end

    true
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
