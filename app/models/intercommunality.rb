class Intercommunality < ApplicationRecord
  has_many :communes
  validates :name, :siren, :slug, presence: true
  validates :siren, uniqueness: {case_sensitive: false}, format: {with: /\A\d{9}\z/}
  validates :form, inclusion: {in: %w[ca cu cc met]}
  before_validation :generate_slug, on: :create
  before_validation :update_slug, on: :update

  def communes_hash
    communes.pluck(:code_insee, :name).to_h
  end

  private

  def generate_slug
    self.slug = name.parameterize if name.present?
  end

  def update_slug
    self.slug = name.parameterize if name.present? && !slug.present?
  end
end
