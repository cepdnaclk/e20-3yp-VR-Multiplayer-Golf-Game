import pandas as pd

# Input file (raw data)
INPUT_FILE = "sensor_data.csv"

# Output file (cleaned Gyro1 data)
OUTPUT_FILE = "gyro1_data.csv"


def extract_gyro1_data():
    # Read the CSV with at least two columns: timestamp, raw_data
    df = pd.read_csv(INPUT_FILE)

    # Prepare a list to hold valid Gyro1 rows
    gyro1_rows = []

    # Iterate through each row in the dataframe
    for index, row in df.iterrows():
        raw_line = str(row["raw_data"]).strip()

        # Check if line starts with "Gyro1:"
        if raw_line.startswith("Gyro1:"):
            # Remove "Gyro1:" prefix
            data_part = raw_line.replace("Gyro1:", "").strip()

            # Some lines have a trailing comma -> remove it if present
            if data_part.endswith(","):
                data_part = data_part[:-1]  # remove last character

            # Split on commas
            parts = data_part.split(",")

            # Expect exactly 6 numeric values (gx, gy, gz, ax, ay, az)
            if len(parts) == 6:
                try:
                    # Convert all parts to integers
                    gx, gy, gz, ax, ay, az = map(int, parts)

                    # Append to our valid Gyro1 list
                    gyro1_rows.append([gx, gy, gz, ax, ay, az])
                except ValueError:
                    # If conversion fails, skip this line
                    pass

    # Convert the collected data into a new DataFrame
    gyro1_df = pd.DataFrame(
        gyro1_rows,
        columns=["gx", "gy", "gz", "ax", "ay", "az"]
    )

    # Save to CSV
    gyro1_df.to_csv(OUTPUT_FILE, index=False)
    print(f"Saved {len(gyro1_df)} Gyro1 rows to {OUTPUT_FILE}")


if __name__ == "__main__":
    extract_gyro1_data()
