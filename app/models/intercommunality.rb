class Intercommunality < ApplicationRecord
  has_many :communes
  validates :name, :siren, presence: true
  validates :siren, uniqueness: {case_sensitive: false}, format: {with: /\A\d{9}\z/}
  validates :form, inclusion: {in: %w[ca cu cc met me]}
  before_save :generate_slug

  def communes_hash
    communes.to_hash
  end

  private

  def generate_slug
    self.slug = name.parameterize unless slug.present?
  end
end
