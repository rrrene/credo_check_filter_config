defmodule CredoCheckFilterConfig do
  import Credo.Plugin

  def init(exec) do
    exec
    |> append_task(
      Credo.CLI.Command.Suggest.SuggestCommand,
      :filter_issues,
      CredoCheckFilterConfig.Task.FilterChecks
    )
    |> append_task(
      Credo.CLI.Command.Suggest.SuggestCommand,
      :print_after_analysis,
      CredoCheckFilterConfig.Task.ReportFilteredChecks
    )

    # |> append_task(ListCommand, :determine_issues, CredoCheckFilterConfig.Task.FilterChecks)
    # |> append_task(ListCommand, :print_issues, CredoCheckFilterConfig.Task.ReportFilteredChecks)
  end
end
