require "csv"

class ImportJob < ApplicationJob
  queue_as :default

  def perform(csv)
    intercommunalities, communes = {}, {}
    CSV.foreach(csv, headers: true, col_sep: ";", encoding: "ISO-8859-1", header_converters: :symbol) do |row|
      intercommunalities[row[:siren_epci]] ||= create_intercommunality({
        siren: row[:siren_epci],
        name: row[:nom_complet],
        form: row[:form_epci]
      })
      communes[row[:insee]] ||= create_commune({
        code_insee: row[:insee],
        name: row[:nom_com],
        population: row[:pop_total],
        intercommunality: row[:siren_epci]
      })
    end
    intercommunalities.each do |siren, intercommunality|
      intercommunality = Intercommunality.find_by_siren(intercommunality[:siren])
      intercommunality.update!(population: intercommunality.communes.sum(:population))
    end
    puts "#{intercommunalities.size} intercommunes, #{communes.size} communes"
  end

  private

  def create_intercommunality(raw_hash)
    raw_hash[:form] = raw_hash[:form].downcase.gsub("metro", "met")
    raw_hash[:slug] = raw_hash[:name].parameterize
    Intercommunality.create!(raw_hash) unless Intercommunality.find_by_siren(raw_hash[:siren]).present?
    raw_hash
  end

  def create_commune(raw_hash)
    intercommunality = Intercommunality.find_by_siren(raw_hash[:intercommunality])
    return if intercommunality.nil?
    raw_hash.delete(:intercommunality)
    raw_hash[:intercommunality_id] = intercommunality.id
    Commune.create!(raw_hash) unless Commune.find_by_code_insee(raw_hash[:code_insee]).present?
    raw_hash
  end
end