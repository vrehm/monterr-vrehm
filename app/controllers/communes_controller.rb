class CommunesController < ApplicationController
  before_action :set_commune, only: [:show, :update]

  def index
    render json: Commune.to_hash
  end

  def show
    render(json: @commune)
  end

  def create
    head :forbidden
  end

  def update
    @commune.update(commune_params)
  end

  private

  def set_commune
    @commune = Commune.find_by!(code_insee: params[:id])
  end

  def commune_params
    params.require(:commune).permit(:name)
  end
end
