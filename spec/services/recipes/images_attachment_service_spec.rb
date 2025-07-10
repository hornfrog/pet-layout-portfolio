require 'rails_helper'

RSpec.describe Recipes::ImagesAttachmentService, type: :service do
  include ActionDispatch::TestProcess::FixtureFile

  let(:recipe) { create(:recipe) }

  let(:images) do
    [
      fixture_file_upload(Rails.root.join('spec/fixtures/test_image.png'), 'image/png'),
      fixture_file_upload(Rails.root.join('spec/fixtures/test_image.png'), 'image/png')
    ]
  end

  describe '#attach' do
    context 'when images are attached' do
      it '画像が添付される' do
        described_class.new(recipe, images).attach
        expect(recipe.images.size).to eq 2
      end
    end

    context 'when no images are provided' do
      it '画像が添付されない' do
        expect do
          described_class.new(recipe, []).attach
        end.not_to change(ActiveStorage::Attachment, :count)
      end
    end
  end

  describe '#purge' do
    before { described_class.new(recipe, images).attach }

    it '指定 ID のみ削除', :aggregate_failures do
      id_to_remove = recipe.images.first.id

      expect do
        described_class.new(recipe, nil).purge([id_to_remove])
      end.to change { recipe.images.reload.count }.from(2).to(1)

      expect(recipe.images.reload.pluck(:id)).not_to include(id_to_remove)
    end
  end
end
