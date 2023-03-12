class Task < ApplicationRecord
  belongs_to :user
  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings, source: :label
  accepts_nested_attributes_for :labels

  validates :title, presence: true, length: { maximum: 50}
  validates :content, presence: true,  length: { maximum: 200}

  enum priority: { 高: "1", 中: "2", 低: "3" }

  scope :latest, -> {order(limit: :desc)}
  scope :by_keyword, -> (keyword) { where("title LIKE ?", "%#{keyword}%") if keyword.present? }
  scope :by_status, -> (status) { where(status: status) if status.present? }
  scope :search_title_status, -> (title, status){where('title LIKE ?',"%#{title}%").where(status: status)}
  scope :priority_sort, -> {order(priority: :asc)}
  scope :search_name, -> (label_search) { joins(:labels).where("labels.name LIKE ?", "%#{label_search}%") if label_search.present? }

  def self.search(search)
    return Task.all unless search
    Task.where('title LIKE(?)', "%#{search}%")
  end
end
