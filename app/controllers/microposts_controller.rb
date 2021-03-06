class MicropostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user,   only: :destroy

  # GET /microposts
  # GET /microposts.json
  def index
    @microposts = Micropost.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @microposts }
    end
  end

  # GET /microposts/1
  # GET /microposts/1.json
  def show
    @micropost = Micropost.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @micropost }
    end
  end
=begin


  # GET /microposts/new
  # GET /microposts/new.json
  def new
    @micropost = Micropost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @micropost }
    end
  end
=end

  # GET /microposts/1/edit
  def edit
    @micropost = Micropost.find(params[:id])
  end

  # POST /microposts
  # POST /microposts.json
  def create
    params[:micropost][:write_time] = DateTime.new(params[:micropost][:write_year].to_i,params[:micropost][:write_month].to_i,params[:micropost][:write_day].to_i)

    @micropost = current_user.microposts.build(params[:micropost])
    success = @micropost.save
    # Due to @micropost.micropost_subjects micropost_id is nil, move @micropost.save
    # after subject_ids assignment will cause @micropost.save fail
    @micropost.subject_ids = params[:selected_subject_ids]
    success = @micropost.save if success
    if success
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
=begin
  # PUT /microposts/1
  # PUT /microposts/1.json
  def update
    @micropost = Micropost.find(params[:id])

    respond_to do |format|
      if @micropost.update_attributes(params[:micropost])
        format.html { redirect_to @micropost, notice: 'Micropost was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end
=end
=begin
{"utf8"=>"✓", "_method"=>"put", "authenticity_token"=>"2oJ7TdPVzqVgUeNwq9QEehiK2t5bZYIy0peyruxvgH4=",
"micropost"=>{"content"=>"xlu post 1", "user_id"=>"101", "subject_id"=>""},
"selected_subject_ids"=>["11"],
"commit"=>"Update Micropost", "action"=>"update", "controller"=>"microposts", "id"=>"301"}
=end
  def update
    @micropost = current_user.microposts.find(params[:id])
    @micropost.subject_ids = params[:selected_subject_ids]
    params[:micropost][:write_time] = DateTime.new(params[:micropost][:write_year].to_i,params[:micropost][:write_month].to_i,params[:micropost][:write_day].to_i)

    respond_to do |format|
      if @micropost.update_attributes(params[:micropost])
        flash[:notice] = 'Micropost was successfully updated.'
        format.html { redirect_back_or @micropost }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /microposts/1
  # DELETE /microposts/1.json
  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

  def correct_user
    @micropost = current_user.microposts.where(id: params[:id]).first
    redirect_to root_url if @micropost.nil?
  end
end
