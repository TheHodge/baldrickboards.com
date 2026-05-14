class WikiPage < ApplicationRecord
  has_rich_text :body

  belongs_to :parent, class_name: "WikiPage", optional: true
  has_many :children, -> { order(:position, :title) }, class_name: "WikiPage", foreign_key: :parent_id, inverse_of: :parent, dependent: :nullify

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validate :parent_must_not_create_cycle

  before_validation :nilify_blank_parent_id
  before_validation :assign_slug

  scope :roots, -> { where(parent_id: nil).order(:position, :title) }
  scope :ordered_tree, -> { order(Arel.sql("parent_id NULLS FIRST"), :position, :title) }

  def self.sidebar_tree
    by_parent = includes(:rich_text_body).ordered_tree.group_by(&:parent_id)
    roots = by_parent[nil] || []
    [by_parent, roots]
  end

  def subtree_ids
    WikiPage.where(parent_id: id).flat_map { |c| [c.id] + c.subtree_ids }
  end

  def parent_select_options
    exclude = new_record? ? [] : [id] + subtree_ids
    scope = WikiPage.order(:title)
    scope = scope.where.not(id: exclude) if exclude.any?
    scope.pluck(:title, :id)
  end

  def parent_must_not_create_cycle
    return if parent_id.blank?

    walker_id = parent_id
    while walker_id
      if walker_id == id
        errors.add(:parent_id, "cannot be nested under itself or a descendant")
        return
      end
      walker_id = WikiPage.find_by(id: walker_id)&.parent_id
    end
  end

  private

  def nilify_blank_parent_id
    self.parent_id = nil if parent_id.blank?
  end

  def assign_slug
    base = title.to_s.parameterize
    base = "page" if base.blank?
    candidate = base
    suffix = 2
    while WikiPage.where.not(id: id).exists?(slug: candidate)
      candidate = "#{base}-#{suffix}"
      suffix += 1
    end
    self.slug = candidate
  end
end
