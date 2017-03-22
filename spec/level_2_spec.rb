require 'rails_helper'

RSpec.describe "Level 2: few models methods" do

  describe "Intercommunality", type: :model do

    let(:subject) do
      Intercommunality.create!(
        name:  'Montpellier Métropole',
        form:  'met',
        siren: '243400017'
      )
    end

    describe '#communes_hash' do
      it "returns a hash with :code_insee in keys and :name in values" do
        subject.communes << Commune.create(name: 'Montpellier', code_insee: '34172')
        subject.communes << Commune.create(name: 'Baillargues', code_insee: '34022')
        subject.communes << Commune.create(name: 'Vendargues' , code_insee: '34327')

        expect(subject.communes_hash).to eq({
          '34022' => 'Baillargues',
          '34172' => 'Montpellier',
          '34327' => 'Vendargues'
        })
      end
    end

    describe '#slug' do
      it "generates a slug on save" do
        expect(subject.slug).to eq('montpellier-metropole')
      end

      it "no longer changes slug when name change" do
        subject.update(name: "Montpellier Méditerranée Métropole")
        expect(subject.slug).to eq('montpellier-metropole')
      end

      it "regenerates slug on demand" do
        subject.update(name: "Montpellier Méditerranée Métropole", slug: nil)
        expect(subject.slug).to eq('montpellier-mediterranee-metropole')
      end
    end
  end

  describe "Commune", type: :model do

    describe '.search' do
      let!(:montpellier) { Commune.create(name: 'Montpellier', code_insee: '34172') }
      let!(:baillargues) { Commune.create(name: 'Baillargues', code_insee: '34022') }
      let!(:vendargues)  { Commune.create(name: 'Vendargues' , code_insee: '34327') }
      let!(:perols)      { Commune.create(name: 'Pérols'     , code_insee: '34327') }

      it "searches through communes by their name" do
        results = Commune.search('Montpellier')

        expect(results.size).to eq(1)
        expect(results).to include(montpellier)
      end

      it "searches with insensitive case" do
        results = Commune.search('PÉROLS')

        expect(results.size).to eq(1)
        expect(results).to include(perols)
      end

      it "searches with partial name" do
        results = Commune.search('argue')

        expect(results.size).to eq(2)
        expect(results).to include(baillargues)
        expect(results).to include(vendargues)
      end

      it "searches and escapes special characters" do
        results = Commune.search('%argue')

        expect(results.size).to eq(0)
      end

      it "is chainable" do
        results = Commune.search('montpellier')

        expect(results.limit(3)).to be_an(ActiveRecord::Relation)
        expect(results.pluck(:code_insee)).to be_an(Array)
      end
    end

    describe '.to_hash' do
      it "returns a hash with :code_insee in keys and :name in values" do
        Commune.create(name: 'Montpellier', code_insee: '34172')
        Commune.create(name: 'Baillargues', code_insee: '34022')
        Commune.create(name: 'Vendargues' , code_insee: '34327')

        expect(Commune.to_hash).to eq({
          '34022' => 'Baillargues',
          '34172' => 'Montpellier',
          '34327' => 'Vendargues'
        })
      end
    end
  end
end
