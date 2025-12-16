import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv(r"C:\Users\ADMIN\Downloads\Household_Energy.csv")

# Create Total Energy column
df["Total_Energy"] = df["Electricity_Usage (kWh)"] + df["Gas_Usage"]

# 1. Bar Chart: Average Energy by Family Size
family_energy = df.groupby("Family_Size")["Total_Energy"].mean()
plt.figure()
family_energy.plot(kind="bar")
plt.title("Average Energy Consumption by Family Size")
plt.xlabel("Family Size")
plt.ylabel("Average Total Energy")
plt.show()

# 2. Bar Chart: Average Energy by Appliances Count
appliance_energy = df.groupby("Appliances_Count")["Total_Energy"].mean()
plt.figure()
appliance_energy.plot(kind="bar")
plt.title("Average Energy Consumption by Appliances Count")
plt.xlabel("Appliances Count")
plt.ylabel("Average Total Energy")
plt.show()

# 3. Line Chart: Monthly Energy Trend
month_energy = df.groupby("Month")["Total_Energy"].mean()
plt.figure()
month_energy.plot(kind="line", marker="o")
plt.title("Monthly Average Energy Consumption")
plt.xlabel("Month")
plt.ylabel("Average Total Energy")
plt.show()

# 4. Pie Chart: Energy by Income Group
df["Income_Group"] = pd.cut(
    df["Monthly_Income"],
    bins=[0, 30000, 60000, 100000],
    labels=["Low Income", "Middle Income", "High Income"]
)

income_energy = df.groupby("Income_Group")["Total_Energy"].mean()
plt.figure()
income_energy.plot(kind="pie", autopct="%1.1f%%")
plt.title("Energy Consumption by Income Group")
plt.ylabel("")
plt.show()
