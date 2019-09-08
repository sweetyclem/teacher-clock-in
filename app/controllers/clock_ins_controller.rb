class ClockInsController < ApplicationController
  before_action :set_clock_in, only: [:edit, :update, :destroy, :end]
  before_action :authenticate_teacher!
  before_action :require_permission, only: [:edit, :update, :destroy, :end]

  # GET /clock_ins
  def index
    @clock_ins = current_teacher.clock_ins.order(created_at: :desc)
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
        else
          flash[:notice] = 'Error creating the clock in.'
        end
      else
        flash[:notice] = 'Error creating the clock in.'
      end
    end
    redirect_to :action => "index"
  end
  
  # POST /end
  def end
    ClockIn.transaction do
      new_end = DateTime.current
      current_teacher.is_clocked_in = false
      current_teacher.save
      params[:clock_in] = { id: @clock_in.id, end: new_end }
      update
    end
  end

  # PATCH/PUT /clock_ins/1
  def update
    ClockIn.transaction do
      if @clock_in.update(clock_in_params)
        flash[:notice] = 'Clock in was successfully ended.'
      else
        flash[:notice] = 'Error ending the clock in.'
      end
    end
    redirect_to :action => "index"
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
      if @clock_in.destroy
        flash[:notice] = 'Clock in was successfully deleted.'
      else
        flash[:notice] = 'Error ending the clock in.'
      end
    end
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

    def require_permission
      if current_teacher != ClockIn.find(params[:id]).teacher
        flash[:notice] = 'Unpermitted action.'
        redirect_to root_path
      end
    end
end
