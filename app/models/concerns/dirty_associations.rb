module DirtyAssociations
  extend ActiveSupport::Concern

  attr_accessor :has_dirty_associations

  def dirty_associations(assoc)
    self.has_dirty_associations = true
  end

  def saved_changes?
    has_dirty_associations || super
  end
end
