class NotesController < ApplicationController
  before_filter :require_user
  before_filter :require_owner, except: [:index, :new, :create]

  # GET /notes.json
  def index
    @notes = current_user.notes
      .paginate( page:     params[:page],
                 per_page: 5,
                 order:    "created_at DESC")
    render json: @notes.map{|note| note.to_hash }
  end

  # GET /notes/1.json
  def show
    @note = Note.find(params[:id])
    render json: @note.to_hash
  end

  # POST /notes.json
  def create
    @note = Note.create!(params[:note].merge(user_id: current_user.id))
    render json: @note.to_hash
  end

  # PUT /notes/1.json
  def update
    @note = Note.find(params[:id])
    @note.update_attributes!(params[:note])
    render json: @note.to_hash
  end


  #################### Filter
  def require_owner
    @note = Note.find(params[:id])
    if @note.user != current_user
      raise UnauthorizedAccess, I18n.t("error.unauthorized_access")
    end
  end
  #################### Filter
end
