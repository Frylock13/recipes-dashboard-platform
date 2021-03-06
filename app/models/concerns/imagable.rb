module Imagable
  # This module helps to find and set image for object before it will be created
  extend ActiveSupport::Concern

  def upload_an_image
    # stop executing if image passes in params 
    return if image.present?

    api = Api::ImagesSearch.new(self.name)
    response = api.get_response
    results = api.get_filtered_array_of_results(response.body)
    self.image = try_to_get_image(results.first)
  end

  private

  def try_to_get_image(image)
    begin
      image = open(image)
    rescue
      # write to missed.log id of object which has an error(with an image probably)
      write_debug_info_to_log
    end

    image
  end

  def write_debug_info_to_log
    class_name = self.class.name
    
    if self.class.last
      object_id = self.class.last.id + 1
    else
      1
    end

    file_path = Rails.root.join('log', 'missed.log')
    open(file_path, 'a') do |f|
      f.puts "#{class_name} - #{object_id}"
    end
  end
end