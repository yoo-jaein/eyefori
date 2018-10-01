class Kindergarden < ActiveRecord::Base
    paginates_per 10
    has_many :users
    has_many :children
    # has_many :buses
end
