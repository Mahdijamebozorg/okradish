# Okardish (Diet & Hardware-Integrated Nutrition Platform)

[![Flutter](https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Hardware Interface](https://img.shields.io/badge/Hardware-BLE%20%2F%20ESP32-blue?logo=bluetooth&logoColor=white)](#)
[![Database](https://img.shields.io/badge/Database-Hive%20NoSQL-green)](#)

**Okardish** is an advanced IoT-integrated health and telemetry application that synchronizes local nutrition tracking with external physical hardware. The repository architecture showcases a robust implementation of real-time wireless data acquisition, local asynchronous caching, and state-driven metric visualization.

<div align="center">
  <a>
    <img src="screenShots/logo.png" alt="Okardish Logo" width="220" height="90">
  </a>
</div>

---

## 📌 Core Engineering Highlights & Innovations

*   **Cyber-Physical BLE Integration:** Established a low-latency connection with an custom ESP32-based weighing scale via Bluetooth Low Energy (BLE), handling automatic device discovery and state synchronization.
*   **Asynchronous Local Database Storage:** Deployed a lightweight NoSQL engine (`Hive`) to process high-frequency nutritional transactions and metrics entirely offline, ensuring atomic disk writes.
*   **Real-time Sensor Stream Parsing:** Managed continuous byte arrays arriving from hardware sensors, utilizing reactive Dart streams to decode, smooth, and map input weights into data models instantly.
*   **Modular Analytical Profiling:** Developed data visualization modules mapping macronutrient matrices (Proteins, Carbs, Fats) and micronutrient distributions over custom time series.

---

## ⚙️ Core Engineering Challenges & System Architecture

Integrating consumer software with volatile wireless hardware components presented structural challenges:

1.  **Volatile Wireless Connection Lifecycle:** High-frequency disconnections and peripheral state drift common in BLE environments.
    *   *Solution:* Built automated connection retry policies, asynchronous state listeners, and dynamic connection timeout handling inside a dedicated BLE Service Layer.
2.  **Telemetry Data Buffering & Precision:** Converting unparsed byte matrices streamed from the ESP32 scale into deterministic numeric data.
    *   *Solution:* Designed data parsing micro-services to decrypt peripheral MTU packets, filter sensory noise, and convert raw inputs into real-time metrics.
3.  **Cross-Platform Bluetooth State Permissions:** Navigating structural OS architecture differences (Android & iOS runtime permissions for location/scanning).
    *   *Solution:* Abstracted hardware-scanning pipelines away from the UI, ensuring consistent state behavior regardless of background system policies.

---

## 🛠️ Deep Tech Stack & Dependency Layout

| Category | Technical Packages & Frameworks | Systemic Purpose |
| :--- | :--- | :--- |
| **Wireless Telemetry** | `flutter_blue_plus` | Low-level peripheral scanning, MTU updates, GATT characteristic notification loops |
| **State Management** | `GetX` | Synchronous hardware event dispatching, view dependency injection (`deps.dart`) |
| **Local Datastore** | `hive`, `hive_flutter`, `build_runner` | Strongly-typed adapters, zero-boilerplate NoSQL byte caching for macro/micronutrients |
| **Network Framework** | `parse_server_sdk_flutter`, `connectivity_plus` | Asynchronous cloud sync engine with local-first offline fallback behaviors |
| **Data Visualization**| `fl_chart` | Time-series distribution charts, progressive rendering of caloric trends |
| **Branding & Layout** | `flutter_svg`, `video_player`, `persian_datetime_picker` | Polished interface integration, asset handling, and localized date parsing |

---

## 🗂️ Architectural Directory Architecture

The repository enforces a decoupled, modular directory flow to ensure that core business rules remain decoupled from hardware components and databases:

```text
lib/
 ├── components/           # Atomic, domain-agnostic UI presentation assets
 ├── db/                   # Hive boxes initialization, type adapters, and entity schemes
 ├── extensions/           # Functional Dart wrappers for data and temporal mutation
 ├── generated/            # Automated assets and localized generation files (`flutter_gen`)
 ├── models/               # Immutable domain entities (Nutrient profiles, Weight structures)
 ├── pages/                # Clean presentation layers and layout views
 ├── services/             # Hardware abstractions, BLE Stream controller logic, and Parse integrations
 ├── states/               # Reactive controller logic separating IO from view triggers
 ├── utils/                # Pure utility matrices and telemetry helpers
 ├── constant.dart         # Global hardware specifications and immutable keys
 ├── deps.dart             # Unified service locator and dependency injector matrix
 └── routes.dart           # Static named navigation matrix
