class Funnel < RestModel
  validates :name, presence: true
  validates :description, presence: true

  belongs_to :app
end