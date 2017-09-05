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
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Topic could not be created")
        |> render "new.html", changeset: changeset
    end
  end
end
