# Este teste é opcional, mas vale a pena tentar e se desafiar 😉

defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Report.generate("report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end

  describe "generate_report/2" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called with suitable dates, generate report" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      from_date = ~N[2001-05-07 10:00:00]
      to_date = ~N[2001-05-07 12:00:00]

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)

      Report.generate_report(from_date, to_date)
      {:ok, file} = File.read("report-by-date.csv")

      assert file =~ content
    end

    test "when called with suitable dates, return success message" do
      params = %{
        complete_date: ~N[2001-05-07 10:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      params_2 = %{
        complete_date: ~N[2001-05-07 11:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      from_date = ~N[2001-05-07 10:00:00]
      to_date = ~N[2001-05-07 11:30:00]

      Flightex.create_or_update_booking(params)
      Flightex.create_or_update_booking(params_2)

      response = Report.generate_report(from_date, to_date)

      expected_response = {:ok, "Report generated successfully"}

      assert response == expected_response
    end
  end
end
