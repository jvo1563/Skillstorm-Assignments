import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns


def load_metrics(file):
    metrics_df = pd.read_csv(file)
    metrics_df["day"] = (
        pd.to_datetime(metrics_df["date"]) - pd.to_datetime(metrics_df["date"]).min()
    ).dt.days + 1
    metrics_df["date"] = pd.to_datetime(metrics_df["date"])
    return metrics_df


def get_portfolio_performance(metrics, portfolio):
    initial_investment = sum(portfolio.values())
    portfolio_performance = pd.DataFrame(columns=["date", "total_value"])
    investments = metrics["name"].unique()

    for date in metrics["date"].unique():
        date_data = metrics[metrics["date"] == date]
        total_value = 0
        invested_value = 0
        for investment in investments:
            current_value = portfolio[investment]
            daily_return = date_data[date_data["name"] == investment][
                "daily_return"
            ].values[0]
            updated_value = current_value * (1 + daily_return)
            portfolio[investment] = updated_value
            invested_value += updated_value

        total_value += invested_value
        portfolio_performance.loc[len(portfolio_performance)] = {
            "date": date,
            "total_value": total_value,
        }

    portfolio_performance["total_return"] = (
        portfolio_performance["total_value"] - initial_investment
    )
    portfolio_performance["cumulative_return"] = (
        portfolio_performance["total_value"]
        .pct_change()
        .fillna(0)
        .add(1)
        .cumprod()
        .sub(1)
    )
    portfolio_performance["num_days"] = (
        pd.to_datetime(portfolio_performance["date"])
        - pd.to_datetime(portfolio_performance["date"]).min()
    ).dt.days + 1

    def calculate_annualized_return(cumulative_return, num_days):
        return (1 + cumulative_return) ** (252 / num_days) - 1

    portfolio_performance["annualized_return"] = portfolio_performance.apply(
        lambda row: calculate_annualized_return(
            row["cumulative_return"], row["num_days"]
        ),
        axis=1,
    )
    portfolio_performance["daily_return"] = portfolio_performance[
        "total_value"
    ].pct_change()
    portfolio_performance.set_index("date", inplace=True)
    portfolio_performance["volatility"] = portfolio_performance["daily_return"].rolling(
        window="30D"
    ).std() * (30**0.5)

    risk_free_rate_daily = (1 + 0.03) ** (1 / 252) - 1

    portfolio_performance["sharpe_ratio"] = (
        (
            (portfolio_performance["daily_return"] - risk_free_rate_daily)
            / portfolio_performance["volatility"]
        )
        .rolling(window="30D")
        .mean()
    )
    portfolio_performance.reset_index(names="date", inplace=True)
    portfolio_performance.fillna(0, inplace=True)
    return portfolio_performance


def cumulative_graph(metrics):
    latest_date = metrics["date"].max()
    df = metrics[metrics["date"] == latest_date]
    graph = sns.barplot(
        data=df, x="name", y="cumulative_return", hue="name", legend=False
    )
    graph.set(xlabel="Name", ylabel="Cumulative Return")
    return graph


def volatility_graph(metrics):
    graph = sns.lineplot(
        data=metrics,
        x="day",
        y="volatility",
        hue="name",
        palette="tab10",
    )
    graph.set(xlabel="Day", ylabel="Volatility")
    return graph


def ma_10_graph(metrics):
    graph = sns.lineplot(
        data=metrics,
        x="day",
        y="10_day_ma",
        hue="name",
        palette="tab10",
    )
    graph.set(xlabel="Day", ylabel="10 Day Moving Average")
    return graph


def ma_100_graph(metrics):
    graph = sns.lineplot(
        data=metrics,
        x="day",
        y="100_day_ma",
        hue="name",
        palette="tab10",
    )
    graph.set(xlabel="Day", ylabel="100 Day Moving Average")
    return graph


def sharpe_graph(metrics):
    graph = sns.lineplot(
        data=metrics,
        x="day",
        y="sharpe_ratio",
        hue="name",
        palette="tab10",
    )
    graph.set(xlabel="Day", ylabel="Sharpe Ratio")
    return graph


def beta_graph(metrics):
    df = metrics
    df.drop(df[df.name == "USDCAD"].index, inplace=True)
    graphs = sns.barplot(data=metrics, x="name", y="beta", hue="name", legend=False)
    graphs.set(xlabel="Name", ylabel="Beta")
    return graphs
