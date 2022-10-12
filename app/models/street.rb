class Street < ApplicationRecord
  has_many :commune_streets
  has_many :communes, through: :commune_streets
  validates :title, presence: true
  validates :from, :to, numericality: {only_integer: true, greater_than: 0}, allow_nil: true
  validate :to_is_greater_than_from

  private

  def to_is_greater_than_from
    errors.add(:to, ":to must be greater than :from") if from.present? && to.present? && from > to
  end
end
