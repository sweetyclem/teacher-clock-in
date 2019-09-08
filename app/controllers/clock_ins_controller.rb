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
    ClockIn.transaction do
      if !current_teacher.is_clocked_in
        @clock_in = ClockIn.new()
        @clock_in.start = DateTime.current
        @clock_in.teacher_id = current_teacher.id
        
        if @clock_in.save
          current_teacher.last_clock_in_id = @clock_in.id
          current_teacher.is_clocked_in = true
          current_teacher.save
          flash[:notice] = 'Clock in was successfully created.'
          redirect_to :action => "index"
          return
        end
      end
    end
    flash[:notice] = 'Error creating the clock in'
    redirect_to :action => "index"
  end
  
  # PATCH/PUT /clock_ins/1
  def update
    ClockIn.transaction do    
      if current_teacher.is_clocked_in
        @clock_in.end = DateTime.current
        current_teacher.is_clocked_in = false
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
  end

  # DELETE /clock_ins/1
  def destroy
    ClockIn.transaction do
      if current_teacher.is_clocked_in
        current_teacher.is_clocked_in = false
      end
      if current_teacher.last_clock_in_id == @clock_in.id
        current_teacher.last_clock_in_id = nil
        current_teacher.save
      end
      @clock_in.destroy
    end
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
