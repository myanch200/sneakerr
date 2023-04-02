class Review < ApplicationRecord
  belongs_to :user
  belongs_to :sneaker
  validates :body, presence: true

  after_destroy_commit -> { broadcast_remove_to [sneaker, :reviews], target: self }
  after_create_commit :broadcast_create
  after_update_commit :broadcast_update

  def broadcast_create
    broadcast_append_to(
        [sneaker, :reviews],
        partial: 'reviews/simple_review',
        target: dom_id(sneaker, :reviews),
        locals: {review: self }
    )
  end

  def broadcast_update
    broadcast_replace_later_to(
      [sneaker, :reviews],
      partial: 'reviews/simple_review',
      locals: {review: self }
    )
  end
end
