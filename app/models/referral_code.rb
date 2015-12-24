class ReferralCode < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :secret_code
  validates_uniqueness_of :secret_code

  def self.create_new_referral_code(user_id = nil)
    random_string = generate_random_string
    ref_code = ReferralCode.create!(secret_code: random_string, user_id: user_id)
    unless user_id.nil?
      user = User.where(id: user_id).first
      ref_code.owner_email = user.email
      ref_code.save!
    end
    ref_code
  end

  def self.generate_random_string
    o = [('0'..'9'), ('A'..'Z')].map { |i| i.to_a }.flatten
    string = (0...5).map { o[rand(o.length)] }.join
  end


end
