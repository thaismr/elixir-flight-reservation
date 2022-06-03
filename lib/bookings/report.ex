defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(filename \\ "report.csv") do
    booking_list = build_booking_list()

    File.write(filename, booking_list)
  end

  defp build_booking_list() do
    BookingAgent.list_all()
    |> Map.values()
    |> Enum.map(&booking_string/1)
  end

  defp booking_string(%Booking{
         user_id: user_id,
         complete_date: complete_date,
         local_origin: local_origin,
         local_destination: local_destination
       }) do
    "#{user_id},#{local_origin},#{local_destination},#{complete_date}\n"
  end
end
