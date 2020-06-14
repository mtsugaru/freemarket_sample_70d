class ProductsController < ApplicationController
  before_action :set_product, except: [:index, :new, :create]
  before_action :set_category, only: [:index, :new, :show]

  def index
    # ↓第3回スプリントレビュー用 終了後削除願います
    @product = Product.all.last
    @image = Image.find_by(product_id: @product)
    # ↑第3回スプリントレビュー用 終了後削除願います
  end

  def new
    @product = Product.new
    @product.images.new
    end
  
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to root_path
    else
      flash[:edit_product] = "必須項目に誤りがあります。もう一度ご確認の上、お試しください。"
      redirect_to edit_product_path(@product)
    end
  end

  def destroy
    if @product.destroy
      redirect_to root_path
    else
      render :show
    end
  end

  def check
    @image = Image.find_by(product_id: params[:id])
    @user = User.find(current_user.id)
    @creditcard = Creditcard.find_by(user_id: current_user.id)
    if @creditcard.present?
      Payjp.api_key = Rails.application.credentials.test_secret_key
      customer = Payjp::Customer.retrieve(@creditcard.customer_id)
      @card = customer.cards.retrieve(@creditcard.card_id)
      @exp_month = @card.exp_month.to_s
      @exp_year = @card.exp_year.to_s.slice(2,3)
    end
  end

  def buy
    if @product.buyer.present?
      flash[:add_creditcard] = "申し訳ございません。先に他のお客様が購入されました。"      
      redirect_to product_path(@product.id)
    else
      @product.with_lock do
        if current_user.creditcard.present?
          @creditcard = Creditcard.find_by(user_id: current_user.id)
          Payjp.api_key = Rails.application.credentials.test_secret_key
          Payjp::Charge.create(
            amount: @product.price,
            customer: @creditcard.customer_id,
            currency: 'jpy'
          )
          @product.update(buyer: current_user.id)
          redirect_to root_path
        else
          flash[:add_creditcard] = "クレジットカードの登録をお願いします。"
          redirect_to new_creditcard_path
        end
      end
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :explanation, :category_id, :brand, :product_status_id, :delivery_cost_id, :shipping_origin_id, :delivery_day_id, :price, images_attributes: [:image, :_destroy, :id]).merge(user_id: current_user.id)
  end

  # 商品情報
  def set_product
    @product = Product.find(params[:id])
  end

  def set_category
    @parents = Category.where(ancestry: nil).order("id ASC")
  end
end
