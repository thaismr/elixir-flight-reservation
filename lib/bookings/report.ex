defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(filename \\ "report.csv") do
    booking_list = build_booking_list()

    File.write(filename, booking_list)
  end

  def generate_report(from_date, to_date) do
    case build_booking_list(from_date, to_date) do
      nil ->
        {:error, "Unable to generate a report for given dates"}

      booking_list ->
        case File.write("report-by-date.csv", booking_list) do
          {:ok, _report} -> {:ok, "Report generated successfully"}
          error -> error
        end
    end
  end

  defp build_booking_list() do
    BookingAgent.list_all()
    |> Map.values()
    |> Enum.map(&booking_string/1)
  end

  defp build_booking_list(%NaiveDateTime{} = from_date, %NaiveDateTime{} = to_date) do
    case BookingAgent.list_by_date(from_date, to_date) do
      {:ok, booking_list} -> booking_list |> Map.values() |> Enum.map(&booking_string/1)
      {:error, _reason} -> nil
    end
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
