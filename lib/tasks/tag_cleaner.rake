namespace :tag_cleaner do
  desc "delete unused tags"
  task :delete_unused => :environment do
    ActsAsTaggableOn::Tag.joins(
      "LEFT JOIN taggings on taggings.tag_id = tags.id").where("taggings.id is null").delete_all
  end

end