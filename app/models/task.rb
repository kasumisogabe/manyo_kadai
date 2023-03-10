class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 50}
  validates :content, presence: true,  length: { maximum: 200}

  enum priority: { 高: "1", 中: "2", 低: "3" }

  scope :latest, -> {order(limit: :desc)}
  scope :by_keyword, -> (keyword) { where("title LIKE ?", "%#{keyword}%") if keyword.present? }
  scope :by_status, -> (status) { where(status: status) if status.present? }
  scope :search_title_status, -> (title, status){where('title LIKE ?',"%#{title}%").where(status: status)}
  scope :priority_sort, -> {order(priority: :asc)}

  def self.search(search)
    return Task.all unless search
    Task.where('title LIKE(?)', "%#{search}%")
  end
end
