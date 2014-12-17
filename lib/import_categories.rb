class ImportCategories
  include Constants

  def self.perform
    document = Nokogiri::HTML(open([BASE_HOST, MARKETPLACE_INDEX_PATH].join))
    category_labels = document.css(CATEGORY_LABELS_SELECTOR)

    category_labels.each do |label_element|
      Category.create(name: label_element.text, remote_id: label_element.attr('for')[/\d+/])
    end
  end
end
