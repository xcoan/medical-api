class Patient < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :date_of_birth, presence: true
  validates :phone_number, presence: true
  validates :medical_history, presence: true
  validates :medication, presence: true

  self.per_page = 10

  def self.search(search)
    where("name ILIKE ?", "%#{search}%").all
  end
end
