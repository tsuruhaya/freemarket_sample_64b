class ItemsController < ApplicationController
  def index
    @parents = Category.all.where(ancestry:nil).order("id ASC").limit(13)
    @items = Item.includes(:item_images).order('created_at DESC').limit(6).where.not(transaction_status: 0).where(transaction_status: 1)
  end

  def new
    @category_parent_array = ["選択してください"]
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << parent.name
    end
    @item = Item.new
    @item.item_images.new
  end

  def create
    @item= Item.new(item_params)
    if @item.save
     redirect_to root_path
    else
     render :new
    end
end


  def show
    @item = Item.find(params[:id])
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def category_children
    respond_to do |format|
      format.html
      format.json do
        @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
      end
    end
  end

  def category_grandchildren
    respond_to do |format|
      format.html
      format.json do
        @category_grandchildren = Category.find(params[:child_id]).children
      end
    end
  end


  private

  def item_params
    params.require(:item).permit(:name, :price, :explanation,:condition,:deliverry_charge,:shipping_origin,:sending_days,item_images_attributes: [:image,:_destroy, :id])
  end
end
