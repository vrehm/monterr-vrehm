require 'rails_helper'

RSpec.describe "Level 4: manipulating data" do

  describe 'ImportTask' do
    let(:csv) { Rails.root.join('spec/fixtures/epcicom.csv') }
    subject!  { ImportJob.perform_now(csv) }

    it "imports the intercommunalities" do
      expect(Intercommunality.count).to eq(3)

      expect(Intercommunality.find_by(
        siren: "243400017",
        name:  "Montpellier Méditerranée Métropole",
        form:  'met'
      )).to be_present

      expect(Intercommunality.find_by(
        siren: "246400030",
        name:  "CA Agglomération Côte Basque Adour",
        form:  'ca'
      )).to be_present

      expect(Intercommunality.find_by(
        siren: "243301504",
        name:  "CC du Bassin d'Arcachon Nord Atlantique",
        form:  'cc'
      )).to be_present
    end

    it "imports the communes" do
      expect(Commune.count).to eq(44)

      expect(Commune.find_by(
        code_insee: "34172",
        name:       "Montpellier",
        population: 276054
      )).to be_present

      expect(Commune.find_by(
        code_insee: "34249",
        name:       "Saint-Drézéry",
        population: 2317
      )).to be_present
    end

    it "links communes & intercommunalities" do
      montpellier = Commune.find_by(code_insee: "34172")
      metropole   = Intercommunality.find_by(siren: "243400017")

      expect(montpellier.intercommunality).to eq(metropole)
      expect(metropole.communes.count).to eq(31)
    end

    it "sums population" do
      metropole = Intercommunality.find_by(siren: "243400017")

      expect(metropole.population).to eq(449026)
    end

    it "avoids duplicates when running third times" do
      2.times { ImportJob.perform_now(csv) }

      expect(Intercommunality.count).to eq(3)
      expect(Commune.count).to eq(44)
    end
  end
end
