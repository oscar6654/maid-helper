# require 'elasticsearch/model'
class Job < ApplicationRecord
  belongs_to :user
  has_many :applicants, dependent: :destroy
  def self.text_search(query)
    self.where("similarity(title, ?) > 0.2 or similarity(work_location, ?) > 0.1 or similarity(job_description, ?) > 0.6", query,query,query).order("similarity(title, #{ActiveRecord::Base.connection.quote(query)}) DESC")
  end
  # , similarity(job_description, ?) > 0.3, similarity(work_location, ?) > 0.5
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks
  # def self.search(query)
  #   __elasticsearch__.search(
  #     {
  #       query: {
  #         multi_match: {
  #           query: query,
  #           fields: ['title^5', 'text'],
  #           fields: ['work_location^4', 'text']
  #         }
  #       }
  #     }
  #   )
  # end

end
# Job.import force: true
