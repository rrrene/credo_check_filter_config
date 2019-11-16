defmodule CredoCheckFilterConfig.Task.FilterChecks do
  @moduledoc false

  use Credo.Execution.Task

  alias Credo.Execution

  def call(exec, _opts) do
    # get checks that have executed
    all_issues = Execution.get_issues(exec)

    # get the check tuples (consisting of `{check, params}` for all checks which raised issues)
    checks = get_check_tuples_for_raised_issues(exec, all_issues)

    # Variant 1: filter issues by extra rules
    # issues = Enum.reject(all_issues, &ignored_by_exluded_param?(&1, checks))

    # Variant 2: split into filtered and rejected issues
    {ignored_issues, issues} = Enum.split_with(all_issues, &ignored_by_exluded_param?(&1, checks))

    exec =
      Execution.put_assign(
        exec,
        "credo_check_filter_config.ignored_issue_count",
        Enum.count(ignored_issues)
      )

    # overwrite issues for this execution
    Execution.set_issues(exec, issues)
  end

  defp get_check_tuples_for_raised_issues(exec, all_issues) do
    {all_check_tuples, _, _} = Execution.checks(exec)
    all_issues_checks = all_issues |> Enum.map(& &1.check) |> Enum.uniq()

    Enum.filter(all_check_tuples, fn {check, _params} ->
      Enum.member?(all_issues_checks, check)
    end)
  end

  defp ignored_by_exluded_param?(issue, checks) do
    params =
      Enum.find_value(checks, fn {check, params} ->
        if issue.check == check do
          params
        end
      end)

    params[:excluded]
    |> List.wrap()
    |> Enum.any?(&String.match?(issue.filename, &1))
  end
end
