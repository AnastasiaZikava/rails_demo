module Admin
  class ItemsController
    include JsonApi::ControllerHelper

    def index
      collection Item
    end
  end
end
