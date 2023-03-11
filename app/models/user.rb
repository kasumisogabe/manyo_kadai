class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  
  has_secure_password

  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, length: { minimum: 6 }

  before_validation { email.downcase! }
  before_destroy :validate_admin_user_existence

  def admin?
    self.admin == true
  end

  private
  def validate_admin_user_existence
    if admin? && User.where(admin: true).count <= 1
      errors.add(:base, "管理者権限を持つユーザが必要です")
      throw :abort
    end
  end
end
