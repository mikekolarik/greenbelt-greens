class AddOwnerEmailToReferralCode < ActiveRecord::Migration
  def change
    add_column :referral_codes, :owner_email, :string

    ReferralCode.all.each do |ref_code|
      unless ref_code.user_id.nil?
        user = User.where(id: ref_code.user_id).first
        ref_code.owner_email = user.try(:email)
        ref_code.save
      end
    end

  end
end
