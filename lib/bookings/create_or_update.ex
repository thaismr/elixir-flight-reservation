defmodule Flightex.Bookings.CreateOrUpdate do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking
  alias Flightex.Users.Agent, as: UserAgent

  def call(%{
        complete_date: complete_date,
        local_origin: local_origin,
        local_destination: local_destination,
        user_id: user_id
      }) do
    case Booking.build(complete_date, local_origin, local_destination, user_id) do
      {:ok, booking} -> BookingAgent.save(booking)
      {:error, reason} -> reason
    end
  end
end
