class User < ActiveRecord::Base
  acts_as_token_authenticatable
  has_and_belongs_to_many :dietary_goals
  has_and_belongs_to_many :dietary_preferences
  has_and_belongs_to_many :ingredients
  belongs_to :meal_type
  has_one :referral_code
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #validates_numericality_of :plan_id, :customer_id, :subscription_id
  validates_uniqueness_of :email
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :first_name, :last_name, length: { maximum: 40 }
  validates_format_of :email, {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Wrong Email"}
  validates :plan_id, inclusion: { in: [10027, 10028], message: "Wrong Plan Id" }, allow_nil: true
  validates :phone, :length => { :minimum => 10, :maximum => 15 }, allow_blank: true

  def admin?
    self.admin
  end
end
