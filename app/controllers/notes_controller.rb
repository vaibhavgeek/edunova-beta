class NotesController < ApplicationController
  def index
  	if params[:search] == ''
  		#redirect to path which has all the listed notes 
       redirect_to root_path
    elsif params[:search] and params[:search] != ''
  	   @notes = Note.search(params[:search]).paginate(:per_page => 5, :page => params[:page])
    else
 		@notes = nil

    end
    if current_user
    @mynotes = Note.where(:user_id => current_user.id).paginate(:per_page => 7, :page => params[:page])
    end

   end
  
 def explore
    @labels = Intrest.all    
    @notes_filter = Note.all.paginate(:per_page => 25, :page => params[:page]) 
 end

def discover 
  @passion = Passion.new
  @allpassion = Passion.all
end

def add_passion
@passion = Passion.new(passion_params)
@passion.user_id = current_user.id
@passion.save

end

def html_view
  if params[:id]
  @note = Note.friendly.find(params[:id])
  else
  @note = Note.friendly.find(params[:note_id])
  end  
  @widgets  = @note.notewidgets
  @cnt = 0
  
end

def display_widgets 
  if params[:id]
  @note = Note.friendly.find(params[:id])
  else
  @note = Note.friendly.find(params[:note_id])
  end  

end


  def new
  	@note = Note.new
    @note.notewidgets.build 
    @array_levels = [*1..6].to_json
  end


  def destroy
    @note = Note.friendly.find(params[:id])
    @note.destroy
    @mynotes = Note.where(:user_id => current_user.id)
  end


  def create
   @note = Note.new(note_params)
   @note.user_id = current_user.id 
     if @note.save
      note_params[:notewidgets_attributes][:note_id] = @note.id
      updatefeed = Feed.new(:user_id => current_user.id , :object_id => @note.id  , :set_type => 'create' , :fcontent => @note.note_from_author)           
      updatefeed.save   
      redirect_to :controller => 'notes', :action => 'show', :id => @note.id
    else
      render "new"
    end
  end


  def update
    @note = Note.friendly.find(params[:id])
    @note.update_attributes(note_params)
    redirect_to :controller => 'notes', :action => 'show', :id => @note.id         
              
  end


  def edit
    @note = Note.friendly.find(params[:id])
    @array_levels = [*1..6].to_json
  end


  def show
   @note = Note.friendly.find(params[:id])
@widgets  = @note.notewidgets
  @cnt = 0
  
  end


  def comment_view  
       @note = Note.friendly.find(params[:note_id])
  end


  def my_notes
    @mynotes = Note.where(:user_id => current_user.id).paginate(:per_page => 7, :page => params[:page])
  end

  def upvote
    @note = Note.friendly.find(params[:id])
    @note.upvote_by current_user
    updatefeed = Feed.new(:user_id => current_user.id , :object_id => @note.id  , :set_type => 'upvote')           
    updatefeed.save
    if current_user.id != @note.user_id
    sendnotif = Notification.find_or_create_by(:to_id => User.find(@note.user_id) , :from_id => current_user , :read => 0 ,:category => 'UYN' , :note_id => @note.id )
    end
  end
  
  def openlibrary
    
    
 end

 def search_results_videos
  videos = Yt::Collections::Videos.new
  if params[:selected_course][:course_tag] != 'all'
  @video_list = videos.where(q: params[:search].to_s , safe_search: 'none' , order: 'Relevance' , channel_id: params[:selected_course][:course_tag] ).first(4)
  else
  @video_list = videos.where(q: params[:search].to_s , safe_search: 'none' , order: 'Relevance').first(4)
  end 
 end
  def next_level
     @note = Note.friendly.find(params[:note_id])
     if  Play.where(:user_id => current_user.id , :note_id => @note.id ).count > 0
      play = Play.where(:user_id => current_user.id , :note_id => @note.id ).first
      p_cnt = play.p_count
      p_cnt = p_cnt + 1
    
        if play.current_level < params[:query].to_i
          play.update_attributes(:p_count => p_cnt , :current_level => params[:query].to_i)
        else
          play.update_attributes(:p_count => p_cnt)
        end
     else 
     play =  Play.new(:user_id => current_user.id , :note_id => @note.id , :p_count => 0 , :current_level => params[:query].to_i  )
     play.save
   end
   if @note.user_id != current_user.id 
     if play.current_level == @note.total_levels
      
         updatefeed = Feed.find_or_create_by(:user_id => current_user.id , :object_id => @note.id  , :set_type => 'play' )           
         updatefeed.save  
      end
      end
    
  end

  def unvote
    @note = Note.friendly.find(params[:id])
    @note.unvote_by current_user
    delfeedupvote = Feed.where(:user_id => current_user.id , :object_id => @note.id , :set_type => 'upvote')
    deletenotif =  Notification.where(:to_id => User.find(@note.user_id) , :from_id => current_user  ,:category => 'UYN' , :note_id => @note.id ).first
    if deletenotif
      deletenotif.destroy
    end
    delfeedupvote.destroy_all
 end


  private
  def note_params
   params.require(:note).permit(:name , :tag_list , :note_from_author ,:notewidgets_attributes => [:id , :note_id , :tag_one ,:tag_two ,:tag_three , :tag_four , :tag_five , :tag_six , :tag_seven , :set_type , :_destroy])
  end
  
  def passion_params
    params.require(:passion).permit(:label , :video_url)
  end

  
end

