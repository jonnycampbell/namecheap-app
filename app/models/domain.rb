class Domain < ActiveRecord::Base
  include Constants
  include ActionView::Helpers::NumberHelper

  ## Associations
  has_many :category_domains
  has_many :categories, through: :category_domains

  ## Validations
  validates :name, presence: true

  # ## Callbacks
  before_save :set_tld

  ## Scopes
  scope :opened, ->{ where("closing_on >= :now", now: DateTime.current) }
  scope :closed, ->{ where("closing_on < :now", now: DateTime.current) }
  scope :active, ->{ opened.where(active: true) }
  scope :inactive, ->{ where active: false }

  def self.generate_csv_file
    domains = self.all
    path = Tempfile.new('namecheap_app')
    CSV.open(path, "wb") do |csv|
      csv << DOMAIN_CSV_HEADER
      domains.each{ |d| csv << d.to_csv }
    end
    File.new(path)
  end

  def closed?
    self.closing_on.past?
  end

  def to_csv
    DOMAIN_CSV_ATTRS.map{ |method| self.public_send(method) }
  end

  def formatted_price
    number_to_currency(self.price)
  end

  ## Methods: formatted_closing_on, formatted_listed_on, formatted_expires_on
  %i[closing_on listed_on expires_on].each do |name|
    define_method :"formatted_#{name}" do
      self.public_send(name).try(:strftime, '%b %d %Y, %I:%M%p')
    end
  end

  def category_names
    self.categories.pluck(:name).join(', ')
  end

  private
  def set_tld
    self.tld = self.name.to_s.split('.')[1..-1].join('.')
  end
end
