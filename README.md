# powerCharts - Mac battery usage visualization

powerCharts helps you visualize your Macbook's battery usage and health data. You can download the app from App Store.

It calculates the battery's consumption rates for you, so you can easily tell whether your mac's battery can last 10 hours like Apple advertises.

![](https://github.com/user-attachments/assets/364e2b6e-2ece-4961-a6a9-9cfacb9fb9dd)

The data is recorded using Crontab. It is a built-in tool on your mac that can run scripts at specified times. We will use it to write your battery data to a csv file periodically.

App Store doesn't allow apps to edit Crontab tasks. So you have to do it manually. It's super easy! Just follow the instructions below:

## Download App

You can download the app from App Store. Try the [Lite version](https://apps.apple.com/app/powercharts-lite/id6698893806) for free or purchase the [complete version](https://apps.apple.com/app/powercharts/id6670771667).

## Install Crontab Task

1. Open Terminal

   Terminal is a built-in app on your Mac.

2. Copy the following command and paste it into Terminal:

   ```
   curl -o "powerCharts_install.sh" "https://raw.githubusercontent.com/tedlex/powerCharts/main/install.sh" && \
   chmod +x "powerCharts_install.sh" && \
   ./powerCharts_install.sh
   rm "powerCharts_install.sh"
   ```

   Press `Enter`/`Return` to run the command.

## Uninstall or Update

If you don't want to run the crontab tasks anymore, you can uninstall it by running the same command above again and choose `uninstall`.

Sometimes I may update the scripts to fix bugs or add new features. You can update it by installing it again as above. You can re-install it anytime as it won't overwrite your data files, only the crontab scripts.

## Features

1. Detailed battery usage data of last 7 days

   ![](https://github.com/user-attachments/assets/364e2b6e-2ece-4961-a6a9-9cfacb9fb9dd)

   Blue line is battery level.

   Green line is when battery is charging.

   Red areas are consumption rates. For example, if it is 5 %/hr, it means your full battery can last 20 hours at this rate. If it is 12.5 %/hr, it can last 8 hours.

2. Battery usage of last 30 days

   ![](https://github.com/user-attachments/assets/bc5a56a4-2c5e-4b39-9fd6-979eb1983c02)

   Working time is how long your mac has been awake. Your mac is considered awake when the crontab tasks are not interrupted.

3. Battery usage of all time

   ![](https://github.com/user-attachments/assets/ea7e72f1-ebf2-4318-aa6c-4b0972784f8b)

   Same as above but it shows monthly data since you started using this app.

4. Battery health data

   ![](https://github.com/user-attachments/assets/f442e62a-da01-4e71-96bc-60fbd02b24c1)

   The fisrt chart shows the change of your battery's cycle count and maxium capacity over time.

   Most Macbook models are designed to retain up to 80% of their original charge capacity after 1000 charge cycles.

   The second chart shows the distribution of your battery levels.

   Keeping your battery level between 20% and 80% can help prolong its lifespan.

## Valid Data Format

The contabs tasks should write your battery data to two csv files like this:

battery_records.csv

```
date,percentage,charging
2024-09-04 12:27:00 +0800,91,1
2024-09-04 12:30:00 +0800,93,1
2024-09-04 12:33:00 +0800,95,1
```

battery_health_records.csv

```
date,cycle,capacity
2024-09-04 15:08:42 +0800,225,88%
2024-09-05 14:30:01 +0800,226,88%
2024-09-06 14:30:01 +0800,227,88%
```

You can then import the files to the app and visualize it.

If your mac has different output format, it may cause the app unable to read it correctly. You can contact me using email or github issue and I will fix it as soon as possible. Thanks for your help!

# Support

If you have any questions, welcome to contact me at litx16@icloud.com
