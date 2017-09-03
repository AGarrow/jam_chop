class JamsController < ApplicationController
  before_action :set_jam, only: [:show, :edit, :update, :destroy]

  def index
    @jams = Jam.all
  end

  def show
  end

  def new
    @jam = Jam.new
  end

  def edit
  end

  def create
    @jam = Jam.new(jam_params)

    respond_to do |format|
      if @jam.save
        format.html { redirect_to @jam, notice: 'Jam was successfully created.' }
        format.json { render :show, status: :created, location: @jam }
      else
        format.html { render :new }
        format.json { render json: @jam.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @jam.update(jam_params)
        format.html { redirect_to @jam, notice: 'Jam was successfully updated.' }
        format.json { render :show, status: :ok, location: @jam }
      else
        format.html { render :edit }
        format.json { render json: @jam.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @jam.destroy
    respond_to do |format|
      format.html { redirect_to jams_url, notice: 'Jam was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jam
      @jam = Jam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jam_params
      params.fetch(:jam, {})
    end
end
