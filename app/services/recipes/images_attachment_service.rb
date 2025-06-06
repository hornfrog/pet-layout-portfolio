module Recipes
  # 画像の添付を担当するサービスクラス
  # 使用例:
  #   Recipes::ImagesAttachmentService.new(recipe, images).attach!
  class ImagesAttachmentService
    def initialize(recipe, images)
      @recipe = recipe
      @images = images
    end

    def attach
      return if @images.blank?

      @images.each { |image| @recipe.images.attach(image) }
    end

    def purge(removed_image_ids)
      return if removed_image_ids.blank?

      removed_image_ids.each do |id|
        image = @recipe.images.find_by(id: id)
        image&.purge
      end
    end
  end
end
