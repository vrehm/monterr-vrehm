require "csv"

class ImportJob < ApplicationJob
  queue_as :default

  def perform(csv, **options)
    options = options.merge({headers: true, header_converters: :symbol})
    options = options.merge({ col_sep: ";" }) unless options[:col_sep]
    options = options.merge({ encoding: "ISO-8859-1" }) unless options[:encoding]
    intercommunalities, communes = {}, {}
    
    CSV.foreach(csv, **options) do |row|
      time = Time.zone.now

      intercommunalities[row[:siren_epci]] ||= {
        siren: row[:siren_epci],
        name: row[:nom_complet],
        form: row[:form_epci].downcase.gsub("metro", "met"),
        slug: row[:nom_complet].parameterize,
        created_at: time,
        updated_at: time,
        population: 0
      }

      communes[row[:insee]] ||= {
        code_insee: row[:insee],
        name: row[:nom_com],
        population: row[:pop_total],
        intercommunality_id: nil,
        created_at: time,
        updated_at: time,
        siren_epci: row[:siren_epci] 
      }
    end

    Intercommunality.upsert_all(intercommunalities.values, unique_by: :siren)
    inter_db = Intercommunality.pluck(:siren, :id).to_h
    
    communes.values.each do |commune|
      commune[:intercommunality_id] = inter_db[commune[:siren_epci]]
      commune.delete(:siren_epci)
    end
    Commune.upsert_all(communes.values, unique_by: :code_insee)

    pop_calculation = Commune.group(:intercommunality_id).sum(:population)

    intercommunalities.each do |siren, intercommunality|
      id = inter_db[siren]
      population = pop_calculation[id]
      intercommunality[:population] = population
      intercommunality[:updated_at] = Time.zone.now
    end

    Intercommunality.upsert_all(intercommunalities.values, unique_by: :siren)
    puts "#{intercommunalities.size} intercommunes, #{communes.size} communes"
  end
end