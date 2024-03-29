class GroupsController < ApplicationController

	before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

	def index
		@groups = Group.all
	end

	def new
		@group = Group.new
	end

	def show
		@group = Group.find(params[:id])
		@posts = @group.posts
	end

	def edit
		@group = current_user.groups.find(params[:id])
	end

	def create
		@group = current_user.groups.create(group_params)

		if @group.save
			current_user.join!(@group)
			redirect_to groups_path
		else
			render :new
		end
	end
	
	def update
		@group = current_user.groups.find(params[:id])

		if @group.update(group_params)
			redirect_to groups_path, notice: "修改討論版成功"
		else
			render :edit
		end
	end

	def destroy
		@group = current_user.groups.find(params[:id])
		@group.destroy
		redirect_to groups_path, alert: "討論板已刪除"
	end

	def join
		@group = Group.find(params[:id])

		if !current_user.is_member_of?(@group)
			current_user.join!(@group)
			flash[:notice] = "你成功加入這個討論版摟！！"
		else
			flash[:warning] = "沒有人已經是成員還在加入的啦XD"
		end

		redirect_to group_path(@group)
	end

	def quit
		@group = Group.find(params[:id])

		if current_user.is_member_of?(@group)
			current_user.quit!(@group)
			flash[:alert] = "早知如此，何必加入QQ"
		else
			flash[:warning] = "你又不是成員，麥來亂哦XD"
		end

		redirect_to group_path(@group)
	end

	private

	def group_params
		params.require(:group).permit(:title, :description)
		
	end

end
