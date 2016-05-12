class MenuItemsController < ApplicationController
  helper_method :menu_items

  def index
    @menu_items = MenuItem.all
  end

  def show
    @menu_item = MenuItem.find(params[:id])
  end

  def new
    @menu_item = MenuItem.new
  end

  def edit
    @menu_item = MenuItem.find(params[:id])
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)

    if @menu_item.save
      redirect_to menu_item_path(@menu_item),
        success: "Menu item created successfully!"
    else
      render :new
    end
  end

  def update
    @menu_item = MenuItem.new(menu_item_params)

    if @menu_item.update(menu_item_params)
      redirect_to menu_item_path(@menu_item),
        success: 'Menu item was successfully updated!! Hooray'
    else
      render action: 'edit'
    end
  end

  def destroy
    MenuItem.find(params[:id]).destroy
    redirect_to menu_items_path,
      success: "Menu item was successfully destroyed"
  end

  private
  def menu_items
    @menu_items ||= MenuItem.all
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price_in_cents, :category)
  end
end
