class Sale < ApplicationRecord
  before_create :generate_guide
  belongs_to :content
  include AASM

  aasm column: 'state' do
    state :sleeping, initial: true
    state :running, :completed
    state :errored

    event :running, after: :charge_card do
      transitions from: :sleeping, to: :running
    end

    event :complete do
      transitions from: :running, to: :completed
    end

    event :fail do
      transitions from: :running, to: :errored
    end


  end

  def charge_card
    begin
      save!
      charge = Stripe::Charge.create(
        amount: self.amount,
        currency: "eur",
        card: self.stripe_token,
        description: "vendita di un contenuto"
      )
      self.update(stripe_id: charge.id)
      self.complete!
    rescue Stripe::StripeError => e
      self.update_attributes(error: e.message)
      self.fail!
    end
  end

  private

  def generate_guide
    self.guid = SecureRandom.uuid()
  end
end
