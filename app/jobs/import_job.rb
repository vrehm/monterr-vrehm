require "csv"

class ImportJob < ApplicationJob
  queue_as :default

  def perform(csv)
    intercommunalities, communes = {}, {}
    
    CSV.foreach(csv, headers: true, col_sep: ";", encoding: "ISO-8859-1", header_converters: :symbol) do |row|
    # CSV.foreach(csv, headers: true, col_sep: ",", encoding: "UTF-8", header_converters: :symbol) do |row|
      intercommunalities[row[:siren_epci]] ||= {
        siren: row[:siren_epci],
        name: row[:nom_complet],
        form: row[:form_epci].downcase.gsub("metro", "met"),
        slug: row[:nom_complet].parameterize,
        created_at: Time.now,
        updated_at: Time.now,
        population: 0
      }

      communes[row[:insee]] ||= {
        code_insee: row[:insee],
        name: row[:nom_com],
        population: row[:pop_total],
        intercommunality_id: nil,
        created_at: Time.now,
        updated_at: Time.now,
        siren_epci: row[:siren_epci] 
      }
    end

    Intercommunality.upsert_all(intercommunalities.values, unique_by: :siren)
    inter_db = Intercommunality.all.pluck(:siren, :id).to_h
    
    communes.values.each do |commune|
      commune[:intercommunality_id] = inter_db[commune[:siren_epci]]
      commune.delete(:siren_epci)
    end
    Commune.upsert_all(communes.values, unique_by: :code_insee)

    intercommunalities.each do |siren, intercommunality|
      id = inter_db[siren]
      population = Intercommunality.where(id: id).includes(:communes).sum("communes.population")
      intercommunality[:population] = population
      intercommunality[:updated_at] = Time.now
    end

    Intercommunality.upsert_all(intercommunalities.values, unique_by: :siren)
    puts "#{intercommunalities.size} intercommunes, #{communes.size} communes"
  end
end