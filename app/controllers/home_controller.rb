class HomeController < ApplicationController
  def index
	if current_user
		@notifications = Notification.where(:to_id => current_user ).where.not(:from_id => current_user).order('created_at DESC').paginate(:per_page => 15, :page => params[:page_notif])	
		@unread_count = @notifications.where(read: 0).count
	end
  if params[:tag]
    @notes_filter = Note.tagged_with(params[:tag]).order('created_at DESC') 
  else
   @notes_filter = Note.all.where(:spam => 1).paginate(:per_page => 15, :page => params[:page]).order('created_at DESC') 
  end
  end
  def mark_as_read
   @notifications = Notification.where(:to_id => current_user ).where.not(:from_id => current_user)
   @notifications.update_all(read: 1)		

  end
  def admin
    
  end
  def activity
      # searchlabels = params[:search].to_s.strip(",")
      if params[:search] 
        @notes_filter = Note.isearch(params[:search]).paginate(:per_page => 15, :page => params[:page]).order('created_at DESC')     
      else
        @notes_filter = Note.all.paginate(:per_page => 15, :page => params[:page]).order('created_at DESC')
      end
  end
end
