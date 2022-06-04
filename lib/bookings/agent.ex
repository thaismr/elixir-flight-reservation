defmodule Flightex.Bookings.Agent do
  alias Flightex.Bookings.Booking

  use Agent

  def start_link(_initial_state) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Booking{id: uuid} = booking) do
    Agent.update(__MODULE__, &update_state(&1, booking, uuid))

    {:ok, uuid}
  end

  def get(uuid), do: Agent.get(__MODULE__, &get_booking(&1, uuid))

  def list_all, do: Agent.get(__MODULE__, & &1)

  def list_by_date(from_date, to_date),
    do: Agent.get(__MODULE__, &filter_by_date(&1, from_date, to_date))

  defp get_booking(state, uuid) do
    case Map.get(state, uuid) do
      nil -> {:error, "Booking not found"}
      booking -> {:ok, booking}
    end
  end

  # Native Map.filter function available from Elixir version 1.13
  defp filter_by_date(state, from_date, to_date) do
    :maps.filter(fn _k, v -> booking_between_dates?(v, from_date, to_date) end, state)
  end

  defp booking_between_dates?(%Booking{complete_date: complete_date}, from_date, to_date) do
    with x <- NaiveDateTime.compare(complete_date, from_date),
         y <- NaiveDateTime.compare(complete_date, to_date),
         true <- x in [:gt, :eq],
         true <- y in [:lt, :eq] do
      true
    else
      _ -> false
    end
  end

  defp update_state(state, %Booking{} = booking, uuid), do: Map.put(state, uuid, booking)
end
