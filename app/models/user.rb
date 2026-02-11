class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :rewards
  has_many :orders
  has_many :parts, dependent: :destroy

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

  def claim_reward(code)
    normalized = code.to_s.strip

    case normalized.downcase
    when "estranged2026tnine"
      rewards.find_or_create_by!(
        name: "Estranged Drags 2026 Attendee"
      ) do |r|
        r.description = "Got Pickled at Estranged Drags 2026"
      end
      true
    when "42069"
      rewards.find_or_create_by!(
        name: "42069 Club"
      ) do |r|
        r.description = "Nice. You found the code."
      end
      true
    else
      false
    end
  end

  def grant_profile_completed_reward
    return if first_name.blank? || last_name.blank?

    rewards.find_or_create_by!(
      name: "Profile Completed"
    ) do |r|
      r.description = "Filled out first and last name"
    end
  end

  def grant_swap_meet_post_rewards!(part_count: nil)
    count = part_count || parts.count

    [
      { threshold: 1, name: "Swap Meet Apprentice", description: "Posted your first Swap Meet listing" },
      { threshold: 2, name: "Swap Meet Journeyman", description: "Posted 2 Swap Meet listings" },
      { threshold: 3, name: "Swap Meet Parts Pusher", description: "Posted 3 Swap Meet listings" },
      { threshold: 5, name: "Swap Meet Regular", description: "Posted 5 Swap Meet listings" },
      { threshold: 25, name: "Swap Meet Legend", description: "Posted 25 Swap Meet listings" }
    ].each do |entry|
      next if count < entry[:threshold]

      rewards.find_or_create_by!(name: entry[:name]) do |r|
        r.description = entry[:description]
      end
    end
  end

  def grant_swap_meet_delete_reward!
    rewards.find_or_create_by!(
      name: "Swap Meet Cleanup"
    ) do |r|
      r.description = "Deleted a Swap Meet listing"
    end
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
