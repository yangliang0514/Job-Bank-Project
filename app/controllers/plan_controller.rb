class PlanController < ApplicationController
  before_action :authenticate_user!

  def payment
    return record_not_found unless plan_available?

    # generate a payment token for the frontend
    @token = gateway.client_token.generate

    @price = plans[params[:id].to_sym]
    @plan = plans.key(@price).to_s.upcase
  end

  def pay
    return record_not_found unless plan_available?

    plan = params[:id]
    price = plans[plan.to_sym]
    nonce = params[:nonce]

    # 建立訂單
    order = current_user.orders.create(plan: plan, amount: price)

    result =
      gateway.transaction.sale(amount: price, payment_method_nonce: nonce)

    if result.success?
      # 那個aasm套件給的方法，用來改變order的狀態
      order.pay!
      return redirect_to root_path, notice: "已成功付款#{price}元"
    end

    order.fail!
    redirect_to root_path, alert: "付款失敗"
  end

  private

  def plan_available?
    plans.keys.include?(params[:id].to_sym)
  end

  def plans
    { a: 100, b: 500, c: 1000 }
  end

  def gateway
    Braintree::Gateway.new(
      environment: :sandbox,
      merchant_id: ENV["BRAINTREE_MERCHANT_ID"],
      public_key: ENV["BRAINTREE_PUBLIC_KEY"],
      private_key: ENV["BRAINTREE_PRIVATE_KEY"],
    )
  end
end
