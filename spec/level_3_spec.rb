require 'rails_helper'

RSpec.describe "Level 3: controllers", type: :request do
  subject { response }

  describe "Communes requests"  do
    let(:met) { Intercommunality.create(name: "Métropole", siren: "123456789", form: "met") }
    let(:commune) { Commune.create(name: 'Montpellier', code_insee: '34172', intercommunality: met) }

    describe "#index" do
      it "responds with success in JSON" do
        get("/communes")
        expect(response).to have_http_status(:success)
      end

      it "is not acceptable in HTML" do
        get("/communes.html")
        expect(response).to have_http_status(:not_acceptable)
      end
    end

    describe '#create' do
      it "is forbidden" do
        post("/communes")
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "#show" do
      it "requires :code_insee to identify resource" do
        get("/communes/#{commune.id}")
        expect(response).to have_http_status(:not_found)
      end

      it "responds with success" do
        get("/communes/#{commune.code_insee}")
        expect(response).to have_http_status(:success)
      end
    end

    describe "#update" do
      it "requires :code_insee to identify resource" do
        put("/communes/#{commune.id}")
        expect(response).to have_http_status(:not_found)
      end

      it "requires attributes to update" do
        put("/communes/#{commune.code_insee}")
        expect(response).to have_http_status(:bad_request)
      end

      it "updates the resource and responds with empty response" do
        put("/communes/#{commune.code_insee}", params: { commune: {name: "Commune de Montpellier"} })
        expect(response).to have_http_status(:no_content)
        expect{ commune.reload }.to change(commune, :name).to("Commune de Montpellier")
      end
    end
  end
end
