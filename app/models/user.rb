class User < ApplicationRecord

	def upcoming_events
		events.where('date > ?', Date.today)
	end

	def previous_events
		events.where('date < ?', Date.today)
	end

	def upcoming_attended_events
		attended_events.where('date > ?', Date.today)
	end

	def previous_attended_events
		attended_events.where('date < ?', Date.today)
	end

	validates :name, presence: true, uniqueness: true
	has_many :events
	has_many :user_events
	has_many :attended_events, through: :user_events, source: :event
end
