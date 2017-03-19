require 'rails_helper'

RSpec.describe "Level 3: controllers" do

  describe "CommunesController", type: :controller do
    def self.described_class
      CommunesController
    end

    let(:commune) { Commune.create(name: 'Montpellier', code_insee: '34172') }

    describe "#index" do
      it "responds with success in JSON" do
        expect(
          get(:index, format: :json)
        ).to have_http_status(:success)
      end

      it "is not acceptable in HTML" do
        expect(
          get(:index, format: :html)
        ).to have_http_status(:not_acceptable)
      end
    end

    describe '#create' do
      it "is forbidden" do
        expect(
          post(:create)
        ).to have_http_status(:forbidden)
      end
    end

    describe "#show" do
      it "requires :code_insee to identify resource" do
        expect(
          get(:show, params: { id: commune.id })
        ).to have_http_status(:not_found)
      end

      it "responds with success" do
        expect(
          get(:show, params: { id: commune.code_insee })
        ).to have_http_status(:success)
      end
    end

    describe "#update" do
      it "requires :code_insee to identify resource" do
        expect(
          put(:update, params: { id: commune.id })
        ).to have_http_status(:not_found)
      end

      it "requires attributes to update" do
        expect(
          put(:update, params: { id: commune.code_insee })
        ).to have_http_status(:bad_request)
      end

      it "updates the resource and responds with empty response" do
        expect(
          put(:update, params: {
            id: commune.code_insee,
            commune: {
              name: "Commune de Montpellier"
            }
          })
        ).to have_http_status(:no_content)

        expect{ commune.reload }.to change(commune, :name).to("Commune de Montpellier")
      end
    end
  end
end
