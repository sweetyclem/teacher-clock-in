class ClockInsController < ApplicationController
  before_action :set_clock_in, only: [:edit, :update, :destroy]

  # GET /clock_ins
  def index
    @clock_ins = ClockIn.all
    @current_teacher = current_teacher
  end

  # GET /clock_ins/1/edit
  def edit
  end
  
  # POST /clock_ins
  def create
    @clock_in = ClockIn.new()
    @clock_in.start = DateTime.current
    @clock_in.teacher_id = current_teacher.id

    if @clock_in.save
      current_teacher.current_clock_in = @clock_in
      current_teacher.save
      flash[:notice] = 'Clock in was successfully created.'
      redirect_to :action => "index"
    else
      flash[:notice] = 'Error creating the clock in'
      redirect_to :action => "index"
    end
  end
  
  # PATCH/PUT /clock_ins/1
  def update
    if !@clock_in.end
      @clock_in.end = DateTime.current
      current_teacher.current_clock_in = nil
      current_teacher.save
    end
    if @clock_in.update(clock_in_params)
      flash[:notice] = 'Clock in was successfully ended.'
      redirect_to :action => "index"
    else
      flash[:notice] = 'Error ending the clock in'
      redirect_to :action => "index"
    end
  end

  # DELETE /clock_ins/1
  def destroy
    @clock_in.destroy
    flash[:notice] = 'Clock in was successfully deleted.'
      redirect_to :action => "index"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clock_in
      @clock_in = ClockIn.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clock_in_params
      params.fetch(:clock_in, {}).permit(:start, :end)
    end
end
