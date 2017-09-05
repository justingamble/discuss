defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic


  def index(conn, _params) do
    topics = Repo.all(Topic)   # Repo is automatically aliased by Phoenix
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    struct = %Topic{}
    params = %{}
    changeset = Topic.changeset(struct, params)

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:warning, "Topic could not be created")
        |> render "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)
    # this changeset has no changes yet.  We just just feeding a starting
    # point into the form, so the form knows what to display.

    render conn, "edit.html", changeset: changeset, topic: topic
  end
end
