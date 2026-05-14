class WikiPage < ApplicationRecord
  RESERVED_SLUGS = %w[help new].freeze

  has_rich_text :body

  belongs_to :parent, class_name: "WikiPage", optional: true
  has_many :children, -> { order(:position, :title) }, class_name: "WikiPage", foreign_key: :parent_id, inverse_of: :parent, dependent: :nullify

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: { scope: :parent_id }
  validate :parent_must_not_create_cycle
  validate :slug_not_reserved

  before_validation :nilify_blank_parent_id
  before_validation :assign_slug

  scope :roots, -> { where(parent_id: nil).order(:position, :title) }
  scope :ordered_tree, -> { order(Arel.sql("parent_id NULLS FIRST"), :position, :title) }

  def self.sidebar_tree
    by_parent = includes(:rich_text_body).ordered_tree.group_by(&:parent_id)
    roots = by_parent[nil] || []
    [by_parent, roots]
  end

  # URL segment path, e.g. "boards" or "boards/baldrick8" (root slug first).
  def url_path
    chain = []
    node = self
    while node
      chain.unshift(node.slug)
      node = node.parent
    end
    chain.join("/")
  end

  def self.find_by_url_path(path_string)
    segments = path_string.to_s.split("/").map(&:presence).compact
    return nil if segments.empty?

    page = nil
    segments.each do |seg|
      scope = page ? WikiPage.where(parent_id: page.id) : WikiPage.where(parent_id: nil)
      page = scope.find_by(slug: seg)
      return nil unless page
    end
    page
  end

  # Resolve [[wiki link]]: full path "a/b", then slug/title heuristics.
  def self.find_for_wiki_link(target)
    target = target.to_s.strip
    return nil if target.blank?

    if target.include?("/")
      found = find_by_url_path(target)
      return found if found
    end

    find_by(slug: target, parent_id: nil) ||
      find_by(slug: target) ||
      ((param = target.parameterize.presence) && find_by(slug: param, parent_id: nil)) ||
      ((param = target.parameterize.presence) && find_by(slug: param)) ||
      where("LOWER(TRIM(title)) = ?", target.downcase.strip).first
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

  def slug_not_reserved
    return if slug.blank?

    errors.add(:slug, "is reserved — pick another slug") if RESERVED_SLUGS.include?(slug.downcase)
  end

  def nilify_blank_parent_id
    self.parent_id = nil if parent_id.blank?
  end

  def assign_slug
    base = title.to_s.parameterize
    base = "page" if base.blank?
    candidate = base
    suffix = 2
    while WikiPage.where(parent_id: parent_id).where.not(id: id).exists?(slug: candidate)
      candidate = "#{base}-#{suffix}"
      suffix += 1
    end
    self.slug = candidate
  end
end
