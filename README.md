# bash_scripts
All the Bash Scripts are here
# Linux Infrastructure & Trading Operations Scripts

Collection of Bash and Python automation scripts for system tuning, exchange connectivity monitoring, daily market operations, and automated backups.

## Repository Structure

### `monitoring/`
* **`monitor_BSE_Temperature_MCX.sh`** – Monitors hardware/server temperature metrics for BSE/MCX infrastructure.
* **`MNT_storage_CHECK1.sh`** – Checks mount points and storage utilization thresholds.
* **`nse_bse_link.sh`** – Verifies network link status and connectivity to NSE/BSE endpoints.
* **`trade_eq.sh`** – Monitors equity trading session processes and health.
* **`mcx_ping_monitor.sh`** – Tracks latency and packet loss to MCX gateways.

### `tuning/`
* **`check_irq.sh`** – Audits current IRQ affinity mappings across CPU cores.
* **`Dynamic_irq.sh`** – Configures dynamic IRQ balancing for network interfaces.
* **`shifting_system_irq.sh`** – Pins system IRQs away from isolated trading cores.
* **`isol.sh`** – Verifies or applies CPU core isolation (`isolcpus`) configurations.
* **`RP_filter_IGMP_version.sh`** – Configures reverse path filtering (`rp_filter`) and IGMP versions for multicast market data.

### `operations/`
* **`raw_morning_task.py`** – Automates pre-market startup checks and morning operational tasks.
* **`date_verify.sh`** – Validates trading calendar dates and system date alignment.
* **`raw_data_verify.sh`** – Checks integrity and completeness of raw market data files.
* **`DATA_DUMP.sh`** – Handles end-of-day data extraction and archival dumps.
* **`web_timestamp_download.sh`** – Downloads time-stamped web resources/files.

### `backups/`
* **`sync_backup_scripts.sh`** – Synchronizes operational scripts across servers/backup locations.
* **`cronsbackup.sh`** – Backs up user and system cron schedules.
* **`rhel_rsync_telegram.sh`** – Runs RHEL `rsync` backups with Telegram status notifications.

## Setup
1. Copy `.env.example` to `.env` and populate your environment-specific variables:
   ```bash
   cp .env.example .env
