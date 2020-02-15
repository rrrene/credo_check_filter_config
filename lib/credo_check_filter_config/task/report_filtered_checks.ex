defmodule CredoCheckFilterConfig.Task.ReportFilteredChecks do
  @moduledoc false

  use Credo.Execution.Task

  def call(exec, _opts) do
    ignored_issue_count =
      Credo.Execution.get_assign(
        exec,
        "credo_check_filter_config.ignored_issue_count"
      )

    case ignored_issue_count do
      0 -> nil
      1 -> Credo.CLI.Output.UI.puts([:faint, "1 issue was filtered."])
      count -> Credo.CLI.Output.UI.puts([:faint, "#{count} issues were filtered."])
    end

    exec
  end
end
