class Commune < ApplicationRecord
  belongs_to :intercommunality
  has_many :commune_streets
  has_many :streets, through: :commune_streets
  validates :name, :code_insee, presence: true
  validates :code_insee, uniqueness: true, format: {with: /(\d{5})|(\d{1}(A|B)\d{3})/}

  scope :search, ->(query) { where("name LIKE ?", "%#{sanitize_sql_like(query.downcase)}%") }

  def self.to_hash
    pluck(:code_insee, :name).to_h
  end
end
