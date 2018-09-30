defmodule Discuss.UserController do
  use Discuss.Web, :controller

  def index(conn, _params) do
    users = Repo.all(Discuss.User)
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Discuss.User, id)
    render(conn, "show.html", user: user)
  end
end
