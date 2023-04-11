class Order < ApplicationRecord
  belongs_to :user

  # 把訂單加上隨機序號
  before_create :serial_generator

  # 狀態機套件，可以order有狀態並更新狀態
  include AASM

  # state machine，且不要讓他從外部直接去改status的值
  aasm column: "status", no_direct_assignment: true do
    state :pending, initial: true
    state :paid, :failed, :cancelled, :refunded

    event :pay do
      transitions from: :pending, to: :paid

      # 在狀態更改後要做的，有user是因為order belongs_to user，在付款後把user改成vip
      after { user.update(role: "vip") }
    end

    event :refund do
      transitions from: :paid, to: :refunded
    end

    event :fail do
      transitions from: :pending, to: :failed
    end

    event :cancel do
      transitions from: %i[pending paid], to: :cancelled
    end
  end

  private

  def serial_generator
    self.serial =
      Time.current.strftime("%Y%m%d") +
        SecureRandom.alphanumeric.to_s.rjust(6, "0")
  end
end
