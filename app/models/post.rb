class Post < ActiveRecord::Base
  belongs_to :user
  has_many :likes
  has_many :liked_posts, through: :likes, source: :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "5MB以下の画像をアップロードしてください。")
      end
    end

    def self.from_friends_with(user)
      friend_ids = "SELECT user_id FROM user_friendships
                              WHERE friend_id = :user_id"
      where("user_id IN (#{friend_ids}) OR user_id = :user_id", 
                  user_id: user.id )
    end
end
