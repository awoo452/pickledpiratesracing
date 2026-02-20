module Parts
  class DestroyPart
    Result = Struct.new(:success?, :part, keyword_init: true)

    def self.call(user:, id:)
      new(user: user, id: id).call
    end

    def initialize(user:, id:)
      @user = user
      @id = id
    end

    def call
      part = if @user.admin?
        Part.find(@id)
      else
        @user.parts.find(@id)
      end
      part.destroy
      @user.grant_swap_meet_delete_reward!
      Result.new(success?: true, part: part)
    rescue ActiveRecord::RecordNotFound
      Result.new(success?: false, part: nil)
    end
  end
end
