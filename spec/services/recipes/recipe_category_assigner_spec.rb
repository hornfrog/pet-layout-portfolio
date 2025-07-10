# spec/services/recipes/recipe_category_assigner_spec.rb
require 'rails_helper'

RSpec.describe Recipes::RecipeCategoryAssigner, type: :service do
  let(:recipe)      { build(:recipe) }
  let(:parent)      { create(:category) }
  let(:child)       { create(:category, parent: parent) }
  let(:grandchild)  { create(:category, parent: child) }

  describe '#assign' do
    context 'when grandchild_category_id is present' do
      let(:params) { { recipe: { grandchild_category_id: grandchild.id, child_category_id: child.id, category_id: parent.id } } }

      it 'grandchild_id を採用' do
        described_class.new(recipe, params).assign
        expect(recipe.category_id).to eq(grandchild.id)
      end
    end

    context 'when only child_category_id is present' do
      let(:params) { { recipe: { child_category_id: child.id } } }

      it 'child_id を採用' do
        described_class.new(recipe, params).assign
        expect(recipe.category_id).to eq(child.id)
      end
    end

    context 'when only category_id is present' do
      let(:params) { { recipe: { category_id: parent.id } } }

      it 'parent_id を採用' do
        described_class.new(recipe, params).assign
        expect(recipe.category_id).to eq(parent.id)
      end
    end

    context 'when no category IDs are provided' do
      let(:params) { { recipe: {} } }

      it 'category_id は nil のまま' do
        described_class.new(recipe, params).assign
        expect(recipe.category_id).to be_nil
      end
    end
  end
end
