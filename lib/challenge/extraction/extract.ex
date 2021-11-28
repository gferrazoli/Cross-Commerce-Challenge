defmodule Challenge.Extraction.Extract do
  use GenServer

  def extract_from_api() do
    {:ok, pid} = GenServer.start_link(__MODULE__, [])

    case start_chunk_requests(pid) do
      {:error, reason} ->
        {:error, reason}

      :ok ->
        result = GenServer.call(pid, :get_list)
        GenServer.stop(pid)
        result
    end
  end

  @request_module Application.compile_env!(:challenge, :request_module)
  defp do_extract(page, pid) do
    @request_module.request_numbers_from_challenge(page)
    |> check_extraction(page, pid)
  end

  defp retry_extract(page, pid), do: do_extract(page, pid)

  defp check_extraction({:error, "Bad Request" = _reason}, page, pid),
    do: retry_extract(page, pid)

  defp check_extraction({:error, reason}, _page, _pid), do: {:error, reason}
  defp check_extraction(%{"numbers" => []}, _page, _pid), do: []

  defp check_extraction(%{"numbers" => number_list}, _page, pid),
    do: GenServer.cast(pid, {:push, number_list})

  @delay_between_chunks 30
  @first_page 1
  @chunk_size Application.compile_env!(:challenge, :chunk_size)
  defp start_chunk_requests(pid, current_page \\ @first_page) do
    :timer.sleep(@delay_between_chunks)

    current_page..(@chunk_size + current_page)
    |> Enum.map(fn request_page ->
      Task.async(fn -> do_extract(request_page, pid) end)
    end)
    |> Enum.map(fn task_pid -> Task.await(task_pid) end)
    |> check_chunk_requests(pid, current_page + @chunk_size)
  end

  defp check_chunk_requests(chunk_return_list, pid, current_page) do
    if {:error, "Challenge API unreachable"} in chunk_return_list do
      {:error, "Challenge API unreachable"}
    else
      if [] in chunk_return_list do
        :ok
      else
        start_chunk_requests(pid, current_page)
      end
    end
  end

  #   @page_range Application.compile_env!(:challenge, :page_range)
  #   defp start_worksers_wrong(pid) do
  #     @page_range
  #     |> Flow.from_enumerable(max_demand: 1000)
  #     |> Flow.map(fn page ->
  #       nil
  #       # do_extract(page, pid)
  #     end)
  #     |> Flow.run()
  #   end

  @impl true
  def init(number_list \\ []) do
    {:ok, number_list}
  end

  @impl true
  def handle_cast({:push, number_list}, state) do
    {:noreply, number_list ++ state}
  end

  @impl true
  def handle_call(:get_list, _from, state) do
    {:reply, state, state}
  end
end
