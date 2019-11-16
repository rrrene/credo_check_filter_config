defmodule CredoCheckFilterConfig.Task.ReportFilteredChecks do
  @moduledoc false

  use Credo.Execution.Task

  def call(exec, _opts) do
    ignored_issue_count =
      Credo.Execution.get_assign(
        exec,
        "credo_check_filter_config.ignored_issue_count"
      )

    if ignored_issue_count > 0 do
      Credo.CLI.Output.UI.puts([:faint, "#{ignored_issue_count} issues were filtered."])
    end

    exec
  end
end
