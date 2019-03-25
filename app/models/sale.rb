class Sale < ApplicationRecord
  before_create :generate_guide
  belongs_to :content

  private

  def generate_guide
    self.guid = SecureRandom.uuid()
  end
end
