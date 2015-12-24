class Admin::CategoriesGroupsController < Admin::ApplicationController

  def index
    @groups = CategoriesGroup.all
  end

  def show
    @group = CategoriesGroup.find(params[:id])
  end

  def new
    @group = CategoriesGroup.new
  end

  def create
    @group = CategoriesGroup.new(permitted_params[:categories_group])
    if @group.save
      service = RefreshCategoriesInGroup.call(group: @group,
                                              group_categories_ids: permitted_params_for_categories[:categories][:group_categories_ids],
                                              categories_ids: permitted_params_for_categories[:categories][:categories_ids])
      if service.success
        flash[:notice] = "Group was successfully created"
        redirect_to admin_categories_groups_path
      else
        @group.destroy
        flash[:notice] = "Something went wrong"
        render 'new'
      end
    else
      flash[:notice] = "Something went wrong"
      render 'new'
    end
  end

  def update
    @group = CategoriesGroup.find(params[:id])
    service = RefreshCategoriesInGroup.call(group: @group,
                                            group_categories_ids: permitted_params_for_categories[:categories][:group_categories_ids],
                                            categories_ids: permitted_params_for_categories[:categories][:categories_ids])
    if @group.update_attributes(permitted_params[:categories_group]) && service.success
      flash[:notice] = "Group was successfully updated"
      redirect_to admin_categories_groups_path
    else
      flash[:notice] = "Something went wrong"
      render 'show'
    end
  end

  def destroy
    service = DeleteGroup.call(group_id: params[:id])
    flash[:notice] = "Group was successfully deleted"
    redirect_to admin_categories_groups_path
  end

  private

  def permitted_params
    { categories_group:
        params.fetch(:categories_group, {}).permit(:name, :order_index) }
  end

  def permitted_params_for_categories
    { categories:
        params.permit(group_categories_ids: [], categories_ids: []) }
  end
end
