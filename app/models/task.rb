class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50}
  validates :content, presence: true,  length: { maximum: 200}
  scope :latest, -> {order(limit: :desc)}

  def self.search(search)
    return Task.all unless search
    Task.where('title LIKE(?)', "%#{search}%")
  end
end
