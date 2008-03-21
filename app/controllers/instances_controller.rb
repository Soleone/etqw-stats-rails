class InstancesController < ApplicationController
	
	before_filter :fetch_player
	
	
	def index
		@instances = @player.instances.find(:all, :order => 'created_at')
		@stats = {}
		@instances.each { |instance| @stats[instance.id] = ETQWStats.parse(instance.data) }
	end
	
	
	def destroy
		if @player.instances.find(params[:id]).destroy
			flash[:notice] = "Successfully deleted instance # #{params[:id]} from player #{@player.name}"
		else
			flash[:error] = "Error while trying to delete instance # #{params[:id]} from player #{@player.name}"
		end
		redirect_to player_instances_path(@player)
	end
	
	
	def show
		@instance = @player.instances.find(params[:player_id])
	end
	
	
	# Downloads the current xml feed from official server and saves it, if it is newer
	def new
  	# redirect and show error if player not registered
  	if @player.nil?
  		flash[:error] = "Error: No registered Player found, sorry!"
  	end
  	xml = ETQWStats.download_for_user(@player.name)
  	stats = ETQWStats.parse(xml)
  	instance = Instance.new(:data => xml, :date => stats.user_info.updated_at)
  	
  	saved_dates = @player.instances.map {|i| i.date.to_date}
  	
  	unless saved_dates.include?(instance.date.to_date)
  		@player.instances << instance 
	  	if @player.save
	  		flash[:notice] = "Saved a new Session for user #{@player.name} for #{instance.date.to_s(:long)} !"
  	 	else
	  		flash[:error] = "Failure, while trying to capture the instance for player #{@player.name}"
	  	end
  	else
  		flash[:error] = "Already downloaded the newest session for player #{@player.name}"
  	end
  	redirect_to player_instances_url(@player)
  end
  
  
  def import
  	instance = Instance.new
  	respond_to do |format|
  		format.xml { @xml = request.body }
  		format.html { @xml = params[:xml]}
  	end
  		begin
  			ETQWStats.parse(@xml)
  			instance.data = @xml
  			@player.instances << instance
  			if @player.save
  				flash[:notice] = "Successfully imported your statistics from a file."
	  			redirect_to player_instances_path(@player)
				else
  				flash[:error] = "Your statistics file could not be imported!"
  			end
  		rescue ArgumentError
  			flash[:error] = "Your supplied statistics file is not valid, sorry!"
  		end
  		
  end
  
  
  #def compare
  #	@newer = ETQWStats.parse(@player.instances.find(params[:newer]).data)
  #	@older = ETQWStats.parse(@player.instances.find(params[:older]).data)
  #	@diff = @older - @newer
  #	render :partial => 'instance', :locals => {:stats => @diff}
  #end
  
  
  private
	def fetch_player
		@player = Player.find(params[:player_id])
	end
end
