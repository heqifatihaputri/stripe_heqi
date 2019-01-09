class User < ActiveRecord::Base
  Stripe.api_key = Rails.application.secrets.stripe_secret_key
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :products
  has_many :credit_cards
  validates :email, presence: true

  # after_commit :assign_customer_id, on: :create
  after_create :assign_customer_id

  def assign_customer_id
    customer = Stripe::Customer.create(email: email)
    customer_id = customer.id
    self.update(customer_id: customer_id)
  end
end
