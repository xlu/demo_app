require 'will_paginate/array'

class SubjectsController < ApplicationController
  # GET /subjects
  # GET /subjects.json
  def index
    @subjects = Subject.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subjects }
    end
  end

  # GET /subjects/1
  # GET /subjects/1.json
  def show
    @subject = Subject.find(params[:id])
    # TODO optimize
    @microposts = @subject.microposts.sort{|a,b|
          a_write_year = a.write_year.blank? ? a.created_at.year.to_i : a.write_year.to_i
          b_write_year = b.write_year.blank? ? b.created_at.year.to_i : b.write_year.to_i
          b_write_year <=> a_write_year
        }.paginate(page: params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subject }
    end
  end

  # GET /subjects/new
  # GET /subjects/new.json
  def new
    @subject = Subject.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subject }
    end
  end

  # GET /subjects/1/edit
  def edit
    #@subject = Subject.find(params[:id])
    @subject = current_user.subjects.find(params[:id])
  end

  def create
    @subject = current_user.subjects.build(params[:subject])
    if @subject.save
      flash[:success] = "Subject created!"
    else
      flash[:error] = "Sorry, failed to save subject"
    end
    redirect_to "/users/#{current_user.id}"
  end

  # PUT /subjects/1
  def update
    @subject = Subject.find(params[:id])
    user = @subject.user

    respond_to do |format|
      if @subject.update_attributes(params[:subject])
        format.html { redirect_to user_path(user), notice: 'Subject was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /subjects/1
  def destroy
    @subject = Subject.find(params[:id])
    @subject.destroy

    redirect_to "/users/#{current_user.id}"
  end
end
