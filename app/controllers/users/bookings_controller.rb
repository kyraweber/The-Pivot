class Users::BookingsController < ApplicationController
  before_action :redirect_to_login_if_not_logged_in, only: [:index]

  def create
    cart = @cart.content
    booking = current_user.bookings.create(trip_name: params[:trip_name])
    booking.generate_reservations(cart)
    session[:cart]={}
    redirect_to traveler_path(current_user),
      notice: "Your itinerary has been successfully booked. Happy travels!"
  end

  def index
    redirect_to traveler_path(current_user)
  end

end
