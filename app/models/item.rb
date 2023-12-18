# encoding: utf-8
class Item < ApplicationRecord
  enum kind: { expenses: 1, income: 2 }
  validates :amount, presence: true
  validates :tags_id, presence: true
  validates :kind, presence: true
  validates :happen_at, presence: true

  # 自定义校验
  validate :check_tags_id_belong_to_user

  def check_tags_id_belong_to_user
    # 查询当前用户所有的tags
    all_tags_ids = Tag.where(user_id: self.user_id).map(&:id)

    # [] & [] 取交集
    # (a1 & a2) == a1    ----->    a1和a2的交集为a1，说明a1包含于a2
    if self.tags_id & all_tags_ids != self.tags_id
      self.errors.add :tags_id, "不属于当前用户"
    end
  end
end
