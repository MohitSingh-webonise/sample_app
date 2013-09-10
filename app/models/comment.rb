class Comment < ActiveRecord::Base
  belongs_to :micropost
  validates :content, presence: true, length: { maximum: 140 }
end
