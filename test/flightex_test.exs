defmodule FlightexTest do
  use ExUnit.Case, async: false

  describe "create_or_update_user/1" do
    setup do
      Flightex.start_agents

      :ok
    end

    test "when all params are valid, returns a valid tuple" do
      params = %{
        name: "Jp",
        email: "jp@banana.com",
        cpf: "12345678900"
      }

      response = Flightex.create_or_update_user(params)

      expected_response = {:ok, "User created or updated successfully"}

      assert response == expected_response
    end
  end

  describe "create_or_update_booking/1" do
    setup do
      Flightex.start_agents

      :ok
    end

    test "when all params are valid, returns a valid tuple" do
      params = %{
        complete_date: ~N[2001-05-07 03:05:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "e9f7d281-b9f2-467f-9b34-1b284ed58f9e"
      }

      response = Flightex.create_or_update_booking(params)

      assert {:ok, _uuid} = response
    end
  end
end
