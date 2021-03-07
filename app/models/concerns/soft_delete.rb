module SoftDelete
  extend ActiveSupport::Concern

  included do
    scope :kept, -> { where.not(deleted_at: nil) }
    scope :soft_deleted, -> { where(deleted_at: nil) }
  end

  def soft_delete!
    update_attribute(:deleted_at, Time.current)
  end

  def soft_deleted?
    self[:deleted_at].nil?
  end
end
