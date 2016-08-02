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
  
  activities = []

activities += Notearticle.where(:note_id => @note.id).all.map do |art|
  Activity.new(art.content, nil ,nil , nil , nil , nil , nil , nil , nil, art.created_at , 'article')
end
  
activities += Notequestion.where(:note_id => @note.id).all.map do |quest|
  Activity.new(nil, quest.question_text, quest.option1 , quest.option2 , quest.option3 ,quest.option4 , quest.correct_answer, quest.solution_explain , quest.hint , quest.created_at , 'question')
end


activities += Noteapplet.where(:note_id => @note.id).all.map do |app|
  Activity.new(app.content, nil ,nil , nil , nil , nil , nil , nil , nil, app.created_at , 'applet')
end

# descending sort by 'date' field
# 10 most recent elements across all models
@widgets = activities.sort_by(&:created_at)
@cnt = 0
end

def display_widgets
 
  if params[:id]
  @note = Note.friendly.find(params[:id])
  else
  @note = Note.friendly.find(params[:note_id])
  end  
  
  activities = []

activities += Notearticle.where(:note_id => @note.id).all.map do |art|
  Activity.new(art.content, nil ,nil , nil , nil , nil , nil , nil , nil, art.created_at , 'article')
end
  
activities += Notequestion.where(:note_id => @note.id).all.map do |quest|
  Activity.new(nil, quest.question_text, quest.option1 , quest.option2 , quest.option3 ,quest.option4 , quest.correct_answer, quest.solution_explain , quest.hint , quest.created_at , 'question')
end


activities += Noteapplet.where(:note_id => @note.id).all.map do |app|
  Activity.new(app.content, nil ,nil , nil , nil , nil , nil , nil , nil, app.created_at , 'applet')
end

# descending sort by 'date' field
# 10 most recent elements across all models
@widgets = activities.sort_by(&:created_at)

end


  def new
  	@note = Note.new
    @note.notearticles.build 
    @hash = AmazonSignature::data_hash
    @array_levels = [*1..6].to_json
  end


  def destroy
    @note = Note.friendly.find(params[:id])
    @deletefeed = Feed.where(:object_id => @note.id)
    @deletecommets = Comment.where(:note_id => @note.id )
    @deletenotifications = Notification.where(:note_id => @note.id)
    @deletefeed.destroy_all
    @deletecommets.destroy_all
    @deletenotifications.destroy_all
    @note.destroy
    @mynotes = Note.where(:user_id => current_user.id).paginate(:per_page => 7, :page => params[:page])
  end


  def create
   @note = Note.new(note_params)
   @note.user_id = current_user.id
   @hash = AmazonSignature::data_hash
   @labels = note_params[:prereq].split(",")
      @labels.each do |intr|
        Intrest.find_or_create_by(value: intr.strip.to_s)
      end  
   
                 if @note.save
                   updatefeed = Feed.new(:user_id => current_user.id , :object_id => @note.id  , :set_type => 'create' , :fcontent => @note.note_from_author)           
                   updatefeed.save   
                   redirect_to :controller => 'notes', :action => 'show', :id => @note.id
                 else
                   render "new"
                 end
              
   
  end


  def update
    @note = Note.friendly.find(params[:id])
     @labels = note_params[:prereq].split(",")
      @labels.each do |intr|
        Intrest.find_or_create_by(value: intr.strip.to_s)
      end  
   @note.total_levels = note_params[:file].to_s.split('<hr>').count
    if @note.total_levels <= 6
             
                 if @note.update(note_params)
                   redirect_to :controller => 'notes', :action => 'show', :id => @note.id
              end
   end
  end


  def edit
    @note = Note.friendly.find(params[:id])
    @hash = AmazonSignature::data_hash    
    if current_user.id == 51 || @note.user_id == current_user.id
      @array_levels = [*1..6].to_json
      @a,@b = "false"
              if @note.description == 'insight'
                @a = "true"
              else
                @b = "true"
              end
      else
       redirect_to notes_my_notes_path
      end
  end


  def show
   @note = Note.friendly.find(params[:id])
    activities = []
    @current_widgets = 1

activities += Notearticle.where(:note_id => @note.id).all.map do |art|
  Activity.new(art.content, nil ,nil , nil , nil , nil , nil , nil , nil, art.created_at , 'article')
end
  
activities += Notequestion.where(:note_id => @note.id).all.map do |quest|
  Activity.new(nil, quest.question_text, quest.option1 , quest.option2 , quest.option3 ,quest.option4 , quest.correct_answer, quest.solution_explain , quest.hint , quest.created_at , 'question')
end


activities += Noteapplet.where(:note_id => @note.id).all.map do |app|
  Activity.new(app.content, nil ,nil , nil , nil , nil , nil , nil , nil, app.created_at , 'applet')
end

# descending sort by 'date' field
# 10 most recent elements across all models
@widgets = activities.sort_by(&:created_at)


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
    sendnotif = Notification.new(:to_id => User.find(@note.user_id) , :from_id => current_user , :read => 0 ,:category => 'UYN' , :note_id => @note.id )
    sendnotif.save
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
   params.require(:note).permit(:name , :prereq , :note_from_author , :notearticles_attributes => [:id , :content , :_destroy] , :noteapplets_attributes => [:id , :content , :_destroy] , :notequestions_attributes => [:id , :question_text , :option1 ,:option2 ,:option3 , :option4 , :correct_answer , :hint , :solution_explain , :_destroy])
  end
  
  def passion_params
    params.require(:passion).permit(:label , :video_url)
  end

  
end

class Activity < Struct.new(:content, :question_text, :option1 , :option2 , :option3 , :option4 , :correct_answer , :solution_explain ,:hint , :created_at , :type); end
