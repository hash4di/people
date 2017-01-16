class ContentsHistorySerializer < ActiveModel::Serializer
  attributes :user_id,
             :skill_id,
             :rate,
             :created_at,
             :updated_at,
             :note,
             :favorite,
             :name,
             :description,
             :rate_type,
             :category,
             :history,
             :first_change_before_data_range

  def description
    object.skill.description
  end

  def name
    object.skill.name
  end

  def rate_type
    object.skill.rate_type
  end

  def category
    object.skill.skill_category.name
  end

  def history
    if date_range_set?
      object.contents.within(start_date, end_date).order(:created_at)
    else
      object.contents.order(:created_at)
    end
  end

  def first_change_before_data_range
    if date_range_set?
      object.contents.where("created_at < ?", start_date).last
    else
      nil
    end
  end

  private

  def date_range_set?
    context.present? && start_date.present? && end_date.present?
  end

  def start_date
    context[:start_date]
  end

  def end_date
    context[:end_date]
  end
end
