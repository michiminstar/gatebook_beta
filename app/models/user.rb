class User < ActiveRecord::Base
  has_many :posts,  dependent: :destroy
  has_many :user_friendships, foreign_key: 'user_id', dependent: :destroy
  has_many :reverse_friendships, foreign_key: 'friend_id',
                                                            class_name: "UserFriendship",
                                                            dependent: :destroy
  has_many :friends, through: :user_friendships, source: :friend

  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true

  def feed
    Post.from_friends_with(self)
  end

  def friend?(other_user)
    user_friendships.find_by(friend_id: other_user.id)
  end

  def add_friend!(other_user)
    user_friendships.create!(friend_id: other_user.id)
    other_user.user_friendships.create!(friend_id: id)
  end

  def unfriend!(other_user)
    user_friendships.find_by(friend_id: other_user.id).destroy
    other_user.user_friendships.find_by(friend_id: id).destroy
  end
end
