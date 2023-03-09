class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50}
  validates :content, presence: true,  length: { maximum: 200}

  scope :latest, -> {order(limit: :desc)}
  scope :by_keyword, -> (keyword) { where("title LIKE ?", "%#{keyword}%") if keyword.present? }
  scope :by_status, -> (status) { where(status: status) if status.present? }
  scope :search_title_status, -> (ttitle, status){where('title LIKE ?',"%#{title}%").where(status: status)}


  def self.search(search)
    return Task.all unless search
    Task.where('title LIKE(?)', "%#{search}%")
  end
end
