# CategoriesHelperは、カテゴリに関連するヘルパーメソッドを提供します。
module CategoriesHelper
  def category_navigation(categories)
    content_tag(:ul, class: "nav-menu") do
      safe_join(categories.map { |category| category_list_item(category) })
    end
  end

  private

  def category_list_item(category)
    content_tag(:li, class: "dropdown") do
      link_to(category.name, category_path(category)) +
        if category.subcategories.any?
          content_tag(:ul, class: "dropdown-menu") do
            safe_join(category.subcategories.map { |sub| category_sub_item(sub) })
          end
        else
          "".html_safe
        end
    end
  end

  def category_sub_item(sub)
    content_tag(:li, class: "dropdown") do
      link_to(sub.name, category_path(sub)) +
        if sub.subcategories.any?
          content_tag(:ul, class: "dropdown-menu") do
            safe_join(sub.subcategories.map { |child| content_tag(:li) { link_to(child.name, category_path(child)) } })
          end
        else
          "".html_safe
        end
    end
  end

  def category_selects(form, parent_name, child_name, grandchild_name, selected_values = {})
    parent_id = selected_values[:parent]
    parent_categories = Category.where(parent_id: nil)

    content_tag(:div, class: "category-select") do
      safe_join([
                  form.select(parent_name, options_from_collection_for_select(parent_categories, :id, :name, parent_id),
                              { prompt: "カテゴリを選択" }, { id: "search_parent_category" }),
                  form.select(child_name, [], { prompt: "カテゴリを選択" }, { id: "search_child_category" }),
                  form.select(grandchild_name, [], { prompt: "カテゴリを選択" }, { id: "search_grandchild_category" })
                ])
    end
  end
end
