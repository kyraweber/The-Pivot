class Booking < ActiveRecord::Base
  belongs_to :user
  enum status: %w(pending completed cancelled)
  scope :pending, -> { where(status: 0)}
  scope :completed, -> { where(status: 1) }
  scope :cancelled, -> { where(status: 2) }

=begin
  def pending?
    status == "pending"
  end

  def total
    listings_with_quantity.reduce(0) do |total, (listing, quantity)|
      total += line_listing_total(listing, quantity)
    end
  end

  def self.generate_booking(user, cart)
    create(user_id: user.id, cart: cart)
  end
=end

  def total_days_per_booking
    cart.each { |listing_id, dates| cart[listing_id] = dates.count('=') }.values.reduce(:+)
  end

  def listings_per_cart
    cart.count { |listing_id, dates| cart[listing_id] = dates.count('=') }
  end

  def parse_listings
    cart.reduce({}) do |hash, (listing_id, dates)|
      hash[Listing.find(listing_id)] = dates
      hash
    end
  end

  def line_listing_total(listing, dates)
    listing.price * dates.size
  end

  def self.sort_by_status(status)
    case status
    when nil
      Booking.all
    when '0'
      Booking.pending
    when '1'
      Booking.completed
    when '2'
      Booking.cancelled
    end
  end


end