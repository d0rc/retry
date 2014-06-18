defmodule Retry do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
    ]

    opts = [strategy: :one_for_one, name: Retry.Supervisor]
    Supervisor.start_link(children, opts)
  end


  def run(opts = %{} \\ %{}, fun) when is_function(fun) do
    opts = Map.merge(%{tries: 10, sleep: 100}, opts)
    opts = Map.put(opts, :cnt, 0)
    exec(fun, opts)
  end

  defp exec(fun, opts = %{tries: tries, cnt: cnt, sleep: sleep}, _ \\ nil) when tries > cnt do
    result = try do
        {:ok, fun.()}
      catch err, msg -> {:failed, {:error, err, msg}}
      rescue exception -> {:failed, {:exception, exception}}
    end
    case result do
      {:ok, res} -> {:ok, res}
      {:failed, thing} ->
        receive do after sleep -> :ok end
        exec(fun, %{opts | cnt: cnt + 1}, thing)
    end
  end
  defp exec(_, opts = %{cnt: cnt}, error) do
    {:error, %{state: :failed, attempts: cnt, error: error}}
  end
end
