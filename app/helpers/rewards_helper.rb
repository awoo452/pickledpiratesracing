module RewardsHelper
  REWARD_ICONS = {
    "Founding Member" => "🏴‍☠️",
    "Early Member" => "⏳",
    "Whoa, how'd you find this" => "🧪",
    "Estranged Drags 2026 Attendee" => "🏁",
    "42069 Club" => "😏",
    "Profile Completed" => "✅"
  }.freeze

  def reward_icon(reward)
    REWARD_ICONS[reward.name] || "✨"
  end
end
