# frozen_string_literal: true

class DailyDigest
  def send_digest
    User.find_each(batch_size: 500) do |user|
      DigestMailer.digest(user).deliver_later
    end
  end
end
