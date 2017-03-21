class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_microposts, ->{order created_at: :desc}
  scope :feeds, -> id {where "user_id IN (SELECT followed_id FROM relationships
    WHERE  follower_id = #{id}) OR user_id = #{id}"}
  mount_uploader :picture, PictureUploader
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, I18n.t("invalid_picture_size")
    end
  end
end
