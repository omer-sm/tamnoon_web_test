defmodule TamnoonWebTest.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    TamnoonWebTest.ComponentCompiler.build_from_root()
    send_file(conn, 200, "out/out.html")
  end

  match _ do
    send_resp(conn, 404, "404")
  end
end
