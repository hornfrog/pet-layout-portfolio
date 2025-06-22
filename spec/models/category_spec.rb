require 'rails_helper'

RSpec.describe Category, type: :model do
  subject(:category) { described_class.new }

  describe 'アソシエーション' do
    it { is_expected.to belong_to(:parent).class_name('Category').optional }

    it {
      expect(category).to have_many(:subcategories)
        .class_name('Category')
        .with_foreign_key('parent_id')
        .dependent(:destroy)
    }

    it { is_expected.to have_many(:recipes).dependent(:destroy) }
  end

  describe 'インスタンスメソッド' do
    let!(:parent) { create(:category, name: '親カテゴリ') }
    let!(:child) { create(:category, name: '子カテゴリ', parent: parent) }
    let!(:grandchild) { create(:category, name: '孫カテゴリ', parent: child) }

    describe '#self_and_descendants_ids' do
      it '自身と子孫のIDをすべて含む' do
        expect(parent.self_and_descendants_ids).to contain_exactly(parent.id, child.id, grandchild.id)
      end

      it '子カテゴリは孫カテゴリを含む' do
        expect(child.self_and_descendants_ids).to contain_exactly(child.id, grandchild.id)
      end
    end

    describe '#self_and_ancestors' do
      it '自分とすべての先祖カテゴリを順に返す' do
        expect(grandchild.self_and_ancestors).to eq([parent, child, grandchild])
      end
    end

    describe '#descendant_ids' do
      it '子と孫のIDを返す' do
        expect(parent.descendant_ids).to contain_exactly(child.id, grandchild.id)
      end

      it '自分自身のIDは含まれない' do
        expect(parent.descendant_ids).not_to include(parent.id)
      end
    end
  end

  describe 'カテゴリ削除時の関連削除' do
    let!(:parent) { create(:category) }
    let!(:child) { create(:category, name: '子カテゴリ', parent: parent) }

    it '親カテゴリを削除すると子カテゴリも削除される' do
      expect { parent.destroy }.to change(described_class, :count).by(-2)
    end

    it 'カテゴリ削除で関連するレシピも削除される' do
      create(:recipe, category: parent)
      expect { parent.destroy }.to change(Recipe, :count).by(-1)
    end
  end
end
