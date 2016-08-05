class Education < ActiveRecord::Base
  before_validation :smart_add_url_protocol
  belongs_to :profile

  validates :school, presence: true
  validates :degree, presence: true
  validates :school_url, :url => {:allow_blank => true}
  validates :from_date, presence: true
  validates :to_date, presence: true

  mount_uploader :image, EducationImageUploader

  # Include model in search
  include PgSearch
  multisearchable against: [:degree, :description, :school]
  
  protected

  def smart_add_url_protocol
    unless self.school_url.empty?
      unless self.school_url.include?("http")
        unless self.school_url[/\^http:\/\//] || self.school_url[/\^https:\/\//]
          self.school_url = "http://#{self.school_url}"
        end
      end
    end
  end

end
