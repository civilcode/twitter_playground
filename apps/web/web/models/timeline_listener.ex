defmodule TimelineListener do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    GenServer.cast(self(), :init)

    {:ok, []}
  end

  def handle_cast(:init, state) do
    PubSub.subscribe(self(), "twitter:timeline")

    {:noreply, state}
  end

  def handle_info({:new_tweet, tweet}, state) do
    Web.Endpoint.broadcast!("tweets", "new_timeline_tweet", tweet)

    {:noreply, state}
  end

  def handle_info({:all_tweets, tweets}, state) do
    Web.Endpoint.broadcast!("tweets", "refresh_list", %{tweets: tweets})

    {:noreply, state}
  end
end
