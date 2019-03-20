class ItemSerializer
  include ModelSerializer
  include AllAttributes
  include AssetAttributes
  include HasStatus

  asset :image

  belongs_to :category
  has_many :tags
end
