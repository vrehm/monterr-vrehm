class Commune < ApplicationRecord
  belongs_to :intercommunality
  has_many :commune_street
  has_many :streets, through: :commune_street
  validates :name, :code_insee, presence: true
  validates :code_insee, format: {with: /\A\d{5}\z/}
  # counter_culture :intercommunality, column_name: "population", delta_column: "population"

  scope :search, ->(query) { where("name LIKE ?", "%#{sanitize_sql_like(query.downcase)}%") }

  def self.to_hash
    all.pluck(:code_insee, :name).to_h
  end
end
